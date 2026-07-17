package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL业务过滤规则定义表，用于描述固定业务条件和SQL过滤逻辑
 */
@Data
@TableName("dsl_filter")
public class DslFilter {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 过滤规则编码，例如valid_student、valid_score
     */
    private String filterCode;
    /**
     * 过滤规则名称，例如有效学生、有效成绩
     */
    private String filterName;
    /**
     * 过滤所属实体编码，对应dsl_entity.entity_code
     */
    private String entityCode;
    /**
     * 过滤字段编码，对应dsl_attribute.attribute_code
     */
    private String attributeCode;
    /**
     * 操作符类型，例如EQ、GT、LT、BETWEEN
     */
    private String operatorType;
    /**
     * 过滤SQL表达式，例如score.score_value >= 60
     */
    private String expression;
    /**
     * 过滤规则业务描述
     */
    private String description;
    /**
     * 是否系统默认过滤规则
     */
    private Boolean isSystem;
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
