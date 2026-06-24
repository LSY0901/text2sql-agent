package com.example.firstaidemo.config;

import com.example.firstaidemo.tools.DynamicColumnTool;
import com.example.firstaidemo.tools.DynamicSchemaTool;
import com.example.firstaidemo.tools.PlanningTool;
import com.example.firstaidemo.tools.RagTableSearchTool;
import com.example.firstaidemo.tools.RerankTool;
import com.example.firstaidemo.tools.ReviewTool;
import com.example.firstaidemo.tools.SqlExecuteTool;
import com.example.firstaidemo.tools.SqlGenerateTool;
import org.springframework.ai.support.ToolCallbacks;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ToolConfig {

    @Bean
    public ToolCallback[] sqlTools(
            DynamicSchemaTool schemaTool,
            DynamicColumnTool columnTool,
            SqlExecuteTool executeTool) {

        return ToolCallbacks.from(
                schemaTool,
                columnTool,
                executeTool
        );
    }

    @Bean
    public ToolCallback[] rerankTools(
            RagTableSearchTool ragTableSearchTool,
            RerankTool rerankTool,
            DynamicColumnTool columnTool,
            SqlExecuteTool executeTool) {

        return ToolCallbacks.from(
                ragTableSearchTool,
                rerankTool,
                columnTool,
                executeTool
        );
    }

    @Bean
    public ToolCallback[] columnRerankTools(
            RagTableSearchTool ragTableSearchTool,
            DynamicColumnTool columnTool,
            RerankTool rerankTool,
            SqlExecuteTool executeTool) {

        return ToolCallbacks.from(
                ragTableSearchTool,
                columnTool,
                rerankTool,
                executeTool
        );
    }

    @Bean
    public ToolCallback[] ragTools(
            RagTableSearchTool ragTableSearchTool,
            DynamicColumnTool columnTool,
            SqlExecuteTool executeTool) {

        return ToolCallbacks.from(
                ragTableSearchTool,
                columnTool,
                executeTool
        );
    }

    /**
     * Planner 专用工具 — 只暴露 Schema 检索能力，
     * 不暴露 SQL 生成/Review/执行，由代码层在 Planner 完成后接管
     */
    @Bean
    public ToolCallback[] plannerTools(
            RagTableSearchTool ragTableSearchTool,
            DynamicColumnTool columnTool,
            RerankTool rerankTool) {

        return ToolCallbacks.from(
                ragTableSearchTool,
                columnTool,
                rerankTool
        );
    }

}
