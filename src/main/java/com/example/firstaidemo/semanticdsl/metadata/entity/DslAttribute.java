package com.example.firstaidemo.semanticdsl.metadata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("dsl_attribute")
public class DslAttribute {
    private Integer id;
    private String entityCode;
    private String attributeCode;
    private String attributeName;
    private String physicalColumn;
    private String dataType;
    private String description;
    /** JOIN dsl_entity 得到，仅用于 embedding 文本拼接 */
    private String entityName;
    private Boolean isDeleted;
    private String creator;
    private Long createdDt;
    private String lastEditor;
    private Long lastEditedDt;
}
