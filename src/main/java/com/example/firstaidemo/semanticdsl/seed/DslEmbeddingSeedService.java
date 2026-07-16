package com.example.firstaidemo.semanticdsl.seed;

import com.example.firstaidemo.mapper.dsl.DslAttributeMapper;
import com.example.firstaidemo.mapper.dsl.DslDimensionMapper;
import com.example.firstaidemo.mapper.dsl.DslDimensionValueMapper;
import com.example.firstaidemo.mapper.dsl.DslEntityMapper;
import com.example.firstaidemo.mapper.dsl.DslFilterMapper;
import com.example.firstaidemo.mapper.dsl.DslMetricMapper;
import com.example.firstaidemo.mapper.dsl.DslSynonymMapper;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslAttribute;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimension;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslDimensionValue;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslEntity;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslFilter;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslMetric;
import com.example.firstaidemo.semanticdsl.metadata.entity.DslSynonym;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.function.Supplier;

/**
 * 启动时为 DSL 元数据表中 embedding 为空的记录补全向量。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DslEmbeddingSeedService {

    private final EmbeddingModel embeddingModel;
    private final DslEntityMapper dslEntityMapper;
    private final DslAttributeMapper dslAttributeMapper;
    private final DslMetricMapper dslMetricMapper;
    private final DslDimensionMapper dslDimensionMapper;
    private final DslDimensionValueMapper dslDimensionValueMapper;
    private final DslFilterMapper dslFilterMapper;
    private final DslSynonymMapper dslSynonymMapper;

    /**
     * 项目启动时检查并补全各 DSL 表空 embedding。
     */
    @PostConstruct
    public void initDslEmbeddings() {
        log.info("━━━ DSL Embedding 初始化开始 ━━━");
        try {
            seedEntities();
            seedAttributes();
            seedMetrics();
            seedDimensions();
            seedDimensionValues();
            seedSynonyms();
            log.info("━━━ DSL Embedding 初始化完成 ━━━");
        } catch (Exception e) {
            // 启动不因种子失败而中断，后续检索可能降级
            log.error("DSL Embedding 初始化失败: {}", e.getMessage(), e);
        }
    }

    /**
     * dsl_entity: entity_name + description
     */
    private void seedEntities() {
        seedTable(
                "dsl_entity",
                dslEntityMapper::selectWithNullEmbedding,
                row -> joinText(row.getEntityName(), row.getDescription()),
                DslEntity::getId,
                dslEntityMapper::updateEmbedding
        );
    }

    /**
     * dsl_attribute: attribute_name + description + entity_name
     */
    private void seedAttributes() {
        seedTable(
                "dsl_attribute",
                dslAttributeMapper::selectWithNullEmbedding,
                row -> joinText(row.getAttributeName(), row.getDescription(), row.getEntityName()),
                DslAttribute::getId,
                dslAttributeMapper::updateEmbedding
        );
    }

    /**
     * dsl_metric: metric_name + metric_code + description + expression
     */
    private void seedMetrics() {
        seedTable(
                "dsl_metric",
                dslMetricMapper::selectWithNullEmbedding,
                row -> joinText(
                        row.getMetricName(),
                        row.getMetricCode(),
                        row.getDescription(),
                        row.getExpression()),
                DslMetric::getId,
                dslMetricMapper::updateEmbedding
        );
    }

    /**
     * dsl_dimension: dimension_name + description
     */
    private void seedDimensions() {
        seedTable(
                "dsl_dimension",
                dslDimensionMapper::selectWithNullEmbedding,
                row -> joinText(row.getDimensionName(), row.getDescription()),
                DslDimension::getId,
                dslDimensionMapper::updateEmbedding
        );
    }

    /**
     * dsl_dimension_value: value_name + dimension_name + description
     */
    private void seedDimensionValues() {
        seedTable(
                "dsl_dimension_value",
                dslDimensionValueMapper::selectWithNullEmbedding,
                row -> joinText(
                        row.getValueName(),
                        row.getDimensionName(),
                        row.getDescription()),
                DslDimensionValue::getId,
                dslDimensionValueMapper::updateEmbedding
        );
    }

    /**
     * dsl_synonym: synonym_text + standard_name + description
     */
    private void seedSynonyms() {
        seedTable(
                "dsl_synonym",
                dslSynonymMapper::selectWithNullEmbedding,
                row -> joinText(
                        row.getSynonymText(),
                        row.getStandardName(),
                        row.getDescription()),
                DslSynonym::getId,
                dslSynonymMapper::updateEmbedding
        );
    }

    /**
     * 通用种子逻辑：查空 embedding → 拼文本 → 生成向量 → 回写。
     *
     * @param tableName   表名（日志用）
     * @param loader      加载空 embedding 行
     * @param textBuilder 拼装 embedding 文本
     * @param idGetter    取主键
     * @param updater     回写向量
     */
    private <T> void seedTable(String tableName,
                               Supplier<List<T>> loader,
                               Function<T, String> textBuilder,
                               Function<T, Integer> idGetter,
                               BiConsumer<Integer, String> updater) {
        List<T> rows = loader.get();
        if (rows == null || rows.isEmpty()) {
            log.info("[{}] 无需补全 embedding", tableName);
            return;
        }
        int success = 0;
        for (T row : rows) {
            Integer id = idGetter.apply(row);
            String text = textBuilder.apply(row);
            if (text == null || text.isBlank()) {
                log.warn("[{}] id={} 文本为空，跳过", tableName, id);
                continue;
            }
            try {
                float[] vector = embeddingModel.embed(text);
                updater.accept(id, toVectorStr(vector));
                success++;
            } catch (Exception e) {
                log.warn("[{}] id={} 生成 embedding 失败: {}", tableName, id, e.getMessage());
            }
        }
        log.info("[{}] 已补全 embedding {}/{} 条", tableName, success, rows.size());
    }

    /**
     * 用空格拼接非空字段。
     */
    private String joinText(String... parts) {
        StringBuilder sb = new StringBuilder();
        for (String part : parts) {
            if (part == null || part.isBlank()) {
                continue;
            }
            if (sb.length() > 0) {
                sb.append(' ');
            }
            sb.append(part.trim());
        }
        return sb.toString();
    }

    /**
     * 将 float[] 转为 pgvector 文本格式: [x,x,x]
     */
    private String toVectorStr(float[] vec) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < vec.length; i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append(vec[i]);
        }
        sb.append(']');
        return sb.toString();
    }
}
