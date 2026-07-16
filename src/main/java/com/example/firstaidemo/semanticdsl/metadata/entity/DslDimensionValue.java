package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_dimension_value")
public class DslDimensionValue {
    private Integer id;
    private String dimensionCode;
    private String valueCode;
    private String valueName;
    private String physicalValue;
    private String description;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
