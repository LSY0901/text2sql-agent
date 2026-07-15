package com.example.firstaidemo.service;

import reactor.core.publisher.Flux;

public interface IAiChatService {

    /**
     * 聊天 - 等待一次返回
     * @param message
     * @return
     */
    String chat(String message);

    /**
     * 聊天 - 流式返回
     * @param message
     * @return
     */
    Flux<String> chatStream(String message);

    /**
     * 聊天 - 获取实时数据
     * @param message
     * @return
     */
    String chatRealPgData(String message);


    /**
     * 规定流程-workFlowAiAgent
     * @param question
     * @return
     */
    String workFlowAiAgent(String question);

    /**
     * sql-workFlowAiAgent
     * @param question
     * @return
     */
    String sqlAgentNotWorkFlow(String question);

    /**
     * Embedding 测试 — 将文本向量化后存入 PostgreSQL（pgvector）
     * @param text 要存储的文本
     * @return 结果信息
     */
    String embeddingStore(String text);

    /**
     * Embedding 测试 — 根据查询文本进行相似度搜索
     * @param query 查询文本
     * @return 相似文档列表（JSON）
     */
    String embeddingSearch(String query);

    /**
     * RAG SQL Agent — 向量搜索元数据表 → LLM 生成 SQL → 执行并返回
     * @param question 用户问题
     * @return SQL 执行结果（JSON）
     */
    String ragSqlAgent(String question);

    /**
     * RAG Agent Tools — LLM 自主调用 Tool 完成 RAG 搜索 + SQL 生成 + 执行
     * @param question 用户问题
     * @return LLM 最终回答
     */
    String ragAgentTools(String question);

    /**
     * RAG Rerank Agent — 向量搜索 + LLM相关性打分重排序 → 加载列 → LLM生成SQL → 执行
     * @param question 用户问题
     * @return SQL 执行结果（JSON）
     */
    String ragRerankAgent(String question);

    /**
     * RAG Rerank Agent Tools — LLM 自主调用 Tool（含 RerankTool）完成搜索+重排序+SQL生成+执行
     * @param question 用户问题
     * @return LLM 最终回答
     */
    String ragRerankAgentTools(String question);

    /**
     * RAG Rerank Column Agent Stream — LLM 自主调用 Tool 完成: 搜索表 → 加载列元数据 → 列级Rerank → SQL执行
     * 流式输出，先加载列再 Rerank，比仅用表名 Rerank 更可靠
     * @param question 用户问题
     * @return 流式 SSE 响应
     */
    Flux<String> ragRerankColumnAgentStream(String question);

    /**
     * 重置并重新生成元数据表的 embedding（先置 NULL，再调用 DeepSeek embedding 生成）
     * @return 结果信息
     */
    String seedMetadataEmbeddings();

    /**
     * 文本转 SQL
     * @param question
     * @return
     */
    Flux<String> text2SqlAgent(String question);

    /**
     * Text2SQL Agent — LLM 完全自主决策调用 Tool，
     * 搜索表 → 加载列 → Rerank → Planning → 生成SQL → Review → 执行 → 回答，
     * 流程由 LLM 自主决定，流式输出最终答案
     * @param question 用户自然语言问题
     * @return 流式 SSE 响应
     */
    Flux<String> text2SqlAgentTools(String question);

    /**
     * NLP2DSL2SQL Agent — 六阶段管线
     * Schema 检索 → DSL 生成 → DSL 校验 → DSL 翻译SQL → Review+执行 → 自然语言回答
     * @param question 用户自然语言问题
     * @return 流式 SSE 响应
     */
    Flux<String> nlp2Dsl2SqlAgent(String question);
}
