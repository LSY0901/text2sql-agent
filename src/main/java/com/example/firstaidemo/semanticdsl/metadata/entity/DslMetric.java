package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL业务指标定义表，用于描述自然语言中的业务指标、计算逻辑以及语义向量
 */
@Data
@TableName("dsl_metric")
public class DslMetric {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 指标编码，例如avg_score、student_count
     */
    private String metricCode;
    /**
     * 指标名称，例如平均成绩、不及格率
     */
    private String metricName;
    /**
     * 指标业务类型，例如QUALITY、STATISTICS
     */
    private String metricType;
    /**
     * 指标所属业务实体编码，对应dsl_entity.entity_code
     */
    private String entityCode;
    /**
     * 聚合类型，例如AVG、SUM、COUNT、MAX、MIN、RATE
     */
    private String aggregationType;
    /**
     * 指标计算表达式，用于生成SQL，例如AVG(score.score_value)
     */
    private String expression;
    /**
     * 指标单位，例如分、%、人数
     */
    private String unit;
    /**
     * 指标结果保留小数位数
     */
    private Integer precisionValue;
    /**
     * 指标结果类型，例如NUMBER、PERCENT、INTEGER
     */
    private String resultType;
    /**
     * 指标业务描述，用于LLM理解指标口径
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
