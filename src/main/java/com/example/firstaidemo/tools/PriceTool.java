package com.example.firstaidemo.tools;

import com.example.firstaidemo.models.entity.PriceEntity;
import com.example.firstaidemo.service.IPriceService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PriceTool {

    private final IPriceService priceService;


    @Tool(description = "根据订单id 查询订单价格信息")
    public PriceEntity getPriceMessage(Long orderId) {
        return priceService.getPriceByOrderId(orderId);
    }

}
