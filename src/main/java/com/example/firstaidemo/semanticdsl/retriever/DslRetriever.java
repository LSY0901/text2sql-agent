package com.example.firstaidemo.semanticdsl.retriever;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslAttribute;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslEntity;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslFilter;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslRelation;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslSynonym;
import com.example.firstaidemo.semanticdsl.model.DslCandidate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 语义层检索：向量召回 + 同义词扩展 + Rerank。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DslRetriever {

    private final IDslMetaDataService metaDataService;
    private final EmbeddingModel embeddingModel;
    private final RerankClient rerankClient;

    /**
     * 根据用户问题召回候选指标/维度/实体等元数据。
     *
     * @param question 用户问题
     * @return 候选集
     */
    public DslCandidate retrieve(String question) {
        log.info("━━━ DSL Retriever 启动 ━━━");

        float[] questionVector = embeddingModel.embed(question);
        String vectorStr = toVectorStr(questionVector);

        int recallTopN = 10;
        List<String> metricCodes = new ArrayList<>(
                metaDataService.searchMetricsByVector(vectorStr, recallTopN));
        List<String> dimensionCodes = new ArrayList<>(
                metaDataService.searchDimensionsByVector(vectorStr, recallTopN));
        List<DslSynonym> hitSynonyms =
                metaDataService.searchSynonymRowsByVector(vectorStr, recallTopN);
        log.info("向量召回: metrics={}, dimensions={}, synonyms={}",
                metricCodes.size(), dimensionCodes.size(), hitSynonyms.size());

        // 同义词扩展：把 METRIC/DIMENSION/ENTITY 命中并入候选，避免「学生」类问题被成绩指标挤掉
        expandBySynonyms(question, hitSynonyms, metricCodes, dimensionCodes);

        List<DslMetric> candidateMetrics = metaDataService.getMetricsByCodes(metricCodes);
        List<DslDimension> candidateDimensions =
                metaDataService.getDimensionsByCodes(dimensionCodes);

        List<DslMetric> rerankedMetrics = rerankMetrics(question, candidateMetrics);
        List<DslDimension> rerankedDimensions = rerankDimensions(question, candidateDimensions);

        // 计数类问题：把名称含数量/人数/count 的指标置顶
        if (isCountQuestion(question)) {
            rerankedMetrics = boostCountMetrics(rerankedMetrics);
        }

        int topK = 3;
        List<DslMetric> topMetrics = rerankedMetrics.stream()
                .limit(topK).collect(Collectors.toList());
        List<DslDimension> topDimensions = rerankedDimensions.stream()
                .limit(topK * 2L).collect(Collectors.toList());

        log.info("精排后候选指标: {}", topMetrics.stream()
                .map(DslMetric::getMetricCode).collect(Collectors.toList()));

        Set<String> entityCodes = topMetrics.stream()
                .map(DslMetric::getEntityCode)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        // 同义词命中的实体也并入
        for (DslSynonym s : hitSynonyms) {
            if ("ENTITY".equalsIgnoreCase(s.getObjectType()) && s.getObjectCode() != null) {
                entityCodes.add(s.getObjectCode());
            }
        }
        // 维度所属实体并入（过滤/分组时需要 JOIN）
        for (DslDimension d : topDimensions) {
            if (d.getEntityCode() != null) {
                entityCodes.add(d.getEntityCode());
            }
        }
        // JOIN 路径中间实体（如 student→class→grade 中的 class）
        List<DslRelation> relations = metaDataService.getAllRelations();
        entityCodes.addAll(collectBridgeEntities(entityCodes, relations));

        List<DslEntity> entities =
                metaDataService.getEntitiesByCodes(new ArrayList<>(entityCodes));
        List<DslFilter> systemFilters = entities.stream()
                .flatMap(e -> metaDataService.getSystemFilters(e.getEntityCode()).stream())
                .collect(Collectors.toList());
        List<DslAttribute> attributes = entities.stream()
                .flatMap(e -> metaDataService.getAttributesByEntityCode(e.getEntityCode()).stream())
                .collect(Collectors.toList());
        List<DslDimensionValue> dimensionValues = metaDataService.getDimensionValuesByCodes(
                topDimensions.stream()
                        .map(DslDimension::getDimensionCode)
                        .collect(Collectors.toList()));

        DslCandidate candidate = new DslCandidate();
        candidate.setMetrics(topMetrics);
        candidate.setEntities(entities);
        candidate.setDimensions(topDimensions);
        candidate.setDimensionValues(dimensionValues);
        candidate.setSynonyms(hitSynonyms);
        candidate.setRelations(relations);
        candidate.setSystemFilters(systemFilters);
        candidate.setAttributes(attributes);

        log.info("━━━ DSL Retriever 完成: metrics={}, dimensions={}, entities={} ━━━",
                topMetrics.size(), topDimensions.size(), entities.size());
        return candidate;
    }

    /**
     * 收集实体集合之间 JOIN 路径上的中间实体。
     */
    private Set<String> collectBridgeEntities(Set<String> entityCodes,
                                              List<DslRelation> relations) {
        Set<String> bridges = new LinkedHashSet<>();
        List<String> list = new ArrayList<>(entityCodes);
        for (int i = 0; i < list.size(); i++) {
            for (int j = i + 1; j < list.size(); j++) {
                List<String> pathNodes = findEntityPathNodes(list.get(i), list.get(j), relations);
                bridges.addAll(pathNodes);
            }
        }
        bridges.removeAll(entityCodes);
        return bridges;
    }

    /**
     * BFS 返回 from→to 路径上的节点（含两端）。
     */
    private List<String> findEntityPathNodes(String from, String to,
                                             List<DslRelation> relations) {
        if (from.equals(to)) {
            return List.of(from);
        }
        Map<String, List<String>> graph = new HashMap<>();
        for (DslRelation r : relations) {
            graph.computeIfAbsent(r.getSourceEntity(), k -> new ArrayList<>()).add(r.getTargetEntity());
            graph.computeIfAbsent(r.getTargetEntity(), k -> new ArrayList<>()).add(r.getSourceEntity());
        }
        Queue<String> queue = new ArrayDeque<>();
        Map<String, String> prev = new HashMap<>();
        queue.add(from);
        prev.put(from, null);
        while (!queue.isEmpty()) {
            String cur = queue.poll();
            if (cur.equals(to)) {
                break;
            }
            for (String next : graph.getOrDefault(cur, List.of())) {
                if (prev.containsKey(next)) {
                    continue;
                }
                prev.put(next, cur);
                queue.add(next);
            }
        }
        if (!prev.containsKey(to)) {
            return List.of();
        }
        List<String> path = new ArrayList<>();
        String cur = to;
        while (cur != null) {
            path.add(0, cur);
            cur = prev.get(cur);
        }
        return path;
    }

    /**
     * 按同义词命中扩展指标/维度，并对 ENTITY 命中追加该实体下指标。
     */
    private void expandBySynonyms(String question,
                                  List<DslSynonym> hitSynonyms,
                                  List<String> metricCodes,
                                  List<String> dimensionCodes) {
        if (hitSynonyms == null || hitSynonyms.isEmpty()) {
            return;
        }
        Set<String> metricSet = new LinkedHashSet<>(metricCodes);
        Set<String> dimensionSet = new LinkedHashSet<>(dimensionCodes);
        Set<String> entityCodes = new LinkedHashSet<>();

        for (DslSynonym s : hitSynonyms) {
            if (s.getObjectCode() == null || s.getObjectType() == null) {
                continue;
            }
            String type = s.getObjectType().trim().toUpperCase();
            switch (type) {
                case "METRIC" -> metricSet.add(s.getObjectCode());
                case "DIMENSION" -> dimensionSet.add(s.getObjectCode());
                case "ENTITY" -> entityCodes.add(s.getObjectCode());
                default -> log.debug("忽略未知同义词类型: {}", type);
            }
        }

        if (!entityCodes.isEmpty()) {
            // 实体命中 → 并入该实体下全部指标（如「学生」→ student_count）
            for (DslMetric m : metaDataService.getAllMetrics()) {
                if (entityCodes.contains(m.getEntityCode())) {
                    metricSet.add(m.getMetricCode());
                }
            }
            log.info("同义词实体扩展: entities={}, 追加后metrics={}",
                    entityCodes, metricSet.size());
        }

        metricCodes.clear();
        metricCodes.addAll(metricSet);
        dimensionCodes.clear();
        dimensionCodes.addAll(dimensionSet);
        log.info("同义词扩展后: metrics={}, dimensions={}, question={}",
                metricCodes.size(), dimensionCodes.size(), question);
    }

    /**
     * 是否为计数/数量类问题。
     */
    private boolean isCountQuestion(String question) {
        if (question == null) {
            return false;
        }
        return question.contains("多少")
                || question.contains("几个")
                || question.contains("数量")
                || question.contains("人数")
                || question.contains("总数");
    }

    /**
     * 将数量类指标排到前面。
     */
    private List<DslMetric> boostCountMetrics(List<DslMetric> metrics) {
        if (metrics == null || metrics.isEmpty()) {
            return metrics;
        }
        List<DslMetric> boosted = new ArrayList<>();
        List<DslMetric> others = new ArrayList<>();
        for (DslMetric m : metrics) {
            if (isCountMetric(m)) {
                boosted.add(m);
            } else {
                others.add(m);
            }
        }
        boosted.addAll(others);
        return boosted;
    }

    private boolean isCountMetric(DslMetric m) {
        String name = (m.getMetricName() == null ? "" : m.getMetricName())
                + (m.getMetricCode() == null ? "" : m.getMetricCode())
                + (m.getDescription() == null ? "" : m.getDescription());
        String lower = name.toLowerCase();
        return lower.contains("数量")
                || lower.contains("人数")
                || lower.contains("count")
                || lower.contains("统计");
    }

    private List<DslMetric> rerankMetrics(String question, List<DslMetric> candidates) {
        if (candidates.isEmpty()) {
            return Collections.emptyList();
        }
        List<String> documents = candidates.stream()
                .map(m -> m.getMetricName() + " "
                        + (m.getDescription() != null ? m.getDescription() : ""))
                .collect(Collectors.toList());
        List<Double> scores = rerankClient.rerank(question, documents);
        return sortByScore(candidates, scores);
    }

    private List<DslDimension> rerankDimensions(String question, List<DslDimension> candidates) {
        if (candidates.isEmpty()) {
            return Collections.emptyList();
        }
        List<String> documents = candidates.stream()
                .map(d -> d.getDimensionName() + " "
                        + (d.getDescription() != null ? d.getDescription() : ""))
                .collect(Collectors.toList());
        List<Double> scores = rerankClient.rerank(question, documents);
        return sortByScore(candidates, scores);
    }

    private <T> List<T> sortByScore(List<T> items, List<Double> scores) {
        if (scores == null || scores.size() != items.size()) {
            return items;
        }
        List<int[]> indexed = new ArrayList<>();
        for (int i = 0; i < items.size(); i++) {
            indexed.add(new int[]{i, i});
        }
        indexed.sort((a, b) -> Double.compare(scores.get(b[0]), scores.get(a[0])));
        return indexed.stream().map(idx -> items.get(idx[0])).collect(Collectors.toList());
    }

    private static String toVectorStr(float[] vector) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < vector.length; i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(vector[i]);
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Rerank 服务客户端。
     */
    @Slf4j
    @Component
    public static class RerankClient {
        private final RestClient rerankClient;

        public RerankClient(
                @org.springframework.beans.factory.annotation.Value(
                        "${rerank.base-url:http://localhost:8083}") String baseUrl) {
            this.rerankClient = RestClient.builder().baseUrl(baseUrl).build();
        }

        /**
         * 对文档列表按与 query 的相关性打分。
         */
        @SuppressWarnings("unchecked")
        public List<Double> rerank(String query, List<String> documents) {
            try {
                Map<String, Object> body = new HashMap<>();
                body.put("query", query);
                body.put("documents", documents);
                Map<String, Object> resp = rerankClient.post()
                        .uri("/rerank")
                        .body(body)
                        .retrieve()
                        .body(Map.class);
                if (resp != null && resp.containsKey("scores")) {
                    return ((List<Number>) resp.get("scores")).stream()
                            .map(Number::doubleValue)
                            .collect(Collectors.toList());
                }
            } catch (Exception e) {
                log.warn("Rerank 调用失败，跳过精排: {}", e.getMessage());
            }
            return documents.stream().map(d -> 0.0).collect(Collectors.toList());
        }
    }
}
