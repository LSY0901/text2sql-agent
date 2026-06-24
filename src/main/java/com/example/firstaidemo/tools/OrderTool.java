package com.example.firstaidemo.tools;

import com.example.firstaidemo.models.entity.OrderEntity;
import com.example.firstaidemo.service.IOrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class OrderTool {

    private final IOrderService orderService;

    @Tool(description = "根据订单号查询订单状态")
    public String getOrderStatus(String orderNo) {
        OrderEntity order = orderService.getOrderByOrderNo(orderNo);
        if (order == null) {
            return "未找到订单";
        }
        return "订单号：" + orderNo +
                "，状态：" + order.getStatus();
    }



    @Tool(description = "根据订单号查询订单数量")
    public String getOrderQty(String orderNo) {
        OrderEntity order = orderService.getOrderByOrderNo(orderNo);
        if (order == null) {
            return "未找到订单";
        }
        return "订单号：" + orderNo +
                "，数量：" + order.getAmount();
    }



    @Tool(description = "根据订单号查询订单信息")
    public OrderEntity getOrderMessage(String orderNo) {
        return orderService.getOrderByOrderNo(orderNo);
    }


}
