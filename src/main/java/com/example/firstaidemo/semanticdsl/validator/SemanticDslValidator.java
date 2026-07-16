package com.example.firstaidemo.semanticdsl.validator;

import com.example.firstaidemo.semanticdsl.metadata.IDslMetaDataService;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetricDimension;
import com.example.firstaidemo.semanticdsl.model.IntentResult;
import com.example.firstaidemo.semanticdsl.model.SemanticFilter;
import com.example.firstaidemo.semanticdsl.model.SemanticQueryDSL;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 语义 DSL 代码侧校验门禁。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SemanticDslValidator {

    private final IDslMetaDataService metaDataService;

    /**
     * 按意图类型校验语义 DSL 的合法性。
     *
     * @param dsl    语义 DSL
     * @param intent 意图类型
     * @return 校验结果
     */
    public ValidationResult validate(SemanticQueryDSL dsl, IntentResult.IntentType intent) {
        List<String> errors = new ArrayList<>();

        if (dsl == null) {
            return new ValidationResult(false, List.of("DSL为空"));
        }
        if (intent == IntentResult.IntentType.NON_BUSINESS) {
            return new ValidationResult(true, errors);
        }

        validateByIntent(dsl, intent, errors);
        validateMetricAndEntity(dsl, errors);
        validateDimensions(dsl, errors);
        warnMetricDimensionCompat(dsl);
        validateFilters(dsl, errors);

        boolean valid = errors.isEmpty();
        log.info("DSL校验结果: valid={}, errors={}", valid, errors);
        return new ValidationResult(valid, errors);
    }

    /**
     * 按意图强制必填字段。
     */
    private void validateByIntent(SemanticQueryDSL dsl, IntentResult.IntentType intent,
                                  List<String> errors) {
        switch (intent) {
            case METRIC_QUERY -> {
                if (isBlank(dsl.getMetric())) {
                    errors.add("METRIC_QUERY意图必须指定metric");
                }
            }
            case DIMENSION_ANALYSIS -> {
                if (isBlank(dsl.getMetric())) {
                    errors.add("DIMENSION_ANALYSIS意图必须指定metric");
                }
                if (dsl.getDimensions() == null || dsl.getDimensions().isEmpty()) {
                    errors.add("DIMENSION_ANALYSIS意图必须指定至少一个dimension");
                }
            }
            case DETAIL_QUERY -> {
                if (isBlank(dsl.getEntity())) {
                    errors.add("DETAIL_QUERY意图必须指定entity");
                }
            }
            default -> {
                // NON_BUSINESS 已在入口短路
            }
        }
    }

    /**
     * 校验指标存在性及与实体的归属关系。
     */
    private void validateMetricAndEntity(SemanticQueryDSL dsl, List<String> errors) {
        if (isBlank(dsl.getMetric())) {
            return;
        }
        DslMetric metric = metaDataService.getMetricByCode(dsl.getMetric());
        if (metric == null) {
            errors.add("指标不存在: " + dsl.getMetric());
            return;
        }
        if (dsl.getEntity() != null && !dsl.getEntity().equals(metric.getEntityCode())) {
            errors.add("实体与指标不匹配: 指标[" + dsl.getMetric() + "]属于实体["
                    + metric.getEntityCode() + "]，但DSL中实体为[" + dsl.getEntity() + "]");
        }
    }

    /**
     * 校验维度 code 是否存在。
     */
    private void validateDimensions(SemanticQueryDSL dsl, List<String> errors) {
        if (dsl.getDimensions() == null) {
            return;
        }
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

    /**
     * 校验指标与维度兼容性；元数据缺失时仅告警，不阻断。
     */
    private void warnMetricDimensionCompat(SemanticQueryDSL dsl) {
        if (isBlank(dsl.getMetric()) || dsl.getDimensions() == null) {
            return;
        }
        for (String dimCode : dsl.getDimensions()) {
            DslMetricDimension relation =
                    metaDataService.getMetricDimension(dsl.getMetric(), dimCode);
            if (relation == null) {
                log.warn("指标与维度可能不兼容或未配置: metric={}, dimension={}",
                        dsl.getMetric(), dimCode);
            }
        }
    }

    /**
     * 校验过滤条件的维度与维度值。
     */
    private void validateFilters(SemanticQueryDSL dsl, List<String> errors) {
        if (dsl.getFilters() == null) {
            return;
        }
        for (SemanticFilter filter : dsl.getFilters()) {
            DslDimension dim = metaDataService.getDimensionByCode(filter.getDimension());
            if (dim == null) {
                errors.add("过滤维度不存在: " + filter.getDimension());
                continue;
            }
            List<DslDimensionValue> values =
                    metaDataService.getDimensionValuesByCodes(List.of(filter.getDimension()));
            boolean valueValid = values.stream()
                    .anyMatch(v -> v.getValueCode().equals(filter.getValue()));
            if (!valueValid) {
                errors.add("过滤值不存在: dimension=" + filter.getDimension()
                        + ", value=" + filter.getValue());
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    /**
     * DSL 校验结果。
     */
    public record ValidationResult(boolean valid, List<String> errors) {}
}
