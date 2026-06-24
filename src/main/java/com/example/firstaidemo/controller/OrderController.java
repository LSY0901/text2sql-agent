package com.example.firstaidemo.controller;


import com.example.firstaidemo.models.entity.OrderEntity;
import com.example.firstaidemo.service.IOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private IOrderService orderService;


    @GetMapping("/getOrderById")
    public OrderEntity getOrderById(@RequestParam Long id) {
        return orderService.getOrderById(id);
    }


    @GetMapping("/getOrderByOrderNo")
    public OrderEntity getOrderByOrderNo(@RequestParam String orderNo) {
        return orderService.getOrderByOrderNo(orderNo);
    }




}
