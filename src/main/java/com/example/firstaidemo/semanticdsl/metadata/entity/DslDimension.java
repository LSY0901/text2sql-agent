package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL查询维度定义表，用于描述业务分析中的分组维度，例如年级、班级、科目
 */
@Data
@TableName("dsl_dimension")
public class DslDimension {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 维度编码，例如grade、class、subject
     */
    private String dimensionCode;
    /**
     * 维度名称，例如年级、班级、科目
     */
    private String dimensionName;
    /**
     * 所属实体编码，对应dsl_entity.entity_code
     */
    private String entityCode;
    /**
     * 对应属性编码，对应dsl_attribute.attribute_code
     */
    private String attributeCode;
    /**
     * 维度类型，例如ATTRIBUTE、ENUM
     */
    private String dimensionType;
    /**
     * 对应数据库物理字段
     */
    private String physicalColumn;
    /**
     * 维度业务描述，用于LLM理解维度含义
     */
    private String description;
    /**
     * 是否允许作为查询分组维度
     */
    private Boolean isQueryable;
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
