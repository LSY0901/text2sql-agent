package com.example.firstaidemo.tools;

import com.example.firstaidemo.service.ISqlGenerateService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class SqlGenerateTool {

    private final ISqlGenerateService sqlGenerateService;

    @Tool(description = "根据自然语言和Schema生成SQL")
    public String generateSql(String question,String schema){
        return sqlGenerateService.generateSql(
                question,
                schema
        );
    }


    @Tool(description = "根据Schema和查询计划生成SQL")
    public String generateSqlByPlan(String plan,String schema){
        return sqlGenerateService.generateSqlByPlan(
                plan,
                schema
        );
    }

    @Tool(description = "根据Schema和错误原因重新生成SQL")
    public String generateSqlByErrorReason(String errorReason,String schema){
        return sqlGenerateService.generateSqlByErrorReason(
                errorReason,
                schema
        );
    }
}
