package com.example.firstaidemo.service;

import com.example.firstaidemo.models.entity.OrderEntity;

public interface IOrderService {


    /**
     * 根据订单id查询订单
     * @param id
     * @return
     */
    OrderEntity getOrderById(Long id);


    /**
     * 根据订单号查询订单
     * @param orderNo
     * @return
     */
    OrderEntity getOrderByOrderNo(String orderNo);


}
