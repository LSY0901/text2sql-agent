package com.example.firstaidemo.tools;

import com.alibaba.fastjson2.JSON;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class UpgradeSqlExecuteTool {

    private final JdbcTemplate jdbcTemplate;

    @Tool(description = """
        执行SQL查询。
        只能执行SELECT语句。
        输入参数必须是完整SQL。
        """)
    public String executeSql(String sql) {

        sql = cleanSql(sql);

        if (!sql.trim()
                .toLowerCase()
                .startsWith("select")) {

            throw new RuntimeException(
                    "只允许SELECT");
        }

        List<Map<String,Object>> result =
                jdbcTemplate.queryForList(sql);

        return JSON.toJSONString(result);
    }

    private String cleanSql(String sql){

        sql = sql.replace("```sql","");
        sql = sql.replace("```","");

        return sql.trim();
    }
}
