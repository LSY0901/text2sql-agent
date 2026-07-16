package com.example.firstaidemo.semanticdsl.validator;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.*;
import com.example.firstaidemo.semanticdsl.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class SemanticDslValidator {

    private final IDslMetaDataService metaDataService;

    public ValidationResult validate(SemanticQueryDSL dsl, IntentResult.IntentType intent) {
        List<String> errors = new ArrayList<>();

        if (intent == IntentResult.IntentType.NON_BUSINESS) {
            return new ValidationResult(true, errors);
        }

        // 校验指标
        if (dsl.getMetric() != null && !dsl.getMetric().isEmpty()) {
            DslMetric metric = metaDataService.getMetricByCode(dsl.getMetric());
            if (metric == null) {
                errors.add("指标不存在: " + dsl.getMetric());
            } else if (dsl.getEntity() != null && !dsl.getEntity().equals(metric.getEntityCode())) {
                errors.add("实体与指标不匹配: 指标[" + dsl.getMetric() + "]属于实体[" + metric.getEntityCode()
                        + "]，但DSL中实体为[" + dsl.getEntity() + "]");
            }
        }

        // 校验维度
        if (dsl.getDimensions() != null) {
            Set<String> validDimensionCodes = new HashSet<>();
            for (DslDimension dim : metaDataService.getAllDimensions()) {
                validDimensionCodes.add(dim.getDimensionCode());
            }
            for (String dimCode : dsl.getDimensions()) {
                if (!validDimensionCodes.contains(dimCode)) {
                    errors.add("维度不存在: " + dimCode);
                }
            }
        }

        // 校验过滤条件
        if (dsl.getFilters() != null) {
            for (SemanticFilter filter : dsl.getFilters()) {
                DslDimension dim = metaDataService.getDimensionByCode(filter.getDimension());
                if (dim == null) {
                    errors.add("过滤维度不存在: " + filter.getDimension());
                    continue;
                }
                List<DslDimensionValue> values = metaDataService.getDimensionValuesByCodes(List.of(filter.getDimension()));
                boolean valueValid = values.stream().anyMatch(v -> v.getValueCode().equals(filter.getValue()));
                if (!valueValid) {
                    errors.add("过滤值不存在: dimension=" + filter.getDimension() + ", value=" + filter.getValue());
                }
            }
        }

        boolean valid = errors.isEmpty();
        log.info("DSL校验结果: valid={}, errors={}", valid, errors);
        return new ValidationResult(valid, errors);
    }

    public record ValidationResult(boolean valid, List<String> errors) {}
}
