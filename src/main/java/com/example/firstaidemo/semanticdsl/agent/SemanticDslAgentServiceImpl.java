package com.example.firstaidemo.semanticdsl.agent;

import com.alibaba.fastjson2.JSON;
import com.example.firstaidemo.models.entity.ReviewResult;
import com.example.firstaidemo.semanticdsl.enricher.SemanticDslEnricher;
import com.example.firstaidemo.semanticdsl.model.DslCandidate;
import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import com.example.firstaidemo.semanticdsl.model.IntentResult;
import com.example.firstaidemo.semanticdsl.model.SemanticQueryDSL;
import com.example.firstaidemo.semanticdsl.prompt.SemanticPromptTemplates;
import com.example.firstaidemo.semanticdsl.retriever.DslRetriever;
import com.example.firstaidemo.semanticdsl.translator.DslTranslator;
import com.example.firstaidemo.semanticdsl.validator.SemanticDslValidator;
import com.example.firstaidemo.tools.ReviewTool;
import com.example.firstaidemo.tools.SqlExecuteTool;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.ResponseFormat;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.scheduler.Schedulers;

import java.util.List;
import java.util.Map;

/**
 * NLP2DSL2SQL Agent V2 — 语义层管线实现。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SemanticDslAgentServiceImpl implements ISemanticDslAgentService {

    private final ChatModel chatModel;
    private final DslRetriever dslRetriever;
    private final SemanticDslEnricher dslEnricher;
    private final SemanticDslValidator dslValidator;
    private final DslTranslator dslTranslator;
    private final ReviewTool reviewTool;
    private final SqlExecuteTool sqlExecuteTool;
    private final ObjectMapper objectMapper;

    /**
     * 语义层管线（流式）：意图 → 检索 → DSL → 校验 → 富化 → SQL → 审查 → 执行 → 回答。
     *
     * @param question 用户自然语言问题
     * @return SSE 文本流
     */
    @Override
    public Flux<String> nlp2Dsl2SqlAgentV2(String question) {
        if (question == null || question.isBlank()) {
            return Flux.just("错误: 问题不能为空");
        }

        return Flux.defer(() -> {
            try {
                return runPipeline(question.trim());
            } catch (PipelineException e) {
                log.warn("Agent业务失败: {}", e.getMessage());
                return Flux.just("错误: " + e.getMessage());
            } catch (Exception e) {
                log.error("Agent执行失败", e);
                return Flux.just("错误: 系统处理失败，请稍后重试");
            }
        }).subscribeOn(Schedulers.boundedElastic());
    }

    /**
     * 执行完整管线并返回流式输出。
     *
     * @param question 用户问题
     * @return 文本流（含意图/SQL前缀与自然语言回答）
     */
    private Flux<String> runPipeline(String question) throws Exception {
        log.info("━━━━━━━ NLP2DSL2SQL Agent V2 启动 ━━━━━━━");
        log.info("用户问题: {}", question);

        // Stage 1: 意图识别
        IntentResult intent = classifyIntent(question);
        IntentResult.IntentType intentType = intent.resolveIntentType();
        log.info("[Stage 1] 意图识别: {} (confidence={})", intentType, intent.getConfidence());

        if (intentType == IntentResult.IntentType.NON_BUSINESS) {
            throw new PipelineException("非业务问题，无法处理。原因: " + intent.getReason());
        }

        // Stage 2: 语义检索
        DslCandidate candidate = dslRetriever.retrieve(question);
        log.info("[Stage 2] 语义检索完成: metrics={}, dimensions={}",
                sizeOf(candidate.getMetrics()), sizeOf(candidate.getDimensions()));
        if (sizeOf(candidate.getMetrics()) == 0 && sizeOf(candidate.getEntities()) == 0) {
            throw new PipelineException("未检索到相关指标/实体，请换一种问法");
        }

        // Stage 3: 语义DSL生成（带上意图，避免 DIMENSION_ANALYSIS 漏填 metric）
        SemanticQueryDSL semanticDSL = generateSemanticDSL(question, candidate, intentType);
        log.info("[Stage 3] 语义DSL: {}", objectMapper.writeValueAsString(semanticDSL));

        // Stage 4: DSL校验
        SemanticDslValidator.ValidationResult validation =
                dslValidator.validate(semanticDSL, intentType);
        log.info("[Stage 4] 校验结果: valid={}", validation.valid());
        if (!validation.valid()) {
            throw new PipelineException("DSL校验失败: " + validation.errors());
        }

        // Stage 5: DSL富化
        EnrichedQueryDSL enrichedDSL = dslEnricher.enrich(semanticDSL, candidate);
        log.info("[Stage 5] DSL富化完成");
        if (enrichedDSL.getMainPhysicalTable() == null
                || enrichedDSL.getSelectColumns() == null
                || enrichedDSL.getSelectColumns().isEmpty()) {
            throw new PipelineException("DSL富化结果不完整，无法生成SQL");
        }

        // Stage 6: SQL生成（确定性 + 参数绑定）
        DslTranslator.TranslatedSql translated = dslTranslator.translate(enrichedDSL);
        String sql = translated.sql();
        List<Object> params = translated.parameters();
        log.info("[Stage 6] SQL生成: {}, params={}", sql, params);

        // Stage 7: SQL审查（不通过则失败，禁止LLM改写代码生成SQL）
        enforceReviewGate(sql, buildReviewSchema(enrichedDSL), question);
        log.info("[Stage 7] SQL审查完成");

        // 执行SQL（带参数）
        List<Map<String, Object>> queryResult = sqlExecuteTool.executeSql(sql, params);
        log.info("━━━━━━━ NLP2DSL2SQL Agent V2 管线完成，开始流式回答 ━━━━━━━");

        String answerPrompt = """
                用户问题：%s

                查询SQL：%s

                查询结果：%s

                请用自然语言回答用户的问题，只输出结论本身，不要重复SQL或意图。
                """.formatted(question, sql, JSON.toJSONString(queryResult));

        // 使用 \n 分段；前端 SSE 解析需正确还原换行并结构化展示
        String intentBlock = "意图：" + intentType.name() + "\n\n";
        String sqlBlock = "SQL：\n" + sql + "\n\n结论：\n";

        return Flux.concat(
                Flux.just(intentBlock),
                Flux.just(sqlBlock),
                ChatClient.builder(chatModel).build()
                        .prompt(answerPrompt)
                        .stream()
                        .content()
        );
    }

    /**
     * 意图识别。
     *
     * @param question 用户问题
     * @return 意图结果
     */
    @Override
    public IntentResult classifyIntent(String question) {
        ResponseFormat responseFormat =
                ResponseFormat.builder()
                        .type(ResponseFormat.Type.JSON_SCHEMA)
                        .jsonSchema(SemanticPromptTemplates.INTENT_JSON_SCHEMA)
                        .build();

        ChatClient chatClient = ChatClient.builder(chatModel).build();
        String response = chatClient.prompt()
                .system(SemanticPromptTemplates.INTENT_SYSTEM_PROMPT)
                .user(question)
                .options(OpenAiChatOptions.builder()
                        .responseFormat(responseFormat)
                        .build())
                .call()
                .content();
        try {
            String json = extractJson(response);
            IntentResult result = objectMapper.readValue(json, IntentResult.class);
            // 规范化非法意图
            IntentResult.IntentType type = result.resolveIntentType();
            result.setIntent(type.name());
            return result;
        } catch (Exception e) {
            log.warn("意图识别解析失败，默认为NON_BUSINESS: {}", e.getMessage());
            IntentResult fallback = new IntentResult();
            fallback.setIntent(IntentResult.IntentType.NON_BUSINESS.name());
            fallback.setConfidence(0.0);
            fallback.setReason("解析失败: " + e.getMessage());
            return fallback;
        }
    }

    /**
     * 执行到富化阶段的管线（供调试/复用）。
     *
     * @param question 用户问题
     * @return 富化 DSL；失败时抛出业务异常
     */
    @Override
    public EnrichedQueryDSL executePipeline(String question) {
        IntentResult intent = classifyIntent(question);
        IntentResult.IntentType intentType = intent.resolveIntentType();
        if (intentType == IntentResult.IntentType.NON_BUSINESS) {
            throw new IllegalArgumentException("非业务问题: " + intent.getReason());
        }
        DslCandidate candidate = dslRetriever.retrieve(question);
        SemanticQueryDSL semanticDSL = generateSemanticDSL(question, candidate, intentType);
        SemanticDslValidator.ValidationResult validation =
                dslValidator.validate(semanticDSL, intentType);
        if (!validation.valid()) {
            throw new IllegalArgumentException("DSL校验失败: " + validation.errors());
        }
        return dslEnricher.enrich(semanticDSL, candidate);
    }

    /**
     * 根据候选元数据与意图生成语义 DSL。
     */
    private SemanticQueryDSL generateSemanticDSL(String question,
                                                 DslCandidate candidate,
                                                 IntentResult.IntentType intentType) {
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        String context = buildCandidateContext(candidate);

        String response = chatClient.prompt()
                .system(SemanticPromptTemplates.DSL_GENERATION_SYSTEM_PROMPT)
                .user("用户问题: " + question
                        + "\n意图类型: " + intentType.name()
                        + "\n\n候选元数据:\n" + context)
                .call()
                .content();
        log.info("[Stage 3] DSL生成原始响应: {}", response);

        try {
            String json = extractJson(response);
            return objectMapper.readValue(json, SemanticQueryDSL.class);
        } catch (Exception e) {
            log.error("DSL解析失败: {}, raw={}", e.getMessage(), response);
            throw new PipelineException("DSL解析失败，请重试");
        }
    }

    /**
     * 组装候选元数据上下文文本。
     */
    private String buildCandidateContext(DslCandidate candidate) {
        StringBuilder context = new StringBuilder();
        context.append("可用指标:\n");
        if (candidate.getMetrics() != null) {
            candidate.getMetrics().forEach(m -> context.append("- ").append(m.getMetricCode())
                    .append("(").append(m.getMetricName()).append("): ")
                    .append(m.getDescription()).append("\n"));
        }
        context.append("\n可用维度:\n");
        if (candidate.getDimensions() != null) {
            candidate.getDimensions().forEach(d -> context.append("- ").append(d.getDimensionCode())
                    .append("(").append(d.getDimensionName()).append("): ")
                    .append(d.getDescription()).append("\n"));
        }
        context.append("\n可用实体:\n");
        if (candidate.getEntities() != null) {
            candidate.getEntities().forEach(e -> context.append("- ").append(e.getEntityCode())
                    .append("(").append(e.getEntityName()).append(")\n"));
        }
        context.append("\n维度值:\n");
        if (candidate.getDimensionValues() != null) {
            candidate.getDimensionValues().forEach(v -> context.append("- ")
                    .append(v.getDimensionCode()).append(".")
                    .append(v.getValueCode()).append(" = ")
                    .append(v.getValueName()).append("\n"));
        }
        context.append("\n同义词提示:\n");
        if (candidate.getSynonyms() != null) {
            candidate.getSynonyms().forEach(s -> context.append("- ")
                    .append(s.getSynonymText())
                    .append(" → ").append(s.getObjectType())
                    .append(":").append(s.getObjectCode())
                    .append("(").append(s.getStandardName()).append(")\n"));
        }
        return context.toString();
    }

    /**
     * SQL 审查门禁：仅审查、不改写。未通过则失败。
     *
     * @param sql     代码生成的 SQL
     * @param schema  审查用 schema 摘要
     * @param question 用户问题（写入 schema 上下文）
     */
    private void enforceReviewGate(String sql, String schema, String question) {
        String reviewContext = schema + "\n用户问题: " + question;
        try {
            ReviewResult review = reviewTool.reviewSql(sql, reviewContext);
            boolean passed = Boolean.TRUE.equals(review.getResult());
            if (passed) {
                log.info("SQL审查通过");
                return;
            }
            String reason = review.getReason() != null ? review.getReason() : "未知原因";
            log.warn("SQL审查未通过: {}", reason);
            throw new PipelineException("SQL审查未通过: " + reason);
        } catch (PipelineException e) {
            throw e;
        } catch (Exception e) {
            // 审查服务异常时失败关闭，避免未审核 SQL 直接执行
            log.error("SQL审查异常", e);
            throw new PipelineException("SQL审查服务异常，已中止执行");
        }
    }

    /**
     * 从富化 DSL 构建审查用 schema 摘要。
     */
    private String buildReviewSchema(EnrichedQueryDSL dsl) {
        StringBuilder sb = new StringBuilder();
        sb.append("主表: ").append(dsl.getMainPhysicalTable()).append("\n");
        if (dsl.getSelectColumns() != null) {
            sb.append("SELECT列:\n");
            dsl.getSelectColumns().forEach(c ->
                    sb.append("- ").append(c.getExpression())
                            .append(" AS ").append(c.getAlias()).append("\n"));
        }
        if (dsl.getJoins() != null) {
            sb.append("JOIN:\n");
            dsl.getJoins().forEach(j ->
                    sb.append("- ").append(j.getJoinType()).append(" ")
                            .append(j.getPhysicalTable()).append(" ON ")
                            .append(j.getOnCondition()).append("\n"));
        }
        if (dsl.getWhereConditions() != null) {
            sb.append("WHERE:\n");
            dsl.getWhereConditions().forEach(w ->
                    sb.append("- ").append(w.getExpression()).append("\n"));
        }
        return sb.toString();
    }

    /**
     * 从 LLM 文本中提取 JSON 对象。
     */
    private String extractJson(String text) {
        if (text == null) {
            return "{}";
        }
        int start = text.indexOf('{');
        int end = text.lastIndexOf('}');
        if (start >= 0 && end > start) {
            return text.substring(start, end + 1);
        }
        return text;
    }

    private int sizeOf(List<?> list) {
        return list == null ? 0 : list.size();
    }

    /**
     * 管线业务异常（可对用户展示 message）。
     */
    private static class PipelineException extends RuntimeException {
        PipelineException(String message) {
            super(message);
        }
    }
}
