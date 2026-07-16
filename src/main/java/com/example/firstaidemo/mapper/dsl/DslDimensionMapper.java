package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslDimensionMapper {
    List<DslDimension> selectAll();
    DslDimension selectByDimensionCode(String dimensionCode);
    List<DslDimension> selectByDimensionCodes(List<String> dimensionCodes);
    List<String> selectVectorSearch(@org.apache.ibatis.annotations.Param("vector") String vector, @org.apache.ibatis.annotations.Param("limit") int limit);
}
