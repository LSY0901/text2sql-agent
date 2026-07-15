package com.example.firstaidemo.models.dsl;

import lombok.Data;

/**
 * SELECT 字段定义
 */
@Data
public class SelectField {

    /** 字段表达式，如 "o.product_name" 或 "COUNT(o.id)" */
    private String expression;

    /** 别名，如 "商品名称"（可选） */
    private String alias;
}
