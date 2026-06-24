package com.example.firstaidemo.models.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("ai_column_metadata")
public class ColumnMetadata {

    private Long id;

    private String tableName;

    private String columnName;

    private String columnType;

    private String columnComment;

    private String businessMeaning;

    private String valueExamples;

    private Boolean enabled;

    private Date createTime;

}
