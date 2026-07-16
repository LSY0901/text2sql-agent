package com.example.firstaidemo.semanticdsl.translator;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.SelectColumn;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.EnrichedJoin;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL.WhereColumn;

import java.util.List;
import java.util.stream.Collectors;

public abstract class AbstractDslTranslator implements DslTranslator {

    @Override
    public String translate(EnrichedQueryDSL dsl) {
        StringBuilder sql = new StringBuilder();
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
                    .map(WhereColumn::getExpression)
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
        return sql.toString();
    }

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

    protected String buildJoinClause(EnrichedJoin join) {
        return join.getJoinType() + " JOIN " + quoteIdentifier(join.getPhysicalTable())
                + " ON " + join.getOnCondition();
    }

    protected abstract String quoteIdentifier(String identifier);
}
