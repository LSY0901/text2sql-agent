package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslDimensionValueMapper {
    List<DslDimensionValue> selectByDimensionCode(String dimensionCode);
    List<DslDimensionValue> selectByDimensionCodes(List<String> dimensionCodes);
}
