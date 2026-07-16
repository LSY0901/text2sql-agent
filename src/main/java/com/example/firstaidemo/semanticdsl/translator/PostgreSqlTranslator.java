package com.example.firstaidemo.semanticdsl.translator;

/**
 * PostgreSQL 方言翻译器（由 {@link TranslatorConfig} 按方言装配）。
 */
public class PostgreSqlTranslator extends AbstractDslTranslator {

    /**
     * @return PostgreSQL 方言
     */
    @Override
    public SqlDialect getDialect() {
        return SqlDialect.POSTGRESQL;
    }

    /**
     * 对标识符各段加双引号，防止注入非法字符。
     *
     * @param identifier 原始标识符
     * @return 引用后的标识符
     */
    @Override
    protected String quoteIdentifier(String identifier) {
        if (identifier == null || identifier.isEmpty()) {
            return identifier;
        }
        // 聚合表达式等不走标识符引用
        if (identifier.contains("(") || identifier.contains(" ")
                || identifier.contains("?") || identifier.contains("=")) {
            return identifier;
        }

        String[] parts = identifier.split("\\.", -1);
        StringBuilder quoted = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            String part = stripQuotes(parts[i]);
            if (!part.matches("^[a-zA-Z_][a-zA-Z0-9_]*$")) {
                throw new IllegalArgumentException("Invalid identifier: " + identifier);
            }
            if (i > 0) {
                quoted.append('.');
            }
            quoted.append('"').append(part.replace("\"", "\"\"")).append('"');
        }
        return quoted.toString();
    }

    /**
     * 去掉已有双引号包裹。
     */
    private String stripQuotes(String raw) {
        if (raw != null && raw.startsWith("\"") && raw.endsWith("\"") && raw.length() >= 2) {
            return raw.substring(1, raw.length() - 1);
        }
        return raw;
    }
}
