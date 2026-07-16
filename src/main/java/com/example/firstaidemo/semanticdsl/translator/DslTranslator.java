package com.example.firstaidemo.semanticdsl.translator;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;

public interface DslTranslator {
    String translate(EnrichedQueryDSL enrichedDSL);
    SqlDialect getDialect();
}
