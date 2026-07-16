package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslEntityMapper {
    List<DslEntity> selectAll();
    DslEntity selectByEntityCode(String entityCode);
    List<DslEntity> selectByEntityCodes(List<String> entityCodes);
}
