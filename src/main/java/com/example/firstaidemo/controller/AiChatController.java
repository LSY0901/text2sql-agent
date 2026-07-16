package com.example.firstaidemo.controller;

import com.example.firstaidemo.models.request.Nlp2DslAgentRequest;
import com.example.firstaidemo.semanticdsl.agent.ISemanticDslAgentService;
import com.example.firstaidemo.service.IAgentService;
import com.example.firstaidemo.service.IAiChatService;
import com.example.firstaidemo.service.IEnterpriseText2SqlService;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/aiChat")
public class AiChatController {

    @Autowired
    private IAiChatService aiChatService;

    @Autowired
    private IAgentService agentService;

    @Autowired
    private IEnterpriseText2SqlService enterpriseText2SqlService;

    @Autowired
    private EmbeddingModel embeddingModel;

    @Autowired
    private ISemanticDslAgentService semanticDslAgentService;

    @GetMapping("/chat")
    public String chat(String message) {
        return aiChatService.chat(message);
    }


    @GetMapping(value = "/chatStream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> chatStream(String message) {
        return aiChatService.chatStream(message);
    }


    @GetMapping("/memoryChat")
    public String memoryChat(String message) {
        return agentService.memoryChat(message);
    }


    @GetMapping(value = "/memoryStreamingChat", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> memoryStreamingChat(String message) {
        return agentService.memoryStreamingChat(message);
    }


    @GetMapping(value = "/memoryStreamingUseToolChat", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> memoryStreamingUseToolChat(String message) {
        return agentService.memoryStreamingUseToolChat(message);
    }


    @GetMapping("/chatRealPgData")
    public String chatRealPgData(String message) {
        return aiChatService.chatRealPgData(message);
    }


    @GetMapping("/workFlowAiAgent")
    public String workFlowAiAgent(String question) {
        return aiChatService.workFlowAiAgent(question);
    }


    @GetMapping("/sqlAgentNotWorkFlow")
    public String sqlAgentNotWorkFlow(String question) {
        return aiChatService.sqlAgentNotWorkFlow(question);
    }


    /**
     * workFlowAiAgent
     * @param question
     * @return
     */
    @GetMapping("/enterpriseSqlAgentWorkflow")
    public String enterpriseSqlAgent(String question) {
        if (question == null || question.isBlank()) {
            return "问题不能为空";
        }
        return enterpriseText2SqlService.enterpriseSqlAgentWorkflow(question);
    }


    @GetMapping("/enterpriseSqlAgentTools")
    public String enterpriseSqlAgentTools(String question) {
        if (question == null || question.isBlank()) {
            return "问题不能为空";
        }
        return enterpriseText2SqlService.enterpriseSqlAgentTools(question);
    }


    /**
     * Embedding 测试 — 将文本向量化后存入 PostgreSQL（需要先 CREATE EXTENSION vector;）
     * GET /aiChat/embedding/store?text=你好世界
     */
    @GetMapping("/embedding/store")
    public String embeddingStore(String text) {
        return aiChatService.embeddingStore(text);
    }

    /**
     * Embedding 测试 — 根据查询文本进行余弦相似度搜索
     * GET /aiChat/embedding/search?query=测试
     */
    @GetMapping("/embedding/search")
    public String embeddingSearch(String query) {
        return aiChatService.embeddingSearch(query);
    }

    /**
     * 手动触发元数据表 embedding 全量重新生成
     * GET /aiChat/embedding/seedMetadata
     */
    @GetMapping("/embedding/seedMetadata")
    public String seedMetadataEmbeddings() {
        return aiChatService.seedMetadataEmbeddings();
    }

    /**
     * RAG SQL Agent — 向量搜索元数据表 → LLM 生成 SQL → 执行
     * GET /aiChat/ragSqlAgent?question=查询所有订单
     */
    @GetMapping("/ragSqlAgent")
    public String ragSqlAgent(String question) {
        return aiChatService.ragSqlAgent(question);
    }

    @GetMapping("/ragAgentTools")
    public String ragAgentTools(String question) {
        return aiChatService.ragAgentTools(question);
    }

    /**
     * RAG Rerank Agent — 向量搜索 + LLM相关性打分重排序 → 加载列 → LLM生成SQL → 执行
     * GET /aiChat/ragRerankAgent?question=查询所有订单
     */
    @GetMapping("/ragRerankWorkflow")
    public String ragRerankAgent(String question) {
        return aiChatService.ragRerankAgent(question);
    }

    /**
     * RAG Rerank Agent Tools — LLM 自主调用
     */
    @GetMapping("/ragRerankAgentTools")
    public String ragRerankAgentTools(String question) {
        return aiChatService.ragRerankAgentTools(question);
    }

    /**
     * RAG Rerank Column Agent Stream — WorkFlow
     */
    @GetMapping(value = "/ragRerankColumnAgentStream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> ragRerankColumnAgentStream(String question) {
        return aiChatService.ragRerankColumnAgentStream(question);
    }


    /**
     * Text2SQL-Agent (Workflow)
     */
    @GetMapping(value = "/text2SqlAgent", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> text2SqlAgent(String question) {
        return aiChatService.text2SqlAgent(question);
    }

    /**
     * Text2SQL-Agent — LLM 完全自主决策调用 Tool，
     * 搜索表 → 加载列 → Rerank → Planning → 生成SQL → Review → 执行 → 回答
     */
    @GetMapping(value = "/text2SqlAgentTools", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> text2SqlAgentTools(String question) {
        return aiChatService.text2SqlAgentTools(question);
    }

    /**
     * NLP2DSL2SQL Agent — 六阶段管线
     * Schema 检索 → DSL 生成 → DSL 校验 → DSL 翻译SQL → Review+执行 → 自然语言回答
     */
    @GetMapping(value = "/nlp2Dsl2SqlAgent", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> nlp2Dsl2SqlAgent(String question) {
        return aiChatService.nlp2Dsl2SqlAgent(question);
    }

    /**
     * NLP2DSL2SQL Agent V2 — 语义层管线（流式）
     * 意图识别 → 向量检索+Rerank → DSL生成 → DSL校验 → DSL富化 → SQL翻译 → SQL审查+执行 → 自然语言回答
     *
     * @param request 请求入参（question）
     * @return SSE 文本流
     */
    @GetMapping(value = "/nlp2Dsl2SqlAgentV2", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> nlp2Dsl2SqlAgentV2(Nlp2DslAgentRequest request) {
        return semanticDslAgentService.nlp2Dsl2SqlAgentV2(request.getQuestion());
    }

}
