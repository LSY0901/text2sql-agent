package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_entity")
public class DslEntity {
    private Integer id;
    private String entityCode;
    private String entityName;
    private String entityType;
    private String physicalTable;
    private String primaryKey;
    private String description;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
