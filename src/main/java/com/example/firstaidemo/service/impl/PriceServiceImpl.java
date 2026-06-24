package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.mapper.PriceMapper;
import com.example.firstaidemo.models.entity.PriceEntity;
import com.example.firstaidemo.service.IPriceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PriceServiceImpl implements IPriceService {

    final PriceMapper priceMapper;


    @Override
    public PriceEntity getPriceByOrderId(Long orderId) {
        return priceMapper.getPriceByOrderId(orderId);
    }
}
