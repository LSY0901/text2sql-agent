package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL维度值定义表，用于描述业务维度中的具体枚举值以及数据库映射
 */
@Data
@TableName("dsl_dimension_value")
public class DslDimensionValue {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 维度编码，对应dsl_dimension.dimension_code
     */
    private String dimensionCode;
    /**
     * 维度值编码，例如grade_1、math
     */
    private String valueCode;
    /**
     * 维度值名称，例如一年级、数学
     */
    private String valueName;
    /**
     * 数据库实际存储值
     */
    private String physicalValue;
    /**
     * 维度值业务描述
     */
    private String description;
    /**
     * JOIN dsl_dimension 得到，仅用于 embedding 文本拼接
     */
    private String dimensionName;
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
