package com.example.firstaidemo.tools;

import com.example.firstaidemo.service.IMetaDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class DynamicSchemaTool {

    private final IMetaDataService metaDataService;


    @Tool(description = "查询数据库中metadata的所有表和注释")
    public String discoverRelevantTables() {
        return metaDataService.getTableNames();
    }
}
