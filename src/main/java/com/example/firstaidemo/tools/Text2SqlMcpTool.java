package com.example.firstaidemo.tools;

import com.example.firstaidemo.service.IText2SqlAgentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

/**
 * MCP Tool — 将 Text2SQL Agent 五阶段管线暴露为 MCP 工具
 * <p>
 * CatPaw / Claude Desktop / Cursor 等 MCP 客户端可通过 SSE 调用此工具，
 * 传入自然语言问题，获得数据库查询结果的中文自然语言回答。
 */
@Slf4j
@Component
public class Text2SqlMcpTool {

    private final IText2SqlAgentService text2SqlAgentService;

    /**
     * @Lazy 打断循环依赖：
     * chatClientBuilder → toolCallbackResolver → text2SqlToolCallbackProvider
     * → text2SqlMcpTool → text2SqlAgentServiceImpl → chatClientBuilder
     */
    public Text2SqlMcpTool(@Lazy IText2SqlAgentService text2SqlAgentService) {
        this.text2SqlAgentService = text2SqlAgentService;
    }

    @Tool(description = """
            自然语言查询数据库（Text2SQL）。
            输入用户的自然语言问题，自动执行五阶段管线：
            1. 向量搜索相关表 → 2. 加载列级元数据 → 3. LLM 生成 SQL
            4. 代码强制 Review 审查 → 5. 执行 SQL → 6. 返回中文自然语言回答。
            适用于：查询学生人数、订单统计、成绩分析等任何数据库相关问题。
            """)
    public String text2sql(
            @ToolParam(description = "用户的自然语言问题，例如：四年级有多少个学生？") String question
    ) {
        log.info("MCP text2sql 调用: question={}", question);
        return text2SqlAgentService.execute(question);
    }
}
