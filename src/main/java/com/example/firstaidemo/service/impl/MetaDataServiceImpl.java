package com.example.firstaidemo.service.impl;

import com.example.firstaidemo.mapper.ColumnMetadataMapper;
import com.example.firstaidemo.mapper.TableMetadataMapper;
import com.example.firstaidemo.models.entity.ColumnMetadata;
import com.example.firstaidemo.models.entity.TableMetadata;
import com.example.firstaidemo.service.IMetaDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MetaDataServiceImpl implements IMetaDataService {

    private final TableMetadataMapper tableMetadataMapper;

    private final ColumnMetadataMapper columnMetadataMapper;

    @Override
    public List<String> getTables() {
        return tableMetadataMapper.selectAll().stream().map(TableMetadata::getTableName).collect(Collectors.toList());
    }

    @Override
    public String getTableNames() {
        List<TableMetadata> tables = tableMetadataMapper.selectAll();
        return tables.stream()
                .map(t -> """
                        表名:%s
                        表注释:%s
                        业务说明:%s
                        别名:%s
                        """
                        .formatted(
                                t.getTableName(),
                                t.getTableComment(),
                                t.getBusinessDesc(),
                                t.getTableAlias()
                        ))
                .collect(Collectors.joining("\n"));
    }

    @Override
    public String getColumnNames(List<String> tables) {
        List<ColumnMetadata> columns = columnMetadataMapper.selectAll(tables);
        return columns.stream()
                .map(c -> """
                    表名：%s
                    字段:%s
                    类型:%s
                    注释:%s
                    业务含义:%s
                    示例值:%s
                    """
                        .formatted(
                                c.getTableName(),
                                c.getColumnName(),
                                c.getColumnType(),
                                c.getColumnComment(),
                                c.getBusinessMeaning(),
                                c.getValueExamples()
                        ))
                .collect(Collectors.joining("\n"));
    }
}
