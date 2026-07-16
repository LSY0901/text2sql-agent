package com.example.firstaidemo.semanticdsl.model;

import com.example.firstaidemo.semanticdsl.metadata.entity.*;
import lombok.Data;

import java.util.List;

@Data
public class DslCandidate {
    private List<DslMetric> metrics;
    private List<DslEntity> entities;
    private List<DslDimension> dimensions;
    private List<DslDimensionValue> dimensionValues;
    private List<DslSynonym> synonyms;
    private List<DslRelation> relations;
    private List<DslFilter> systemFilters;
    private List<DslAttribute> attributes;
}
