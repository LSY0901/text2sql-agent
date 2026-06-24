package com.example.firstaidemo.tools;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 数据库表结构工具
 */

@Component
@RequiredArgsConstructor
public class SchemaTool {

    private final JdbcTemplate jdbcTemplate;

    @Tool(description = "获取数据库结构。\n" +
            "        当需要生成SQL时必须先调用该工具。\n" +
            "        返回内容包含：\n" +
            "        表名、字段、注释、关联关系。")
    public String getDatabaseSchema() {

        String columnSql = """
                            SELECT
                                c.relname AS table_name,
                                COALESCE(obj_description(c.oid), '') AS table_comment,
                                a.attname AS column_name,
                                pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type,
                                COALESCE(col_description(a.attrelid, a.attnum), '') AS column_comment
                            FROM pg_attribute a
                            JOIN pg_class c
                                ON a.attrelid = c.oid
                            JOIN pg_namespace n
                                ON c.relnamespace = n.oid
                            WHERE a.attnum > 0
                              AND NOT a.attisdropped
                              AND n.nspname = 'agent'
                            ORDER BY c.relname, a.attnum
                            """;

        String pkSql = """
                        SELECT
                            tc.table_name,
                            kcu.column_name
                        FROM information_schema.table_constraints tc
                        JOIN information_schema.key_column_usage kcu
                             ON tc.constraint_name = kcu.constraint_name
                        WHERE tc.constraint_type = 'PRIMARY KEY'
                          AND tc.table_schema = 'agent'
                        """;
        String fkSql = """
                    SELECT
                        tc.table_name,
                        kcu.column_name,
                        ccu.table_name AS foreign_table_name,
                        ccu.column_name AS foreign_column_name
                    FROM information_schema.table_constraints tc
                    JOIN information_schema.key_column_usage kcu
                         ON tc.constraint_name = kcu.constraint_name
                    JOIN information_schema.constraint_column_usage ccu
                         ON ccu.constraint_name = tc.constraint_name
                    WHERE tc.constraint_type = 'FOREIGN KEY'
                      AND tc.table_schema = 'agent'
                    """;

        StringBuilder sb = new StringBuilder();

        sb.append("数据库结构:\n\n");

        List<Map<String, Object>> columns =
                jdbcTemplate.queryForList(columnSql);

        Map<String, List<Map<String, Object>>> tableMap =
                columns.stream()
                        .collect(Collectors.groupingBy(
                                x -> x.get("table_name").toString(),
                                LinkedHashMap::new,
                                Collectors.toList()
                        ));

        for (Map.Entry<String, List<Map<String, Object>>> entry : tableMap.entrySet()) {

            List<Map<String, Object>> cols = entry.getValue();

            sb.append("表:")
                    .append(entry.getKey())
                    .append("\n");

            sb.append("说明:")
                    .append(cols.get(0).get("table_comment"))
                    .append("\n\n");

            sb.append("字段:\n");

            for (Map<String, Object> col : cols) {

                sb.append("- ")
                        .append(col.get("column_name"))
                        .append(" ")
                        .append(col.get("data_type"))
                        .append(" (")
                        .append(col.get("column_comment"))
                        .append(")")
                        .append("\n");
            }

            sb.append("\n----------------------\n\n");
        }

        List<Map<String, Object>> fkList =
                jdbcTemplate.queryForList(fkSql);

        sb.append("关联关系:\n");

        for (Map<String, Object> fk : fkList) {

            sb.append(fk.get("table_name"))
                    .append(".")
                    .append(fk.get("column_name"))
                    .append(" -> ")
                    .append(fk.get("foreign_table_name"))
                    .append(".")
                    .append(fk.get("foreign_column_name"))
                    .append("\n");
        }

        return sb.toString();
    }
}
