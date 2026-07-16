package com.example.firstaidemo.semanticdsl.translator;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import org.springframework.stereotype.Component;

@Component
public class PostgreSqlTranslator extends AbstractDslTranslator {

    @Override
    public SqlDialect getDialect() {
        return SqlDialect.POSTGRESQL;
    }

    @Override
    protected String quoteIdentifier(String identifier) {
        if (identifier == null || identifier.isEmpty()) {
            return identifier;
        }
        if (identifier.contains("(") || identifier.contains(" ")) {
            return identifier;
        }
        if (identifier.startsWith("\"") && identifier.endsWith("\"")) {
            return identifier;
        }
        return "\"" + identifier + "\"";
    }

    @Override
    public String translate(EnrichedQueryDSL dsl) {
        return super.translate(dsl);
    }
}
