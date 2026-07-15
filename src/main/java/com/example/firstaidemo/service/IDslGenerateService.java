package com.example.firstaidemo.service;

import com.example.firstaidemo.models.dsl.QueryDSL;

/**
 * DSL 生成服务 — LLM 将自然语言 + Schema 翻译为结构化 JSON DSL
 */
public interface IDslGenerateService {

    /**
     * 根据用户问题和 Schema 生成结构化 DSL
     *
     * @param question 用户自然语言问题
     * @param schema   数据库 Schema 文本（来自 Planner 阶段）
     * @return 结构化 QueryDSL 对象
     */
    QueryDSL generateDsl(String question, String schema);

    /**
     * 根据错误原因重新生成 DSL（校验失败或 SQL 执行失败时调用）
     *
     * @param question     用户自然语言问题
     * @param schema       数据库 Schema 文本
     * @param errorReason  错误原因
     * @return 修正后的 QueryDSL 对象
     */
    QueryDSL generateDslByError(String question, String schema, String errorReason);
}
