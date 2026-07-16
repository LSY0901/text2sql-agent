package com.example.firstaidemo.semanticdsl.enricher;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.*;
import com.example.firstaidemo.semanticdsl.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class SemanticDslEnricher {

    private final IDslMetaDataService metaDataService;

    public EnrichedQueryDSL enrich(SemanticQueryDSL semanticDSL, DslCandidate candidate) {
        log.info("━━━ DSL Enricher 启动 ━━━");

        EnrichedQueryDSL enriched = new EnrichedQueryDSL();
        enriched.setLimit(1000);

        // 查找主实体
        DslEntity mainEntity = candidate.getEntities().stream()
                .filter(e -> e.getEntityCode().equals(semanticDSL.getEntity()))
                .findFirst()
                .orElse(candidate.getEntities().isEmpty() ? null : candidate.getEntities().get(0));

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

        // 处理指标 → SELECT
        if (semanticDSL.getMetric() != null && !semanticDSL.getMetric().isEmpty()) {
            DslMetric metric = candidate.getMetrics().stream()
                    .filter(m -> m.getMetricCode().equals(semanticDSL.getMetric()))
                    .findFirst()
                    .orElse(null);
            if (metric != null) {
                EnrichedQueryDSL.SelectColumn col = new EnrichedQueryDSL.SelectColumn();
                String expr = metric.getExpression();
                if (metric.getAggregationType() != null) {
                    expr = metric.getAggregationType() + "(" + expr + ")";
                }
                col.setExpression(expr);
                col.setAlias(metric.getMetricCode());
                selectColumns.add(col);
            }
        }

        // 处理维度 → SELECT + GROUP BY
        if (semanticDSL.getDimensions() != null) {
            for (String dimCode : semanticDSL.getDimensions()) {
                DslDimension dim = candidate.getDimensions().stream()
                        .filter(d -> d.getDimensionCode().equals(dimCode))
                        .findFirst()
                        .orElse(null);
                if (dim != null) {
                    EnrichedQueryDSL.SelectColumn col = new EnrichedQueryDSL.SelectColumn();
                    col.setExpression(dim.getPhysicalColumn());
                    col.setAlias(dim.getDimensionCode());
                    selectColumns.add(col);
                    groupBy.add(dim.getPhysicalColumn());

                    // 如果维度所属实体 != 主实体，需要JOIN
                    if (!dim.getEntityCode().equals(mainEntity.getEntityCode())) {
                        addJoinForEntity(dim.getEntityCode(), candidate, mainEntity, joins);
                    }
                }
            }
        }
        enriched.setGroupBy(groupBy);

        // 处理过滤条件 → WHERE
        if (semanticDSL.getFilters() != null) {
            for (SemanticFilter filter : semanticDSL.getFilters()) {
                DslDimension dim = candidate.getDimensions().stream()
                        .filter(d -> d.getDimensionCode().equals(filter.getDimension()))
                        .findFirst()
                        .orElse(null);
                if (dim != null) {
                    String physicalValue = resolvePhysicalValue(filter.getDimension(), filter.getValue(), candidate);
                    EnrichedQueryDSL.WhereColumn where = new EnrichedQueryDSL.WhereColumn();
                    where.setExpression(dim.getPhysicalColumn() + " = '" + physicalValue + "'");
                    where.setSystemFilter(false);
                    whereConditions.add(where);
                }
            }
        }

        // 追加系统过滤条件
        for (DslFilter sysFilter : candidate.getSystemFilters()) {
            if (sysFilter.getEntityCode().equals(mainEntity.getEntityCode()) && Boolean.TRUE.equals(sysFilter.getIsSystem())) {
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

    private void addJoinForEntity(String entityCode, DslCandidate candidate, DslEntity mainEntity,
                                   List<EnrichedQueryDSL.EnrichedJoin> joins) {
        DslRelation relation = candidate.getRelations().stream()
                .filter(r -> (r.getSourceEntity().equals(mainEntity.getEntityCode()) && r.getTargetEntity().equals(entityCode))
                        || (r.getTargetEntity().equals(mainEntity.getEntityCode()) && r.getSourceEntity().equals(entityCode)))
                .findFirst()
                .orElse(null);
        if (relation != null) {
            DslEntity targetEntity = candidate.getEntities().stream()
                    .filter(e -> e.getEntityCode().equals(entityCode))
                    .findFirst()
                    .orElse(null);
            if (targetEntity != null) {
                EnrichedQueryDSL.EnrichedJoin join = new EnrichedQueryDSL.EnrichedJoin();
                join.setJoinType(relation.getJoinType() != null ? relation.getJoinType() : "LEFT");
                join.setPhysicalTable(targetEntity.getPhysicalTable());
                join.setOnCondition(relation.getJoinCondition());
                join.setSourceRelation(relation);
                joins.add(join);
            }
        }
    }

    private String resolvePhysicalValue(String dimensionCode, String valueCode, DslCandidate candidate) {
        return candidate.getDimensionValues().stream()
                .filter(v -> v.getDimensionCode().equals(dimensionCode) && v.getValueCode().equals(valueCode))
                .map(DslDimensionValue::getPhysicalValue)
                .findFirst()
                .orElse(valueCode);
    }
}
