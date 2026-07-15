package com.example.firstaidemo.models.dsl;

import lombok.Data;

/**
 * WHERE / HAVING 条件定义
 */
@Data
public class WhereCondition {

    /** 逻辑连接符: "AND" 或 "OR"（第一个条件可忽略） */
    private String logic;

    /** 字段引用，如 "o.status"（用于校验，rawExpression 为空时必填） */
    private String field;

    /** 操作符: =, !=, >, <, >=, <=, LIKE, IN, NOT IN, BETWEEN, IS NULL, IS NOT NULL */
    private String operator;

    /** 比较值（IS NULL / IS NOT NULL 时可空） */
    private String value;

    /** 值类型: "string", "number", "boolean", "raw"（默认 "string"，决定是否加引号） */
    private String valueType;

    /** 原始 SQL 表达式（复杂条件时使用，优先于 field/operator/value） */
    private String rawExpression;
}
