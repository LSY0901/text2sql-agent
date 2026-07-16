package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslFilter;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslFilterMapper {
    List<DslFilter> selectSystemFiltersByEntityCode(String entityCode);
    List<DslFilter> selectByEntityCode(String entityCode);
}
