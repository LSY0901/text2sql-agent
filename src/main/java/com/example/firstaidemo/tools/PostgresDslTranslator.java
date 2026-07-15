package com.example.firstaidemo.tools;

import com.example.firstaidemo.models.dsl.JoinClause;
import com.example.firstaidemo.models.dsl.OrderByClause;
import com.example.firstaidemo.models.dsl.QueryDSL;
import com.example.firstaidemo.models.dsl.SelectField;
import com.example.firstaidemo.models.dsl.WhereCondition;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * PostgreSQL 方言的 DSL → SQL 翻译器。
 * <p>
 * 纯代码实现，确定性输出，无 LLM 介入。
 */
@Slf4j
@Component
public class PostgresDslTranslator implements DslTranslator {

    @Override
    public String translate(QueryDSL dsl) {
        StringBuilder sql = new StringBuilder();

        // === SELECT ===
        sql.append("SELECT ");
        if (dsl.isDistinct()) {
            sql.append("DISTINCT ");
        }

        if (dsl.getSelectFields() == null || dsl.getSelectFields().isEmpty()) {
            sql.append("*");
        } else {
            sql.append(dsl.getSelectFields().stream()
                    .map(this::formatSelectField)
                    .collect(Collectors.joining(", ")));
        }

        // === FROM ===
        sql.append("\nFROM ").append(quoteIdentifier(dsl.getTable()));
        if (dsl.getTableAlias() != null && !dsl.getTableAlias().isBlank()) {
            sql.append(" AS ").append(quoteIdentifier(dsl.getTableAlias()));
        }

        // === JOIN ===
        if (dsl.getJoins() != null) {
            for (JoinClause join : dsl.getJoins()) {
                String joinType = (join.getType() != null) ? join.getType().toUpperCase() : "INNER";
                sql.append("\n").append(joinType).append(" JOIN ")
                        .append(quoteIdentifier(join.getTable()));
                if (join.getAlias() != null && !join.getAlias().isBlank()) {
                    sql.append(" AS ").append(quoteIdentifier(join.getAlias()));
                }
                sql.append(" ON ").append(join.getOnCondition());
            }
        }

        // === WHERE ===
        if (dsl.getWhereConditions() != null && !dsl.getWhereConditions().isEmpty()) {
            sql.append("\nWHERE ");
            sql.append(buildConditionClause(dsl.getWhereConditions()));
        }

        // === GROUP BY ===
        if (dsl.getGroupBy() != null && !dsl.getGroupBy().isEmpty()) {
            sql.append("\nGROUP BY ").append(String.join(", ", dsl.getGroupBy()));
        }

        // === HAVING ===
        if (dsl.getHaving() != null && !dsl.getHaving().isEmpty()) {
            sql.append("\nHAVING ");
            sql.append(buildConditionClause(dsl.getHaving()));
        }

        // === ORDER BY ===
        if (dsl.getOrderBy() != null && !dsl.getOrderBy().isEmpty()) {
            sql.append("\nORDER BY ");
            sql.append(dsl.getOrderBy().stream()
                    .map(this::formatOrderBy)
                    .collect(Collectors.joining(", ")));
        }

        // === LIMIT ===
        if (dsl.getLimit() != null) {
            sql.append("\nLIMIT ").append(dsl.getLimit());
        }

        // === OFFSET ===
        if (dsl.getOffset() != null) {
            sql.append("\nOFFSET ").append(dsl.getOffset());
        }

        String result = sql.toString();
        log.info("📝 DSL → SQL:\n{}", result);
        return result;
    }

    // ======================== 私有方法 ========================

    private String formatSelectField(SelectField field) {
        String expr = field.getExpression();
        if (field.getAlias() != null && !field.getAlias().isBlank()) {
            return expr + " AS " + quoteIdentifier(field.getAlias());
        }
        return expr;
    }

    private String formatOrderBy(OrderByClause orderBy) {
        String field = orderBy.getField();
        String direction = (orderBy.getDirection() != null) ? orderBy.getDirection().toUpperCase() : "ASC";
        return field + " " + direction;
    }

    /**
     * 构建 WHERE / HAVING 条件子句
     */
    private String buildConditionClause(List<WhereCondition> conditions) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < conditions.size(); i++) {
            WhereCondition cond = conditions.get(i);

            if (i > 0) {
                String logic = (cond.getLogic() != null) ? cond.getLogic().toUpperCase() : "AND";
                sb.append(" ").append(logic).append(" ");
            }

            sb.append(buildSingleCondition(cond));
        }
        return sb.toString();
    }

    /**
     * 构建单个条件表达式
     */
    private String buildSingleCondition(WhereCondition cond) {
        // rawExpression 优先
        if (cond.getRawExpression() != null && !cond.getRawExpression().isBlank()) {
            return cond.getRawExpression();
        }

        String field = cond.getField();
        String operator = cond.getOperator().toUpperCase().trim();
        String value = cond.getValue();
        String valueType = (cond.getValueType() != null) ? cond.getValueType().toLowerCase() : "string";

        // IS NULL / IS NOT NULL
        if ("IS NULL".equals(operator)) {
            return field + " IS NULL";
        }
        if ("IS NOT NULL".equals(operator)) {
            return field + " IS NOT NULL";
        }

        // BETWEEN
        if ("BETWEEN".equals(operator) && value != null) {
            String[] parts = value.split(",");
            if (parts.length == 2) {
                return field + " BETWEEN " + formatValue(parts[0].trim(), valueType)
                        + " AND " + formatValue(parts[1].trim(), valueType);
            }
            // 格式不对，降级为等号
            return field + " = " + formatValue(value, valueType);
        }

        // IN / NOT IN
        if ("IN".equals(operator) || "NOT IN".equals(operator)) {
            if (value != null) {
                String[] parts = value.split(",");
                String formatted = java.util.Arrays.stream(parts)
                        .map(p -> formatValue(p.trim(), valueType))
                        .collect(Collectors.joining(", "));
                return field + " " + operator + " (" + formatted + ")";
            }
        }

        // 普通操作符: =, !=, >, <, >=, <=, LIKE
        return field + " " + operator + " " + formatValue(value, valueType);
    }

    /**
     * 根据值类型格式化值
     */
    private String formatValue(String value, String valueType) {
        if (value == null) {
            return "NULL";
        }

        return switch (valueType) {
            case "number" -> {
                try {
                    yield String.valueOf(Double.parseDouble(value.trim()));
                } catch (NumberFormatException e) {
                    // 不是合法数字，退化为字符串
                    yield "'" + escapeSingleQuotes(value.trim()) + "'";
                }
            }
            case "boolean" -> value.trim().equalsIgnoreCase("true") ? "TRUE" : "FALSE";
            case "raw" -> value.trim();
            default -> {
                // string: 加单引号
                String v = value.trim();
                // 去掉 LLM 可能误加的引号
                if ((v.startsWith("'") && v.endsWith("'")) || (v.startsWith("\"") && v.endsWith("\""))) {
                    v = v.substring(1, v.length() - 1);
                }
                yield "'" + escapeSingleQuotes(v) + "'";
            }
        };
    }

    /**
     * 转义单引号，防止 SQL 注入
     */
    private String escapeSingleQuotes(String value) {
        return value.replace("'", "''");
    }

    /**
     * 引用标识符（PostgreSQL 使用双引号）
     */
    private String quoteIdentifier(String identifier) {
        if (identifier == null) {
            return "";
        }
        // 如果已经包含点号（如 schema.table），分别引用
        if (identifier.contains(".")) {
            return java.util.Arrays.stream(identifier.split("\\."))
                    .map(part -> "\"" + part + "\"")
                    .collect(Collectors.joining("."));
        }
        return "\"" + identifier + "\"";
    }
}
