package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_metric")
public class DslMetric {
    private Integer id;
    private String metricCode;
    private String metricName;
    private String metricType;
    private String entityCode;
    private String aggregationType;
    private String expression;
    private String unit;
    private Integer precisionValue;
    private String resultType;
    private String description;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
