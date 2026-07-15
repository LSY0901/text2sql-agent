package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.models.dsl.QueryDSL;
import com.example.firstaidemo.service.IDslGenerateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.ResponseFormat;
import org.springframework.stereotype.Service;

/**
 * DSL 生成服务实现 — 使用 LLM + Structured Output (JSON Schema) 生成 QueryDSL
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DslGenerateServiceImpl implements IDslGenerateService {

    private final ChatClient.Builder chatClientBuilder;

    private static final String JSON_SCHEMA = """
            {
              "type": "object",
              "properties": {
                "table": { "type": "string", "description": "主表名" },
                "tableAlias": { "type": "string", "description": "主表别名，如 o、t 等" },
                "distinct": { "type": "boolean", "description": "是否去重" },
                "selectFields": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "expression": { "type": "string", "description": "字段表达式，如 o.product_name 或 COUNT(o.id)" },
                      "alias": { "type": "string", "description": "字段别名，如 商品名称" }
                    },
                    "required": ["expression"]
                  }
                },
                "joins": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "type": { "type": "string", "description": "JOIN 类型: INNER, LEFT, RIGHT, FULL" },
                      "table": { "type": "string", "description": "关联表名" },
                      "alias": { "type": "string", "description": "关联表别名" },
                      "onCondition": { "type": "string", "description": "ON 条件，如 o.product_id = p.product_id" }
                    },
                    "required": ["type", "table", "onCondition"]
                  }
                },
                "whereConditions": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "logic": { "type": "string", "description": "逻辑连接符: AND 或 OR" },
                      "field": { "type": "string", "description": "字段引用，如 o.status" },
                      "operator": { "type": "string", "description": "操作符: =, !=, >, <, >=, <=, LIKE, IN, NOT IN, BETWEEN, IS NULL, IS NOT NULL" },
                      "value": { "type": "string", "description": "比较值。IN/NOT IN 用逗号分隔多个值，BETWEEN 用逗号分隔两个值" },
                      "valueType": { "type": "string", "description": "值类型: string, number, boolean, raw" },
                      "rawExpression": { "type": "string", "description": "原始SQL表达式，用于复杂条件。提供时优先于 field/operator/value" }
                    }
                  }
                },
                "groupBy": {
                  "type": "array",
                  "items": { "type": "string" }
                },
                "having": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "logic": { "type": "string" },
                      "field": { "type": "string" },
                      "operator": { "type": "string" },
                      "value": { "type": "string" },
                      "valueType": { "type": "string" },
                      "rawExpression": { "type": "string" }
                    }
                  }
                },
                "orderBy": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "field": { "type": "string", "description": "排序字段或别名" },
                      "direction": { "type": "string", "description": "ASC 或 DESC" }
                    },
                    "required": ["field"]
                  }
                },
                "limit": { "type": "integer", "description": "限制行数" },
                "offset": { "type": "integer", "description": "偏移行数" }
              },
              "required": ["table", "selectFields"]
            }
            """;

    @Override
    public QueryDSL generateDsl(String question, String schema) {
        String prompt = """
                你是数据分析专家。请将用户的自然语言问题转换为结构化查询 DSL（JSON 格式）。

                ## 数据库 Schema
                %s

                ## 用户问题
                %s

                ## DSL 结构说明
                - table: 要查询的主表名（必须与 Schema 中的表名完全一致）
                - tableAlias: 主表别名，如 o、t
                - selectFields: SELECT 的字段列表，每项包含 expression（字段或聚合表达式）和可选的 alias
                - joins: JOIN 关联列表，每项包含 type（INNER/LEFT/RIGHT/FULL）、table、alias、onCondition
                - whereConditions: WHERE 条件列表，每项包含:
                    - logic: AND 或 OR（第一个条件可省略）
                    - field: 字段引用，如 o.status
                    - operator: =, !=, >, <, >=, <=, LIKE, IN, NOT IN, BETWEEN, IS NULL, IS NOT NULL
                    - value: 比较值（IN 用逗号分隔，BETWEEN 用逗号分隔两个值）
                    - valueType: string（加单引号）、number（不加引号）、boolean、raw（原样输出）
                    - rawExpression: 复杂条件时直接写 SQL 表达式
                - groupBy: GROUP BY 字段列表
                - having: HAVING 条件列表（结构同 whereConditions）
                - orderBy: ORDER BY 列表，每项包含 field 和 direction（ASC/DESC）
                - limit: 返回行数限制
                - offset: 偏移量

                ## 约束
                1. 表名和字段名必须与 Schema 中完全一致
                2. 聚合函数使用大写: COUNT, SUM, AVG, MIN, MAX
                3. 不要生成子查询，只用单层查询
                4. valueType 为 string 时，translator 会自动加单引号，不要在 value 中包含引号
                """.formatted(schema, question);

        ResponseFormat responseFormat = ResponseFormat.builder()
                .type(ResponseFormat.Type.JSON_SCHEMA)
                .jsonSchema(JSON_SCHEMA)
                .build();

        QueryDSL dsl = chatClientBuilder.build()
                .prompt(prompt)
                .options(OpenAiChatOptions.builder()
                        .responseFormat(responseFormat)
                        .build())
                .call()
                .entity(QueryDSL.class);

        log.info("📋 生成 DSL: table={}, joins={}, where={}",
                dsl.getTable(),
                dsl.getJoins() != null ? dsl.getJoins().size() : 0,
                dsl.getWhereConditions() != null ? dsl.getWhereConditions().size() : 0);
        return dsl;
    }

    @Override
    public QueryDSL generateDslByError(String question, String schema, String errorReason) {
        String prompt = """
                你是数据分析专家。之前生成的查询 DSL 存在错误，请根据错误原因修正。

                ## 数据库 Schema
                %s

                ## 用户问题
                %s

                ## 错误原因
                %s

                ## 要求
                请重新生成修正后的 DSL（JSON 格式），确保不再出现同样的错误。
                表名和字段名必须与 Schema 中完全一致。
                """.formatted(schema, question, errorReason);

        ResponseFormat responseFormat = ResponseFormat.builder()
                .type(ResponseFormat.Type.JSON_SCHEMA)
                .jsonSchema(JSON_SCHEMA)
                .build();

        QueryDSL dsl = chatClientBuilder.build()
                .prompt(prompt)
                .options(OpenAiChatOptions.builder()
                        .responseFormat(responseFormat)
                        .build())
                .call()
                .entity(QueryDSL.class);

        log.info("🔄 修正 DSL: table={}", dsl.getTable());
        return dsl;
    }
}
