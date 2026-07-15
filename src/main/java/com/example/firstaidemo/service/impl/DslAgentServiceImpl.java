package com.example.firstaidemo.service.impl;

import com.alibaba.fastjson2.JSON;
import com.example.firstaidemo.models.dsl.DslValidationResult;
import com.example.firstaidemo.models.dsl.QueryDSL;
import com.example.firstaidemo.models.entity.ReviewResult;
import com.example.firstaidemo.service.IDslAgentService;
import com.example.firstaidemo.service.IDslGenerateService;
import com.example.firstaidemo.tools.DslTranslator;
import com.example.firstaidemo.tools.DslValidator;
import com.example.firstaidemo.tools.ReviewTool;
import com.example.firstaidemo.tools.SqlExecuteTool;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.ToolResponseMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.model.tool.DefaultToolCallingChatOptions;
import org.springframework.ai.model.tool.ToolCallingChatOptions;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * NLP2DSL2SQL Agent — 六阶段管线实现
 * <p>
 * 核心改进：在 LLM 和 SQL 之间引入结构化 DSL 中间层。
 * LLM 只负责 NLP → DSL，DSL → SQL 由确定性代码完成。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DslAgentServiceImpl implements IDslAgentService {

    private final ChatClient.Builder chatClientBuilder;
    private final ChatModel chatModel;
    private final IDslGenerateService dslGenerateService;
    private final DslValidator dslValidator;
    private final DslTranslator dslTranslator;
    private final SqlExecuteTool sqlExecuteTool;
    private final ReviewTool reviewTool;

    @Autowired
    @Qualifier("plannerTools")
    private ToolCallback[] plannerTools;

    // ======================== 公共接口 ========================

    @Override
    public String execute(String question) {
        try {
            log.info("━━━ NLP2DSL2SQL Agent 启动 ━━━");
            log.info("用户问题: {}", question);

            // ===== 第一阶段: Planner — Schema 检索 =====
            log.info("** 第一阶段: Planner — Schema 检索 **");
            String schema = runPlanner(question);
            if (schema == null || schema.isBlank()) {
                return "Planner 未能获取到有效的表结构信息，请检查数据库元数据配置。";
            }
            log.info("📋 Planner 输出 Schema ({} 字符)", schema.length());

            // ===== 第二阶段: DSL Generator — LLM 生成结构化 DSL =====
            log.info("** 第二阶段: DSL Generator **");
            QueryDSL dsl = dslGenerateService.generateDsl(question, schema);
            log.info("📋 生成 DSL: {}", JSON.toJSONString(dsl));

            // ===== 第三阶段: DSL Validator — 代码校验 =====
            log.info("** 第三阶段: DSL Validator **");
            DslValidationResult validationResult = dslValidator.validate(dsl, schema);

            // 校验失败 → 重新生成 DSL（最多 3 次）
            int dslRetry = 0;
            while (!validationResult.isValid() && dslRetry < 3) {
                dslRetry++;
                String errorReason = String.join("; ", validationResult.getErrors());
                log.warn("❌ DSL 校验失败 (第{}次): {}", dslRetry, errorReason);

                dsl = dslGenerateService.generateDslByError(question, schema, errorReason);
                validationResult = dslValidator.validate(dsl, schema);
            }

            if (!validationResult.isValid()) {
                log.warn("⚠ DSL 经 {} 次修正仍未通过校验，使用最后一次结果继续", dslRetry);
                if (!validationResult.getErrors().isEmpty()) {
                    log.warn("  剩余错误: {}", validationResult.getErrors());
                }
            } else {
                log.info("✅ DSL 校验通过");
            }

            // ===== 第四阶段: DSL Translator — 确定性翻译 DSL → SQL =====
            log.info("** 第四阶段: DSL Translator **");
            String sql = dslTranslator.translate(dsl);
            log.info("📝 翻译 SQL: {}", sql);

            // ===== 第五阶段: SQL Review + Execute =====
            log.info("** 第五阶段: SQL Review + Execute **");

            // Review Gate（复用现有 ReviewTool）
            sql = enforceReviewGate(sql, schema);
            log.info("✅ Review 通过，最终 SQL: {}", sql);

            // 执行 SQL
            List<Map<String, Object>> result;
            try {
                result = sqlExecuteTool.executeSql(sql);
                log.info("✅ SQL 执行成功，返回 {} 行", result.size());
            } catch (Exception e) {
                log.warn("SQL 执行失败: {}，尝试修复", e.getMessage());
                result = executeWithRepair(question, sql, schema, e.getMessage());
            }

            // ===== 第六阶段: 自然语言回答 =====
            log.info("** 第六阶段: 生成自然语言回答 **");
            String answer = generateNaturalLanguageAnswer(question, sql, result);

            log.info("━━━ NLP2DSL2SQL Agent 结束 ━━━");
            return answer;

        } catch (Exception e) {
            log.error("NLP2DSL2SQL Agent 异常", e);
            return "系统错误: " + e.getMessage();
        }
    }

    @Override
    public Flux<String> executeStream(String question) {
        return Flux.defer(() -> Flux.just(execute(question)));
    }

    // ======================== 六阶段实现 ========================

    /**
     * 阶段 1: Planner — LLM 自主调用 Schema 检索工具
     * (与 Text2SqlAgentServiceImpl.runPlanner 相同的逻辑)
     */
    private String runPlanner(String question) {
        ToolCallingChatOptions plannerOptions = DefaultToolCallingChatOptions.builder()
                .toolCallbacks(plannerTools)
                .internalToolExecutionEnabled(false)
                .build();

        Map<String, ToolCallback> toolIndex = new LinkedHashMap<>();
        for (ToolCallback tc : plannerTools) {
            toolIndex.put(tc.getToolDefinition().name(), tc);
        }

        List<Message> messages = new ArrayList<>();
        messages.add(new SystemMessage("""
                你是一个数据分析 Planner，负责理解用户意图并检索相关数据库表结构。

                ## 你的任务

                1. 调用 searchRelevantTables 向量搜索与用户问题最相关的表
                2. 调用 loadColumnMetadata 获取这些表的列信息、类型、注释
                3. 如果候选表太多，调用 rerankWithColumns 重排序，聚焦最相关的表

                ## 约束

                - 你只能使用以上三个工具：searchRelevantTables、loadColumnMetadata、rerankWithColumns
                - 禁止编造表名、字段名、数据
                - 获取到完整的列级 schema 后，不需要输出额外文字，系统会自动进入下一阶段
                """));

        messages.add(new UserMessage("请帮我查询以下问题需要的数据：\n" + question));

        int maxIterations = 5;
        String collectedSchema = null;

        for (int i = 0; i < maxIterations && collectedSchema == null; i++) {
            log.info("  Planner 第{}轮", i + 1);

            Prompt prompt = new Prompt(messages, plannerOptions);
            ChatResponse response = chatModel.call(prompt);
            AssistantMessage am = response.getResult().getOutput();
            String text = (am.getText() != null) ? am.getText() : "";

            if (!text.isBlank()) {
                log.info("  [Planner] {}", text.substring(0, Math.min(300, text.length())));
            }

            if (!am.hasToolCalls()) {
                log.info("  Planner 完成（无更多工具调用）");
                break;
            }

            messages.add(am);

            List<AssistantMessage.ToolCall> toolCalls = am.getToolCalls();
            List<ToolResponseMessage.ToolResponse> toolResponses = new ArrayList<>();

            for (AssistantMessage.ToolCall tc : toolCalls) {
                String toolName = tc.name();
                log.info("    🔧 {} | 参数: {}", toolName, tc.arguments());

                ToolCallback cb = toolIndex.get(toolName);
                String result;
                if (cb == null) {
                    result = "工具不存在: " + toolName;
                    log.warn("    ❌ {}", result);
                } else {
                    try {
                        result = cb.call(tc.arguments());
                        log.info("    ✅ {} 返回({}字符)", toolName, result.length());
                    } catch (Exception e) {
                        result = "异常: " + e.getMessage();
                        log.error("    ❌ {} 异常: {}", toolName, e.getMessage());
                    }
                }
                toolResponses.add(new ToolResponseMessage.ToolResponse(tc.id(), toolName, result));

                if ("loadColumnMetadata".equals(toolName)) {
                    collectedSchema = result;
                }
            }
            messages.add(ToolResponseMessage.builder().responses(toolResponses).build());
        }

        if (collectedSchema == null) {
            log.warn("⚠ Planner 未能在 {} 轮内完成 Schema 检索", maxIterations);
        }
        return collectedSchema;
    }

    /**
     * 阶段 5a: Review Gate（代码强制） — 复用 ReviewTool
     */
    private String enforceReviewGate(String sql, String schema) {
        int maxRepairs = 3;

        for (int i = 0; i < maxRepairs; i++) {
            ReviewResult reviewResult = reviewTool.reviewSql(sql, schema);
            log.info("  Review 第{}次 raw: {}", i + 1, reviewResult);
            boolean passed = reviewResult.getResult();
            String reason = reviewResult.getReason();

            if (passed) {
                log.info("  ✅ Review 通过");
                return sql;
            }

            log.warn("  ❌ Review 未通过 (第{}次), reason: {}", i + 1, reason);
            // Review 失败时，通过 LLM 直接修正 SQL（不经过 DSL 层）
            sql = fixSqlWithError(reason != null ? reason : "SQL格式错误", schema, sql);
            log.info("  🔄 修正后 SQL (第{}次): {}", i + 1, sql);
        }

        ReviewResult finalReview = reviewTool.reviewSql(sql, schema);
        if (finalReview.getResult()) {
            log.info("  ✅ 最终 Review 通过");
        } else {
            log.warn("  ⚠ 经过{}次修正后 Review 仍未通过，reason: {}", maxRepairs, finalReview.getReason());
        }
        return sql;
    }

    /**
     * 阶段 5b: SQL 执行失败时修复重试
     */
    private List<Map<String, Object>> executeWithRepair(String question, String sql, String schema, String firstError) {
        int maxRetries = 3;
        String currentSql = sql;
        String lastError = firstError;

        for (int i = 0; i < maxRetries; i++) {
            if (i > 0) {
                log.info("  🔄 根据错误修正 SQL (第{}次): {}", i, lastError);
                currentSql = fixSqlWithError(lastError, schema, currentSql);
                log.info("  修正后: {}", currentSql);
            }
            try {
                List<Map<String, Object>> result = sqlExecuteTool.executeSql(currentSql);
                log.info("  ✅ SQL 执行成功 (尝试{}次)", i + 1);
                return result;
            } catch (Exception e) {
                lastError = e.getMessage();
                log.warn("  ❌ 执行失败 (尝试{}次): {}", i + 1, lastError);
            }
        }
        throw new RuntimeException("SQL 执行失败，已重试 " + maxRetries + " 次。最后错误: " + lastError);
    }

    /**
     * LLM 直接修正 SQL（Review 或执行失败时使用）
     */
    private String fixSqlWithError(String errorReason, String schema, String currentSql) {
        String prompt = String.format("""
                你是 PostgreSQL 专家。请根据错误信息修正 SQL。

                Schema:
                %s

                当前 SQL:
                %s

                错误原因:
                %s

                要求：
                1. 禁止 INSERT / UPDATE / DELETE
                2. 返回纯 SQL，不要 Markdown，不要解释文字
                """, schema, currentSql, errorReason);

        String fixed = chatClientBuilder.build()
                .prompt(prompt)
                .call()
                .content();

        return cleanSql(fixed);
    }

    /**
     * 阶段 6: LLM 将 SQL + 结果转为中文自然语言回答
     */
    private String generateNaturalLanguageAnswer(String question, String sql, List<Map<String, Object>> result) {
        String answerPrompt = String.format("""
                        用户问题：%s

                        查询SQL：%s

                        查询结果（JSON）：
                        %s

                        请用简洁的中文自然语言回答用户的问题。
                        直接说结论，不要输出SQL，不要输出JSON，不要用Markdown格式。
                        """,
                question, sql, JSON.toJSONString(result));

        String finalAnswer = chatClientBuilder.build()
                .prompt(answerPrompt)
                .call()
                .content();

        return finalAnswer != null ? finalAnswer : "查询完成，但未能生成自然语言回答。";
    }

    // ======================== 工具方法 ========================

    private String cleanSql(String raw) {
        if (raw == null) return "";
        String sql = raw.trim();
        sql = sql.replaceAll("^```(?:sql)?\\s*\\n?", "");
        sql = sql.replaceAll("\\n?```\\s*$", "");
        return sql.trim();
    }
}
