package com.example.firstaidemo.mapper.dsl;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslSynonym;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DslSynonymMapper {
    List<DslSynonym> selectAll();
    List<DslSynonym> selectBySynonymText(String synonymText);
    List<String> selectVectorSearch(@Param("vector") String vector, @Param("limit") int limit);

    /** 向量召回完整同义词行（含 object_type） */
    List<DslSynonym> selectVectorSearchRows(@Param("vector") String vector,
                                            @Param("limit") int limit);

    /** 查询 embedding 为空的同义词 */
    List<DslSynonym> selectWithNullEmbedding();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Integer id, @Param("vector") String vector);
}
