package com.example.firstaidemo.service.impl;

import com.alibaba.fastjson2.JSON;
import com.example.firstaidemo.models.entity.ReviewResult;
import com.example.firstaidemo.service.IText2SqlAgentService;
import com.example.firstaidemo.tools.SqlExecuteTool;
import com.example.firstaidemo.tools.SqlGenerateTool;
import com.example.firstaidemo.tools.ReviewTool;
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
 * Text2SQL Agent — 五阶段 Planner-Executor 管线实现
 * <p>
 * 从 AiChatServiceImpl 提取为独立 Service，可被 REST Controller、MCP Server 等多渠道调用。
 * <p>
 * 五阶段：
 * 1. Planner — LLM 自主调用 Schema 检索工具 (手动 Tool Call 循环)
 * 2. SQL Generator — LLM 生成 SQL (Structured Output)
 * 3. Review Gate — 代码强制的 SQL 审查 (最多 3 轮修正)
 * 4. Execute — JdbcTemplate 执行 SELECT (失败自动修复重试 3 次)
 * 5. 自然语言回答 — LLM 将结果转为中文回答
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Text2SqlAgentServiceImpl implements IText2SqlAgentService {

    private final ChatClient.Builder chatClientBuilder;

    private final ChatModel chatModel;

    private final SqlGenerateTool sqlGenerateTool;

    private final SqlExecuteTool sqlExecuteTool;

    private final ReviewTool reviewTool;

    @Autowired
    @Qualifier("plannerTools")
    private ToolCallback[] plannerTools;

    // ======================== 公共接口 ========================

    @Override
    public String execute(String question) {
        try {
            log.info("━━━ Text2SQL Agent (Planner-Executor) 启动 ━━━");
            log.info("用户问题: {}", question);

            // ===== 第一阶段: Planner — LLM 自主调用 Schema 检索工具 =====
            log.info("** 第一阶段: Planner — Schema 检索 **");
            String schema = runPlanner(question);
            if (schema == null || schema.isBlank()) {
                return "Planner 未能获取到有效的表结构信息，请检查数据库元数据配置。";
            }
            log.info("📋 Planner 输出 Schema ({} 字符):\n{}", schema.length(), schema);

            // ===== 第二阶段: SQL Generator =====
            log.info("** 第二阶段: SQL Generator **");
            String sql = sqlGenerateTool.generateSql(question, schema);
            sql = cleanSql(sql);
            log.info("📝 生成 SQL: {}", sql);

            // ===== 第三阶段: Review Gate（代码强制） =====
            log.info("** 第三阶段: Review Gate **");
            sql = enforceReviewGate(sql, schema);
            log.info("✅ Review 通过，最终 SQL: {}", sql);

            // ===== 第四阶段: Execute =====
            log.info("** 第四阶段: Execute **");
            List<Map<String, Object>> result;
            try {
                result = sqlExecuteTool.executeSql(sql);
                log.info("✅ SQL 执行成功，返回 {} 行", result.size());
            } catch (Exception e) {
                log.warn("SQL 执行失败: {}，尝试修复", e.getMessage());
                result = executeWithRepair(sql, schema, e.getMessage());
            }

            // ===== 第五阶段: 自然语言回答 =====
            log.info("** 第五阶段: 生成自然语言回答 **");
            String answer = generateNaturalLanguageAnswer(question, sql, result);

            log.info("━━━ Text2SQL Agent 结束 ━━━");
            return answer;

        } catch (Exception e) {
            log.error("Text2SQL Agent 异常", e);
            return "系统错误: " + e.getMessage();
        }
    }

    @Override
    public Flux<String> executeStream(String question) {
        return Flux.defer(() -> Flux.just(execute(question)));
    }

    // ======================== 五阶段实现 ========================

    /**
     * 阶段 1: Planner — LLM 自主调用 Schema 检索工具
     * (searchRelevantTables / loadColumnMetadata / rerankWithColumns)
     * 代码层在 loadColumnMetadata 被调用后终止循环。
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

                // 关键状态：loadColumnMetadata 被调用后，标记 schema 已就绪
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
     * 阶段 3: Review Gate（代码强制）
     * 调用 reviewSql → 检查 result → false 则调用 generateSqlByErrorReason 修正
     * 最多 3 轮修正，最后再 Review 一次。
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
            sql = sqlGenerateTool.generateSqlByErrorReason(
                    reason != null ? reason : "SQL格式错误", schema);
            sql = cleanSql(sql);
            log.info("  🔄 修正后 SQL (第{}次): {}", i + 1, sql);
        }

        // 最后再 Review 一次
        ReviewResult finalReview = reviewTool.reviewSql(sql, schema);
        if (finalReview.getResult()) {
            log.info("  ✅ 最终 Review 通过");
        } else {
            log.warn("  ⚠ 经过{}次修正后 Review 仍未通过，reason: {}", maxRepairs, finalReview.getReason());
        }
        return sql;
    }

    /**
     * 阶段 4 辅助: SQL 执行失败时，调用 generateSqlByErrorReason 修正后重试
     */
    private List<Map<String, Object>> executeWithRepair(String sql, String schema, String firstError) {
        int maxRetries = 3;
        String currentSql = sql;
        String lastError = firstError;

        for (int i = 0; i < maxRetries; i++) {
            if (i > 0) {
                log.info("  🔄 根据错误修正 SQL (第{}次): {}", i, lastError);
                currentSql = sqlGenerateTool.generateSqlByErrorReason(lastError, schema);
                currentSql = cleanSql(currentSql);
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
     * 阶段 5: LLM 将 SQL + 结果转为中文自然语言回答
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

    /**
     * 清理 Markdown 包裹、多余空白
     */
    private String cleanSql(String raw) {
        if (raw == null) return "";
        String sql = raw.trim();
        sql = sql.replaceAll("^```(?:sql)?\\s*\\n?", "");
        sql = sql.replaceAll("\\n?```\\s*$", "");
        return sql.trim();
    }
}
