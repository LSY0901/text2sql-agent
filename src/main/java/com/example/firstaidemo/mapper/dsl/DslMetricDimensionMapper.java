package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetricDimension;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DslMetricDimensionMapper {
    DslMetricDimension selectByMetricAndDimension(@org.apache.ibatis.annotations.Param("metricCode") String metricCode, @org.apache.ibatis.annotations.Param("dimensionCode") String dimensionCode);
    java.util.List<DslMetricDimension> selectByMetricCode(String metricCode);
}
