package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL实体关系定义表，用于描述业务实体之间关联关系以及SQL JOIN规则
 */
@Data
@TableName("dsl_relation")
public class DslRelation {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 关系编码，唯一标识实体之间关联关系
     */
    private String relationCode;
    /**
     * 源实体编码，对应dsl_entity.entity_code
     */
    private String sourceEntity;
    /**
     * 目标实体编码，对应dsl_entity.entity_code
     */
    private String targetEntity;
    /**
     * 实体关系类型，例如ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE
     */
    private String relationType;
    /**
     * SQL连接类型，例如INNER JOIN、LEFT JOIN
     */
    private String joinType;
    /**
     * 实体关联条件，用于自动生成SQL JOIN语句
     */
    private String joinCondition;
    /**
     * 关系优先级，用于多条JOIN路径选择
     */
    private Integer priority;
    /**
     * 关系业务描述，用于LLM理解实体之间关系
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
