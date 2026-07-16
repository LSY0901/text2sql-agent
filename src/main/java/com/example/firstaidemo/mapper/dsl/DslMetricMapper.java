package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslMetricMapper {
    List<DslMetric> selectAll();
    DslMetric selectByMetricCode(String metricCode);
    List<DslMetric> selectByMetricCodes(List<String> metricCodes);
    List<String> selectVectorSearch(@org.apache.ibatis.annotations.Param("vector") String vector, @org.apache.ibatis.annotations.Param("limit") int limit);
}
