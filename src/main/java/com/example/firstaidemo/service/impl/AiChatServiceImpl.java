package com.example.firstaidemo.service.impl;

import com.alibaba.fastjson2.JSON;
import com.example.firstaidemo.mapper.ColumnMetadataMapper;
import com.example.firstaidemo.mapper.TableMetadataMapper;
import com.example.firstaidemo.models.entity.ColumnMetadata;
import com.example.firstaidemo.models.entity.ReviewResult;
import com.example.firstaidemo.models.entity.TableMetadata;
import com.example.firstaidemo.service.IAiChatService;
import com.example.firstaidemo.service.IText2SqlAgentService;
import com.example.firstaidemo.tools.*;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.Arrays;
import java.util.List;
import java.util.Map;


@Slf4j
@Service
@RequiredArgsConstructor
public class AiChatServiceImpl implements IAiChatService {

    private final ChatClient.Builder chatClientBuilder;

    private final ChatModel chatModel;

    private final OrderTool orderTool;

    private final PriceTool priceTool;

    private final SqlGenerateTool sqlGenerateTool;

    private final SchemaTool schemaTool;

    private final SqlExecuteTool sqlExecuteTool;

    private final RerankTool rerankTool;

    private final PlanningTool planningTool;

    private final ReviewTool reviewTool;

    private final RagTableSearchTool ragTableSearchTool;

    private final DynamicColumnTool dynamicColumnTool;

    private final EmbeddingModel embeddingModel;

    private final JdbcTemplate jdbcTemplate;

    private final TableMetadataMapper tableMetadataMapper;

    private final ColumnMetadataMapper columnMetadataMapper;

    @Autowired
    @Qualifier("ragTools")
    private ToolCallback[] ragTools;

    @Autowired
    @Qualifier("rerankTools")
    private ToolCallback[] rerankTools;

    @Autowired
    @Qualifier("columnRerankTools")
    private ToolCallback[] columnRerankTools;

    private final IText2SqlAgentService text2SqlAgentService;

    @Value("${openai.embedding.dimension:1024}")
    private int embeddingDimension;


    /**
     * 初始化：pgvector 扩展、vector_store 表、元数据表 embedding 列 + 种子数据
     */
    @PostConstruct
    public void initVectorStore() {
        //metadata-table-embedding不存在值的初始化
        seedTableEmbeddings();
        //metadata-column-embedding不存在值的初始化
        seedColumnEmbeddings();
    }

    private void seedTableEmbeddings() {
        List<TableMetadata> rows = tableMetadataMapper.selectEnabledWithNullEmbedding();
        for (TableMetadata row : rows) {
            String text = String.format("%s %s %s %s %s",
                    row.getTableName(),
                    nvl(row.getTableComment()),
                    nvl(row.getBusinessDomain()),
                    nvl(row.getBusinessDesc()),
                    nvl(row.getTableAlias()));
            float[] vector = embeddingModel.embed(text);
            tableMetadataMapper.updateEmbedding(row.getId(), toVectorStr(vector));
        }
        if (!rows.isEmpty()) {
            log.info("已为 {} 张表生成 embedding", rows.size());
        }
    }

    private void seedColumnEmbeddings() {
        List<ColumnMetadata> rows = columnMetadataMapper.selectEnabledWithNullEmbedding();
        for (ColumnMetadata row : rows) {
            String text = String.format("%s %s %s %s %s %s",
                    row.getTableName(),
                    nvl(row.getColumnName()),
                    nvl(row.getColumnType()),
                    nvl(row.getColumnComment()),
                    nvl(row.getBusinessMeaning()),
                    nvl(row.getValueExamples()));
            float[] vector = embeddingModel.embed(text);
            columnMetadataMapper.updateEmbedding(row.getId(), toVectorStr(vector));
        }
        if (!rows.isEmpty()) {
            log.info("已为 {} 列生成 embedding", rows.size());
        }
    }

    private String nvl(Object o) {
        return o == null ? "" : o.toString();
    }

    /**
     * 将 float[] 转为 pgvector 可接受的文本格式: [x,x,x]
     */
    private String toVectorStr(float[] vec) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < vec.length; i++) {
            if (i > 0) sb.append(',');
            sb.append(vec[i]);
        }
        sb.append(']');
        return sb.toString();
    }

    @Override
    public String chat(String message) {

        ChatClient chatClient = chatClientBuilder.build();
        return chatClient.prompt()
                .user(message)
                .call()
                .content();
    }

    @Override
    public Flux<String> chatStream(String message) {
        ChatClient chatClient = chatClientBuilder.build();
        return chatClient.prompt()
                .user(message)
                .stream()
                .content();
    }

    @Override
    public String chatRealPgData(String message) {

        ChatClient chatClient = chatClientBuilder.build();

        return chatClient.prompt()
                .tools(orderTool, priceTool)
                .user(message)
                .call()
                .content();
    }

    @Override
    public String workFlowAiAgent(String question) {
        String schema =
                schemaTool.getDatabaseSchema();

        String sql =
                sqlGenerateTool.generateSql(
                        question,
                        schema);
        log.info("查看获取的schema{}", schema);

        log.info("生成的SQL{}", sql);

        List<Map<String, Object>> maps = sqlExecuteTool.executeSql(sql);

        return JSON.toJSONString(maps);

    }

    @Override
    public String sqlAgentNotWorkFlow(String question) {
        return chatClientBuilder
                .build()
                .prompt("""
                        你是一个PostgreSQL数据分析Agent。
                        
                        当需要查询数据库时：
                        
                        1. 先调用getDatabaseSchema
                        2. 生成SQL
                        3. 调用executeSql
                        4. 根据结果回答
                        
                        用户问题：
                        
                        %s
                        """
                        .formatted(question))
                .tools(
                        schemaTool,
                        sqlExecuteTool
                )
                .call()
                .content();
    }

    @Override
    public String embeddingStore(String text) {
        float[] vector = embeddingModel.embed(text);
        String vectorStr = toVectorStr(vector);
        jdbcTemplate.update(
                "INSERT INTO agent.vector_store (content, embedding, metadata) VALUES (?, ?::vector, ?::jsonb)",
                text,
                vectorStr,
                JSON.toJSONString(Map.of("source", "test-embedding"))
        );

        return "✅ embedding 存储成功: " + text;
    }

    @Override
    public String embeddingSearch(String query) {
        float[] vector = embeddingModel.embed(query);
        String vectorStr = toVectorStr(vector);

        List<Map<String, Object>> results = jdbcTemplate.queryForList(
                "SELECT content, metadata, 1 - (embedding <=> ?::vector) AS similarity " +
                        "FROM agent.vector_store " +
                        "ORDER BY embedding <=> ?::vector " +
                        "LIMIT 1",
                vectorStr,
                vectorStr
        );

        return JSON.toJSONString(results);
    }

    @Override
    public String seedMetadataEmbeddings() {
        tableMetadataMapper.resetAllEmbeddings();
        columnMetadataMapper.resetAllEmbeddings();
        seedTableEmbeddings();
        seedColumnEmbeddings();
        return "✅ 元数据表 embedding 重置并重新生成完成";
    }


    @Override
    public String ragSqlAgent(String question) {
        // 1. Tool: 向量搜索相关表
        String tableNamesStr = ragTableSearchTool.searchRelevantTables(question);
        List<String> tableNames = List.of(tableNamesStr.split("\n"));
        log.info("RAG 选中表: {}", tableNames);

        // 2. Tool: 加载列元数据
        String schema = dynamicColumnTool.loadColumnMetadata(tableNames);

        // 3. Tool: 生成 SQL
        String sql = sqlGenerateTool.generateSql(question, schema);
        log.info("LLM 生成的 SQL: {}", sql);

        // 4. Tool: 执行 SQL
        List<Map<String, Object>> result = sqlExecuteTool.executeSql(sql);

        return JSON.toJSONString(result);
    }

    @Override
    public String ragAgentTools(String question) {
        return chatClientBuilder.build()
                .prompt()
                .user(question)
                .toolCallbacks(ragTools)
                .call()
                .content();
    }

    @Override
    public String ragRerankAgent(String question) {
        // 1. Tool: 向量搜索候选表
        String tableNamesStr = ragTableSearchTool.searchRelevantTables(question);
        List<String> candidateTables = List.of(tableNamesStr.split("\n"));
        log.info("向量搜索候选表: {}", candidateTables);

        // 2. Tool: 加载列元数据
        String columnMetaText = dynamicColumnTool.loadColumnMetadata(candidateTables);

        // 3. Tool: 列级 Rerank
        String rerankedStr = rerankTool.rerankWithColumns(question, columnMetaText);
        List<String> topTables = Arrays.stream(rerankedStr.split("\n"))
                .filter(s -> !s.isBlank())
                .toList();
        log.info("Rerank 后选中表: {}", topTables);

        // 4. 为 top 表构造 schema（从已加载的列元数据中过滤）
        String schema = buildSchemaForTables(columnMetaText, topTables);

        // 5. Tool: 生成 SQL
        String sql = sqlGenerateTool.generateSql(question, schema);
        log.info("LLM 生成的 SQL: {}", sql);

        // 6. Tool: 执行 SQL
        List<Map<String, Object>> result = sqlExecuteTool.executeSql(sql);

        return JSON.toJSONString(result);
    }

    /**
     * 从 loadColumnMetadata 的文本输出中筛选指定表的 schema
     */
    private String buildSchemaForTables(String columnMetaText, List<String> topTables) {
        StringBuilder schema = new StringBuilder();
        String currentTable = null;
        boolean include = false;

        for (String line : columnMetaText.split("\n")) {
            String trimmed = line.trim();
            if (trimmed.startsWith("表名") || trimmed.startsWith("Table")) {
                int idx = trimmed.indexOf("：");
                if (idx < 0) idx = trimmed.indexOf(":");
                currentTable = idx >= 0 ? trimmed.substring(idx + 1).trim() : "";
                include = topTables.contains(currentTable);
            }
            if (include) {
                schema.append(line).append("\n");
            }
        }
        return schema.toString();
    }

    /**
     * 根据错误信息重新生成 SQL
     */
    private String regenerateSqlWithError(String schema, String question, String failedSql, String error) {
        return chatClientBuilder.build()
                .prompt("""
                        你是一个PostgreSQL专家。
                        
                        数据库表结构：
                        %s
                        
                        用户问题：
                        %s
                        
                        上次生成的SQL：
                        %s
                        
                        执行报错：
                        %s
                        
                        请根据以上信息修复SQL并重新生成。
                        - 只允许生成SELECT语句
                        - 禁止INSERT、UPDATE、DELETE
                        - 禁止Markdown、禁止```sql
                        - 禁止任何解释文字
                        - 返回内容必须以SELECT开头
                        """
                        .formatted(schema, question, failedSql, error))
                .call()
                .content();
    }

    @Override
    public String ragRerankAgentTools(String question) {
        return chatClientBuilder.build()
                .prompt()
                .user(question)
                .toolCallbacks(rerankTools)
                .call()
                .content();
    }


    @Override
    public Flux<String> ragRerankColumnAgentStream(String question) {
        return Flux.defer(() -> {
            try {
                // 1. Tool: 向量搜索候选表
                String tableNamesStr = ragTableSearchTool.searchRelevantTables(question);
                List<String> candidateTables = List.of(tableNamesStr.split("\n"));
                log.info("向量搜索候选表: {}", candidateTables);

                // 2. Tool: 加载列元数据
                String columnMetaText = dynamicColumnTool.loadColumnMetadata(candidateTables);

                // 3. Tool: 列级 Rerank
                String rerankedStr = rerankTool.rerankWithColumns(question, columnMetaText);
                List<String> topTables = Arrays.stream(rerankedStr.split("\n"))
                        .filter(s -> !s.isBlank())
                        .toList();
                log.info("列级Rerank 后选中表: {}", topTables);

                // 4. 为 top 表构造 schema
                String schema = buildSchemaForTables(columnMetaText, topTables);

                //TODO llm生成的SQL准确定不高，表复杂度升高。
                // sqlExample 通过question embedding查询历史SQL 和 top表构造schema 经过rerank后
                // 同时丢给llm 生成更加准确的SQL

                // 5-6. Tool: 生成 SQL + 执行（失败重试最多3次）
                String sql = sqlGenerateTool.generateSql(question, schema);
                List<Map<String, Object>> result = null;
                String lastError = null;

                for (int attempt = 0; attempt < 3; attempt++) {
                    try {
                        if (attempt > 0) {
                            sql = regenerateSqlWithError(schema, question, sql, lastError);
                            log.info("LLM 重新生成的 SQL (第{}次): {}", attempt + 1, sql);
                        } else {
                            log.info("LLM 生成的 SQL: {}", sql);
                        }
                        result = sqlExecuteTool.executeSql(sql);
                        lastError = null;
                        break;
                    } catch (Exception e) {
                        lastError = e.getMessage();
                        log.warn("SQL 执行失败 (第{}次): {}", attempt + 1, lastError);
                    }
                }
                if (lastError != null) {
                    return Flux.just("SQL执行失败3次: " + lastError);
                }

                // 7. LLM 自然语言回答，流式输出
                String answerPrompt = """
                        用户问题：%s
                        
                        查询SQL：%s
                        
                        查询结果：%s
                        
                        请用自然语言回答用户的问题。
                        """
                        .formatted(question, sql, JSON.toJSONString(result));

                return Flux.concat(
//                        Flux.just("向量搜索候选表: " + candidateTables + "\n"),
//                        Flux.just("列级Rerank结果: " + topTables + "\n"),
//                        Flux.just("生成SQL: " + sql + "\n\n"),
                        chatClientBuilder.build()
                                .prompt(answerPrompt)
                                .stream()
                                .content()
                );
            } catch (Exception e) {
                log.error("ragRerankColumnAgentStream 失败", e);
                return Flux.just("错误: " + e.getMessage());
            }
        });
    }


    @Override
    public Flux<String> text2SqlAgent(String question) {
        return Flux.defer(() -> {
            try {
                // 1. Tool: 向量搜索候选表
                String tableNamesStr = ragTableSearchTool.searchRelevantTables(question);
                List<String> candidateTables = List.of(tableNamesStr.split("\n"));
                log.info("向量搜索候选表: {}", candidateTables);

                // 2. Tool: 加载列元数据
                String columnMetaText = dynamicColumnTool.loadColumnMetadata(candidateTables);

                // 3. Tool: 列级 Rerank
                String rerankedStr = rerankTool.rerankWithColumns(question, columnMetaText);
                List<String> topTables = Arrays.stream(rerankedStr.split("\n"))
                        .filter(s -> !s.isBlank())
                        .toList();
                log.info("列级Rerank 后选中表:\n {}", topTables);

                // 4. 为 top 表构造 schema
                String schema = buildSchemaForTables(columnMetaText, topTables);

                // 5. planning
                String planningPrompt = planningTool.planningPrompt(question, schema);
                log.info("planningPrompt:\n {}", planningPrompt);

                // 6. generate SQL
                String generatedSqlByPlan = sqlGenerateTool.generateSqlByPlan(planningPrompt, schema);
                log.info("LLM 生成的 SQL:\n {}", generatedSqlByPlan);

                // 7. review
                ReviewResult reviewResultEntity = reviewTool.reviewSql(generatedSqlByPlan, schema);
                log.info("reviewResult:\n {}", JSON.toJSONString(reviewResultEntity));
                // 8. regenerate SQL
                for (int i = 0; i < 3; i++) {
                    if (!reviewResultEntity.getResult()) {
                        generatedSqlByPlan = sqlGenerateTool.generateSqlByErrorReason(reviewResultEntity.getReason(), schema);
                        log.info("LLM 第{}次,重新生成的 SQL: {}", i, generatedSqlByPlan);
                        reviewResultEntity = reviewTool.reviewSql(generatedSqlByPlan, schema);

                    }
                }
                List<Map<String, Object>> result = null;
                String lastError = null;

                for (int attempt = 0; attempt < 3; attempt++) {
                    try {
                        if (attempt > 0) {
                            generatedSqlByPlan = sqlGenerateTool.generateSqlByErrorReason(lastError, schema);
                            log.info("LLM 重新生成的 SQL (第{}次):{}", attempt + 1, generatedSqlByPlan);
                        }
                        result = sqlExecuteTool.executeSql(generatedSqlByPlan);
                        lastError = null;
                        break;
                    } catch (Exception e) {
                        lastError = e.getMessage();
                        log.warn("SQL 执行失败 (第{}次): {}", attempt + 1, lastError);
                    }
                }
                if (lastError != null) {
                    return Flux.just("SQL执行失败3次: " + lastError);
                }

                // 7. LLM 自然语言回答，流式输出
                String answerPrompt = """
                        用户问题：%s
                        
                        查询SQL：%s
                        
                        查询结果：%s
                        
                        请用自然语言回答用户的问题。
                        """
                        .formatted(question, generatedSqlByPlan, JSON.toJSONString(result));
                log.info("answerPrompt:\n {}", answerPrompt);
                return Flux.concat(
                        chatClientBuilder.build()
                                .prompt(answerPrompt)
                                .stream()
                                .content()
                );
            } catch (Exception e) {
                log.error("ragRerankColumnAgentStream 失败", e);
                return Flux.just("错误: " + e.getMessage());
            }
        });
    }

    @Override
    public Flux<String> text2SqlAgentTools(String question) {
        return text2SqlAgentService.executeStream(question);
    }


}
