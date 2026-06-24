package com.example.firstaidemo.models.entity;


import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("ai_table_metadata")
public class TableMetadata {

    private Long id;

    private String tableName;

    private String tableComment;

    private String businessDomain;

    private String businessDesc;

    private String tableAlias;

    private Boolean enabled;

    private Date createTime;

}
