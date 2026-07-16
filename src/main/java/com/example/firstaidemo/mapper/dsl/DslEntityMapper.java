package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslEntityMapper {
    List<DslEntity> selectAll();
    DslEntity selectByEntityCode(String entityCode);
    List<DslEntity> selectByEntityCodes(List<String> entityCodes);

    /** 查询 embedding 为空的实体（用于启动种子） */
    List<DslEntity> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
