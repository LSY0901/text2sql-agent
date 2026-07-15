package com.example.firstaidemo.tools;

import com.example.firstaidemo.models.dsl.DslValidationResult;
import com.example.firstaidemo.models.dsl.QueryDSL;
import com.example.firstaidemo.models.dsl.WhereCondition;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * DSL 校验器 — 在生成 SQL 前对 QueryDSL 进行结构性校验。
 * <p>
 * 校验内容：
 * 1. 主表名是否在 Schema 中存在
 * 2. JOIN 表名是否在 Schema 中存在
 * 3. WHERE/HAVING 条件中的字段引用是否合法
 * 4. 操作符是否合法
 * 5. LIMIT/OFFSET 是否为正数
 */
@Slf4j
@Component
public class DslValidator {

    private static final Set<String> VALID_OPERATORS = new HashSet<>(Arrays.asList(
            "=", "!=", ">", "<", ">=", "<=", "LIKE", "IN", "NOT IN",
            "BETWEEN", "IS NULL", "IS NOT NULL"
    ));

    private static final Set<String> VALID_JOIN_TYPES = new HashSet<>(Arrays.asList(
            "INNER", "LEFT", "RIGHT", "FULL"
    ));

    private static final Set<String> VALID_VALUE_TYPES = new HashSet<>(Arrays.asList(
            "string", "number", "boolean", "raw"
    ));

    // 匹配 field 引用中的表别名和字段名，如 "o.status" → alias=o, column=status
    private static final Pattern FIELD_PATTERN = Pattern.compile("([a-zA-Z_][a-zA-Z0-9_]*)\\.([a-zA-Z_][a-zA-Z0-9_]*)");

    /**
     * 校验 DSL
     *
     * @param dsl    查询 DSL
     * @param schema Schema 文本（来自 DynamicColumnTool.loadColumnMetadata 的输出）
     * @return 校验结果
     */
    public DslValidationResult validate(QueryDSL dsl, String schema) {
        DslValidationResult result = DslValidationResult.ok();

        if (dsl == null) {
            return DslValidationResult.fail("DSL 为空");
        }

        // 解析 Schema，构建 表名 → 列名集合 的映射
        Map<String, Set<String>> tableColumns = parseSchema(schema);

        // 1. 校验主表
        if (dsl.getTable() == null || dsl.getTable().isBlank()) {
            result.addError("主表名 (table) 不能为空");
        } else if (!tableColumns.containsKey(dsl.getTable())) {
            result.addError("主表 '" + dsl.getTable() + "' 在 Schema 中不存在。可用表: " + tableColumns.keySet());
        }

        // 2. 校验 JOIN 表
        if (dsl.getJoins() != null) {
            for (var join : dsl.getJoins()) {
                if (join.getTable() == null || join.getTable().isBlank()) {
                    result.addError("JOIN 表名不能为空");
                } else if (!tableColumns.containsKey(join.getTable())) {
                    result.addError("JOIN 表 '" + join.getTable() + "' 在 Schema 中不存在");
                }
                if (join.getType() != null && !VALID_JOIN_TYPES.contains(join.getType().toUpperCase())) {
                    result.addError("JOIN 类型 '" + join.getType() + "' 不合法，可选: " + VALID_JOIN_TYPES);
                }
                if (join.getOnCondition() == null || join.getOnCondition().isBlank()) {
                    result.addError("JOIN onCondition 不能为空 (表: " + join.getTable() + ")");
                }
            }
        }

        // 3. 校验 WHERE 条件
        if (dsl.getWhereConditions() != null) {
            validateConditions(dsl.getWhereConditions(), tableColumns, result, "WHERE");
        }

        // 4. 校验 HAVING 条件
        if (dsl.getHaving() != null) {
            validateConditions(dsl.getHaving(), tableColumns, result, "HAVING");
        }

        // 5. 校验 SELECT 字段非空
        if (dsl.getSelectFields() == null || dsl.getSelectFields().isEmpty()) {
            result.addError("SELECT 字段列表 (selectFields) 不能为空");
        }

        // 6. 校验 LIMIT / OFFSET
        if (dsl.getLimit() != null && dsl.getLimit() < 0) {
            result.addError("LIMIT 不能为负数: " + dsl.getLimit());
        }
        if (dsl.getOffset() != null && dsl.getOffset() < 0) {
            result.addError("OFFSET 不能为负数: " + dsl.getOffset());
        }

        if (result.isValid()) {
            log.info("✅ DSL 校验通过");
        } else {
            log.warn("❌ DSL 校验失败: {}", result.getErrors());
        }

        return result;
    }

    private void validateConditions(java.util.List<WhereCondition> conditions,
                                    Map<String, Set<String>> tableColumns,
                                    DslValidationResult result,
                                    String context) {
        for (int i = 0; i < conditions.size(); i++) {
            WhereCondition cond = conditions.get(i);

            // rawExpression 优先，跳过结构化校验
            if (cond.getRawExpression() != null && !cond.getRawExpression().isBlank()) {
                continue;
            }

            // 校验操作符
            if (cond.getOperator() == null || cond.getOperator().isBlank()) {
                result.addError(context + " 条件[" + i + "] operator 不能为空");
            } else if (!VALID_OPERATORS.contains(cond.getOperator().toUpperCase())) {
                result.addError(context + " 条件[" + i + "] operator '" + cond.getOperator()
                        + "' 不合法，可选: " + VALID_OPERATORS);
            }

            // 校验字段引用
            String field = cond.getField();
            if (field == null || field.isBlank()) {
                result.addError(context + " 条件[" + i + "] field 不能为空（或使用 rawExpression）");
            } else {
                validateFieldReference(field, tableColumns, result, context, i);
            }

            // 校验 valueType
            if (cond.getValueType() != null && !VALID_VALUE_TYPES.contains(cond.getValueType().toLowerCase())) {
                result.addWarning(context + " 条件[" + i + "] valueType '" + cond.getValueType()
                        + "' 不在标准列表中，将按 string 处理");
            }

            // IS NULL / IS NOT NULL 不需要 value
            String op = cond.getOperator() != null ? cond.getOperator().toUpperCase() : "";
            if (!"IS NULL".equals(op) && !"IS NOT NULL".equals(op)) {
                if (cond.getValue() == null || cond.getValue().isBlank()) {
                    result.addError(context + " 条件[" + i + "] value 不能为空 (operator=" + op + ")");
                }
            }
        }
    }

    /**
     * 校验字段引用 — 提取 "alias.column" 中的 column，检查是否在某个表的列中存在。
     * 聚合函数表达式（如 COUNT(o.id)）不校验字段，只做宽松检查。
     */
    private void validateFieldReference(String field,
                                        Map<String, Set<String>> tableColumns,
                                        DslValidationResult result,
                                        String context, int index) {
        String upperField = field.toUpperCase().trim();

        // 聚合函数表达式不严格校验
        if (upperField.startsWith("COUNT(") || upperField.startsWith("SUM(")
                || upperField.startsWith("AVG(") || upperField.startsWith("MIN(")
                || upperField.startsWith("MAX(")) {
            return;
        }

        // 提取 alias.column 中的 column
        Matcher matcher = FIELD_PATTERN.matcher(field.trim());
        if (matcher.find()) {
            String column = matcher.group(2);
            boolean found = tableColumns.values().stream()
                    .anyMatch(cols -> cols.contains(column));
            if (!found) {
                result.addWarning(context + " 条件[" + index + "] 字段 '" + column
                        + "' 未在 Schema 列中找到，可能需要检查");
            }
        }
    }

    /**
     * 解析 Schema 文本，构建 表名 → 列名集合 的映射。
     * <p>
     * Schema 文本格式（来自 MetaDataServiceImpl.getColumnNames）：
     * <pre>
     * 表名：orders
     * 字段:id
     * 类型:integer
     * 注释:订单ID
     * ...
     * </pre>
     */
    private Map<String, Set<String>> parseSchema(String schema) {
        Map<String, Set<String>> tableColumns = new java.util.LinkedHashMap<>();
        if (schema == null || schema.isBlank()) {
            return tableColumns;
        }

        String currentTable = null;
        for (String line : schema.split("\n")) {
            line = line.trim();
            if (line.startsWith("表名：") || line.startsWith("表名:")) {
                currentTable = line.substring(line.indexOf('：') >= 0 ? 3 : 3).trim();
                // 统一处理全角/半角冒号
                currentTable = line.replaceFirst("表名[：:]", "").trim();
                tableColumns.computeIfAbsent(currentTable, k -> new HashSet<>());
            } else if (line.startsWith("字段:") || line.startsWith("字段：")) {
                String column = line.replaceFirst("字段[：:]", "").trim();
                if (currentTable != null) {
                    tableColumns.get(currentTable).add(column);
                }
            }
        }

        return tableColumns;
    }
}
