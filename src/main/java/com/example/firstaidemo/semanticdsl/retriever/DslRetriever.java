package com.example.firstaidemo.semanticdsl.retriever;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.*;
import com.example.firstaidemo.semanticdsl.model.DslCandidate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class DslRetriever {

    private final IDslMetaDataService metaDataService;
    private final EmbeddingModel embeddingModel;
    private final RerankClient rerankClient;

    public DslCandidate retrieve(String question) {
        log.info("━━━ DSL Retriever 启动 ━━━");

        // 1. 问题向量化 (BGE-M3)
        float[] questionVector = embeddingModel.embed(question);
        String vectorStr = toVectorStr(questionVector);

        // 2. 向量召回 top-N
        int recallTopN = 10;
        List<String> metricCodes = metaDataService.searchMetricsByVector(vectorStr, recallTopN);
        List<String> dimensionCodes = metaDataService.searchDimensionsByVector(vectorStr, recallTopN);
        List<String> synonymObjectCodes = metaDataService.searchSynonymsByVector(vectorStr, recallTopN);
        log.info("向量召回: metrics={}, dimensions={}, synonyms={}", metricCodes.size(), dimensionCodes.size(), synonymObjectCodes.size());

        // 3. 加载候选元数据
        List<DslMetric> candidateMetrics = metaDataService.getMetricsByCodes(metricCodes);
        List<DslDimension> candidateDimensions = metaDataService.getDimensionsByCodes(dimensionCodes);
        List<DslSynonym> candidateSynonyms = metaDataService.getAllSynonyms().stream()
                .filter(s -> synonymObjectCodes.contains(s.getObjectCode()))
                .collect(Collectors.toList());

        // 4. Reranker 精排
        List<DslMetric> rerankedMetrics = rerankMetrics(question, candidateMetrics);
        List<DslDimension> rerankedDimensions = rerankDimensions(question, candidateDimensions);

        // 5. 取 top-K
        int topK = 3;
        List<DslMetric> topMetrics = rerankedMetrics.stream().limit(topK).collect(Collectors.toList());
        List<DslDimension> topDimensions = rerankedDimensions.stream().limit(topK * 2).collect(Collectors.toList());

        // 6. 加载关联元数据
        Set<String> entityCodes = topMetrics.stream().map(DslMetric::getEntityCode).collect(Collectors.toSet());
        List<DslEntity> entities = metaDataService.getEntitiesByCodes(new ArrayList<>(entityCodes));
        List<DslRelation> relations = metaDataService.getAllRelations();
        List<DslFilter> systemFilters = entities.stream()
                .flatMap(e -> metaDataService.getSystemFilters(e.getEntityCode()).stream())
                .collect(Collectors.toList());
        List<DslAttribute> attributes = entities.stream()
                .flatMap(e -> metaDataService.getAttributesByEntityCode(e.getEntityCode()).stream())
                .collect(Collectors.toList());
        List<DslDimensionValue> dimensionValues = metaDataService.getDimensionValuesByCodes(
                topDimensions.stream().map(DslDimension::getDimensionCode).collect(Collectors.toList()));

        DslCandidate candidate = new DslCandidate();
        candidate.setMetrics(topMetrics);
        candidate.setEntities(entities);
        candidate.setDimensions(topDimensions);
        candidate.setDimensionValues(dimensionValues);
        candidate.setSynonyms(candidateSynonyms);
        candidate.setRelations(relations);
        candidate.setSystemFilters(systemFilters);
        candidate.setAttributes(attributes);

        log.info("━━━ DSL Retriever 完成: metrics={}, dimensions={}, entities={} ━━━",
                topMetrics.size(), topDimensions.size(), entities.size());
        return candidate;
    }

    private List<DslMetric> rerankMetrics(String question, List<DslMetric> candidates) {
        if (candidates.isEmpty()) return Collections.emptyList();
        List<String> documents = candidates.stream()
                .map(m -> m.getMetricName() + " " + (m.getDescription() != null ? m.getDescription() : ""))
                .collect(Collectors.toList());
        List<Double> scores = rerankClient.rerank(question, documents);
        return sortByScore(candidates, scores);
    }

    private List<DslDimension> rerankDimensions(String question, List<DslDimension> candidates) {
        if (candidates.isEmpty()) return Collections.emptyList();
        List<String> documents = candidates.stream()
                .map(d -> d.getDimensionName() + " " + (d.getDescription() != null ? d.getDescription() : ""))
                .collect(Collectors.toList());
        List<Double> scores = rerankClient.rerank(question, documents);
        return sortByScore(candidates, scores);
    }

    private <T> List<T> sortByScore(List<T> items, List<Double> scores) {
        List<int[]> indexed = new ArrayList<>();
        for (int i = 0; i < items.size(); i++) indexed.add(new int[]{i, i});
        indexed.sort((a, b) -> Double.compare(scores.get(b[0]), scores.get(a[0])));
        return indexed.stream().map(idx -> items.get(idx[0])).collect(Collectors.toList());
    }

    private static String toVectorStr(float[] vector) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < vector.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(vector[i]);
        }
        sb.append("]");
        return sb.toString();
    }

    @lombok.extern.slf4j.Slf4j
    @Component
    public static class RerankClient {
        private final RestClient rerankClient;

        public RerankClient(
                @org.springframework.beans.factory.annotation.Value("${rerank.base-url:http://localhost:8083}") String baseUrl) {
            this.rerankClient = RestClient.builder().baseUrl(baseUrl).build();
        }

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
            // fallback: 返回等分，保持原顺序
            return documents.stream().map(d -> 0.0).collect(Collectors.toList());
        }
    }
}
