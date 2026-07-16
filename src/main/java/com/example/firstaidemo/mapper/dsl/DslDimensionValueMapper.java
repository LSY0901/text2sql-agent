package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslDimensionValueMapper {
    List<DslDimensionValue> selectByDimensionCode(String dimensionCode);
    List<DslDimensionValue> selectByDimensionCodes(List<String> dimensionCodes);

    /** 查询 embedding 为空的维度值（含 dimension_name） */
    List<DslDimensionValue> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
