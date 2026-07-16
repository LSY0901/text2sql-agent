package com.example.firstaidemo.semanticdsl.enricher;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslEntity;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslFilter;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslRelation;
import com.example.firstaidemo.semanticdsl.model.DslCandidate;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import com.example.firstaidemo.semanticdsl.model.SemanticFilter;
import com.example.firstaidemo.semanticdsl.model.SemanticQueryDSL;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

/**
 * 将语义 DSL 富化为带物理表/列/JOIN/WHERE 的 EnrichedQueryDSL。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SemanticDslEnricher {

    private final IDslMetaDataService metaDataService;

    /**
     * 富化语义 DSL。
     *
     * @param semanticDSL 语义 DSL
     * @param candidate   检索候选
     * @return 富化结果
     */
    public EnrichedQueryDSL enrich(SemanticQueryDSL semanticDSL, DslCandidate candidate) {
        log.info("━━━ DSL Enricher 启动 ━━━");

        EnrichedQueryDSL enriched = new EnrichedQueryDSL();
        enriched.setLimit(1000);

        DslEntity mainEntity = resolveMainEntity(semanticDSL, candidate);
        if (mainEntity == null) {
            log.warn("未找到主实体，返回空EnrichedQueryDSL");
            return enriched;
        }

        enriched.setMainEntity(mainEntity.getEntityCode());
        enriched.setMainPhysicalTable(mainEntity.getPhysicalTable());
        enriched.setMainPrimaryKey(mainEntity.getPrimaryKey());

        List<EnrichedQueryDSL.SelectColumn> selectColumns = new ArrayList<>();
        List<EnrichedQueryDSL.EnrichedJoin> joins = new ArrayList<>();
        List<EnrichedQueryDSL.WhereColumn> whereConditions = new ArrayList<>();
        List<String> groupBy = new ArrayList<>();
        Set<String> joinedEntities = new HashSet<>();
        joinedEntities.add(mainEntity.getEntityCode());

        // 指标 → SELECT（避免对已含聚合的 expression 二次包裹）
        if (semanticDSL.getMetric() != null && !semanticDSL.getMetric().isEmpty()) {
            DslMetric metric = findMetric(semanticDSL.getMetric(), candidate);
            if (metric != null) {
                EnrichedQueryDSL.SelectColumn col = new EnrichedQueryDSL.SelectColumn();
                col.setExpression(buildMetricExpression(metric));
                col.setAlias(metric.getMetricCode());
                selectColumns.add(col);
            }
        }

        // 维度 → SELECT + GROUP BY + JOIN
        if (semanticDSL.getDimensions() != null) {
            for (String dimCode : semanticDSL.getDimensions()) {
                DslDimension dim = findDimension(dimCode, candidate);
                if (dim == null) {
                    continue;
                }
                String qualifiedCol = qualifyColumn(dim, candidate);
                EnrichedQueryDSL.SelectColumn col = new EnrichedQueryDSL.SelectColumn();
                col.setExpression(qualifiedCol);
                col.setAlias(dim.getDimensionCode());
                selectColumns.add(col);
                groupBy.add(qualifiedCol);
                ensureJoinsForEntity(dim.getEntityCode(), mainEntity, candidate,
                        joins, joinedEntities);
            }
        }
        enriched.setGroupBy(groupBy);

        // 过滤 → WHERE + 必要 JOIN（同维度多值合并为 IN）
        if (semanticDSL.getFilters() != null && !semanticDSL.getFilters().isEmpty()) {
            Map<String, List<SemanticFilter>> grouped = new LinkedHashMap<>();
            for (SemanticFilter filter : semanticDSL.getFilters()) {
                grouped.computeIfAbsent(filter.getDimension(), k -> new ArrayList<>()).add(filter);
            }
            for (Map.Entry<String, List<SemanticFilter>> entry : grouped.entrySet()) {
                String dimCode = entry.getKey();
                List<SemanticFilter> filters = entry.getValue();
                DslDimension dim = findDimension(dimCode, candidate);
                if (dim == null) {
                    log.warn("过滤维度不在候选中: {}", dimCode);
                    continue;
                }
                ensureJoinsForEntity(dim.getEntityCode(), mainEntity, candidate,
                        joins, joinedEntities);

                List<Object> params = new ArrayList<>();
                for (SemanticFilter filter : filters) {
                    params.add(resolvePhysicalValue(dimCode, filter.getValue(), candidate));
                }
                EnrichedQueryDSL.WhereColumn where = new EnrichedQueryDSL.WhereColumn();
                String col = qualifyColumn(dim, candidate);
                if (params.size() == 1) {
                    where.setExpression(col + " = ?");
                } else {
                    String placeholders = String.join(", ",
                            Collections.nCopies(params.size(), "?"));
                    where.setExpression(col + " IN (" + placeholders + ")");
                }
                where.setParameters(params);
                where.setSystemFilter(false);
                whereConditions.add(where);
            }
        }

        // 系统过滤（跳过无意义的 IS NOT NULL）
        if (candidate.getSystemFilters() != null) {
            for (DslFilter sysFilter : candidate.getSystemFilters()) {
                if (!mainEntity.getEntityCode().equals(sysFilter.getEntityCode())
                        || !Boolean.TRUE.equals(sysFilter.getIsSystem())) {
                    continue;
                }
                if (isTautologyFilter(sysFilter.getExpression())) {
                    log.info("跳过无意义系统过滤: {}", sysFilter.getExpression());
                    continue;
                }
                EnrichedQueryDSL.WhereColumn where = new EnrichedQueryDSL.WhereColumn();
                where.setExpression(sysFilter.getExpression());
                where.setSystemFilter(true);
                whereConditions.add(where);
            }
        }

        enriched.setSelectColumns(selectColumns);
        enriched.setJoins(joins);
        enriched.setWhereConditions(whereConditions);

        log.info("━━━ DSL Enricher 完成: selectCols={}, joins={}, wheres={} ━━━",
                selectColumns.size(), joins.size(), whereConditions.size());
        return enriched;
    }

    /**
     * 构建指标表达式：expression 已含聚合则不再包裹 aggregation_type。
     */
    private String buildMetricExpression(DslMetric metric) {
        String expr = metric.getExpression() == null ? "" : metric.getExpression().trim();
        String agg = metric.getAggregationType();
        if (agg == null || agg.isBlank()) {
            return expr;
        }
        if (alreadyAggregated(expr)) {
            return expr;
        }
        return agg.trim() + "(" + expr + ")";
    }

    /**
     * 判断表达式是否已是聚合函数。
     */
    private boolean alreadyAggregated(String expr) {
        if (expr == null || expr.isEmpty()) {
            return false;
        }
        String upper = expr.toUpperCase();
        return upper.startsWith("COUNT(")
                || upper.startsWith("SUM(")
                || upper.startsWith("AVG(")
                || upper.startsWith("MAX(")
                || upper.startsWith("MIN(");
    }

    /**
     * 是否为无业务含义的 tautology 过滤（如 id IS NOT NULL）。
     */
    private boolean isTautologyFilter(String expression) {
        if (expression == null) {
            return false;
        }
        return expression.toUpperCase().matches(".*\\bIS\\s+NOT\\s+NULL\\s*$");
    }

    /**
     * 解析主实体。
     */
    private DslEntity resolveMainEntity(SemanticQueryDSL semanticDSL, DslCandidate candidate) {
        if (semanticDSL.getEntity() != null) {
            DslEntity fromCandidate = findEntity(semanticDSL.getEntity(), candidate);
            if (fromCandidate != null) {
                return fromCandidate;
            }
            return metaDataService.getEntityByCode(semanticDSL.getEntity());
        }
        if (candidate.getEntities() != null && !candidate.getEntities().isEmpty()) {
            return candidate.getEntities().get(0);
        }
        return null;
    }

    /**
     * 为维度/过滤所属实体补齐到主实体的 JOIN 路径（支持多跳）。
     */
    private void ensureJoinsForEntity(String targetEntityCode,
                                      DslEntity mainEntity,
                                      DslCandidate candidate,
                                      List<EnrichedQueryDSL.EnrichedJoin> joins,
                                      Set<String> joinedEntities) {
        if (targetEntityCode == null
                || targetEntityCode.equals(mainEntity.getEntityCode())
                || joinedEntities.contains(targetEntityCode)) {
            return;
        }

        List<DslRelation> relations = candidate.getRelations() != null
                ? candidate.getRelations() : metaDataService.getAllRelations();
        List<DslRelation> path = findRelationPath(
                mainEntity.getEntityCode(), targetEntityCode, relations);
        if (path.isEmpty()) {
            log.warn("无法找到 JOIN 路径: {} -> {}", mainEntity.getEntityCode(), targetEntityCode);
            return;
        }

        String current = mainEntity.getEntityCode();
        for (DslRelation relation : path) {
            String next = relation.getSourceEntity().equals(current)
                    ? relation.getTargetEntity() : relation.getSourceEntity();
            if (!joinedEntities.contains(next)) {
                DslEntity target = findEntity(next, candidate);
                if (target == null) {
                    target = metaDataService.getEntityByCode(next);
                }
                if (target == null) {
                    log.warn("JOIN 目标实体不存在: {}", next);
                    return;
                }
                EnrichedQueryDSL.EnrichedJoin join = new EnrichedQueryDSL.EnrichedJoin();
                join.setJoinType(normalizeJoinType(relation.getJoinType()));
                join.setPhysicalTable(target.getPhysicalTable());
                join.setOnCondition(relation.getJoinCondition());
                join.setSourceRelation(relation);
                joins.add(join);
                joinedEntities.add(next);
            }
            current = next;
        }
    }

    /**
     * BFS 查找实体间关系路径。
     */
    private List<DslRelation> findRelationPath(String from, String to,
                                               List<DslRelation> relations) {
        if (from.equals(to)) {
            return List.of();
        }
        Map<String, List<DslRelation>> graph = new HashMap<>();
        for (DslRelation r : relations) {
            if (Boolean.TRUE.equals(r.getIsDeleted())) {
                continue;
            }
            graph.computeIfAbsent(r.getSourceEntity(), k -> new ArrayList<>()).add(r);
            graph.computeIfAbsent(r.getTargetEntity(), k -> new ArrayList<>()).add(r);
        }

        Queue<String> queue = new ArrayDeque<>();
        Map<String, String> prevNode = new HashMap<>();
        Map<String, DslRelation> prevEdge = new HashMap<>();
        queue.add(from);
        prevNode.put(from, null);

        while (!queue.isEmpty()) {
            String cur = queue.poll();
            if (cur.equals(to)) {
                break;
            }
            for (DslRelation r : graph.getOrDefault(cur, List.of())) {
                String next = r.getSourceEntity().equals(cur)
                        ? r.getTargetEntity() : r.getSourceEntity();
                if (prevNode.containsKey(next)) {
                    continue;
                }
                prevNode.put(next, cur);
                prevEdge.put(next, r);
                queue.add(next);
            }
        }

        if (!prevNode.containsKey(to)) {
            return List.of();
        }
        List<DslRelation> path = new ArrayList<>();
        String cur = to;
        while (prevEdge.containsKey(cur)) {
            path.add(0, prevEdge.get(cur));
            cur = prevNode.get(cur);
        }
        return path;
    }

    /**
     * 规范化 JOIN 类型，避免出现 "INNER JOIN JOIN"。
     */
    private String normalizeJoinType(String joinType) {
        if (joinType == null || joinType.isBlank()) {
            return "LEFT JOIN";
        }
        String trimmed = joinType.trim();
        if (trimmed.toUpperCase().contains("JOIN")) {
            return trimmed;
        }
        return trimmed + " JOIN";
    }

    /**
     * 为物理列补上表名前缀，降低歧义。
     */
    private String qualifyColumn(DslDimension dim, DslCandidate candidate) {
        String col = dim.getPhysicalColumn();
        if (col == null) {
            return null;
        }
        if (col.contains(".")) {
            return col;
        }
        DslEntity entity = findEntity(dim.getEntityCode(), candidate);
        if (entity == null) {
            entity = metaDataService.getEntityByCode(dim.getEntityCode());
        }
        if (entity != null && entity.getPhysicalTable() != null) {
            return entity.getPhysicalTable() + "." + col;
        }
        return col;
    }

    /**
     * 解析过滤值：优先 value_code，其次 value_name，最后回退原值。
     */
    private String resolvePhysicalValue(String dimensionCode, String valueCode,
                                        DslCandidate candidate) {
        List<DslDimensionValue> values = candidate.getDimensionValues();
        if (values == null || values.isEmpty()) {
            values = metaDataService.getDimensionValuesByCodes(List.of(dimensionCode));
        }
        final List<DslDimensionValue> lookup = values == null ? List.of() : values;

        return lookup.stream()
                .filter(v -> dimensionCode.equals(v.getDimensionCode())
                        && valueCode.equals(v.getValueCode()))
                .map(DslDimensionValue::getPhysicalValue)
                .findFirst()
                .or(() -> lookup.stream()
                        .filter(v -> dimensionCode.equals(v.getDimensionCode())
                                && (valueCode.equals(v.getValueName())
                                || valueCode.equals(v.getPhysicalValue())))
                        .map(DslDimensionValue::getPhysicalValue)
                        .findFirst())
                .orElseGet(() -> {
                    log.warn("维度值未在元数据中找到，回退原值: dim={}, value={}",
                            dimensionCode, valueCode);
                    return valueCode;
                });
    }

    private DslMetric findMetric(String code, DslCandidate candidate) {
        if (candidate.getMetrics() == null) {
            return metaDataService.getMetricByCode(code);
        }
        return candidate.getMetrics().stream()
                .filter(m -> code.equals(m.getMetricCode()))
                .findFirst()
                .orElseGet(() -> metaDataService.getMetricByCode(code));
    }

    private DslDimension findDimension(String code, DslCandidate candidate) {
        if (candidate.getDimensions() != null) {
            DslDimension found = candidate.getDimensions().stream()
                    .filter(d -> code.equals(d.getDimensionCode()))
                    .findFirst()
                    .orElse(null);
            if (found != null) {
                return found;
            }
        }
        return metaDataService.getDimensionByCode(code);
    }

    private DslEntity findEntity(String code, DslCandidate candidate) {
        if (candidate.getEntities() == null) {
            return null;
        }
        return candidate.getEntities().stream()
                .filter(e -> code.equals(e.getEntityCode()))
                .findFirst()
                .orElse(null);
    }
}
