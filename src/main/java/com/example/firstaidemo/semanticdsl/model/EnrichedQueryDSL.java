package com.example.firstaidemo.semanticdsl.model;

import com.example.firstaidemo.semanticdsl.metadata.entity.DslRelation;
import lombok.Data;

import java.util.List;

@Data
public class EnrichedQueryDSL {
    private String mainEntity;
    private String mainPhysicalTable;
    private String mainPrimaryKey;
    private List<SelectColumn> selectColumns;
    private List<EnrichedJoin> joins;
    private List<WhereColumn> whereConditions;
    private List<String> groupBy;
    private Integer limit;

    @Data public static class SelectColumn { private String expression; private String alias; }
    @Data public static class EnrichedJoin { private String joinType; private String physicalTable; private String onCondition; private DslRelation sourceRelation; }
    @Data public static class WhereColumn { private String expression; private boolean systemFilter; }
}
