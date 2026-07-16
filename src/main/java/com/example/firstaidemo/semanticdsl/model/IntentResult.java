package com.example.firstaidemo.semanticdsl.model;

import lombok.Data;

/**
 * 意图识别结果。
 */
@Data
public class IntentResult {
    private String intent;
    private double confidence;
    private String reason;

    public enum IntentType {
        METRIC_QUERY, DIMENSION_ANALYSIS, DETAIL_QUERY, NON_BUSINESS
    }

    /**
     * 安全解析意图枚举，非法值回落为 NON_BUSINESS。
     *
     * @param intent 意图字符串
     * @return 意图枚举
     */
    public static IntentType parseIntentType(String intent) {
        if (intent == null || intent.isBlank()) {
            return IntentType.NON_BUSINESS;
        }
        try {
            return IntentType.valueOf(intent.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return IntentType.NON_BUSINESS;
        }
    }

    /**
     * @return 解析后的意图枚举
     */
    public IntentType resolveIntentType() {
        return parseIntentType(this.intent);
    }
}
