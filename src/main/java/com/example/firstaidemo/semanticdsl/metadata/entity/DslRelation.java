package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_relation")
public class DslRelation {
    private Integer id;
    private String sourceEntity;
    private String targetEntity;
    private String joinType;
    private String joinCondition;
    private String relationType;
    private String description;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
