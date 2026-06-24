package com.example.firstaidemo.mapper;

import com.example.firstaidemo.models.entity.PriceEntity;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PriceMapper {

    PriceEntity getPriceByOrderId(Long orderId);

}
