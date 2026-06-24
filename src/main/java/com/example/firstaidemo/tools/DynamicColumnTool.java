package com.example.firstaidemo.tools;

import com.example.firstaidemo.service.IMetaDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class DynamicColumnTool {


    private final IMetaDataService metaDataService;

    @Tool(description = "根据表名加载列级元数据。输入可以是单个表名或多个表名（逗号分隔）。返回列名、数据类型、注释和主键信息。")
    public String loadColumnMetadata(List<String> tableNames) {
        return metaDataService.getColumnNames(tableNames);
    }
}
