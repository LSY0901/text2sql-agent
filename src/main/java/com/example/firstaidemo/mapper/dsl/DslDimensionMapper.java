package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslDimensionMapper {
    List<DslDimension> selectAll();
    DslDimension selectByDimensionCode(String dimensionCode);
    List<DslDimension> selectByDimensionCodes(List<String> dimensionCodes);
    List<String> selectVectorSearch(@Param("vector") String vector, @Param("limit") int limit);

    /** 查询 embedding 为空的维度 */
    List<DslDimension> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
