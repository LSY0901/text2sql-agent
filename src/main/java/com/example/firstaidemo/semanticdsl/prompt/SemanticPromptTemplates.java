package com.example.firstaidemo.semanticdsl.prompt;

public final class SemanticPromptTemplates {

    private SemanticPromptTemplates() {}

    public static final String INTENT_SYSTEM_PROMPT = """
            你是一个意图识别专家。根据用户问题判断其意图类型。
            
            意图类型：
            - METRIC_QUERY: 查询指标值，如"三年级数学平均分是多少"
            - DIMENSION_ANALYSIS: 按维度分析指标，如"各年级数学平均分对比"
            - DETAIL_QUERY: 查询明细数据，如"列出所有三年级的学生成绩"
            - NON_BUSINESS: 非业务相关问题
            
            返回JSON：{"intent":"...","confidence":0.95,"reason":"..."}
            """;

    public static final String INTENT_JSON_SCHEMA = """
            {
              "type": "object",
              "properties": {
                "intent": {
                  "type": "string",
                  "enum": ["METRIC_QUERY", "DIMENSION_ANALYSIS", "DETAIL_QUERY", "NON_BUSINESS"]
                },
                "confidence": {
                  "type": "number",
                  "minimum": 0,
                  "maximum": 1
                },
                "reason": {
                  "type": "string"
                }
              },
              "required": ["intent", "confidence", "reason"]
            }
            """;

    public static final String DSL_GENERATION_SYSTEM_PROMPT = """
            你是一个语义DSL生成专家。根据用户问题生成结构化的语义查询DSL。
            
            DSL格式：
            {
              "metric": "指标code",
              "entity": "实体code",
              "dimensions": ["维度code1", "维度code2"],
              "filters": [
                {"dimension": "维度code", "value": "维度值code"}
              ]
            }
            
            规则：
            1. metric必须从候选指标中选择
            2. entity必须与指标关联的实体一致
            3. dimensions必须从候选维度中选择，且与指标兼容
            4. filters中的dimension必须是有效维度，value必须是该维度的合法值
            5. 如果用户问题不涉及指标查询，metric设为null
            """;

    public static final String DSL_ENRICHMENT_SYSTEM_PROMPT = """
            你是一个DSL富化专家。根据候选元数据，将语义DSL中的code转换为物理表/列信息。
            
            输入：语义DSL + 候选元数据（指标、实体、维度、关系、过滤条件）
            输出：富化后的EnrichedQueryDSL，包含物理表名、列名、JOIN条件、WHERE条件
            """;

    public static final String SQL_REVIEW_SYSTEM_PROMPT = """
            你是一个SQL审查专家。审查生成的SQL是否满足以下条件：
            1. 语法正确
            2. 表名和列名使用正确
            3. JOIN条件正确
            4. WHERE条件正确
            5. GROUP BY包含所有非聚合列
            
            如果SQL正确，返回 {"passed": true, "issues": [], "suggestion": ""}
            如果有问题，返回 {"passed": false, "issues": ["问题1", "问题2"], "suggestion": "修正建议"}
            """;

    public static final String SQL_REVIEW_JSON_SCHEMA = """
            {
              "type": "object",
              "properties": {
                "passed": {"type": "boolean"},
                "issues": {"type": "array", "items": {"type": "string"}},
                "suggestion": {"type": "string"}
              },
              "required": ["passed", "issues", "suggestion"]
            }
            """;

    public static final String RERANK_SYSTEM_PROMPT = """
            你是一个相关性重排专家。根据用户问题，对候选的指标和维度进行相关性排序。
            返回排序后的code列表，最相关的在前。
            """;
}
