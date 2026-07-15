package com.example.firstaidemo.tools;

import com.example.firstaidemo.models.dsl.QueryDSL;

/**
 * DSL → SQL 翻译器接口
 * <p>
 * 确定性翻译，不经过 LLM。不同数据库方言实现不同子类。
 */
public interface DslTranslator {

    /**
     * 将 QueryDSL 翻译为可执行的 SQL 字符串
     *
     * @param dsl 查询 DSL
     * @return SQL 字符串
     */
    String translate(QueryDSL dsl);
}
