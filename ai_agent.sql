/**
  agent
│
├── dsl_entity                 实体定义
│
├── dsl_attribute              属性定义
│
├── dsl_relation               实体关系
│
├── dsl_metric                 指标定义
│
├── dsl_metric_attribute       指标字段依赖
│
├── dsl_dimension              查询维度
│
├── dsl_dimension_value        维度值
│
├── dsl_metric_dimension       指标维度约束
│
├── dsl_filter                 业务过滤规则
│
└── dsl_synonym                业务同义词
 */

/*==============================================================*/
/* table: dsl_entity                                             */
/*==============================================================*/
drop table if exists agent.dsl_entity;
drop sequence if exists agent.dsl_entity_id_seq;

create sequence agent.dsl_entity_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_entity_id_seq owner to agent_user;


create table agent.dsl_entity
(
    id              int4 not null default nextval('agent.dsl_entity_id_seq'::regclass),

    entity_code     varchar(64),

    entity_name     varchar(128),

    entity_type     varchar(32),

    physical_table  varchar(128),

    primary_key     varchar(64),

    description     varchar(500),

    embedding       vector(1024),

    is_deleted      bool default false,

    creator         varchar(64),

    created_dt      int8,

    last_editor     varchar(64),

    last_edited_dt  int8,

    constraint dsl_entity_pkey primary key(id)
);


alter table agent.dsl_entity owner to agent_user;


create index ix_dsl_entity_code
    on agent.dsl_entity(entity_code);


comment on table agent.dsl_entity
is 'DSL业务实体定义表，用于描述自然语言中的业务对象，例如学生、成绩、班级';


comment on column agent.dsl_entity.id
is '主键ID';


comment on column agent.dsl_entity.entity_code
is '实体编码，例如student、score';


comment on column agent.dsl_entity.entity_name
is '实体名称，例如学生、成绩';


comment on column agent.dsl_entity.entity_type
is '实体类型，例如ENTITY';


comment on column agent.dsl_entity.physical_table
is '对应数据库物理表名称';


comment on column agent.dsl_entity.primary_key
is '物理表主键字段';


comment on column agent.dsl_entity.description
is '实体业务描述，用于LLM理解实体含义';


comment on column agent.dsl_entity.embedding
is 'BGE-M3生成的1024维语义向量，用于实体语义检索';


comment on column agent.dsl_entity.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_entity.creator
is '创建人';


comment on column agent.dsl_entity.created_dt
is '创建时间戳';


comment on column agent.dsl_entity.last_editor
is '最后修改人';


comment on column agent.dsl_entity.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_entity
(
    entity_code,
    entity_name,
    entity_type,
    physical_table,
    primary_key,
    description,
    creator,
    created_dt
)
values
    (
        'grade',
        '年级',
        'ENTITY',
        'grade',
        'id',
        '学校年级实体，描述学生所属年级信息',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class',
        '班级',
        'ENTITY',
        'class',
        'id',
        '教学班级实体，描述学生所属班级信息',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student',
        '学生',
        'ENTITY',
        'student',
        'id',
        '学生基础信息实体，描述学生姓名、编号等基础资料',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'score',
        '成绩',
        'ENTITY',
        'score',
        'id',
        '学生考试成绩实体，保存各科考试成绩信息',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_attribute                                          */
/*==============================================================*/
drop table if exists agent.dsl_attribute;
drop sequence if exists agent.dsl_attribute_id_seq;

create sequence agent.dsl_attribute_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_attribute_id_seq owner to agent_user;


create table agent.dsl_attribute
(
    id                  int4 not null default nextval('agent.dsl_attribute_id_seq'::regclass),

    entity_code         varchar(64),

    attribute_code      varchar(64),

    attribute_name      varchar(128),

    physical_column     varchar(128),

    data_type           varchar(32),

    attribute_type      varchar(32),

    description         varchar(500),

    embedding           vector(1024),

    is_queryable        bool default true,

    is_aggregatable     bool default false,

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_attribute_pkey primary key(id)
);


alter table agent.dsl_attribute owner to agent_user;


create index ix_dsl_attribute_entity_code
    on agent.dsl_attribute(entity_code);


create index ix_dsl_attribute_code
    on agent.dsl_attribute(attribute_code);



comment on table agent.dsl_attribute
is 'DSL业务属性定义表，用于描述实体字段语义以及SQL字段映射';


comment on column agent.dsl_attribute.id
is '主键ID';


comment on column agent.dsl_attribute.entity_code
is '所属实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_attribute.attribute_code
is '属性编码，例如student_name、score_value';


comment on column agent.dsl_attribute.attribute_name
is '属性名称，例如学生姓名、成绩';


comment on column agent.dsl_attribute.physical_column
is '对应物理表字段名称';


comment on column agent.dsl_attribute.data_type
is '字段数据类型，例如varchar、int、decimal';


comment on column agent.dsl_attribute.attribute_type
is '属性类型，例如ATTRIBUTE普通属性、MEASURE度量属性';


comment on column agent.dsl_attribute.description
is '属性业务描述，用于LLM理解字段含义';


comment on column agent.dsl_attribute.embedding
is 'BGE-M3生成的1024维语义向量，用于字段语义检索';


comment on column agent.dsl_attribute.is_queryable
is '是否允许作为查询字段或过滤条件';


comment on column agent.dsl_attribute.is_aggregatable
is '是否支持聚合计算，例如AVG、SUM、MAX';


comment on column agent.dsl_attribute.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_attribute.creator
is '创建人';


comment on column agent.dsl_attribute.created_dt
is '创建时间戳';


comment on column agent.dsl_attribute.last_editor
is '最后修改人';


comment on column agent.dsl_attribute.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_attribute
(
    entity_code,
    attribute_code,
    attribute_name,
    physical_column,
    data_type,
    attribute_type,
    description,
    is_queryable,
    is_aggregatable,
    creator,
    created_dt
)
values
    (
        'grade',
        'grade_name',
        '年级名称',
        'grade_name',
        'varchar',
        'ATTRIBUTE',
        '学校年级名称，例如一年级、二年级、三年级',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class',
        'class_name',
        '班级名称',
        'class_name',
        'varchar',
        'ATTRIBUTE',
        '教学班级名称，例如一班、二班',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student',
        'student_no',
        '学生编号',
        'student_no',
        'varchar',
        'ATTRIBUTE',
        '学生唯一编号',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student',
        'student_name',
        '学生姓名',
        'student_name',
        'varchar',
        'ATTRIBUTE',
        '学生姓名信息，用于查询学生名称',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student',
        'gender',
        '性别',
        'gender',
        'varchar',
        'ATTRIBUTE',
        '学生性别信息',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'score',
        'subject',
        '科目',
        'subject',
        'varchar',
        'ATTRIBUTE',
        '考试科目信息，例如数学、语文、英语',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'score',
        'score_value',
        '成绩',
        'score_value',
        'decimal',
        'MEASURE',
        '学生考试分数，可用于平均值、最大值、最小值等聚合计算',
        true,
        true,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'score',
        'exam_time',
        '考试时间',
        'exam_time',
        'timestamp',
        'ATTRIBUTE',
        '学生考试发生时间',
        true,
        false,
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_relation                                           */
/*==============================================================*/
drop table if exists agent.dsl_relation;
drop sequence if exists agent.dsl_relation_id_seq;

create sequence agent.dsl_relation_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_relation_id_seq owner to agent_user;


create table agent.dsl_relation
(
    id                  int4 not null default nextval('agent.dsl_relation_id_seq'::regclass),

    relation_code       varchar(64),

    source_entity       varchar(64),

    target_entity       varchar(64),

    relation_type       varchar(32),

    join_type           varchar(32),

    join_condition      varchar(500),

    priority            int4 default 0,

    description         varchar(500),

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_relation_pkey primary key(id)
);


alter table agent.dsl_relation owner to agent_user;


create index ix_dsl_relation_source_entity
    on agent.dsl_relation(source_entity);


create index ix_dsl_relation_target_entity
    on agent.dsl_relation(target_entity);


create unique index uk_dsl_relation_code
    on agent.dsl_relation(relation_code);



comment on table agent.dsl_relation
is 'DSL实体关系定义表，用于描述业务实体之间关联关系以及SQL JOIN规则';


comment on column agent.dsl_relation.id
is '主键ID';


comment on column agent.dsl_relation.relation_code
is '关系编码，唯一标识实体之间关联关系';


comment on column agent.dsl_relation.source_entity
is '源实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_relation.target_entity
is '目标实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_relation.relation_type
is '实体关系类型，例如ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE';


comment on column agent.dsl_relation.join_type
is 'SQL连接类型，例如INNER JOIN、LEFT JOIN';


comment on column agent.dsl_relation.join_condition
is '实体关联条件，用于自动生成SQL JOIN语句';


comment on column agent.dsl_relation.priority
is '关系优先级，用于多条JOIN路径选择';


comment on column agent.dsl_relation.description
is '关系业务描述，用于LLM理解实体之间关系';


comment on column agent.dsl_relation.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_relation.creator
is '创建人';


comment on column agent.dsl_relation.created_dt
is '创建时间戳';


comment on column agent.dsl_relation.last_editor
is '最后修改人';


comment on column agent.dsl_relation.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_relation
(
    relation_code,
    source_entity,
    target_entity,
    relation_type,
    join_type,
    join_condition,
    priority,
    description,
    creator,
    created_dt
)
values
    (
        'student_class',
        'student',
        'class',
        'MANY_TO_ONE',
        'INNER JOIN',
        'student.class_id = class.id',
        100,
        '学生属于班级，一个班级包含多个学生',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class_grade',
        'class',
        'grade',
        'MANY_TO_ONE',
        'INNER JOIN',
        'class.grade_id = grade.id',
        100,
        '班级属于年级，一个年级包含多个班级',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_score',
        'student',
        'score',
        'ONE_TO_MANY',
        'LEFT JOIN',
        'student.id = score.student_id',
        100,
        '学生拥有多条考试成绩记录',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_metric                                             */
/*==============================================================*/
drop table if exists agent.dsl_metric;
drop sequence if exists agent.dsl_metric_id_seq;

create sequence agent.dsl_metric_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_metric_id_seq owner to agent_user;


create table agent.dsl_metric
(
    id                  int4 not null default nextval('agent.dsl_metric_id_seq'::regclass),

    metric_code         varchar(64),

    metric_name         varchar(128),

    metric_type         varchar(32),

    entity_code         varchar(64),

    aggregation_type    varchar(32),

    expression          varchar(1000),

    unit                varchar(32),

    precision_value     int4,

    result_type         varchar(32),

    description         varchar(500),

    embedding           vector(1024),

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_metric_pkey primary key(id)
);


alter table agent.dsl_metric owner to agent_user;


create unique index uk_dsl_metric_code
    on agent.dsl_metric(metric_code);


create index ix_dsl_metric_entity_code
    on agent.dsl_metric(entity_code);



comment on table agent.dsl_metric
is 'DSL业务指标定义表，用于描述自然语言中的业务指标、计算逻辑以及语义向量';


comment on column agent.dsl_metric.id
is '主键ID';


comment on column agent.dsl_metric.metric_code
is '指标编码，例如avg_score、student_count';


comment on column agent.dsl_metric.metric_name
is '指标名称，例如平均成绩、不及格率';


comment on column agent.dsl_metric.metric_type
is '指标业务类型，例如QUALITY、STATISTICS';


comment on column agent.dsl_metric.entity_code
is '指标所属业务实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_metric.aggregation_type
is '聚合类型，例如AVG、SUM、COUNT、MAX、MIN、RATE';


comment on column agent.dsl_metric.expression
is '指标计算表达式，用于生成SQL，例如AVG(score.score_value)';


comment on column agent.dsl_metric.unit
is '指标单位，例如分、%、人数';


comment on column agent.dsl_metric.precision_value
is '指标结果保留小数位数';


comment on column agent.dsl_metric.result_type
is '指标结果类型，例如NUMBER、PERCENT、INTEGER';


comment on column agent.dsl_metric.description
is '指标业务描述，用于LLM理解指标口径';


comment on column agent.dsl_metric.embedding
is 'BGE-M3生成的1024维语义向量，用于指标语义检索';


comment on column agent.dsl_metric.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_metric.creator
is '创建人';


comment on column agent.dsl_metric.created_dt
is '创建时间戳';


comment on column agent.dsl_metric.last_editor
is '最后修改人';


comment on column agent.dsl_metric.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_metric
(
    metric_code,
    metric_name,
    metric_type,
    entity_code,
    aggregation_type,
    expression,
    unit,
    precision_value,
    result_type,
    description,
    creator,
    created_dt
)
values
    (
        'avg_score',
        '平均成绩',
        'STATISTICS',
        'score',
        'AVG',
        'AVG(score.score_value)',
        '分',
        2,
        'NUMBER',
        '计算指定范围内学生考试成绩平均值，例如某年级平均成绩、某班平均成绩',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'max_score',
        '最高成绩',
        'STATISTICS',
        'score',
        'MAX',
        'MAX(score.score_value)',
        '分',
        0,
        'NUMBER',
        '查询指定范围内学生考试最高成绩',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'min_score',
        '最低成绩',
        'STATISTICS',
        'score',
        'MIN',
        'MIN(score.score_value)',
        '分',
        0,
        'NUMBER',
        '查询指定范围内学生考试最低成绩',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'sum_score',
        '成绩总分',
        'STATISTICS',
        'score',
        'SUM',
        'SUM(score.score_value)',
        '分',
        0,
        'NUMBER',
        '计算学生成绩累计总分',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_count',
        '学生数量',
        'STATISTICS',
        'student',
        'COUNT',
        'COUNT(DISTINCT student.id)',
        '人',
        0,
        'INTEGER',
        '统计满足查询条件的学生数量',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'fail_rate',
        '不及格率',
        'STATISTICS',
        'score',
        'RATE',
        'SUM(CASE WHEN score.score_value < 60 THEN 1 ELSE 0 END) / COUNT(*)',
        '%',
        2,
        'PERCENT',
        '统计考试成绩低于60分的数据占全部成绩比例',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_metric_attribute                                   */
/*==============================================================*/
drop table if exists agent.dsl_metric_attribute;
drop sequence if exists agent.dsl_metric_attribute_id_seq;

create sequence agent.dsl_metric_attribute_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_metric_attribute_id_seq owner to agent_user;


create table agent.dsl_metric_attribute
(
    id                  int4 not null default nextval('agent.dsl_metric_attribute_id_seq'::regclass),

    metric_code         varchar(64),

    entity_code         varchar(64),

    attribute_code      varchar(64),

    role_type           varchar(32),

    description         varchar(500),

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_metric_attribute_pkey primary key(id)
);


alter table agent.dsl_metric_attribute owner to agent_user;


create index ix_dsl_metric_attribute_metric_code
    on agent.dsl_metric_attribute(metric_code);


create index ix_dsl_metric_attribute_attribute_code
    on agent.dsl_metric_attribute(attribute_code);


create unique index uk_dsl_metric_attribute
    on agent.dsl_metric_attribute
        (
         metric_code,
         attribute_code
            );



comment on table agent.dsl_metric_attribute
is 'DSL指标属性依赖关系表，用于描述指标计算依赖的业务字段';


comment on column agent.dsl_metric_attribute.id
is '主键ID';


comment on column agent.dsl_metric_attribute.metric_code
is '指标编码，对应dsl_metric.metric_code';


comment on column agent.dsl_metric_attribute.entity_code
is '属性所属实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_metric_attribute.attribute_code
is '指标依赖属性编码，对应dsl_attribute.attribute_code';


comment on column agent.dsl_metric_attribute.role_type
is '字段角色类型，例如MEASURE计算字段、FILTER过滤字段、GROUP维度字段';


comment on column agent.dsl_metric_attribute.description
is '指标字段依赖说明';


comment on column agent.dsl_metric_attribute.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_metric_attribute.creator
is '创建人';


comment on column agent.dsl_metric_attribute.created_dt
is '创建时间戳';


comment on column agent.dsl_metric_attribute.last_editor
is '最后修改人';


comment on column agent.dsl_metric_attribute.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_metric_attribute
(
    metric_code,
    entity_code,
    attribute_code,
    role_type,
    description,
    creator,
    created_dt
)
values
    (
        'avg_score',
        'score',
        'score_value',
        'MEASURE',
        '平均成绩计算字段，使用score.score_value进行AVG聚合',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'max_score',
        'score',
        'score_value',
        'MEASURE',
        '最高成绩计算字段，使用score.score_value进行MAX聚合',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'min_score',
        'score',
        'score_value',
        'MEASURE',
        '最低成绩计算字段，使用score.score_value进行MIN聚合',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'sum_score',
        'score',
        'score_value',
        'MEASURE',
        '成绩总分计算字段，使用score.score_value进行SUM聚合',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'fail_rate',
        'score',
        'score_value',
        'MEASURE',
        '不及格率计算字段，根据score.score_value判断是否低于60分',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_count',
        'student',
        'id',
        'COUNT',
        '学生数量统计字段，根据student.id进行去重计数',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_dimension                                          */
/*==============================================================*/
drop table if exists agent.dsl_dimension;
drop sequence if exists agent.dsl_dimension_id_seq;

create sequence agent.dsl_dimension_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_dimension_id_seq owner to agent_user;


create table agent.dsl_dimension
(
    id                  int4 not null default nextval('agent.dsl_dimension_id_seq'::regclass),

    dimension_code      varchar(64),

    dimension_name      varchar(128),

    entity_code         varchar(64),

    attribute_code      varchar(64),

    dimension_type      varchar(32),

    physical_column     varchar(128),

    description         varchar(500),

    embedding           vector(1024),

    is_queryable        bool default true,

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_dimension_pkey primary key(id)
);


alter table agent.dsl_dimension owner to agent_user;


create unique index uk_dsl_dimension_code
    on agent.dsl_dimension(dimension_code);


create index ix_dsl_dimension_entity_code
    on agent.dsl_dimension(entity_code);



comment on table agent.dsl_dimension
is 'DSL查询维度定义表，用于描述业务分析中的分组维度，例如年级、班级、科目';


comment on column agent.dsl_dimension.id
is '主键ID';


comment on column agent.dsl_dimension.dimension_code
is '维度编码，例如grade、class、subject';


comment on column agent.dsl_dimension.dimension_name
is '维度名称，例如年级、班级、科目';


comment on column agent.dsl_dimension.entity_code
is '所属实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_dimension.attribute_code
is '对应属性编码，对应dsl_attribute.attribute_code';


comment on column agent.dsl_dimension.dimension_type
is '维度类型，例如ATTRIBUTE、ENUM';


comment on column agent.dsl_dimension.physical_column
is '对应数据库物理字段';


comment on column agent.dsl_dimension.description
is '维度业务描述，用于LLM理解维度含义';


comment on column agent.dsl_dimension.embedding
is 'BGE-M3生成的1024维语义向量，用于维度语义检索';


comment on column agent.dsl_dimension.is_queryable
is '是否允许作为查询分组维度';


comment on column agent.dsl_dimension.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_dimension.creator
is '创建人';


comment on column agent.dsl_dimension.created_dt
is '创建时间戳';


comment on column agent.dsl_dimension.last_editor
is '最后修改人';


comment on column agent.dsl_dimension.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_dimension
(
    dimension_code,
    dimension_name,
    entity_code,
    attribute_code,
    dimension_type,
    physical_column,
    description,
    creator,
    created_dt
)
values
    (
        'grade',
        '年级',
        'grade',
        'grade_name',
        'ATTRIBUTE',
        'grade_name',
        '按照学校年级进行数据分析，例如查询各年级平均成绩',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class',
        '班级',
        'class',
        'class_name',
        'ATTRIBUTE',
        'class_name',
        '按照班级进行数据分析，例如查询班级成绩排名',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'subject',
        '科目',
        'score',
        'subject',
        'ATTRIBUTE',
        'subject',
        '按照考试科目进行数据分析，例如查询数学平均成绩',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_dimension_value                                    */
/*==============================================================*/
drop table if exists agent.dsl_dimension_value;
drop sequence if exists agent.dsl_dimension_value_id_seq;

create sequence agent.dsl_dimension_value_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_dimension_value_id_seq owner to agent_user;


create table agent.dsl_dimension_value
(
    id                  int4 not null default nextval('agent.dsl_dimension_value_id_seq'::regclass),

    dimension_code      varchar(64),

    value_code          varchar(64),

    value_name          varchar(128),

    physical_value      varchar(128),

    description         varchar(500),

    embedding           vector(1024),

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_dimension_value_pkey primary key(id)
);


alter table agent.dsl_dimension_value owner to agent_user;


create index ix_dsl_dimension_value_dimension_code
    on agent.dsl_dimension_value(dimension_code);


create index ix_dsl_dimension_value_value_code
    on agent.dsl_dimension_value(value_code);



comment on table agent.dsl_dimension_value
is 'DSL维度值定义表，用于描述业务维度中的具体枚举值以及数据库映射';


comment on column agent.dsl_dimension_value.id
is '主键ID';


comment on column agent.dsl_dimension_value.dimension_code
is '维度编码，对应dsl_dimension.dimension_code';


comment on column agent.dsl_dimension_value.value_code
is '维度值编码，例如grade_1、math';


comment on column agent.dsl_dimension_value.value_name
is '维度值名称，例如一年级、数学';


comment on column agent.dsl_dimension_value.physical_value
is '数据库实际存储值';


comment on column agent.dsl_dimension_value.description
is '维度值业务描述';


comment on column agent.dsl_dimension_value.embedding
is 'BGE-M3生成的1024维语义向量，用于维度值语义检索';


comment on column agent.dsl_dimension_value.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_dimension_value.creator
is '创建人';


comment on column agent.dsl_dimension_value.created_dt
is '创建时间戳';


comment on column agent.dsl_dimension_value.last_editor
is '最后修改人';


comment on column agent.dsl_dimension_value.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_dimension_value
(
    dimension_code,
    value_code,
    value_name,
    physical_value,
    description,
    creator,
    created_dt
)
values
    (
        'grade',
        'grade_1',
        '一年级',
        '一年级',
        '学校年级维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'grade',
        'grade_2',
        '二年级',
        '二年级',
        '学校年级维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'grade',
        'grade_3',
        '三年级',
        '三年级',
        '学校年级维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class',
        'class_1',
        '一班',
        '一班',
        '班级维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'class',
        'class_2',
        '二班',
        '二班',
        '班级维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'subject',
        'math',
        '数学',
        '数学',
        '考试科目维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'subject',
        'chinese',
        '语文',
        '语文',
        '考试科目维度值',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'subject',
        'english',
        '英语',
        '英语',
        '考试科目维度值',
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_metric_dimension                                   */
/*==============================================================*/
drop table if exists agent.dsl_metric_dimension;
drop sequence if exists agent.dsl_metric_dimension_id_seq;

create sequence agent.dsl_metric_dimension_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_metric_dimension_id_seq owner to agent_user;


create table agent.dsl_metric_dimension
(
    id                  int4 not null default nextval('agent.dsl_metric_dimension_id_seq'::regclass),

    metric_code         varchar(64),

    dimension_code      varchar(64),

    relation_type       varchar(32),

    description         varchar(500),

    is_required         bool default false,

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_metric_dimension_pkey primary key(id)
);


alter table agent.dsl_metric_dimension owner to agent_user;


create index ix_dsl_metric_dimension_metric_code
    on agent.dsl_metric_dimension(metric_code);


create index ix_dsl_metric_dimension_dimension_code
    on agent.dsl_metric_dimension(dimension_code);


create unique index uk_dsl_metric_dimension
    on agent.dsl_metric_dimension
        (
         metric_code,
         dimension_code
            );



comment on table agent.dsl_metric_dimension
is 'DSL指标维度关系表，用于限制指标支持的分析维度，避免LLM生成非法组合';


comment on column agent.dsl_metric_dimension.id
is '主键ID';


comment on column agent.dsl_metric_dimension.metric_code
is '指标编码，对应dsl_metric.metric_code';


comment on column agent.dsl_metric_dimension.dimension_code
is '维度编码，对应dsl_dimension.dimension_code';


comment on column agent.dsl_metric_dimension.relation_type
is '指标维度关系类型，例如GROUP、FILTER';


comment on column agent.dsl_metric_dimension.description
is '指标支持该维度的业务说明';


comment on column agent.dsl_metric_dimension.is_required
is '是否必须指定该维度';


comment on column agent.dsl_metric_dimension.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_metric_dimension.creator
is '创建人';


comment on column agent.dsl_metric_dimension.created_dt
is '创建时间戳';


comment on column agent.dsl_metric_dimension.last_editor
is '最后修改人';


comment on column agent.dsl_metric_dimension.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_metric_dimension
(
    metric_code,
    dimension_code,
    relation_type,
    description,
    is_required,
    creator,
    created_dt
)
values
    (
        'avg_score',
        'grade',
        'GROUP',
        '平均成绩支持按照年级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'avg_score',
        'class',
        'GROUP',
        '平均成绩支持按照班级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'avg_score',
        'subject',
        'GROUP',
        '平均成绩支持按照考试科目进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'max_score',
        'grade',
        'GROUP',
        '最高成绩支持按照年级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'max_score',
        'class',
        'GROUP',
        '最高成绩支持按照班级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_count',
        'grade',
        'GROUP',
        '学生数量支持按照年级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_count',
        'class',
        'GROUP',
        '学生数量支持按照班级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'fail_rate',
        'grade',
        'GROUP',
        '不及格率支持按照年级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'fail_rate',
        'class',
        'GROUP',
        '不及格率支持按照班级进行统计分析',
        false,
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_filter                                             */
/*==============================================================*/
drop table if exists agent.dsl_filter;
drop sequence if exists agent.dsl_filter_id_seq;

create sequence agent.dsl_filter_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_filter_id_seq owner to agent_user;


create table agent.dsl_filter
(
    id                  int4 not null default nextval('agent.dsl_filter_id_seq'::regclass),

    filter_code         varchar(64),

    filter_name         varchar(128),

    entity_code         varchar(64),

    attribute_code      varchar(64),

    operator_type       varchar(32),

    expression          varchar(1000),

    description         varchar(500),

    is_system           bool default false,

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_filter_pkey primary key(id)
);


alter table agent.dsl_filter owner to agent_user;


create unique index uk_dsl_filter_code
    on agent.dsl_filter(filter_code);


create index ix_dsl_filter_entity_code
    on agent.dsl_filter(entity_code);



comment on table agent.dsl_filter
is 'DSL业务过滤规则定义表，用于描述固定业务条件和SQL过滤逻辑';


comment on column agent.dsl_filter.id
is '主键ID';


comment on column agent.dsl_filter.filter_code
is '过滤规则编码，例如valid_student、valid_score';


comment on column agent.dsl_filter.filter_name
is '过滤规则名称，例如有效学生、有效成绩';


comment on column agent.dsl_filter.entity_code
is '过滤所属实体编码，对应dsl_entity.entity_code';


comment on column agent.dsl_filter.attribute_code
is '过滤字段编码，对应dsl_attribute.attribute_code';


comment on column agent.dsl_filter.operator_type
is '操作符类型，例如EQ、GT、LT、BETWEEN';


comment on column agent.dsl_filter.expression
is '过滤SQL表达式，例如score.score_value >= 60';


comment on column agent.dsl_filter.description
is '过滤规则业务描述';


comment on column agent.dsl_filter.is_system
is '是否系统默认过滤规则';


comment on column agent.dsl_filter.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_filter.creator
is '创建人';


comment on column agent.dsl_filter.created_dt
is '创建时间戳';


comment on column agent.dsl_filter.last_editor
is '最后修改人';


comment on column agent.dsl_filter.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_filter
(
    filter_code,
    filter_name,
    entity_code,
    attribute_code,
    operator_type,
    expression,
    description,
    is_system,
    creator,
    created_dt
)
values
    (
        'valid_score',
        '有效成绩',
        'score',
        'score_value',
        'GT_EQ',
        'score.score_value >= 0',
        '过滤有效考试成绩，排除异常成绩数据',
        true,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'pass_score',
        '及格成绩',
        'score',
        'score_value',
        'GT_EQ',
        'score.score_value >= 60',
        '过滤成绩达到60分及以上的数据',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'fail_score',
        '不及格成绩',
        'score',
        'score_value',
        'LT',
        'score.score_value < 60',
        '过滤成绩低于60分的数据',
        false,
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        'student_exists',
        '有效学生',
        'student',
        'id',
        'IS_NOT_NULL',
        'student.id IS NOT NULL',
        '过滤有效学生数据',
        true,
        'agent',
        extract(epoch from now())::bigint
    );

/*==============================================================*/
/* table: dsl_synonym                                            */
/*==============================================================*/
drop table if exists agent.dsl_synonym;
drop sequence if exists agent.dsl_synonym_id_seq;

create sequence agent.dsl_synonym_id_seq
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence agent.dsl_synonym_id_seq owner to agent_user;


create table agent.dsl_synonym
(
    id                  int4 not null default nextval('agent.dsl_synonym_id_seq'::regclass),

    synonym_text        varchar(128),

    object_type         varchar(32),

    object_code         varchar(64),

    standard_name       varchar(128),

    description         varchar(500),

    embedding           vector(1024),

    is_deleted          bool default false,

    creator             varchar(64),

    created_dt          int8,

    last_editor         varchar(64),

    last_edited_dt      int8,

    constraint dsl_synonym_pkey primary key(id)
);


alter table agent.dsl_synonym owner to agent_user;


create index ix_dsl_synonym_text
    on agent.dsl_synonym(synonym_text);


create index ix_dsl_synonym_object_code
    on agent.dsl_synonym(object_code);



comment on table agent.dsl_synonym
is 'DSL业务同义词定义表，用于将用户自然语言表达映射到标准DSL对象';


comment on column agent.dsl_synonym.id
is '主键ID';


comment on column agent.dsl_synonym.synonym_text
is '用户可能输入的自然语言表达，例如均分、平均分';


comment on column agent.dsl_synonym.object_type
is '映射对象类型，例如ENTITY、ATTRIBUTE、METRIC、DIMENSION';


comment on column agent.dsl_synonym.object_code
is '映射目标编码，对应DSL对象编码';


comment on column agent.dsl_synonym.standard_name
is '标准业务名称';


comment on column agent.dsl_synonym.description
is '同义词业务说明';


comment on column agent.dsl_synonym.embedding
is 'BGE-M3生成的1024维语义向量，用于用户表达语义检索';


comment on column agent.dsl_synonym.is_deleted
is '逻辑删除标识';


comment on column agent.dsl_synonym.creator
is '创建人';


comment on column agent.dsl_synonym.created_dt
is '创建时间戳';


comment on column agent.dsl_synonym.last_editor
is '最后修改人';


comment on column agent.dsl_synonym.last_edited_dt
is '最后修改时间戳';



insert into agent.dsl_synonym
(
    synonym_text,
    object_type,
    object_code,
    standard_name,
    description,
    creator,
    created_dt
)
values
    (
        '平均分',
        'METRIC',
        'avg_score',
        '平均成绩',
        '用户表达平均成绩指标',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '均分',
        'METRIC',
        'avg_score',
        '平均成绩',
        '用户口语表达平均成绩指标',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '平均成绩',
        'METRIC',
        'avg_score',
        '平均成绩',
        '标准指标名称',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '最高分',
        'METRIC',
        'max_score',
        '最高成绩',
        '用户表达最高成绩指标',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '最低分',
        'METRIC',
        'min_score',
        '最低成绩',
        '用户表达最低成绩指标',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '人数',
        'METRIC',
        'student_count',
        '学生数量',
        '用户表达数量统计指标',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '学生',
        'ENTITY',
        'student',
        '学生',
        '用户表达学生实体',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '成绩',
        'ENTITY',
        'score',
        '成绩',
        '用户表达成绩实体',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '年级',
        'DIMENSION',
        'grade',
        '年级',
        '用户表达年级维度',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '班级',
        'DIMENSION',
        'class',
        '班级',
        '用户表达班级维度',
        'agent',
        extract(epoch from now())::bigint
    ),
    (
        '科目',
        'DIMENSION',
        'subject',
        '科目',
        '用户表达科目维度',
        'agent',
        extract(epoch from now())::bigint
    );