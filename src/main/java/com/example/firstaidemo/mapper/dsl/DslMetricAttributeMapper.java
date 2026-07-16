package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetricAttribute;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslMetricAttributeMapper {
    List<DslMetricAttribute> selectByMetricCode(String metricCode);
    List<DslMetricAttribute> selectByMetricCodes(List<String> metricCodes);
}
