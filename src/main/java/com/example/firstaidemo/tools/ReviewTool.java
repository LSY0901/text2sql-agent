package com.example.firstaidemo.tools;


import com.alibaba.fastjson2.JSONObject;
import com.example.firstaidemo.models.entity.ReviewResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.converter.BeanOutputConverter;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.ResponseFormat;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class ReviewTool {

    private final ChatClient.Builder chatClientBuilder;


    private static final BeanOutputConverter<ReviewResult> REVIEW_CONVERTER =
            new BeanOutputConverter<>(ReviewResult.class);

    @Tool(description = "根据输入 sql 和 schema 检查 SQL 是否正确。返回严格 JSON: {\"result\":true/false,\"reason\":\"...\"}")
    public ReviewResult reviewSql(String sql, String schema) {
        // 使用 JSON_OBJECT 模式（更兼容 DashScope/qwen）
        // 注意：prompt 中必须包含小写 "json" 字样，否则 DashScope 会报错

        String jsonSchema = """
                {
                  "type": "object",
                  "properties": {
                    "result": {
                      "type": "boolean"
                    },
                    "reason": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "result",
                    "reason"
                  ],
                  "additionalProperties": false
                }
                """;
        ResponseFormat responseFormat = ResponseFormat.builder()
                .type(ResponseFormat.Type.JSON_SCHEMA)
                .jsonSchema(jsonSchema)
                .build();

        String prompt = """
                你是 PostgreSQL 专家。请检查以下 SQL，并以 json 格式输出结果。

                检查项：
                1. 表是否存在
                2. 字段是否存在
                3. JOIN 是否合理
                4. GROUP BY 是否缺失
                5. 聚合函数是否正确
                6. WHERE 条件是否合理

                Schema:
                %s

                SQL:
                %s

                必须严格按以下 json 格式输出，不要加任何其他文字：
                {"result": true,"reason": "ok"}
                """
                .formatted(schema, sql);

        return chatClientBuilder.build()
                .prompt(prompt)
                .options(OpenAiChatOptions.builder()
                        .responseFormat(responseFormat)
                        .build())
                .call()
                .entity(ReviewResult.class);

        /*log.info("reviewSql raw: {}", rawResult);

        // 标准化输出：确保返回 {"result":..., "reason":"..."}
        String cleaned = cleanMarkdown(rawResult);
        try {
            JSONObject parsed = JSONObject.parseObject(cleaned);
            if (parsed.containsKey("result") && parsed.containsKey("reason")) {
                boolean result = parsed.getBooleanValue("result");
                String reason = parsed.getString("reason");
                return "{\"result\":" + result + ",\"reason\":\"" + escape(reason) + "\"}";
            }
            // 字段缺失，返回结构但内容有误 — 默认放行
            log.warn("reviewSql 返回缺少 result/reason 字段：{}", cleaned);
            return "{\"result\":true,\"reason\":\"review 返回格式异常，默认放行\"}";

        } catch (Exception e) {
            log.warn("reviewSql JSON 解析失败：{}，原始：{}", e.getMessage(), rawResult);
            return "{\"result\":true,\"reason\":\"review 返回非 JSON，默认放行\"}";
        }*/
    }

    /**
     * 去掉可能的 ```json ... ``` 包裹
     */
    private String cleanMarkdown(String raw) {
        if (raw == null || raw.isBlank()) return "";
        return raw.trim()
                .replaceAll("^```(?:json)?\\s*\\n?", "")
                .replaceAll("\\n?```\\s*$", "")
                .trim();
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", "");
    }
}
