package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_filter")
public class DslFilter {
    private Integer id;
    private String entityCode;
    private String filterName;
    private String filterType;
    private String expression;
    private String description;
    private Boolean isSystem;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
