package com.example.firstaidemo.service;

import reactor.core.publisher.Flux;

/**
 * NLP2DSL2SQL Agent Service — 六阶段管线
 * <p>
 * 阶段 1: Planner — LLM 自主调用工具检索 Schema (向量搜索 → 加载列 → Rerank)
 * 阶段 2: DSL Generator — LLM 根据 question + schema 生成结构化 JSON DSL (Structured Output)
 * 阶段 3: DSL Validator — 代码强制校验 DSL (表名/字段名/操作符合法性)
 * 阶段 4: DSL Translator — 确定性代码翻译 DSL → SQL (无 LLM 介入)
 * 阶段 5: SQL Review + Execute — 代码强制 Review → JdbcTemplate 执行 (失败自动修复重试)
 * 阶段 6: 自然语言回答 — LLM 将 SQL + 结果转为中文回答
 * <p>
 * 与 Text2SQL 的核心区别：在 LLM 和 SQL 之间引入结构化 DSL 中间层，
 * DSL→SQL 翻译由确定性代码完成，消除 LLM 在 SQL 生成环节的幻觉。
 */
public interface IDslAgentService {

    /**
     * 执行 NLP2DSL2SQL 管线，返回自然语言回答（同步）
     *
     * @param question 用户自然语言问题
     * @return 中文自然语言回答
     */
    String execute(String question);

    /**
     * 执行 NLP2DSL2SQL 管线，流式返回自然语言回答（SSE）
     *
     * @param question 用户自然语言问题
     * @return 流式 SSE 响应
     */
    Flux<String> executeStream(String question);
}
