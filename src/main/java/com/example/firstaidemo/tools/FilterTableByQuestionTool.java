package com.example.firstaidemo.tools;


import com.example.firstaidemo.service.IMetaDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class FilterTableByQuestionTool {

    private final IMetaDataService metaDataService;

    private final ChatClient.Builder chatClientBuilder;

    @Tool(description = "根据用户问题过滤出符合要求的表")
    public List<String> filterTableByQuestion(String question,String tableNames) {
        String prompt = """
                用户问题：%s

                数据库中有以下表：
                %s

                请分析用户问题，从以上表中选择与该问题最相关的表（最多3张）。
                只返回表名，每行一个，不要任何额外文字。
                """
                .formatted(question, tableNames);
        String llmResponse = chatClientBuilder.build()
                .prompt(prompt)
                .call()
                .content();
        List<String> tablesAll = metaDataService.getTables();
        assert llmResponse != null;
        return llmResponse.lines()
                .map(String::trim)
                .filter(name -> !name.isEmpty())
                .filter(name -> tablesAll.contains(name.toLowerCase()))
                .toList();

    }

}
