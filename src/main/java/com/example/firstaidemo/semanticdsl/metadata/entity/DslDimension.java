package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_dimension")
public class DslDimension {
    private Integer id;
    private String dimensionCode;
    private String dimensionName;
    private String entityCode;
    private String attributeCode;
    private String dimensionType;
    private String physicalColumn;
    private String description;
    private Boolean isQueryable;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
