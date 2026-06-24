package com.example.firstaidemo.mapper;

import com.example.firstaidemo.models.entity.ColumnMetadata;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ColumnMetadataMapper {

    List<ColumnMetadata> selectAll(@Param("tableNames") List<String> tableNames);

    /** 查询未生成 embedding 的已启用列（用于 seed） */
    List<ColumnMetadata> selectEnabledWithNullEmbedding();

    /** 更新单列 embedding */
    void updateEmbedding(@Param("id") Long id, @Param("vector") String vector);

    /** 重置所有列的 embedding 为 NULL */
    void resetAllEmbeddings();
}
