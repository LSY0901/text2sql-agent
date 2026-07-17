package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslMetricMapper {
    List<DslMetric> selectAll();

    DslMetric selectByMetricCode(String metricCode);

    List<DslMetric> selectByMetricCodes(List<String> metricCodes);

    List<String> selectVectorSearch(@Param("vector") String vector, @Param("limit") int limit);

    /**
     * 查询 embedding 为空的指标
     */
    List<DslMetric> selectWithNullEmbedding();

    /**
     * 更新单行 embedding
     */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
