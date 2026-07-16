package com.example.firstaidemo.models.request;

import lombok.Data;

/**
 * NLP2DSL2SQL Agent V2 请求入参。
 */
@Data
public class Nlp2DslAgentRequest {

    /**
     * 用户自然语言问题。
     */
    private String question;
}
