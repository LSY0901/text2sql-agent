package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.models.entity.SqlResult;
import com.example.firstaidemo.service.ISqlGenerateService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.ResponseFormat;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
@RequiredArgsConstructor
public class SqlGenerateServiceImpl implements ISqlGenerateService {


    private final ChatClient.Builder chatClientBuilder;


    @Override
    public String generateSql(String question, String schema) {

        String jsonSchema = """
                {
                  "type":"object",
                  "properties":{
                      "sql":{
                          "type":"string"
                      }
                  },
                  "required":["sql"],
                  "additionalProperties":false
                }
                """;

        ResponseFormat responseFormat = ResponseFormat.builder()
                .type(ResponseFormat.Type.JSON_SCHEMA)
                .jsonSchema(jsonSchema)
                .build();
//        ResponseFormat responseFormat = ResponseFormat.builder()
//                .type(ResponseFormat.Type.JSON_SCHEMA)
//                .jsonSchema(ResponseFormat.JsonSchema.builder()
//                        .name("sql")
//                        .strict(true)
//                        .schema(jsonSchema)
//                        .build())
//                .build();

        String prompt = """
                你是PostgreSQL专家。
                数据库结构：
                %s
                用户问题：
                %s
                        - 只允许生成SELECT语句
                                - 禁止INSERT
                                - 禁止UPDATE
                                - 禁止DELETE
                                - 禁止Markdown
                                - 禁止```sql
                                - 禁止任何解释文字
                
                                禁止生成:```包含的SQL```
                """.formatted(schema, question);
        return Objects.requireNonNull(chatClientBuilder.build()
                        .prompt(prompt)
                        .options(OpenAiChatOptions.builder()
                                .responseFormat(responseFormat)
                                .build())
                        .call()
                        .entity(SqlResult.class))
                .getSql();
    }

    @Override
    public String generateSqlByPlan(String plan, String schema) {
        String prompt = """
                   你是PostgreSQL专家。
                
                   根据Schema和查询计划生成SQL。
                
                   要求：
                   1. 禁止INSERT
                   2. 禁止UPDATE
                   3. 禁止DELETE
                   4. 返回纯SQL
                
                   Schema:
                   %s
                
                   Plan:
                   %s
                
                   禁止生成:```包含的SQL```
                   正确示例：
                        select * from student
                """.formatted(schema, plan);
        return chatClientBuilder.build().prompt(prompt).call().content();
    }

    @Override
    public String generateSqlByErrorReason(String errorReason, String schema) {
        String prompt = """
                 你是PostgreSQL专家。
                
                 根据Schema和错误原因重新生成SQL。
                
                 要求：
                
                 1. 禁止INSERT
                 2. 禁止UPDATE
                 3. 禁止DELETE
                 4. 返回纯SQL
                
                 Schema:
                 %s
                
                 errorReason:
                 %s
                
                
                禁止生成:```包含的SQL```
                正确示例：
                     select * from student
                """.formatted(schema, errorReason);
        return chatClientBuilder.build().prompt(prompt).call().content();
    }
}
