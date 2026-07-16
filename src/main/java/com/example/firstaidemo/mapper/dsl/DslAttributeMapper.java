package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslAttribute;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslAttributeMapper {
    List<DslAttribute> selectByEntityCode(String entityCode);
    List<DslAttribute> selectByEntityCodes(List<String> entityCodes);
}
