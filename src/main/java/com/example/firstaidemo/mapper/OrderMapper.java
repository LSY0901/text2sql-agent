package com.example.firstaidemo.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.firstaidemo.models.entity.OrderEntity;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<OrderEntity> {


    /**
     * 根据订单号查询订单
     * @param orderNo
     * @return
     */
    OrderEntity getOrderByOrderNo(String orderNo);
}
