package com.example.firstaidemo.models.dsl;

import lombok.Data;

/**
 * ORDER BY 子句定义
 */
@Data
public class OrderByClause {

    /** 排序字段或别名，如 "订单数" 或 "o.created_at" */
    private String field;

    /** 排序方向: "ASC" 或 "DESC"（默认 ASC） */
    private String direction;
}
