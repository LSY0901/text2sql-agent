package com.example.firstaidemo.semanticdsl.translator;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;

import java.util.Collections;
import java.util.List;

/**
 * 语义 DSL → SQL 翻译器。
 */
public interface DslTranslator {

    /**
     * 将富化后的 DSL 翻译为 SQL 及绑定参数。
     *
     * @param enrichedDSL 富化 DSL
     * @return SQL 与参数列表
     */
    TranslatedSql translate(EnrichedQueryDSL enrichedDSL);

    /**
     * @return 当前方言
     */
    SqlDialect getDialect();

    /**
     * 翻译结果：SQL 文本 + JDBC 绑定参数。
     */
    record TranslatedSql(String sql, List<Object> parameters) {

        /**
         * 构造空参数翻译结果。
         */
        public TranslatedSql(String sql) {
            this(sql, Collections.emptyList());
        }

        /**
         * @return 不可变参数列表
         */
        @Override
        public List<Object> parameters() {
            return parameters == null ? Collections.emptyList() : parameters;
        }
    }
}
