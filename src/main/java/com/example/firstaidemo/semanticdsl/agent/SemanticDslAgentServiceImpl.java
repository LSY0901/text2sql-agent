package com.example.firstaidemo.semanticdsl.agent;

import com.alibaba.fastjson2.JSON;
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
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.List;
import java.util.Map;

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

    @Override
    public Flux<String> nlp2Dsl2SqlAgentV2(String question) {
        return Flux.defer(() -> {
            try {
                log.info("━━━━━━━ NLP2DSL2SQL Agent V2 启动 ━━━━━━━");
                log.info("用户问题: {}", question);

                // Stage 1: 意图识别
                IntentResult intent = classifyIntent(question);
                log.info("[Stage 1] 意图识别: {} (confidence={})", intent.getIntent(), intent.getConfidence());

                if ("NON_BUSINESS".equals(intent.getIntent())) {
                    return Flux.just("非业务问题，无法处理。原因: " + intent.getReason());
                }

                // Stage 2: 语义检索
                DslCandidate candidate = dslRetriever.retrieve(question);
                log.info("[Stage 2] 语义检索完成: metrics={}, dimensions={}",
                        candidate.getMetrics().size(), candidate.getDimensions().size());

                // Stage 3: 语义DSL生成
                SemanticQueryDSL semanticDSL = generateSemanticDSL(question, candidate);
                log.info("[Stage 3] 语义DSL: {}", objectMapper.writeValueAsString(semanticDSL));

                // Stage 4: DSL校验
                IntentResult.IntentType intentType = IntentResult.IntentType.valueOf(intent.getIntent());
                SemanticDslValidator.ValidationResult validation = dslValidator.validate(semanticDSL, intentType);
                log.info("[Stage 4] 校验结果: valid={}", validation.valid());

                if (!validation.valid()) {
                    return Flux.just("DSL校验失败: " + validation.errors());
                }

                // Stage 5: DSL富化
                EnrichedQueryDSL enrichedDSL = dslEnricher.enrich(semanticDSL, candidate);
                log.info("[Stage 5] DSL富化完成");

                // Stage 6: SQL生成
                String sql = dslTranslator.translate(enrichedDSL);
                log.info("[Stage 6] SQL生成: {}", sql);

                // Stage 7: SQL审查 (带重试)
                String finalSql = enforceReviewGate(sql, question, 3);
                log.info("[Stage 7] SQL审查完成: {}", finalSql);

                // 执行SQL
                List<Map<String, Object>> queryResult = sqlExecuteTool.executeSql(finalSql);
                log.info("━━━━━━━ NLP2DSL2SQL Agent V2 管线完成，开始流式回答 ━━━━━━━");

                // Stage 8: LLM 自然语言回答，流式输出
                String answerPrompt = """
                        用户问题：%s

                        查询SQL：%s

                        查询结果：%s

                        请用自然语言回答用户的问题。
                        """.formatted(question, finalSql, JSON.toJSONString(queryResult));

                return Flux.concat(
                        Flux.just("【意图】" + intent.getIntent() + "\n"),
                        Flux.just("【SQL】" + finalSql + "\n\n"),
                        ChatClient.builder(chatModel).build()
                                .prompt(answerPrompt)
                                .stream()
                                .content()
                );

            } catch (Exception e) {
                log.error("Agent执行失败", e);
                return Flux.just("错误: " + e.getMessage());
            }
        });
    }

    @Override
    public IntentResult classifyIntent(String question) {
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        String response = chatClient.prompt()
                .system(SemanticPromptTemplates.INTENT_SYSTEM_PROMPT)
                .user(question)
                .call()
                .content();
        try {
            return objectMapper.readValue(response, IntentResult.class);
        } catch (Exception e) {
            log.warn("意图识别解析失败，默认为NON_BUSINESS: {}", e.getMessage());
            IntentResult fallback = new IntentResult();
            fallback.setIntent("NON_BUSINESS");
            fallback.setConfidence(0.0);
            fallback.setReason("解析失败: " + e.getMessage());
            return fallback;
        }
    }

    @Override
    public EnrichedQueryDSL executePipeline(String question) {
        IntentResult intent = classifyIntent(question);
        if ("NON_BUSINESS".equals(intent.getIntent())) {
            return new EnrichedQueryDSL();
        }
        DslCandidate candidate = dslRetriever.retrieve(question);
        SemanticQueryDSL semanticDSL = generateSemanticDSL(question, candidate);
        IntentResult.IntentType intentType = IntentResult.IntentType.valueOf(intent.getIntent());
        SemanticDslValidator.ValidationResult validation = dslValidator.validate(semanticDSL, intentType);
        if (!validation.valid()) {
            return new EnrichedQueryDSL();
        }
        return dslEnricher.enrich(semanticDSL, candidate);
    }

    private SemanticQueryDSL generateSemanticDSL(String question, DslCandidate candidate) {
        ChatClient chatClient = ChatClient.builder(chatModel).build();

        StringBuilder context = new StringBuilder();
        context.append("可用指标:\n");
        candidate.getMetrics().forEach(m -> context.append("- ").append(m.getMetricCode())
                .append("(").append(m.getMetricName()).append("): ").append(m.getDescription()).append("\n"));
        context.append("\n可用维度:\n");
        candidate.getDimensions().forEach(d -> context.append("- ").append(d.getDimensionCode())
                .append("(").append(d.getDimensionName()).append("): ").append(d.getDescription()).append("\n"));
        context.append("\n可用实体:\n");
        candidate.getEntities().forEach(e -> context.append("- ").append(e.getEntityCode())
                .append("(").append(e.getEntityName()).append(")\n"));
        context.append("\n维度值:\n");
        candidate.getDimensionValues().forEach(v -> context.append("- ").append(v.getDimensionCode())
                .append(".").append(v.getValueCode()).append(" = ").append(v.getValueName()).append("\n"));

        String response = chatClient.prompt()
                .system(SemanticPromptTemplates.DSL_GENERATION_SYSTEM_PROMPT)
                .user("用户问题: " + question + "\n\n候选元数据:\n" + context)
                .call()
                .content();

        try {
            String json = extractJson(response);
            return objectMapper.readValue(json, SemanticQueryDSL.class);
        } catch (Exception e) {
            log.error("DSL解析失败: {}", e.getMessage());
            SemanticQueryDSL fallback = new SemanticQueryDSL();
            fallback.setEntity(candidate.getEntities().isEmpty() ? null : candidate.getEntities().get(0).getEntityCode());
            return fallback;
        }
    }

    private String enforceReviewGate(String sql, String question, int maxRetries) {
        String currentSql = sql;
        for (int i = 0; i < maxRetries; i++) {
            try {
                com.example.firstaidemo.models.entity.ReviewResult review = reviewTool.reviewSql(currentSql, question);
                boolean passed = Boolean.TRUE.equals(review.getResult());
                if (passed) {
                    log.info("SQL审查通过 (attempt {})", i + 1);
                    return currentSql;
                }
                String reason = review.getReason();
                log.warn("SQL审查未通过 (attempt {}): reason={}", i + 1, reason);
                currentSql = regenerateSqlWithError(currentSql, reason, "请根据错误修正SQL", question);
            } catch (Exception e) {
                log.warn("审查结果解析失败，跳过审查: {}", e.getMessage());
                return currentSql;
            }
        }
        log.warn("SQL审查达到最大重试次数({})，使用最后版本", maxRetries);
        return currentSql;
    }

    private String regenerateSqlWithError(String oldSql, String error, String suggestion, String question) {
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        String response = chatClient.prompt()
                .system("你是一个SQL修正专家。根据错误信息修正SQL。只返回修正后的SQL，不要任何解释。")
                .user("原SQL: " + oldSql + "\n错误: " + error + "\n建议: " + suggestion + "\n问题: " + question)
                .call()
                .content();
        return response != null ? response.trim().replaceAll("```sql|```", "") : oldSql;
    }

    private String extractJson(String text) {
        if (text == null) return "{}";
        int start = text.indexOf("{");
        int end = text.lastIndexOf("}");
        if (start >= 0 && end > start) {
            return text.substring(start, end + 1);
        }
        return text;
    }
}
