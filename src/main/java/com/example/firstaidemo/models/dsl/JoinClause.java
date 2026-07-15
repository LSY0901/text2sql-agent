package com.example.firstaidemo.models.dsl;

import lombok.Data;

/**
 * JOIN 子句定义
 */
@Data
public class JoinClause {

    /** JOIN 类型: "INNER", "LEFT", "RIGHT", "FULL" */
    private String type;

    /** 关联表名 */
    private String table;

    /** 关联表别名（可选） */
    private String alias;

    /** ON 条件，如 "o.product_id = p.product_id" */
    private String onCondition;
}
