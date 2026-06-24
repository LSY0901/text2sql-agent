package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.mapper.OrderMapper;
import com.example.firstaidemo.models.entity.OrderEntity;
import com.example.firstaidemo.service.IOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderServiceImpl implements IOrderService {

    @Autowired
    private OrderMapper orderMapper;


    @Override
    public OrderEntity getOrderById(Long id) {
        return orderMapper.selectById(id);
    }

    @Override
    public OrderEntity getOrderByOrderNo(String orderNo) {
        return orderMapper.getOrderByOrderNo(orderNo);
    }
}
