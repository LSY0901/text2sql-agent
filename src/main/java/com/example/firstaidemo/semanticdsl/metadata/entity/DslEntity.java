package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL业务实体定义表，用于描述自然语言中的业务对象，例如学生、成绩、班级
 */
@Data
@TableName("dsl_entity")
public class DslEntity {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 实体编码，例如student、score
     */
    private String entityCode;
    /**
     * 实体名称，例如学生、成绩
     */
    private String entityName;
    /**
     * 实体类型，例如ENTITY
     */
    private String entityType;
    /**
     * 对应数据库物理表名称
     */
    private String physicalTable;
    /**
     * 物理表主键字段
     */
    private String primaryKey;
    /**
     * 实体业务描述，用于LLM理解实体含义
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
