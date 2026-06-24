package com.example.firstaidemo.tools;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class SqlExecuteTool {

    private final JdbcTemplate jdbcTemplate;

    @Tool(description = "执行SQL查询。执行成功返回查询结果")
    public List<Map<String,Object>> executeSql(String sql) {
        if (sql.trim().toLowerCase().startsWith("insert")
        || sql.trim().toLowerCase().startsWith("update")
        || sql.trim().toLowerCase().startsWith("delete")) {
            return List.of(Map.of("error", "只允许SELECT语句，当前SQL不以SELECT开头", "sql", sql));
        }
        try {
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) {
            log.warn("SQL执行失败: {}", e.getMessage());
            throw new RuntimeException("SQL执行失败: " + e.getMessage());
        }
    }
}
