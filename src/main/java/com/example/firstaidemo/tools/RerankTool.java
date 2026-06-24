package com.example.firstaidemo.tools;

import com.example.firstaidemo.mapper.TableMetadataMapper;
import com.example.firstaidemo.models.entity.TableMetadata;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Component
public class RerankTool {

    private final RestClient rerankRestClient;

    private final String rerankModel;

    private final TableMetadataMapper tableMetadataMapper;

    public RerankTool(
            @Qualifier("rerankRestClient") RestClient rerankRestClient,
            @Value("${rerank.model}") String rerankModel,
            TableMetadataMapper tableMetadataMapper) {
        this.rerankRestClient = rerankRestClient;
        this.rerankModel = rerankModel;
        this.tableMetadataMapper = tableMetadataMapper;
    }

    @Tool(description = """
            使用BGE-Reranker对候选表名进行相关性重排序。
            输入用户问题和候选表名列表（每行一个表名），自动加载每张表的元数据描述，
            调用专用Reranker模型一次完成所有表的相关性打分，返回按分数降序排列的表名。""")
    public String rerankTables(String question, String candidateTables) {
        List<String> tables = Arrays.stream(candidateTables.split("\n"))
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .toList();

        if (tables.isEmpty()) {
            return "";
        }

        // 查询每张表的元数据，构造 document 文本
        List<TableMetadata> rows = tableMetadataMapper.selectByTableNames(tables);
        Map<String, String> docByTable = rows.stream()
                .collect(Collectors.toMap(
                        TableMetadata::getTableName,
                        this::buildDocText));

        List<String> documents = tables.stream()
                .map(t -> docByTable.getOrDefault(t, t))
                .toList();

        // 调用 Reranker API
        String requestBody = String.format(
                "{\"model\":\"%s\",\"query\":\"%s\",\"documents\":%s,\"top_n\":%d}",
                rerankModel,
                escapeJson(question),
                toJsonArray(documents),
                Math.min(tables.size(), 3));

        log.info("Rerank 请求: model={}, tables={}", rerankModel, tables);

        try {
            String response = rerankRestClient.post()
                    .uri("/rerank")
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            log.info("Rerank 响应: {}", response);
            return parseRerankResponse(response, tables);
        } catch (Exception e) {
            log.warn("Rerank API 调用失败: {}", e.getMessage());
            return tables.stream().limit(3).collect(Collectors.joining("\n"));
        }
    }

    @Tool(description = """
            基于列级元数据对候选表进行相关性重排序（比仅用表名rerank更可靠）。
            输入用户问题和loadColumnMetadata返回的列级元数据文本，
            利用列名、列类型、列注释、业务含义、值示例等丰富信息进行rerank，
            返回按相关性降序排列的表名。""")
    public String rerankWithColumns(String question, String columnMetadata) {
        LinkedHashMap<String, List<String>> tableColumns = parseColumnMetadata(columnMetadata);
        if (tableColumns.isEmpty()) {
            log.warn("loadColumnMetadata 返回空结果");
            return "";
        }

        List<String> tableNames = new ArrayList<>(tableColumns.keySet());

        List<String> documents = tableNames.stream()
                .map(t -> t + ": " + String.join(" | ", tableColumns.get(t)))
                .toList();

        String requestBody = String.format(
                "{\"model\":\"%s\",\"query\":\"%s\",\"documents\":%s,\"top_n\":%d}",
                rerankModel,
                escapeJson(question),
                toJsonArray(documents),
                Math.min(tableNames.size(), 3));

        log.info("Rerank(列级) 请求: tables={}", tableNames);

        try {
            String response = rerankRestClient.post()
                    .uri("/rerank")
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            log.info("Rerank(列级) 响应: {}", response);
            return parseRerankResponse(response, tableNames);
        } catch (Exception e) {
            log.warn("Rerank(列级) API 调用失败: {}", e.getMessage());
            return tableNames.stream().limit(3).collect(Collectors.joining("\n"));
        }
    }

    /**
     * 解析 MetaDataServiceImpl.getColumnNames 的输出:
     * <pre>
     * 表名：grade
     * 字段:id
     * 类型:BIGSERIAL
     * 注释:主键ID
     * 业务含义:年级唯一标识
     * 示例值:1,2,3
     * </pre>
     * 每个列6行一组，多组之间无空行分隔。
     */
    private LinkedHashMap<String, List<String>> parseColumnMetadata(String text) {
        LinkedHashMap<String, List<String>> result = new LinkedHashMap<>();
        String currentTable = null;
        String field = null, type = null, comment = null, meaning = null, example = null;
        int fieldCount = 0;

        for (String line : text.split("\n")) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;

            if (isTableLine(trimmed)) {
                // 上一列结束，保存
                if (currentTable != null && field != null) {
                    result.computeIfAbsent(currentTable, k -> new ArrayList<>())
                            .add(String.format("%s %s | %s | %s | 示例:%s",
                                    field, type != null ? type : "",
                                    comment != null ? comment : "",
                                    meaning != null ? meaning : "",
                                    example != null ? example : ""));
                }
                currentTable = extractValue(trimmed);
                field = type = comment = meaning = example = null;
                fieldCount = 0;
            } else {
                switch (fieldCount) {
                    case 0 -> field = extractValue(trimmed);
                    case 1 -> type = extractValue(trimmed);
                    case 2 -> comment = extractValue(trimmed);
                    case 3 -> meaning = extractValue(trimmed);
                    case 4 -> example = extractValue(trimmed);
                }
                fieldCount = (fieldCount + 1) % 5;
            }
        }
        // 最后一列
        if (currentTable != null && field != null) {
            result.computeIfAbsent(currentTable, k -> new ArrayList<>())
                    .add(String.format("%s %s | %s | %s | 示例:%s",
                            field, type != null ? type : "",
                            comment != null ? comment : "",
                            meaning != null ? meaning : "",
                            example != null ? example : ""));
        }
        return result;
    }

    private boolean isTableLine(String line) {
        return line.startsWith("表名") || line.startsWith("Table");
    }

    private String extractValue(String line) {
        int idx = line.indexOf("：");
        if (idx < 0) idx = line.indexOf(":");
        return idx >= 0 ? line.substring(idx + 1).trim() : line.trim();
    }

    private String buildDocText(TableMetadata t) {
        StringBuilder sb = new StringBuilder(t.getTableName());
        append(sb, t.getTableComment());
        append(sb, t.getBusinessDomain());
        append(sb, t.getBusinessDesc());
        return sb.toString();
    }

    private void append(StringBuilder sb, String val) {
        if (val != null && !val.isBlank()) {
            sb.append(": ").append(val);
        }
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", "");
    }

    private String toJsonArray(List<String> items) {
        return items.stream()
                .map(s -> "\"" + escapeJson(s) + "\"")
                .collect(Collectors.joining(",", "[", "]"));
    }

    @SuppressWarnings("unchecked")
    private String parseRerankResponse(String json, List<String> originalOrder) {
        try {
            Map<String, Object> map = (Map<String, Object>) com.alibaba.fastjson2.JSON.parse(json);
            List<Map<String, Object>> results = (List<Map<String, Object>>) map.get("results");

            return results.stream()
                    .sorted((a, b) -> Double.compare(getScore(b), getScore(a)))
                    .map(r -> {
                        int idx = getInt(r, "index");
                        return idx >= 0 && idx < originalOrder.size() ? originalOrder.get(idx) : "";
                    })
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.joining("\n"));
        } catch (Exception e) {
            log.warn("解析 rerank 响应失败: {}, raw={}", e.getMessage(), json);
            return String.join("\n", originalOrder.stream().limit(3).toList());
        }
    }

    private double getScore(Map<String, Object> r) {
        for (String key : new String[]{"relevance_score", "relevanceScore", "score"}) {
            Object v = r.get(key);
            if (v instanceof Number n) return n.doubleValue();
        }
        return 0;
    }

    private int getInt(Map<String, Object> r, String key) {
        Object v = r.get(key);
        return v instanceof Number n ? n.intValue() : -1;
    }
}
