package com.example.firstaidemo.models.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;


@Data
@TableName("orders_price")
public class PriceEntity {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private BigDecimal price;
}


