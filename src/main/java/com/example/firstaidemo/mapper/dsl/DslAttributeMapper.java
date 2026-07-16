package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslAttribute;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslAttributeMapper {
    List<DslAttribute> selectByEntityCode(String entityCode);
    List<DslAttribute> selectByEntityCodes(List<String> entityCodes);

    /** 查询 embedding 为空的属性（含 entity_name） */
    List<DslAttribute> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
