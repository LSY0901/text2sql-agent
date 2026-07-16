package com.example.firstaidemo.semanticdsl.translator;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.EnrichedJoin;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.SelectColumn;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.WhereColumn;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DSL → SQL 翻译公共逻辑，方言差异由子类实现标识符引用规则。
 */
public abstract class AbstractDslTranslator implements DslTranslator {

    /**
     * 组装 SELECT / FROM / JOIN / WHERE / GROUP BY / LIMIT，并收集绑定参数。
     *
     * @param dsl 富化 DSL
     * @return SQL 与参数
     */
    @Override
    public TranslatedSql translate(EnrichedQueryDSL dsl) {
        if (dsl == null || dsl.getMainPhysicalTable() == null
                || dsl.getMainPhysicalTable().isEmpty()) {
            throw new IllegalArgumentException("富化DSL缺少主表，无法翻译SQL");
        }
        if (dsl.getSelectColumns() == null || dsl.getSelectColumns().isEmpty()) {
            throw new IllegalArgumentException("富化DSL缺少SELECT列，无法翻译SQL");
        }

        StringBuilder sql = new StringBuilder();
        List<Object> parameters = new ArrayList<>();

        sql.append("SELECT ");
        sql.append(buildSelectClause(dsl.getSelectColumns()));
        sql.append(" FROM ");
        sql.append(quoteIdentifier(dsl.getMainPhysicalTable()));

        if (dsl.getJoins() != null && !dsl.getJoins().isEmpty()) {
            for (EnrichedJoin join : dsl.getJoins()) {
                sql.append(" ").append(buildJoinClause(join));
            }
        }

        List<WhereColumn> wheres = dsl.getWhereConditions();
        if (wheres != null && !wheres.isEmpty()) {
            sql.append(" WHERE ");
            sql.append(wheres.stream()
                    .map(w -> {
                        if (w.getParameters() != null && !w.getParameters().isEmpty()) {
                            parameters.addAll(w.getParameters());
                        }
                        return w.getExpression();
                    })
                    .collect(Collectors.joining(" AND ")));
        }

        if (dsl.getGroupBy() != null && !dsl.getGroupBy().isEmpty()) {
            sql.append(" GROUP BY ");
            sql.append(dsl.getGroupBy().stream()
                    .map(this::quoteIdentifier)
                    .collect(Collectors.joining(", ")));
        }

        if (dsl.getLimit() != null && dsl.getLimit() > 0) {
            sql.append(" LIMIT ").append(dsl.getLimit());
        }

        return new TranslatedSql(sql.toString(), parameters);
    }

    /**
     * 构建 SELECT 子句。
     */
    protected String buildSelectClause(List<SelectColumn> columns) {
        return columns.stream()
                .map(c -> {
                    String expr = c.getExpression();
                    if (c.getAlias() != null && !c.getAlias().isEmpty()) {
                        return expr + " AS " + quoteIdentifier(c.getAlias());
                    }
                    return expr;
                })
                .collect(Collectors.joining(", "));
    }

    /**
     * 构建 JOIN 子句。
     */
    protected String buildJoinClause(EnrichedJoin join) {
        String joinType = join.getJoinType() != null ? join.getJoinType().trim() : "LEFT JOIN";
        if (!joinType.toUpperCase().contains("JOIN")) {
            joinType = joinType + " JOIN";
        }
        return joinType + " " + quoteIdentifier(join.getPhysicalTable())
                + " ON " + join.getOnCondition();
    }

    /**
     * 按方言对标识符加引号。
     *
     * @param identifier 表名/列名，支持 schema.table 形式
     * @return 引用后的标识符
     */
    protected abstract String quoteIdentifier(String identifier);
}
