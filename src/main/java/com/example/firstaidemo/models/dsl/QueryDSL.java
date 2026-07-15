package com.example.firstaidemo.models.dsl;

import lombok.Data;

import java.util.List;

/**
 * 查询 DSL — 自然语言查询的结构化中间表示。
 * <p>
 * LLM 将用户问题翻译为此结构，代码层校验后由 {@code DslTranslator} 确定性翻译为 SQL。
 *
 * <pre>
 * 示例 JSON:
 * {
 *   "table": "orders",
 *   "tableAlias": "o",
 *   "distinct": false,
 *   "selectFields": [
 *     {"expression": "o.product_name", "alias": "商品名称"},
 *     {"expression": "COUNT(o.id)", "alias": "订单数"}
 *   ],
 *   "joins": [
 *     {"type": "LEFT", "table": "price_ai", "alias": "p", "onCondition": "o.product_id = p.product_id"}
 *   ],
 *   "whereConditions": [
 *     {"logic": "AND", "field": "o.status", "operator": "=", "value": "completed", "valueType": "string"}
 *   ],
 *   "groupBy": ["o.product_name"],
 *   "having": [
 *     {"logic": "AND", "field": "COUNT(o.id)", "operator": ">", "value": "10", "valueType": "number"}
 *   ],
 *   "orderBy": [
 *     {"field": "订单数", "direction": "DESC"}
 *   ],
 *   "limit": 10,
 *   "offset": 0
 * }
 * </pre>
 */
@Data
public class QueryDSL {

    /** 主表名 */
    private String table;

    /** 主表别名（可选） */
    private String tableAlias;

    /** 是否 DISTINCT */
    private boolean distinct;

    /** SELECT 字段列表 */
    private List<SelectField> selectFields;

    /** JOIN 子句列表 */
    private List<JoinClause> joins;

    /** WHERE 条件列表 */
    private List<WhereCondition> whereConditions;

    /** GROUP BY 字段列表 */
    private List<String> groupBy;

    /** HAVING 条件列表 */
    private List<WhereCondition> having;

    /** ORDER BY 子句列表 */
    private List<OrderByClause> orderBy;

    /** LIMIT */
    private Integer limit;

    /** OFFSET */
    private Integer offset;
}
