package com.example.firstaidemo.config;

import com.example.firstaidemo.tools.OrderTool;
import com.example.firstaidemo.tools.Text2SqlMcpTool;
import org.springframework.ai.support.ToolCallbacks;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MCP Server 工具注册
 * <p>
 * 核心原理：Spring AI MCP Server 自动配置（McpServerAutoConfiguration）会扫描容器中所有
 * {@link ToolCallbackProvider} Bean，把其中的 ToolCallback 收集起来，
 * 转换为 MCP SyncToolSpecification，最终通过 SSE 端点暴露给 MCP 客户端（如 CatPaw）。
 * <p>
 * 客户端连接流程：
 * 1. CatPaw 连接 GET /sse → 获得 sessionId
 * 2. CatPaw 发送 initialize → 协议版本协商
 * 3. CatPaw 发送 tools/list → 服务器返回所有注册的 ToolCallback
 * 4. CatPaw 根据工具描述决定何时调用哪个工具
 * <p>
 * 注册多个工具的两种方式：
 * <ul>
 *   <li>方式一：每个工具类注册为单独的 ToolCallbackProvider Bean（见 text2SqlToolCallbackProvider）</li>
 *   <li>方式二：多个工具类合并到一个 ToolCallbackProvider Bean 中（见 orderToolCallbackProvider）</li>
 * </ul>
 * 两种方式效果一样，MCP 客户端看到的是所有 Bean 的工具合集。
 */
@Configuration
public class McpServerConfig {

    /**
     * 方式一：单个工具类注册为一个 ToolCallbackProvider
     * CatPaw 会看到 text2sql 工具
     */
    @Bean
    public ToolCallbackProvider text2SqlToolCallbackProvider(Text2SqlMcpTool text2SqlMcpTool) {
        return () -> ToolCallbacks.from(text2SqlMcpTool);
    }

    /**
     * 方式二：同样注册另一个工具类
     * CatPaw 会看到 getOrderStatus、getOrderQty、getOrderMessage 三个工具
     * （因为 OrderTool 中有三个 @Tool 注解的方法）
     */
    @Bean
    public ToolCallbackProvider orderToolCallbackProvider(OrderTool orderTool) {
        return () -> ToolCallbacks.from(orderTool);
    }

    /**
     * 方式三（可选）：把多个工具类合并到一个 Provider 中
     * 以下示例等价于上面两个 Bean 的效果，只是写法不同：
     * <pre>{@code
     * @Bean
     * public ToolCallbackProvider allToolsProvider(Text2SqlMcpTool text2SqlMcpTool, OrderTool orderTool) {
     *     return () -> ToolCallbacks.from(text2SqlMcpTool, orderTool);
     * }
     * }</pre>
     * 注意：不要同时使用方式三和方式一/二，否则同一个工具会被注册两次。
     */
}
