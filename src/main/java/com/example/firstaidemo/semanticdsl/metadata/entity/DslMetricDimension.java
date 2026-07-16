package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_metric_dimension")
public class DslMetricDimension {
    private Integer id;
    private String metricCode;
    private String dimensionCode;
    private String relationType;
    private String description;
    private Boolean isRequired;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
