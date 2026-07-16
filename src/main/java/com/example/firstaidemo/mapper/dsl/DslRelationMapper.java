package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslRelation;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslRelationMapper {
    List<DslRelation> selectAll();
    List<DslRelation> selectByEntity(String entityCode);
}
