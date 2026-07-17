package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL指标属性依赖关系表，用于描述指标计算依赖的业务字段
 */
@Data
@TableName("dsl_metric_attribute")
public class DslMetricAttribute {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 指标编码，对应dsl_metric.metric_code
     */
    private String metricCode;
    /**
     * 属性所属实体编码，对应dsl_entity.entity_code
     */
    private String entityCode;
    /**
     * 指标依赖属性编码，对应dsl_attribute.attribute_code
     */
    private String attributeCode;
    /**
     * 字段角色类型，例如MEASURE计算字段、FILTER过滤字段、GROUP维度字段
     */
    private String roleType;
    /**
     * 指标字段依赖说明
     */
    private String description;
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
