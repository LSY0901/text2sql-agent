package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslSynonym;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DslSynonymMapper {
    List<DslSynonym> selectAll();
    List<DslSynonym> selectBySynonymText(String synonymText);
    List<String> selectVectorSearch(@org.apache.ibatis.annotations.Param("vector") String vector, @org.apache.ibatis.annotations.Param("limit") int limit);
}
