package com.example.firstaidemo.models.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;


@Data
@TableName("orders")
public class OrderEntity {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String orderNo;

    private String status;

    private BigDecimal amount;
}


