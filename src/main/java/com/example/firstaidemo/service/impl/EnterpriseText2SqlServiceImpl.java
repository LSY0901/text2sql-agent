package com.example.firstaidemo.service.impl;

import com.alibaba.fastjson2.JSON;
import com.example.firstaidemo.service.IEnterpriseText2SqlService;
import com.example.firstaidemo.tools.DynamicColumnTool;
import com.example.firstaidemo.tools.DynamicSchemaTool;
import com.example.firstaidemo.tools.FilterTableByQuestionTool;
import com.example.firstaidemo.tools.SqlExecuteTool;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class EnterpriseText2SqlServiceImpl implements IEnterpriseText2SqlService {

    private final ChatClient.Builder chatClientBuilder;

    @Autowired
    @Qualifier("sqlTools")
    private ToolCallback[] tools;

    private final DynamicSchemaTool dynamicSchemaTool;

    private final FilterTableByQuestionTool filterTableByQuestionTool;

    private final DynamicColumnTool dynamicColumnTool;

    private final SqlExecuteTool sqlExecuteTool;

    @Override
    public String enterpriseSqlAgentWorkflow(String question) {

        // Stage 1: Dynamically discover relevant tables
        String tableNames = dynamicSchemaTool.discoverRelevantTables();

        // Stage 2: Filter relevant tables based on user question
        List<String> relevantTables = filterTableByQuestionTool.filterTableByQuestion(question, tableNames);

        // Stage 3: Load column metadata for discovered tables
        String columnMetadata = dynamicColumnTool.loadColumnMetadata(relevantTables);

        // Stage 4: Generate SQL
        String sql = generateSql(columnMetadata, question);

        // Stage 5: Execute SQL with retry
        try {
            List<Map<String, Object>> result = sqlExecuteTool.executeSql(sql);
            return formatResponse(question, result);
        } catch (Exception e) {
            String retrySql = generateSqlWithError(columnMetadata, question, e.getMessage());
            List<Map<String, Object>> result = sqlExecuteTool.executeSql(retrySql);
            return formatResponse(question, result);
        }
    }

    String SYSTEM_PROMPT = """
                                你是企业级 PostgreSQL Text2SQL Agent。
                                
                                工作原则：
                                
                                1 先确定相关表
                                
                                如果不知道表结构
                                必须调用 discoverRelevantTables
                                
                                2 获取字段信息
                                
                                必须调用 loadColumnMetadata
                                
                                3 SQL必须是SELECT
                                
                                4 SQL生成后调用 executeSql
                                
                                5 根据结果回答用户
                                
                                禁止编造数据库结构
                                禁止猜测字段
                                """;

    @Override
    public String enterpriseSqlAgentTools(String question) {
        ChatClient chatClient = chatClientBuilder.build();
        return chatClient
                .prompt()
                .system(SYSTEM_PROMPT)
                .user(question)
                //这是两种调用tool的方式
                //.tools(sqlExecuteTool, dynamicColumnTool, dynamicSchemaTool, filterTableByQuestionTool)
                .toolCallbacks(tools)
                .call()
                .content();
    }

    private String generateSql(String columnMetadata, String question) {
        String prompt = """
                你是一个PostgreSQL专家。

                数据库表结构：
                %s

                用户问题：
                %s

                请生成对应的SQL查询语句。
                - 只允许生成SELECT语句
                - 禁止INSERT、UPDATE、DELETE
                - 禁止Markdown、禁止```sql
                - 禁止任何解释文字
                - 返回内容必须以SELECT开头
                - 返回内容必须以分号结束
                """
                .formatted(columnMetadata, question);

        return chatClientBuilder.build()
                .prompt(prompt)
                .call()
                .content();
    }

    private String generateSqlWithError(String columnMetadata, String question, String errorMessage) {
        String prompt = """
                你是一个PostgreSQL专家。

                数据库表结构：
                %s

                用户问题：
                %s

                之前生成的SQL执行出错：
                %s

                请重新生成正确的SQL查询语句。
                - 只允许生成SELECT语句
                - 禁止INSERT、UPDATE、DELETE
                - 禁止Markdown、禁止```sql
                - 禁止任何解释文字
                - 返回内容必须以SELECT开头
                - 返回内容必须以分号结束
                """
                .formatted(columnMetadata, question, errorMessage);

        return chatClientBuilder.build()
                .prompt(prompt)
                .call()
                .content();
    }

    private String formatResponse(String question, List<Map<String, Object>> result) {
        String responsePrompt = """
                用户问题：%s

                查询结果（JSON格式）：
                %s

                请用自然语言回答用户的问题，基于以上查询结果。
                """
                .formatted(question, JSON.toJSONString(result));

        return chatClientBuilder.build()
                .prompt(responsePrompt)
                .call()
                .content();
    }
}
