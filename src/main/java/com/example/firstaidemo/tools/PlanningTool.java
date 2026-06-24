package com.example.firstaidemo.tools;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class PlanningTool {

    private final ChatClient.Builder chatClientBuilder;


    @Tool(description = "根据输入问题和schema生成查询计划")
    public String planningPrompt(String question, String schema) {
        String prompt = """
                        你是资深数据分析师。
                        
                        根据用户问题和数据库Schema，
                        输出查询计划。
                        
                        要求：
                        1. 不生成SQL
                        2. 只输出步骤
                        3. 每一步简洁明确
                        
                        用户问题：
                        %s
                        
                        Schema:
                        %s
                        """
                .formatted(question, schema);
        return chatClientBuilder.build()
                .prompt(prompt)
                .call()
                .content();
    }

}
