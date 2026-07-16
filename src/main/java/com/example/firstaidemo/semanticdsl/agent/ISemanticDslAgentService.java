package com.example.firstaidemo.semanticdsl.agent;

import com.example.firstaidemo.semanticdsl.model.EnrichedQueryDSL;
import com.example.firstaidemo.semanticdsl.model.IntentResult;

import java.util.Map;

public interface ISemanticDslAgentService {
    Map<String, Object> nlp2Dsl2SqlAgentV2(String question);
    IntentResult classifyIntent(String question);
    EnrichedQueryDSL executePipeline(String question);
}
