package com.example.firstaidemo.tools;

import com.example.firstaidemo.mapper.TableMetadataMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class RagTableSearchTool {

    private final EmbeddingModel embeddingModel;

    private final TableMetadataMapper tableMetadataMapper;

    @Tool(description = "根据用户问题，使用向量相似度在元数据表中搜索最相关的表，返回表名列表（每行一个表名）")
    public String searchRelevantTables(String question) {
        float[] questionVector = embeddingModel.embed(question);
        String vectorStr = toVectorStr(questionVector);

        List<String> tableNames = tableMetadataMapper.selectVectorSearch(vectorStr, 5);

        if (tableNames.isEmpty()) {
            tableNames = tableMetadataMapper.selectEnabled();
        }

        log.info("RAG 向量搜索选中表: {}", tableNames);
        return String.join("\n", tableNames);
    }

    private String toVectorStr(float[] vec) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < vec.length; i++) {
            if (i > 0) sb.append(',');
            sb.append(vec[i]);
        }
        sb.append(']');
        return sb.toString();
    }
}
