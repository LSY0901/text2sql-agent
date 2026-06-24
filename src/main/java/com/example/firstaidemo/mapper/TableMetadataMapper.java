package com.example.firstaidemo.mapper;

import com.example.firstaidemo.models.entity.TableMetadata;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TableMetadataMapper {

    List<TableMetadata> selectAll();

    /** 查询未生成 embedding 的已启用表（用于 seed） */
    List<TableMetadata> selectEnabledWithNullEmbedding();

    /** 按表名列表查询 */
    List<TableMetadata> selectByTableNames(@Param("tableNames") List<String> tableNames);

    /** 向量相似度搜索，返回最相关的 N 张表 */
    List<String> selectVectorSearch(@Param("vector") String vector, @Param("limit") int limit);

    /** 查询所有已启用表名（向量搜索为空时的 fallback） */
    List<String> selectEnabled();

    /** 更新单行 embedding */
    void updateEmbedding(@Param("id") Long id, @Param("vector") String vector);

    /** 重置所有表的 embedding 为 NULL */
    void resetAllEmbeddings();
}
