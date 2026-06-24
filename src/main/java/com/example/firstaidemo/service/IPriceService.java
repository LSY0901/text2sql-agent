package com.example.firstaidemo.service;

import com.example.firstaidemo.models.entity.PriceEntity;

public interface IPriceService {

    PriceEntity getPriceByOrderId(Long orderId);

}
