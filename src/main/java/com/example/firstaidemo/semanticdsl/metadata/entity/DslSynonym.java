package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * DSL业务同义词定义表，用于将用户自然语言表达映射到标准DSL对象
 */
@Data
@TableName("dsl_synonym")
public class DslSynonym {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 用户可能输入的自然语言表达，例如均分、平均分
     */
    private String synonymText;
    /**
     * 映射对象类型，例如ENTITY、ATTRIBUTE、METRIC、DIMENSION
     */
    private String objectType;
    /**
     * 映射目标编码，对应DSL对象编码
     */
    private String objectCode;
    /**
     * 标准业务名称
     */
    private String standardName;
    /**
     * 同义词业务说明
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
