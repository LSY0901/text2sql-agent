package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL指标维度关系表，用于限制指标支持的分析维度，避免LLM生成非法组合
 */
@Data
@TableName("dsl_metric_dimension")
public class DslMetricDimension {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 指标编码，对应dsl_metric.metric_code
     */
    private String metricCode;
    /**
     * 维度编码，对应dsl_dimension.dimension_code
     */
    private String dimensionCode;
    /**
     * 指标维度关系类型，例如GROUP、FILTER
     */
    private String relationType;
    /**
     * 指标支持该维度的业务说明
     */
    private String description;
    /**
     * 是否必须指定该维度
     */
    private Boolean isRequired;
    /**
     * 逻辑删除标识
     */
    private Boolean isDeleted;
    /**
     * 创建人
     */
    private String creator;
    /**
     * 创建时间戳
     */
    private Long createdDt;
    /**
     * 最后修改人
     */
    private String lastEditor;
    /**
     * 最后修改时间戳
     */
    private Long lastEditedDt;
}
