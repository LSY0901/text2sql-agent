package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslFilter;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslFilterMapper {
    List<DslFilter> selectSystemFiltersByEntityCode(String entityCode);
    List<DslFilter> selectByEntityCode(String entityCode);

    /** 查询 embedding 为空的过滤条件 */
    List<DslFilter> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
