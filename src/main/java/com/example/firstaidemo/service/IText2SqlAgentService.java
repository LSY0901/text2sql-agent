package com.example.firstaidemo.service;

import reactor.core.publisher.Flux;

/**
 * Text2SQL Agent Service — 五阶段 Planner-Executor 管线
 * <p>
 * 阶段 1: Planner — LLM 自主调用工具检索 Schema (向量搜索 → 加载列 → Rerank)
 * 阶段 2: SQL Generator — LLM 根据 question + schema 生成 SQL (Structured Output)
 * 阶段 3: Review Gate — 代码强制的 SQL 审查，最多 3 轮修正
 * 阶段 4: Execute — JdbcTemplate 执行 SELECT，失败自动修复重试 (3次)
 * 阶段 5: 自然语言回答 — LLM 将 SQL + 结果转为中文回答
 * <p>
 * 可被 REST Controller、MCP Server、测试代码等多渠道调用。
 */
public interface IText2SqlAgentService {

    /**
     * 执行 Text2SQL 管线，返回自然语言回答（同步）
     *
     * @param question 用户自然语言问题
     * @return 中文自然语言回答
     */
    String execute(String question);

    /**
     * 执行 Text2SQL 管线，流式返回自然语言回答（SSE）
     *
     * @param question 用户自然语言问题
     * @return 流式 SSE 响应
     */
    Flux<String> executeStream(String question);
}
