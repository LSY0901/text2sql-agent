package com.example.firstaidemo.semanticdsl.model;

import lombok.Data;

@Data
public class IntentResult {
    private String intent;
    private double confidence;
    private String reason;

    public enum IntentType {
        METRIC_QUERY, DIMENSION_ANALYSIS, DETAIL_QUERY, NON_BUSINESS
    }
}
