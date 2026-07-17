package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL业务属性定义表，用于描述实体字段语义以及SQL字段映射
 */
@Data
@TableName("dsl_attribute")
public class DslAttribute {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 所属实体编码，对应dsl_entity.entity_code
     */
    private String entityCode;
    /**
     * 属性编码，例如student_name、score_value
     */
    private String attributeCode;
    /**
     * 属性名称，例如学生姓名、成绩
     */
    private String attributeName;
    /**
     * 对应物理表字段名称
     */
    private String physicalColumn;
    /**
     * 字段数据类型，例如varchar、int、decimal
     */
    private String dataType;
    /**
     * 属性类型，例如ATTRIBUTE普通属性、MEASURE度量属性
     */
    private String attributeType;
    /**
     * 属性业务描述，用于LLM理解字段含义
     */
    private String description;
    /**
     * JOIN dsl_entity 得到，仅用于 embedding 文本拼接
     */
    private String entityName;
    /**
     * 是否允许作为查询字段或过滤条件
     */
    private Boolean isQueryable;
    /**
     * 是否支持聚合计算，例如AVG、SUM、MAX
     */
    private Boolean isAggregatable;
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
