CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_receive_order_hk_id_seq;
CREATE TABLE "wms_erp_task_receive_order_hk"
(
    "id"             int4 NOT NULL  DEFAULT nextval('wms_erp_task_receive_order_hk_id_seq'::regclass),
    "task_no"        varchar(64) COLLATE "pg_catalog"."default",
    "erp_org_code"   varchar(255) COLLATE "pg_catalog"."default",
    "task_status"    varchar(255) COLLATE "pg_catalog"."default",
    "delivery_date"  int8,
    "uom_code"       varchar(255) COLLATE "pg_catalog"."default",
    "total_qty"      numeric(11, 3) DEFAULT 0.000,
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL  DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL  DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL  DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_erp_task_receive_order_hk_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_erptaskreceiveorderhk_taskno ON wms_erp_task_receive_order_hk (task_no);
CREATE INDEX idx_erptaskreceiveorderhk_deliverydate ON wms_erp_task_receive_order_hk (delivery_date);
CREATE INDEX idx_erptaskreceiveorderhk_createddt ON wms_erp_task_receive_order_hk (created_dt);

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."erp_org_code" IS 'ERP组织编码（区分平台orgCode）';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."task_status" IS '任务状态（WMS_TASK_RECEIVE_STATUS）';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."delivery_date" IS '交货日期';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."total_qty" IS '总数量';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_receive_order_hk" IS 'ERP港料单任务表';


CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_receive_order_hk_detail_id_seq;

CREATE TABLE "wms_erp_task_receive_order_hk_detail"
(
    "id"                           int4 NOT NULL  DEFAULT nextval('wms_erp_task_receive_order_hk_detail_id_seq'::regclass),
    "erp_task_receive_order_hk_id" int4,
    "erp_item_id"                  varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                  varchar(64) COLLATE "pg_catalog"."default",
    "material_name"                varchar(64) COLLATE "pg_catalog"."default",
    "po_no"                        varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"                  varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"                  varchar(255) COLLATE "pg_catalog"."default",
    "uom_code"                     varchar(64) COLLATE "pg_catalog"."default",
    "qty"                          numeric(11, 3) DEFAULT 0.000,
    "carton_qty"                   numeric(11, 3) DEFAULT 0.000,
    "net_weight"                   numeric(11, 3) DEFAULT 0.000,
    "gross_weight"                 numeric(11, 3) DEFAULT 0.000,
    "weight_uom_code"              varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                     varchar(64) COLLATE "pg_catalog"."default",
    "remark"                       varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                   bool NOT NULL  DEFAULT false,
    "creator"                      varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                   int4 NOT NULL  DEFAULT 0,
    "created_dt"                   int8,
    "last_editor"                  varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"               int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"               int8,
    CONSTRAINT "wms_erp_task_receive_order_hk_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_erptaskreceiveorderhkdetail_erptaskreceiveorderhkid ON wms_erp_task_receive_order_hk_detail (erp_task_receive_order_hk_id);

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."erp_task_receive_order_hk_id" IS 'ERP港料单任务id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."erp_item_id" IS 'ERP明细行id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."po_no" IS '采购单号';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."vendor_code" IS '供应商编码';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."vendor_name" IS '供应商名称';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."qty" IS '数量';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."carton_qty" IS '箱数';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."net_weight" IS '净重';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."gross_weight" IS '毛重';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."weight_uom_code" IS '重量单位编码';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_receive_order_hk_detail"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_receive_order_hk_detail" IS 'ERP港料单任务物料明细表';






CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_inbound_receive_id_seq;
CREATE TABLE "wms_erp_task_inbound_receive"
(
    "id"                int4 NOT NULL  DEFAULT nextval('wms_erp_task_inbound_receive_id_seq'::regclass),
    "task_no"           varchar(64) COLLATE "pg_catalog"."default",
    "erp_org_code"      varchar(255) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "task_status"       varchar(255) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "inbound_bin"       varchar(64) COLLATE "pg_catalog"."default",
    "erp_hk_no"         varchar(64) COLLATE "pg_catalog"."default",
    "total_qty"         numeric(11, 3) DEFAULT 0.000,
    "warehouse_admin"   varchar(64) COLLATE "pg_catalog"."default",
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL  DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL  DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_erp_task_inbound_receive_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskinboundreceive_taskno ON wms_erp_task_inbound_receive (task_no);
CREATE INDEX idx_wmserptaskinboundreceive_inboundno ON wms_erp_task_inbound_receive (inbound_no);
CREATE INDEX idx_wmserptaskinboundreceive_createddt ON wms_erp_task_inbound_receive (created_dt);

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."erp_org_code" IS 'ERP组织编码（区分平台orgCode）';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."order_type" IS '单据类型，来自于WMS单据类型数据，交易方向为 INBOUND_RECEIVE';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."task_status" IS '任务状态，来自于字典（WMS_TASK_RECEIVE_INBOUND_STATUS）';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."inbound_warehouse" IS '入库仓库';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."inbound_bin" IS '入库储位';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."erp_hk_no" IS 'ERP港料单号';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."total_qty" IS '总数量';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."warehouse_admin" IS '仓库人员';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."inbound_no" IS '入库单号';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_inbound_receive" IS 'ERP收货入库任务表';




CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_inbound_receive_detail_id_seq;
CREATE TABLE "wms_erp_task_inbound_receive_detail"
(
    "id"                          int4 NOT NULL  DEFAULT nextval('wms_erp_task_inbound_receive_detail_id_seq'::regclass),
    "erp_task_inbound_receive_id" int4,
    "erp_item_id"                 varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                 varchar(64) COLLATE "pg_catalog"."default",
    "material_name"               varchar(64) COLLATE "pg_catalog"."default",
    "uom_code"                    varchar(64) COLLATE "pg_catalog"."default",
    "qty"                         numeric(11, 3) DEFAULT 0.000,
    "po_no"                       varchar(64) COLLATE "pg_catalog"."default",
    "inspection_no"               varchar(64) COLLATE "pg_catalog"."default",
    "inspection_date"             varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                    varchar(64) COLLATE "pg_catalog"."default",
    "remark"                      varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                  bool NOT NULL  DEFAULT false,
    "creator"                     varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                  int4 NOT NULL  DEFAULT 0,
    "created_dt"                  int8,
    "last_editor"                 varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"              int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"              int8,
    CONSTRAINT "wms_erp_task_inbound_receive_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskinboundreceivedetail_erptaskinboundreceiveid ON wms_erp_task_inbound_receive_detail (erp_task_inbound_receive_id);

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."erp_task_inbound_receive_id" IS 'ERP收货入库任务id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."erp_item_id" IS 'ERP明细行id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."qty" IS '数量';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."po_no" IS '采购单号';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."inspection_no" IS '检验单号';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."inspection_date" IS '检验日期';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_inbound_receive_detail"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_inbound_receive_detail" IS 'ERP收货入库物料表';






CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_inbound_material_id_seq;
CREATE TABLE "wms_erp_task_inbound_material"
(
    "id"                int4 NOT NULL  DEFAULT nextval('wms_erp_task_inbound_material_id_seq'::regclass),
    "task_no"           varchar(64) COLLATE "pg_catalog"."default",
    "erp_org_code"      varchar(255) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "task_status"       varchar(255) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "total_qty"         numeric(11, 3) DEFAULT 0.000,
    "warehouse_admin"   varchar(64) COLLATE "pg_catalog"."default",
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "wo_no"             varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL  DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL  DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_erp_task_inbound_material_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskinboundmaterial_taskno ON wms_erp_task_inbound_material (task_no);
CREATE INDEX idx_wmserptaskinboundmaterial_inboundno ON wms_erp_task_inbound_material (inbound_no);
CREATE INDEX idx_wmserptaskinboundmaterial_createddt ON wms_erp_task_inbound_material (created_dt);

COMMENT ON COLUMN "wms_erp_task_inbound_material"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."erp_org_code" IS 'ERP组织编码（区分平台orgCode）';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."order_type" IS '单据类型，来自于WMS单据类型数据，交易方向为 INBOUND_MATERIAL';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."task_status" IS '任务状态，来自于字典（WMS_TASK_MATERIAL_INBOUND_STATUS）';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."inbound_warehouse" IS '入库仓库';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."total_qty" IS '总数量';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."warehouse_admin" IS '仓库人员';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."inbound_no" IS '入库单号';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."wo_no" IS '工单号';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_inbound_material"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_inbound_material" IS 'ERP物料入库任务表';




CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_inbound_material_detail_id_seq;
CREATE TABLE "wms_erp_task_inbound_material_detail"
(
    "id"                           int4 NOT NULL  DEFAULT nextval('wms_erp_task_inbound_material_detail_id_seq'::regclass),
    "erp_task_inbound_material_id" int4,
    "erp_item_id"                  varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                  varchar(64) COLLATE "pg_catalog"."default",
    "material_name"                varchar(64) COLLATE "pg_catalog"."default",
    "uom_code"                     varchar(64) COLLATE "pg_catalog"."default",
    "qty"                          numeric(11, 3) DEFAULT 0.000,
    "org_code"                     varchar(64) COLLATE "pg_catalog"."default",
    "remark"                       varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                   bool NOT NULL  DEFAULT false,
    "creator"                      varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                   int4 NOT NULL  DEFAULT 0,
    "created_dt"                   int8,
    "last_editor"                  varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"               int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"               int8,
    CONSTRAINT "wms_erp_task_inbound_material_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskinboundmaterialdetail_erptaskinboundmaterialid ON wms_erp_task_inbound_material_detail (erp_task_inbound_material_id);

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."erp_task_inbound_material_id" IS 'ERP物料入库任务id';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."erp_item_id" IS 'ERP明细行id';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."qty" IS '数量';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_inbound_material_detail"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_inbound_material_detail" IS 'ERP物料入库物料表';





CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_outbound_pick_material_id_seq;
CREATE TABLE "wms_erp_task_outbound_pick_material"
(
    "id"                 int4 NOT NULL  DEFAULT nextval('wms_erp_task_outbound_pick_material_id_seq'::regclass),
    "task_no"            varchar(64) COLLATE "pg_catalog"."default",
    "erp_org_code"       varchar(255) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "task_status"        varchar(255) COLLATE "pg_catalog"."default",
    "outbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "total_qty"          numeric(11, 3) DEFAULT 0.000,
    "warehouse_admin"    varchar(64) COLLATE "pg_catalog"."default",
    "outbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "line_code"          varchar(64) COLLATE "pg_catalog"."default",
    "building"           varchar(64) COLLATE "pg_catalog"."default",
    "floor"              varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL  DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL  DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_erp_task_outbound_pick_material_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskoutboundpickmaterial_taskno ON wms_erp_task_outbound_pick_material (task_no);
CREATE INDEX idx_wmserptaskoutboundpickmaterial_inboundno ON wms_erp_task_outbound_pick_material (outbound_no);
CREATE INDEX idx_wmserptaskoutboundpickmaterial_createddt ON wms_erp_task_outbound_pick_material (created_dt);
CREATE INDEX idx_wmserptaskoutboundpickmaterial_linecode ON wms_erp_task_outbound_pick_material (line_code);
CREATE INDEX idx_wmserptaskoutboundpickmaterial_buildingfloor ON wms_erp_task_outbound_pick_material (building, floor);

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."erp_org_code" IS 'ERP组织编码（区分平台orgCode）';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."order_type" IS '单据类型，来自于WMS单据类型数据，交易方向为 INBOUND_MATERIAL';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."task_status" IS '任务状态，来自于字典（WMS_TASK_MATERIAL_INBOUND_STATUS）';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."outbound_warehouse" IS '出库仓库';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."total_qty" IS '总数量';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."warehouse_admin" IS '仓库人员';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."outbound_no" IS '出库单号';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."line_code" IS '线别编码';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."building" IS '楼栋';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."floor" IS '楼层';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_outbound_pick_material" IS 'ERP物料拣货任务表';




CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_outbound_pick_material_detail_id_seq;
CREATE TABLE "wms_erp_task_outbound_pick_material_detail"
(
    "id"                                 int4 NOT NULL  DEFAULT nextval('wms_erp_task_outbound_pick_material_detail_id_seq'::regclass),
    "erp_task_outbound_pick_material_id" int4,
    "erp_item_id"                        varchar(64) COLLATE "pg_catalog"."default",
    "wo_no"                              varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                        varchar(64) COLLATE "pg_catalog"."default",
    "material_name"                      varchar(64) COLLATE "pg_catalog"."default",
    "uom_code"                           varchar(64) COLLATE "pg_catalog"."default",
    "qty"                                numeric(11, 3) DEFAULT 0.000,
    "specify_dc_code"                    varchar(64) COLLATE "pg_catalog"."default",
    "specify_bin"                        varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                           varchar(64) COLLATE "pg_catalog"."default",
    "remark"                             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                         bool NOT NULL  DEFAULT false,
    "creator"                            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                         int4 NOT NULL  DEFAULT 0,
    "created_dt"                         int8,
    "last_editor"                        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"                     int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"                     int8,
    CONSTRAINT "wms_erp_task_outbound_pick_material_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskoutboundpickmaterialdetail_erptaskoutboundpickmaterialid ON wms_erp_task_outbound_pick_material_detail (erp_task_outbound_pick_material_id);

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."erp_task_outbound_pick_material_id" IS 'ERP物料拣货任务id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."erp_item_id" IS 'ERP明细行id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."wo_no" IS '工单号';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."qty" IS '数量';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."specify_dc_code" IS '指定DC Code（生成日期）';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."specify_bin" IS '指定储位';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_outbound_pick_material_detail"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_outbound_pick_material_detail" IS 'ERP物料拣货物料表';





CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_allocate_material_id_seq;
CREATE TABLE "wms_erp_task_allocate_material"
(
    "id"               int4 NOT NULL DEFAULT nextval('wms_erp_task_allocate_material_id_seq'::regclass),
    "task_no"          varchar(64) COLLATE "pg_catalog"."default",
    "erp_org_code"     varchar(255) COLLATE "pg_catalog"."default",
    "order_type"       varchar(64) COLLATE "pg_catalog"."default",
    "task_status"      varchar(255) COLLATE "pg_catalog"."default",
    "source_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "target_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_admin"  varchar(64) COLLATE "pg_catalog"."default",
    "allocate_no"      varchar(64) COLLATE "pg_catalog"."default",
    "org_code"         varchar(64) COLLATE "pg_catalog"."default",
    "remark"           varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"       bool NOT NULL DEFAULT false,
    "creator"          varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"       int4 NOT NULL DEFAULT 0,
    "created_dt"       int8,
    "last_editor"      varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"   int4 NOT NULL DEFAULT 0,
    "last_edited_dt"   int8,
    CONSTRAINT "wms_erp_task_allocate_material_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskallocatematerial_taskno ON wms_erp_task_allocate_material (task_no);
CREATE INDEX idx_wmserptaskallocatematerial_allocateno ON wms_erp_task_allocate_material (allocate_no);
CREATE INDEX idx_wmserptaskallocatematerial_createddt ON wms_erp_task_allocate_material (created_dt);

COMMENT ON COLUMN "wms_erp_task_allocate_material"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."erp_org_code" IS 'ERP组织编码（区分平台orgCode）';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."order_type" IS '单据类型，来自于WMS单据类型数据，交易方向为 ALLOCATE_MATERIAL';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."task_status" IS '任务状态，来自于字典（WMS_TASK_MATERIAL_ALLOCATE_STATUS）';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."source_warehouse" IS '来源仓库';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."target_warehouse" IS '目标仓库';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."warehouse_admin" IS '仓库人员';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."allocate_no" IS '调拨单号';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_allocate_material"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_allocate_material" IS 'ERP物料调拨任务表';




CREATE
SEQUENCE IF NOT EXISTS wms_erp_task_allocate_material_detail_id_seq;
CREATE TABLE "wms_erp_task_allocate_material_detail"
(
    "id"                            int4 NOT NULL  DEFAULT nextval('wms_erp_task_allocate_material_detail_id_seq'::regclass),
    "erp_task_allocate_material_id" int4,
    "erp_item_id"                   varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                   varchar(64) COLLATE "pg_catalog"."default",
    "material_name"                 varchar(64) COLLATE "pg_catalog"."default",
    "uom_code"                      varchar(64) COLLATE "pg_catalog"."default",
    "qty"                           numeric(11, 3) DEFAULT 0.000,
    "specify_dc_code"               varchar(64) COLLATE "pg_catalog"."default",
    "specify_bin"                   varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                      varchar(64) COLLATE "pg_catalog"."default",
    "remark"                        varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                    bool NOT NULL  DEFAULT false,
    "creator"                       varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                    int4 NOT NULL  DEFAULT 0,
    "created_dt"                    int8,
    "last_editor"                   varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"                int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"                int8,
    CONSTRAINT "wms_erp_task_allocate_material_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmserptaskallocatematerialdetail_erptaskallocatematerialid ON wms_erp_task_allocate_material_detail (erp_task_allocate_material_id);

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."id" IS '主键id';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."erp_task_allocate_material_id" IS 'ERP物料调拨任务id';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."erp_item_id" IS 'ERP明细行id';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."uom_code" IS '单位编码';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."qty" IS '数量';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."specify_dc_code" IS '指定DC Code（生成日期）';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."specify_bin" IS '指定储位';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."remark" IS '备注';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_erp_task_allocate_material_detail"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_erp_task_allocate_material_detail" IS 'ERP物料调拨物料表';






CREATE
SEQUENCE IF NOT EXISTS wms_agv_task_execute_id_seq;
CREATE TABLE "wms_agv_task_execute"
(
    "id"             int4 NOT NULL DEFAULT nextval('wms_agv_task_execute_id_seq'::regclass),
    "task_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_no"       varchar(64) COLLATE "pg_catalog"."default",
    "order_type"     varchar(64) COLLATE "pg_catalog"."default",
    "execute_status" varchar(64) COLLATE "pg_catalog"."default",
    "start_time"     int8,
    "end_time"       int8,
    "from_location"  varchar(64) COLLATE "pg_catalog"."default",
    "from_type"      varchar(64) COLLATE "pg_catalog"."default",
    "to_location"    varchar(64) COLLATE "pg_catalog"."default",
    "to_type"        varchar(64) COLLATE "pg_catalog"."default",
    "req_code"       varchar(64) COLLATE "pg_catalog"."default",
    "client_code"    varchar(64) COLLATE "pg_catalog"."default",
    "ctnr_typ"       varchar(64) COLLATE "pg_catalog"."default",
    "task_type"      varchar(64) COLLATE "pg_catalog"."default",
    "task_result"    varchar(2048) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_agv_task_execute_pkey" PRIMARY KEY ("id")
)
;

alter table "wms"."wms_agv_task_execute"
    owner to "cloudmes";

CREATE INDEX idx_wmsagvtaskexecute_taskno ON wms_agv_task_execute (task_no);
CREATE INDEX idx_wmsagvtaskexecute_orderno ON wms_agv_task_execute (order_no);
CREATE INDEX idx_wmsagvtaskexecute_startendtime ON wms_agv_task_execute (start_time, end_time);
CREATE INDEX idx_wmsagvtaskexecute_createddt ON wms_agv_task_execute (created_dt);

COMMENT ON COLUMN "wms_agv_task_execute"."id" IS '主键id';

COMMENT ON COLUMN "wms_agv_task_execute"."task_no" IS '任务单号';

COMMENT ON COLUMN "wms_agv_task_execute"."order_no" IS '单据单号';

COMMENT ON COLUMN "wms_agv_task_execute"."order_type" IS '单据类型，来自于WMS单据类型数据，交易方向为 ALLOCATE_MATERIAL';

COMMENT ON COLUMN "wms_agv_task_execute"."execute_status" IS '执行状态';

COMMENT ON COLUMN "wms_agv_task_execute"."start_time" IS '开始时间';

COMMENT ON COLUMN "wms_agv_task_execute"."end_time" IS '结束时间';

COMMENT ON COLUMN "wms_agv_task_execute"."from_location" IS '起点';

COMMENT ON COLUMN "wms_agv_task_execute"."from_type" IS '起点类型';

COMMENT ON COLUMN "wms_agv_task_execute"."to_location" IS '终点';

COMMENT ON COLUMN "wms_agv_task_execute"."to_type" IS '终点类型';

COMMENT ON COLUMN "wms_agv_task_execute"."req_code" IS 'agv请求编号';

COMMENT ON COLUMN "wms_agv_task_execute"."client_code" IS 'agv客户端编号';

COMMENT ON COLUMN "wms_agv_task_execute"."ctnr_typ" IS '容器类型（叉车/CTU专用） 叉车项目必传';

COMMENT ON COLUMN "wms_agv_task_execute"."task_type" IS 'agv任务类型';

COMMENT ON COLUMN "wms_agv_task_execute"."task_result" IS 'agv任务结果';

COMMENT ON COLUMN "wms_agv_task_execute"."org_code" IS '工厂组织';

COMMENT ON COLUMN "wms_agv_task_execute"."remark" IS '备注';

COMMENT ON COLUMN "wms_agv_task_execute"."is_deleted" IS '是否已删除，true：已删除 false：未删除';

COMMENT ON COLUMN "wms_agv_task_execute"."creator" IS '创建人code';

COMMENT ON COLUMN "wms_agv_task_execute"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms_agv_task_execute"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms_agv_task_execute"."last_editor" IS '修改人code';

COMMENT ON COLUMN "wms_agv_task_execute"."last_editor_id" IS '修改人id';

COMMENT ON COLUMN "wms_agv_task_execute"."last_edited_dt" IS '修改时间';

COMMENT ON TABLE "wms_agv_task_execute" IS 'AGV执行任务表';


/*==============================================================*/
/* 订单管理-order                                                 */
/*==============================================================*/
/*==============================================================*/
/* table: wms_po_order                                          */
/*==============================================================*/
drop table if exists wms.wms_po_order;
drop
sequence if exists  wms_po_order_seq;
create
sequence wms_po_order_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_po_order
(
    "id"             int4 not null default nextval('wms.wms_po_order_seq'::regclass),
    "po_no"          varchar(64) COLLATE "pg_catalog"."default",
    "po_type"        varchar(64) COLLATE "pg_catalog"."default",
    "type_name"      varchar(64) COLLATE "pg_catalog"."default",
    "status"         varchar(64) COLLATE "pg_catalog"."default",
    "po_date"        timestamp,
    "prepare_by"     varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"    varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_po_order_pkey" primary key ("id")
);


alter table "wms"."wms_po_order"
    owner to "cloudmes";


create index iX_wms_po_order_org_code on "wms"."wms_po_order" ("org_code");
create index iX_wms_po_order_is_deleted on "wms"."wms_po_order" ("is_deleted");
create index iX_wms_po_order_last_edited_dt on "wms"."wms_po_order" ("last_edited_dt");


comment on column "wms"."wms_po_order"."id" is '主键';
comment on column "wms"."wms_po_order"."po_no" is '采购单号';
comment on column "wms"."wms_po_order"."po_type" is '订单类型';
comment on column "wms"."wms_po_order"."type_name" is '类型名称';
comment on column "wms"."wms_po_order"."status" is '订单状态';
comment on column "wms"."wms_po_order"."po_date" is '采购日期';
comment on column "wms"."wms_po_order"."prepare_by" is '制单人';
comment on column "wms"."wms_po_order"."vendor_code" is '供应商编码';
comment on column "wms"."wms_po_order"."vendor_name" is '供应商名称';
comment on column "wms"."wms_po_order"."org_code" is '组织编码';
comment on column "wms"."wms_po_order"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_po_order"."deleted_dt" is '删除时间';
comment on column "wms"."wms_po_order"."creator" is '创建人';
comment on column "wms"."wms_po_order"."creator_id" is '创建人id';
comment on column "wms"."wms_po_order"."created_dt" is '创建时间';
comment on column "wms"."wms_po_order"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_po_order"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_po_order"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_po_order" is '采购订单表';



/*==============================================================*/
/* table: wms_po_order_detail                                   */
/*==============================================================*/
drop table if exists wms.wms_po_order_detail;
drop
sequence if exists  wms_po_order_detail_seq;
create
sequence wms_po_order_detail_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_po_order_detail
(
    "id"             int4 not null default nextval('wms.wms_po_order_detail_seq'::regclass),
    "main_id"        int4,
    "item"           varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "line_status"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(64) COLLATE "pg_catalog"."default",
    "unit"           varchar(64) COLLATE "pg_catalog"."default",
    "qty"            numeric(10, 0),
    "submit_qty"     numeric(10, 0),
    "un_submit_qty"  numeric(10, 0),
    "return_qty"     numeric(10, 0),
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_po_order_detail_pkey" primary key ("id")
);


alter table "wms"."wms_po_order_detail"
    owner to "cloudmes";


create index iX_wms_po_order_detail_org_code on "wms"."wms_po_order_detail" ("org_code");
create index iX_wms_po_order_detail_main_id on "wms"."wms_po_order_detail" ("main_id");
create index iX_wms_po_order_detail_is_deleted on "wms"."wms_po_order_detail" ("is_deleted");
create index iX_wms_po_order_detail_last_edited_dt on "wms"."wms_po_order_detail" ("last_edited_dt");


comment on column "wms"."wms_po_order_detail"."id" is '主键';
comment on column "wms"."wms_po_order_detail"."main_id" is '外键';
comment on column "wms"."wms_po_order_detail"."item" is '项次';
comment on column "wms"."wms_po_order_detail"."material_no" is '物料编码';
comment on column "wms"."wms_po_order_detail"."line_status" is '行状态';
comment on column "wms"."wms_po_order_detail"."material_name" is '物料名称';
comment on column "wms"."wms_po_order_detail"."unit" is '单位';
comment on column "wms"."wms_po_order_detail"."qty" is '采购数量';
comment on column "wms"."wms_po_order_detail"."submit_qty" is '已交数量';
comment on column "wms"."wms_po_order_detail"."un_submit_qty" is '未交数量';
comment on column "wms"."wms_po_order_detail"."return_qty" is '退货数量';
comment on column "wms"."wms_po_order_detail"."org_code" is '组织编码';
comment on column "wms"."wms_po_order_detail"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_po_order_detail"."deleted_dt" is '删除时间';
comment on column "wms"."wms_po_order_detail"."creator" is '创建人';
comment on column "wms"."wms_po_order_detail"."creator_id" is '创建人id';
comment on column "wms"."wms_po_order_detail"."created_dt" is '创建时间';
comment on column "wms"."wms_po_order_detail"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_po_order_detail"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_po_order_detail"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_po_order_detail" is '采购订单物料明细表';

/*==============================================================*/
/* 收获管理-receive                                              */
/*==============================================================*/
/*==============================================================*/
/* table: wms_erp_receive_order_hk                              */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_order_hk;
drop
sequence if exists  wms_erp_receive_order_hk_seq;
create
sequence wms_erp_receive_order_hk_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_order_hk
(
    "id"                int4 not null default nextval('wms.wms_erp_receive_order_hk_seq'::regclass),
    "receive_no"        varchar(64) COLLATE "pg_catalog"."default",
    "prot_no"           varchar(64) COLLATE "pg_catalog"."default",
    "receive_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "status"            varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"        bool          DEFAULT false,
    "deleted_dt"        int8,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    constraint "wms_erp_receive_order_hk_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_order_hk"
    owner to "cloudmes";


create index iX_wms_erp_receive_order_hk_org_code on "wms"."wms_erp_receive_order_hk" ("org_code");
create index iX_wms_erp_receive_order_hk_is_deleted on "wms"."wms_erp_receive_order_hk" ("is_deleted");
create index iX_wms_erp_receive_order_hk_last_edited_dt on "wms"."wms_erp_receive_order_hk" ("last_edited_dt");


comment on column "wms"."wms_erp_receive_order_hk"."id" is '主键';
comment on column "wms"."wms_erp_receive_order_hk"."receive_no" is '收获单号';
comment on column "wms"."wms_erp_receive_order_hk"."prot_no" is '港料单号';
comment on column "wms"."wms_erp_receive_order_hk"."receive_warehouse" is '收获仓库';
comment on column "wms"."wms_erp_receive_order_hk"."status" is '状态';
comment on column "wms"."wms_erp_receive_order_hk"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_order_hk"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_order_hk"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_order_hk"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_order_hk"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_order_hk"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_order_hk"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_order_hk"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_order_hk"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_order_hk" is 'ERP收收货单物料表';



/*==============================================================*/
/* table: wms_erp_receive_order_hk_detail                       */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_order_hk_detail;
drop
sequence if exists  wms_erp_receive_order_hk_detail_seq;
create
sequence wms_erp_receive_order_hk_detail_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_order_hk_detail
(
    "id"             int4 not null default nextval('wms.wms_erp_receive_order_hk_detail_seq'::regclass),
    "main_id"        int4,
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(64) COLLATE "pg_catalog"."default",
    "receive_qty"    numeric(10, 0),
    "po_no"          varchar(64) COLLATE "pg_catalog"."default",
    "inspect_no"     varchar(64) COLLATE "pg_catalog"."default",
    "result"         varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_erp_receive_order_hk_detail_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_order_hk_detail"
    owner to "cloudmes";


create index iX_wms_erp_receive_order_hk_detail_org_code on "wms"."wms_erp_receive_order_hk_detail" ("org_code");
create index iX_wms_erp_receive_order_hk_detail_main_id on "wms"."wms_erp_receive_order_hk_detail" ("main_id");
create index iX_wms_erp_receive_order_hk_detail_is_deleted on "wms"."wms_erp_receive_order_hk_detail" ("is_deleted");
create index iX_wms_erp_receive_order_hk_detail_last_edited_dt on "wms"."wms_erp_receive_order_hk_detail" ("last_edited_dt");


comment on column "wms"."wms_erp_receive_order_hk_detail"."id" is '主键';
comment on column "wms"."wms_erp_receive_order_hk_detail"."main_id" is '外键';
comment on column "wms"."wms_erp_receive_order_hk_detail"."material_no" is '物料编码';
comment on column "wms"."wms_erp_receive_order_hk_detail"."material_name" is '物料名称';
comment on column "wms"."wms_erp_receive_order_hk_detail"."receive_qty" is '收获数量';
comment on column "wms"."wms_erp_receive_order_hk_detail"."po_no" is '采购单号';
comment on column "wms"."wms_erp_receive_order_hk_detail"."inspect_no" is '检验单号';
comment on column "wms"."wms_erp_receive_order_hk_detail"."result" is '结果';
comment on column "wms"."wms_erp_receive_order_hk_detail"."remark" is '备注';
comment on column "wms"."wms_erp_receive_order_hk_detail"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_order_hk_detail"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_order_hk_detail"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_order_hk_detail"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_order_hk_detail"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_order_hk_detail"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_order_hk_detail"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_order_hk_detail"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_order_hk_detail"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_order_hk_detail" is 'ERP收收货单物料明细表';


/*==============================================================*/
/* table: wms_erp_receive_order_label                           */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_order_label;
drop
sequence if exists  wms_erp_receive_order_label_seq;
create
sequence wms_erp_receive_order_label_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_order_label
(
    "id"             int4 not null default nextval('wms.wms_erp_receive_order_label_seq'::regclass),
    "main_id"        int4,
    "label_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "qty"            numeric(10, 0),
    "vendor_code"    varchar(64) COLLATE "pg_catalog"."default",
    "date_code"      varchar(64) COLLATE "pg_catalog"."default",
    "label_content"  varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_erp_receive_order_label_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_order_label"
    owner to "cloudmes";


create index iX_wms_erp_receive_order_label_org_code on "wms"."wms_erp_receive_order_label" ("org_code");
create index iX_wms_erp_receive_order_label_detail_main_id on "wms"."wms_erp_receive_order_label" ("main_id");
create index iX_wms_erp_receive_order_label_is_deleted on "wms"."wms_erp_receive_order_label" ("is_deleted");
create index iX_wms_erp_receive_order_label_last_edited_dt on "wms"."wms_erp_receive_order_label" ("last_edited_dt");



comment on column "wms"."wms_erp_receive_order_label"."id" is '主键';
comment on column "wms"."wms_erp_receive_order_label"."main_id" is '外键';
comment on column "wms"."wms_erp_receive_order_label"."label_no" is '条码号';
comment on column "wms"."wms_erp_receive_order_label"."material_no" is '物料编码';
comment on column "wms"."wms_erp_receive_order_label"."qty" is '数量';
comment on column "wms"."wms_erp_receive_order_label"."vendor_code" is '供应商编码';
comment on column "wms"."wms_erp_receive_order_label"."date_code" is 'D/C编码';
comment on column "wms"."wms_erp_receive_order_label"."label_content" is '条码内容';
comment on column "wms"."wms_erp_receive_order_label"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_order_label"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_order_label"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_order_label"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_order_label"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_order_label"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_order_label"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_order_label"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_order_label"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_order_label" is ' 收货物料条码信息';




/*==============================================================*/
/* table: wms_erp_receive_abnormal_order                        */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_abnormal_order;
drop
sequence if exists  wms_erp_receive_abnormal_order_seq;
create
sequence wms_erp_receive_abnormal_order_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_abnormal_order
(
    "id"                int4 not null default nextval('wms.wms_erp_receive_abnormal_order_seq'::regclass),
    "abnormal_no"       varchar(64) COLLATE "pg_catalog"."default",
    "receive_no"        varchar(64) COLLATE "pg_catalog"."default",
    "receive_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "material_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_name"     varchar(64) COLLATE "pg_catalog"."default",
    "receive_qty"       numeric(10, 0),
    "po_no"             varchar(64) COLLATE "pg_catalog"."default",
    "inspect_no"        varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"        bool          DEFAULT false,
    "deleted_dt"        int8,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    constraint "wms_erp_receive_abnormal_order_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_abnormal_order"
    owner to "cloudmes";


create index iX_wms_erp_receive_abnormal_order_org_code on "wms"."wms_erp_receive_abnormal_order" ("org_code");
create index iX_wms_erp_receive_abnormal_order_is_deleted on "wms"."wms_erp_receive_abnormal_order" ("is_deleted");
create index iX_wms_erp_receive_abnormal_order_last_edited_dt on "wms"."wms_erp_receive_abnormal_order" ("last_edited_dt");



comment on column "wms"."wms_erp_receive_abnormal_order"."id" is '主键';
comment on column "wms"."wms_erp_receive_abnormal_order"."abnormal_no" is '异常单号';
comment on column "wms"."wms_erp_receive_abnormal_order"."receive_no" is '收货单号';
comment on column "wms"."wms_erp_receive_abnormal_order"."receive_warehouse" is '收获仓库';
comment on column "wms"."wms_erp_receive_abnormal_order"."material_no" is '物料编码';
comment on column "wms"."wms_erp_receive_abnormal_order"."material_name" is '物料名称';
comment on column "wms"."wms_erp_receive_abnormal_order"."receive_qty" is '收获数量';
comment on column "wms"."wms_erp_receive_abnormal_order"."po_no" is '采购单号';
comment on column "wms"."wms_erp_receive_abnormal_order"."inspect_no" is '检验单号';
comment on column "wms"."wms_erp_receive_abnormal_order"."remark" is '备注';
comment on column "wms"."wms_erp_receive_abnormal_order"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_abnormal_order"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_abnormal_order"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_abnormal_order"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_abnormal_order"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_abnormal_order"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_abnormal_order"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_abnormal_order"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_abnormal_order"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_abnormal_order" is ' ERP收货异常单表';



/*==============================================================*/
/* table: wms_erp_receive_standard                              */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_standard;
drop
sequence if exists  wms_erp_receive_standard_seq;
create
sequence wms_erp_receive_standard_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_standard
(
    "id"                int4 not null default nextval('wms.wms_erp_receive_standard_seq'::regclass),
    "receive_no"        varchar(64) COLLATE "pg_catalog"."default",
    "receive_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "status"            varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"        bool          DEFAULT false,
    "deleted_dt"        int8,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    constraint "wms_erp_receive_standard_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_standard"
    owner to "cloudmes";


create index iX_wms_erp_receive_standard_org_code on "wms"."wms_erp_receive_standard" ("org_code");
create index iX_wms_erp_receive_standard_is_deleted on "wms"."wms_erp_receive_standard" ("is_deleted");
create index iX_wms_erp_receive_standard_last_edited_dt on "wms"."wms_erp_receive_standard" ("last_edited_dt");


comment on column "wms"."wms_erp_receive_standard"."id" is '主键';
comment on column "wms"."wms_erp_receive_standard"."receive_no" is '收获单号';
comment on column "wms"."wms_erp_receive_standard"."receive_warehouse" is '收获仓库';
comment on column "wms"."wms_erp_receive_standard"."status" is '状态';
comment on column "wms"."wms_erp_receive_standard"."remark" is '备注';
comment on column "wms"."wms_erp_receive_standard"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_standard"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_standard"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_standard"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_standard"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_standard"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_standard"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_standard"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_standard"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_standard" is '标准收货物料表';



/*==============================================================*/
/* table: wms_erp_receive_standard_detail                       */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_standard_detail;
drop
sequence if exists  wms_erp_receive_standard_detail_seq;
create
sequence wms_erp_receive_standard_detail_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_standard_detail
(
    "id"             int4 not null default nextval('wms.wms_erp_receive_standard_detail_seq'::regclass),
    "main_id"        int4,
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(64) COLLATE "pg_catalog"."default",
    "receive_qty"    numeric(10, 0),
    "po_no"          varchar(64) COLLATE "pg_catalog"."default",
    "inspect_no"     varchar(64) COLLATE "pg_catalog"."default",
    "result"         varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_erp_receive_standard_detail_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_standard_detail"
    owner to "cloudmes";


create index iX_wms_erp_receive_standard_detail_org_code on "wms"."wms_erp_receive_standard_detail" ("org_code");
create index iX_wms_erp_receive_standard_detail_main_id on "wms"."wms_erp_receive_standard_detail" ("main_id");
create index iX_wms_erp_receive_standard_detail_is_deleted on "wms"."wms_erp_receive_standard_detail" ("is_deleted");
create index iX_wms_erp_receive_standard_detail_last_edited_dt on "wms"."wms_erp_receive_standard_detail" ("last_edited_dt");


comment on column "wms"."wms_erp_receive_standard_detail"."id" is '主键';
comment on column "wms"."wms_erp_receive_standard_detail"."main_id" is '外键';
comment on column "wms"."wms_erp_receive_standard_detail"."material_no" is '物料编码';
comment on column "wms"."wms_erp_receive_standard_detail"."material_name" is '物料名称';
comment on column "wms"."wms_erp_receive_standard_detail"."receive_qty" is '收获数量';
comment on column "wms"."wms_erp_receive_standard_detail"."po_no" is '采购单号';
comment on column "wms"."wms_erp_receive_standard_detail"."inspect_no" is '检验单号';
comment on column "wms"."wms_erp_receive_standard_detail"."result" is '结果';
comment on column "wms"."wms_erp_receive_standard_detail"."remark" is '备注';
comment on column "wms"."wms_erp_receive_standard_detail"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_standard_detail"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_standard_detail"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_standard_detail"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_standard_detail"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_standard_detail"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_standard_detail"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_standard_detail"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_standard_detail"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_standard_detail" is '标准收货物料表';



/*==============================================================*/
/* table: wms_erp_receive_label                                 */
/*==============================================================*/
drop table if exists wms.wms_erp_receive_label;
drop
sequence if exists  wms_erp_receive_label_seq;
create
sequence wms_erp_receive_label_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_erp_receive_label
(
    "id"             int4 not null default nextval('wms.wms_erp_receive_label_seq'::regclass),
    "main_id"        int4,
    "label_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "qty"            numeric(10, 0),
    "vendor_code"    varchar(64) COLLATE "pg_catalog"."default",
    "date_code"      varchar(64) COLLATE "pg_catalog"."default",
    "label_content"  varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_erp_receive_label_pkey" primary key ("id")
);


alter table "wms"."wms_erp_receive_label"
    owner to "cloudmes";


create index iX_wms_erp_receive_label_org_code on "wms"."wms_erp_receive_label" ("org_code");
create index iX_wms_erp_receive_label_main_id on "wms"."wms_erp_receive_label" ("main_id");
create index iX_wms_erp_receive_label_is_deleted on "wms"."wms_erp_receive_label" ("is_deleted");
create index iX_wms_erp_receive_label_last_edited_dt on "wms"."wms_erp_receive_label" ("last_edited_dt");


comment on column "wms"."wms_erp_receive_label"."id" is '主键';
comment on column "wms"."wms_erp_receive_label"."main_id" is '外键';
comment on column "wms"."wms_erp_receive_label"."label_no" is '条码号';
comment on column "wms"."wms_erp_receive_label"."material_no" is '物料编码';
comment on column "wms"."wms_erp_receive_label"."qty" is '数量';
comment on column "wms"."wms_erp_receive_label"."vendor_code" is '供应商编码';
comment on column "wms"."wms_erp_receive_label"."date_code" is 'D/C编码';
comment on column "wms"."wms_erp_receive_label"."label_content" is '条码内容';
comment on column "wms"."wms_erp_receive_label"."org_code" is '组织编码';
comment on column "wms"."wms_erp_receive_label"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_receive_label"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_receive_label"."creator" is '创建人';
comment on column "wms"."wms_erp_receive_label"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_receive_label"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_receive_label"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_receive_label"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_receive_label"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_receive_label" is ' 收货物料标签表';



/*=============================================================入库管理=====================================================================*/

/*===============================港料单入库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_hk_id_seq;
CREATE TABLE "wms_inbound_order_hk"
(
    "id"                int4 NOT NULL DEFAULT nextval('wms_inbound_order_hk_id_seq'::regclass),
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "order_status"      varchar(64) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "inbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "erp_hk_no"         varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"      varchar(128) COLLATE "pg_catalog"."default",
    "source_type"       varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_inbound_order_hk_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderhk_inboundno ON wms_inbound_order_hk (inbound_no);
CREATE INDEX idx_wmsinboundorderhk_erphkno ON wms_inbound_order_hk (erp_hk_no);
CREATE INDEX idx_wmsinboundorderhk_createddt ON wms_inbound_order_hk (created_dt);

COMMENT ON COLUMN "wms_inbound_order_hk"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_hk"."inbound_no" IS '入库单号';
COMMENT ON COLUMN "wms_inbound_order_hk"."order_type" IS '单据类型，单据类型管理中，功能范围为INBOUND_HK_ORDER';
COMMENT ON COLUMN "wms_inbound_order_hk"."order_status" IS '单据状态，WMS_INBOUND_ORDER_STATUS';
COMMENT ON COLUMN "wms_inbound_order_hk"."inbound_warehouse" IS '入库仓库';
COMMENT ON COLUMN "wms_inbound_order_hk"."inbound_area" IS '入库库区';
COMMENT ON COLUMN "wms_inbound_order_hk"."erp_hk_no" IS '港料单号';
COMMENT ON COLUMN "wms_inbound_order_hk"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_inbound_order_hk"."source_type" IS '来源类型，WMS_DATA_SOURCE_TYPE';
COMMENT ON COLUMN "wms_inbound_order_hk"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_inbound_order_hk"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_hk"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_hk"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_hk"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_hk"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_hk"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_hk"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_hk"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_hk"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_hk" IS '港料入库单表';


CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_hk_detail_id_seq;
CREATE TABLE "wms_inbound_order_hk_detail"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('wms_inbound_order_hk_detail_id_seq'::regclass),
    "inbound_order_hk_id" int4,
    "line_status"         varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(128) COLLATE "pg_catalog"."default",
    "po_no"               varchar(64) COLLATE "pg_catalog"."default",
    "demand_qty"          numeric(11, 3) DEFAULT 0.000,
    "inbound_qty"         numeric(11, 3) DEFAULT 0.000,
    "putaway_qty"         numeric(11, 3) DEFAULT 0.000,
    "putaway_bin"         varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "remark"              varchar(255) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"          bool NOT NULL  DEFAULT false,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4 NOT NULL  DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"      int8,
    CONSTRAINT "wms_inbound_order_hk_detail_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmsinboundorderhkdetail_headerid ON wms_inbound_order_hk_detail (inbound_order_hk_id);

COMMENT ON COLUMN "wms_inbound_order_hk_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."inbound_order_hk_id" IS '港料入库单id';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."po_no" IS '采购单号';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."demand_qty" IS '需求数量';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."inbound_qty" IS '入库数量';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."putaway_qty" IS '上架数量';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."putaway_bin" IS '上架储位';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_hk_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_hk_detail" IS '港料入库单物料明细表';


CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_label_id_seq;
CREATE TABLE "wms_inbound_order_label"
(
    "id"                 int4 NOT NULL  DEFAULT nextval('wms_inbound_order_label_id_seq'::regclass),
    "inbound_order_id"   int4,
    "inbound_order_no"   varchar(128) COLLATE "pg_catalog"."default",
    "inbound_order_type" varchar(128) COLLATE "pg_catalog"."default",
    "label_no"           varchar(128) COLLATE "pg_catalog"."default",
    "material_no"        varchar(64) COLLATE "pg_catalog"."default",
    "material_name"      varchar(128) COLLATE "pg_catalog"."default",
    "qty"                numeric(11, 3) DEFAULT 0.000,
    "lot_no"             varchar(64) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"        varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"        varchar(128) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL  DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL  DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_inbound_order_label_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmsinboundorderlabel_headerid ON wms_inbound_order_label (inbound_order_id, inbound_order_type);

COMMENT ON COLUMN "wms_inbound_order_label"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_label"."inbound_order_id" IS '入库单id';
COMMENT ON COLUMN "wms_inbound_order_label"."inbound_order_no" IS '入库单号';
COMMENT ON COLUMN "wms_inbound_order_label"."inbound_order_type" IS '入库单类型';
COMMENT ON COLUMN "wms_inbound_order_label"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_inbound_order_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inbound_order_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inbound_order_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_inbound_order_label"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inbound_order_label"."source_type" IS '来源类型，WMS_DATA_SOURCE_TYPE';
COMMENT ON COLUMN "wms_inbound_order_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_inbound_order_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_inbound_order_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_label" IS '入库单标签表';


CREATE
SEQUENCE IF NOT EXISTS wms_material_lot_id_seq;
CREATE TABLE "wms_material_lot"
(
    "id"             int4 NOT NULL DEFAULT nextval('wms_material_lot_id_seq'::regclass),
    "order_no"       varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(128) COLLATE "pg_catalog"."default",
    "lot_att01"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att02"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att03"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att04"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att05"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att06"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att07"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att08"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att09"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att10"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att11"      varchar(64) COLLATE "pg_catalog"."default",
    "lot_att12"      varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_material_lot_pkey" PRIMARY KEY ("id")
)
;
CREATE INDEX idx_wmsmateriallot_inboundno ON wms_material_lot (order_no);
CREATE INDEX idx_wmsmateriallot_lotno ON wms_material_lot (lot_no);

COMMENT ON COLUMN "wms_material_lot"."id" IS '主键id';
COMMENT ON COLUMN "wms_material_lot"."order_no" IS '单号';
COMMENT ON COLUMN "wms_material_lot"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_material_lot"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_material_lot"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_material_lot"."lot_att01" IS '生产日期';
COMMENT ON COLUMN "wms_material_lot"."lot_att02" IS '生产批次';
COMMENT ON COLUMN "wms_material_lot"."lot_att03" IS '失效日期';
COMMENT ON COLUMN "wms_material_lot"."lot_att04" IS '收货日期';
COMMENT ON COLUMN "wms_material_lot"."lot_att05" IS '扩展属性5';
COMMENT ON COLUMN "wms_material_lot"."lot_att06" IS '扩展属性6';
COMMENT ON COLUMN "wms_material_lot"."lot_att07" IS '批次属性7';
COMMENT ON COLUMN "wms_material_lot"."lot_att08" IS '批次属性8';
COMMENT ON COLUMN "wms_material_lot"."lot_att09" IS '批次属性9';
COMMENT ON COLUMN "wms_material_lot"."lot_att10" IS '批次属性10';
COMMENT ON COLUMN "wms_material_lot"."lot_att11" IS '批次属性11';
COMMENT ON COLUMN "wms_material_lot"."lot_att12" IS '批次属性12';
COMMENT ON COLUMN "wms_material_lot"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_lot"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_lot"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_lot"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_lot"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_lot"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_lot"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_lot"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_lot"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_lot" IS '物料批次信息表';




/*===============================采购单入库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_purchase_id_seq;
CREATE TABLE "wms_inbound_order_purchase"
(
    "id"                int4 NOT NULL DEFAULT nextval('wms_inbound_order_purchase_id_seq'::regclass),
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "order_status"      varchar(64) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "inbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"       varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"       varchar(128) COLLATE "pg_catalog"."default",
    "related_no"        varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"      varchar(128) COLLATE "pg_catalog"."default",
    "source_type"       varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_inbound_order_purchase_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderpurchase_inboundno ON wms_inbound_order_purchase (inbound_no);
CREATE INDEX idx_wmsinboundorderpurchase_relatedorderno ON wms_inbound_order_purchase (related_no);
CREATE INDEX idx_wmsinboundorderpurchase_createddt ON wms_inbound_order_purchase (created_dt);

COMMENT ON COLUMN "wms_inbound_order_purchase"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_purchase"."inbound_no" IS '入库单号';
COMMENT ON COLUMN "wms_inbound_order_purchase"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_inbound_order_purchase"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_inbound_order_purchase"."inbound_warehouse" IS '入库仓库';
COMMENT ON COLUMN "wms_inbound_order_purchase"."inbound_area" IS '入库库区';
COMMENT ON COLUMN "wms_inbound_order_purchase"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_inbound_order_purchase"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_inbound_order_purchase"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_inbound_order_purchase"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_inbound_order_purchase"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_inbound_order_purchase"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_inbound_order_purchase"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_purchase"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_purchase"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_purchase"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_purchase"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_purchase"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_purchase"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_purchase"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_purchase"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_purchase" IS '采购入库单表';


CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_purchase_detail_id_seq;
CREATE TABLE "wms_inbound_order_purchase_detail"
(
    "id"                        int4 NOT NULL  DEFAULT nextval('wms_inbound_order_purchase_detail_id_seq'::regclass),
    "inbound_order_purchase_id" int4,
    "line_status"               varchar(64) COLLATE "pg_catalog"."default",
    "material_no"               varchar(64) COLLATE "pg_catalog"."default",
    "material_name"             varchar(128) COLLATE "pg_catalog"."default",
    "po_no"                     varchar(64) COLLATE "pg_catalog"."default",
    "item_no"                   varchar(64) COLLATE "pg_catalog"."default",
    "demand_qty"                numeric(11, 3) DEFAULT 0.000,
    "inbound_qty"               numeric(11, 3) DEFAULT 0.000,
    "putaway_qty"               numeric(11, 3) DEFAULT 0.000,
    "putaway_bin"               varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"                    varchar(64) COLLATE "pg_catalog"."default",
    "production_date"           varchar(32) COLLATE "pg_catalog"."default",
    "remark"                    varchar(255) COLLATE "pg_catalog"."default",
    "org_code"                  varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"                bool NOT NULL  DEFAULT false,
    "creator"                   varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                int4 NOT NULL  DEFAULT 0,
    "created_dt"                int8,
    "last_editor"               varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"            int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"            int8,
    CONSTRAINT "wms_inbound_order_purchase_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderpurchasedetail_headerid ON wms_inbound_order_purchase_detail (inbound_order_purchase_id);

COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."inbound_order_purchase_id" IS '采购入库单id';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."po_no" IS '采购单号';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."item_no" IS '采购项次';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."demand_qty" IS '需求数量';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."inbound_qty" IS '入库数量';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."putaway_qty" IS '上架数量';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."putaway_bin" IS '上架储位';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."production_date" IS '生产日期';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_purchase_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_purchase_detail" IS '采购入库单物料明细表';




/*===============================工单入库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_wo_id_seq;
CREATE TABLE "wms_inbound_order_wo"
(
    "id"                int4 NOT NULL DEFAULT nextval('wms_inbound_order_wo_id_seq'::regclass),
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "order_status"      varchar(64) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "inbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "related_no"        varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"      varchar(128) COLLATE "pg_catalog"."default",
    "source_type"       varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_inbound_order_wo_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderwo_inboundno ON wms_inbound_order_wo (inbound_no);
CREATE INDEX idx_wmsinboundorderwo_relatedorderno ON wms_inbound_order_wo (related_no);
CREATE INDEX idx_wmsinboundorderwo_createddt ON wms_inbound_order_wo (created_dt);

COMMENT ON COLUMN "wms_inbound_order_wo"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_wo"."inbound_no" IS '入库单号';
COMMENT ON COLUMN "wms_inbound_order_wo"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_inbound_order_wo"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_inbound_order_wo"."inbound_warehouse" IS '入库仓库';
COMMENT ON COLUMN "wms_inbound_order_wo"."inbound_area" IS '入库库区';
COMMENT ON COLUMN "wms_inbound_order_wo"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_inbound_order_wo"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_inbound_order_wo"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_inbound_order_wo"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_inbound_order_wo"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_wo"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_wo"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_wo"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_wo"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_wo"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_wo"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_wo"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_wo"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_wo" IS '工单入库单表';

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_wo_detail_id_seq;
CREATE TABLE "wms_inbound_order_wo_detail"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('wms_inbound_order_wo_detail_id_seq'::regclass),
    "inbound_order_wo_id" int4,
    "line_status"         varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(128) COLLATE "pg_catalog"."default",
    "wo_no"               varchar(64) COLLATE "pg_catalog"."default",
    "demand_qty"          numeric(11, 3) DEFAULT 0.000,
    "inbound_qty"         numeric(11, 3) DEFAULT 0.000,
    "putaway_qty"         numeric(11, 3) DEFAULT 0.000,
    "putaway_bin"         varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "production_date"     varchar(32) COLLATE "pg_catalog"."default",
    "remark"              varchar(255) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"          bool NOT NULL  DEFAULT false,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4 NOT NULL  DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"      int8,
    CONSTRAINT "wms_inbound_order_wo_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderwodetail_headerid ON wms_inbound_order_wo_detail (inbound_order_wo_id);

COMMENT ON COLUMN "wms_inbound_order_wo_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."inbound_order_wo_id" IS '工单入库单id';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."wo_no" IS '工单号';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."demand_qty" IS '需求数量';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."inbound_qty" IS '入库数量';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."putaway_qty" IS '上架数量';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."putaway_bin" IS '上架储位';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."production_date" IS '生产日期';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_wo_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_wo_detail" IS '工单入库单物料明细表';




/*===============================其他入库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_others_id_seq;
CREATE TABLE "wms_inbound_order_others"
(
    "id"                int4 NOT NULL DEFAULT nextval('wms_inbound_order_others_id_seq'::regclass),
    "inbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"        varchar(64) COLLATE "pg_catalog"."default",
    "order_status"      varchar(64) COLLATE "pg_catalog"."default",
    "inbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "inbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "related_no"        varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"      varchar(128) COLLATE "pg_catalog"."default",
    "cost_center"       varchar(64) COLLATE "pg_catalog"."default",
    "source_type"       varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_inbound_order_others_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderothers_inboundno ON wms_inbound_order_others (inbound_no);
CREATE INDEX idx_wmsinboundorderothers_relatedno ON wms_inbound_order_others (related_no);
CREATE INDEX idx_wmsinboundorderothers_createddt ON wms_inbound_order_others (created_dt);

COMMENT ON COLUMN "wms_inbound_order_others"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_others"."inbound_no" IS '入库单号';
COMMENT ON COLUMN "wms_inbound_order_others"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_inbound_order_others"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_inbound_order_others"."inbound_warehouse" IS '入库仓库';
COMMENT ON COLUMN "wms_inbound_order_others"."inbound_area" IS '入库库区';
COMMENT ON COLUMN "wms_inbound_order_others"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_inbound_order_others"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_inbound_order_others"."cost_center" IS '成本中心';
COMMENT ON COLUMN "wms_inbound_order_others"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_inbound_order_others"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_inbound_order_others"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_others"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_others"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_others"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_others"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_others"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_others"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_others"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_others"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_others" IS '其他入库单表';

CREATE
SEQUENCE IF NOT EXISTS wms_inbound_order_others_detail_id_seq;
CREATE TABLE "wms_inbound_order_others_detail"
(
    "id"                      int4 NOT NULL  DEFAULT nextval('wms_inbound_order_others_detail_id_seq'::regclass),
    "inbound_order_others_id" int4,
    "line_status"             varchar(64) COLLATE "pg_catalog"."default",
    "material_no"             varchar(64) COLLATE "pg_catalog"."default",
    "material_name"           varchar(128) COLLATE "pg_catalog"."default",
    "demand_qty"              numeric(11, 3) DEFAULT 0.000,
    "inbound_qty"             numeric(11, 3) DEFAULT 0.000,
    "putaway_qty"             numeric(11, 3) DEFAULT 0.000,
    "putaway_bin"             varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"                  varchar(64) COLLATE "pg_catalog"."default",
    "production_date"         varchar(32) COLLATE "pg_catalog"."default",
    "remark"                  varchar(255) COLLATE "pg_catalog"."default",
    "org_code"                varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"              bool NOT NULL  DEFAULT false,
    "creator"                 varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"              int4 NOT NULL  DEFAULT 0,
    "created_dt"              int8,
    "last_editor"             varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"          int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"          int8,
    CONSTRAINT "wms_inbound_order_others_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinboundorderothersdetail_headerid ON wms_inbound_order_others_detail (inbound_order_others_id);

COMMENT ON COLUMN "wms_inbound_order_others_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."inbound_order_others_id" IS '其他入库单id';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."demand_qty" IS '需求数量';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."inbound_qty" IS '入库数量';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."putaway_qty" IS '上架数量';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."putaway_bin" IS '上架储位';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."production_date" IS '生产日期';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inbound_order_others_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inbound_order_others_detail" IS '其他入库单物料明细表';




/*=============================================================出库管理=====================================================================*/

/*===============================采购退货===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_purchase_id_seq;
CREATE TABLE "wms_outbound_order_purchase"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_outbound_order_purchase_id_seq'::regclass),
    "outbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "outbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "outbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"        varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"        varchar(128) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"       varchar(128) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "movement_reason"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_outbound_order_purchase_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderpurchase_outboundno ON wms_outbound_order_purchase (outbound_no);
CREATE INDEX idx_wmsoutboundorderpurchase_relatedno ON wms_outbound_order_purchase (related_no);
CREATE INDEX idx_wmsoutboundorderpurchase_createddt ON wms_outbound_order_purchase (created_dt);

COMMENT ON COLUMN "wms_outbound_order_purchase"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_purchase"."outbound_no" IS '出库单号';
COMMENT ON COLUMN "wms_outbound_order_purchase"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_outbound_order_purchase"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_outbound_order_purchase"."outbound_warehouse" IS '出库仓库';
COMMENT ON COLUMN "wms_outbound_order_purchase"."outbound_area" IS '出库库区';
COMMENT ON COLUMN "wms_outbound_order_purchase"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_outbound_order_purchase"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_outbound_order_purchase"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_outbound_order_purchase"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_outbound_order_purchase"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_outbound_order_purchase"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_outbound_order_purchase"."movement_reason" IS '异动原因，数据字典：WMS_MOVEMENT_REASON';
COMMENT ON COLUMN "wms_outbound_order_purchase"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_purchase"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_purchase"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_purchase"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_purchase"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_purchase"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_purchase"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_purchase"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_purchase"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_purchase" IS '采购退货单表';


CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_purchase_detail_id_seq;
CREATE TABLE "wms_outbound_order_purchase_detail"
(
    "id"                         int4 NOT NULL  DEFAULT nextval('wms_outbound_order_purchase_detail_id_seq'::regclass),
    "outbound_order_purchase_id" int4,
    "line_status"                varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                varchar(64) COLLATE "pg_catalog"."default",
    "material_name"              varchar(128) COLLATE "pg_catalog"."default",
    "po_no"                      varchar(64) COLLATE "pg_catalog"."default",
    "po_line_no"                 varchar(64) COLLATE "pg_catalog"."default",
    "returnable_qty"             numeric(11, 3) DEFAULT 0.000,
    "request_qty"                numeric(11, 3) DEFAULT 0.000,
    "ship_qty"                   numeric(11, 3) DEFAULT 0.000,
    "outbound_qty"               numeric(11, 3) DEFAULT 0.000,
    "specify_bin"                varchar(64) COLLATE "pg_catalog"."default",
    "ship_bin"                   varchar(64) COLLATE "pg_catalog"."default",
    "specify_lot"                varchar(64) COLLATE "pg_catalog"."default",
    "specify_dc_code"            varchar(64) COLLATE "pg_catalog"."default",
    "remark"                     varchar(255) COLLATE "pg_catalog"."default",
    "org_code"                   varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"                 bool NOT NULL  DEFAULT false,
    "creator"                    varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                 int4 NOT NULL  DEFAULT 0,
    "created_dt"                 int8,
    "last_editor"                varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"             int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"             int8,
    CONSTRAINT "wms_outbound_order_purchase_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderpurchasedetail_headerid ON wms_outbound_order_purchase_detail (outbound_order_purchase_id);

COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."outbound_order_purchase_id" IS '采购退货单id';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."po_no" IS '采购单号';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."po_line_no" IS '采购项次';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."returnable_qty" IS '可退货数量';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."request_qty" IS '申请数量';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."ship_qty" IS '拣货数量';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."outbound_qty" IS '出库数量';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."specify_bin" IS '指定储位';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."ship_bin" IS '拣货储位';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."specify_lot" IS '指定批次';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."specify_dc_code" IS '指定DC Code（生成日期）';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_purchase_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_purchase_detail" IS '采购退货单物料明细表';


CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_label_id_seq;
CREATE TABLE "wms_outbound_order_label"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('wms_outbound_order_label_id_seq'::regclass),
    "outbound_order_id"   int4,
    "outbound_order_no"   varchar(64) COLLATE "pg_catalog"."default",
    "outbound_order_type" varchar(64) COLLATE "pg_catalog"."default",
    "label_no"            varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(128) COLLATE "pg_catalog"."default",
    "qty"                 numeric(11, 3) DEFAULT 0.000,
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "source_type"         varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"         varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"         varchar(128) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "remark"              varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"          bool NOT NULL  DEFAULT false,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4 NOT NULL  DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"      int8,
    CONSTRAINT "wms_outbound_order_label_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderlabel_headerid ON wms_outbound_order_label (outbound_order_id, outbound_order_type);

COMMENT ON COLUMN "wms_outbound_order_label"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_label"."outbound_order_id" IS '出库单id';
COMMENT ON COLUMN "wms_outbound_order_label"."outbound_order_no" IS '出库单号';
COMMENT ON COLUMN "wms_outbound_order_label"."outbound_order_type" IS '出库单类型';
COMMENT ON COLUMN "wms_outbound_order_label"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_outbound_order_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_outbound_order_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_outbound_order_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_outbound_order_label"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_outbound_order_label"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_outbound_order_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_outbound_order_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_outbound_order_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_label" IS '出库单标签表';



/*===============================工单出库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_wo_id_seq;
CREATE TABLE "wms_outbound_order_wo"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_outbound_order_wo_id_seq'::regclass),
    "outbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "outbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "outbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"        varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"        varchar(128) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"       varchar(128) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_outbound_order_wo_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderwo_outboundno ON wms_outbound_order_wo (outbound_no);
CREATE INDEX idx_wmsoutboundorderwo_relatedno ON wms_outbound_order_wo (related_no);
CREATE INDEX idx_wmsoutboundorderwo_createddt ON wms_outbound_order_wo (created_dt);

COMMENT ON COLUMN "wms_outbound_order_wo"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_wo"."outbound_no" IS '出库单号';
COMMENT ON COLUMN "wms_outbound_order_wo"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_outbound_order_wo"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_outbound_order_wo"."outbound_warehouse" IS '出库仓库';
COMMENT ON COLUMN "wms_outbound_order_wo"."outbound_area" IS '出库库区';
COMMENT ON COLUMN "wms_outbound_order_wo"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_outbound_order_wo"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_outbound_order_wo"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_outbound_order_wo"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_outbound_order_wo"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_outbound_order_wo"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_outbound_order_wo"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_wo"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_wo"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_wo"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_wo"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_wo"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_wo"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_wo"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_wo"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_wo" IS '工单出库单表';

CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_wo_detail_id_seq;
CREATE TABLE "wms_outbound_order_wo_detail"
(
    "id"                   int4 NOT NULL  DEFAULT nextval('wms_outbound_order_wo_detail_id_seq'::regclass),
    "outbound_order_wo_id" int4,
    "line_status"          varchar(64) COLLATE "pg_catalog"."default",
    "material_no"          varchar(64) COLLATE "pg_catalog"."default",
    "material_name"        varchar(128) COLLATE "pg_catalog"."default",
    "wo_no"                varchar(64) COLLATE "pg_catalog"."default",
    "available_qty"        numeric(11, 3) DEFAULT 0.000,
    "request_qty"          numeric(11, 3) DEFAULT 0.000,
    "ship_qty"             numeric(11, 3) DEFAULT 0.000,
    "outbound_qty"         numeric(11, 3) DEFAULT 0.000,
    "specify_bin"          varchar(64) COLLATE "pg_catalog"."default",
    "ship_bin"             varchar(64) COLLATE "pg_catalog"."default",
    "specify_lot"          varchar(64) COLLATE "pg_catalog"."default",
    "specify_dc_code"      varchar(64) COLLATE "pg_catalog"."default",
    "remark"               varchar(255) COLLATE "pg_catalog"."default",
    "org_code"             varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"           bool NOT NULL  DEFAULT false,
    "creator"              varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"           int4 NOT NULL  DEFAULT 0,
    "created_dt"           int8,
    "last_editor"          varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"       int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"       int8,
    CONSTRAINT "wms_outbound_order_wo_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderwodetail_headerid ON wms_outbound_order_wo_detail (outbound_order_wo_id);

COMMENT ON COLUMN "wms_outbound_order_wo_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."outbound_order_wo_id" IS '工单出库单id';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."wo_no" IS '工单号';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."available_qty" IS '可用数量';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."request_qty" IS '申请数量';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."ship_qty" IS '拣货数量';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."outbound_qty" IS '出库数量';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."specify_bin" IS '指定储位';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."ship_bin" IS '拣货储位';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."specify_dc_code" IS '指定DC Code（生成日期）';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_wo_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_wo_detail" IS '工单出库单物料明细表';




/*===============================其他出库===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_others_id_seq;
CREATE TABLE "wms_outbound_order_others"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_outbound_order_others_id_seq'::regclass),
    "outbound_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "outbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "outbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "cost_center"        varchar(64) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"       varchar(128) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_outbound_order_others_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderothers_outboundno ON wms_outbound_order_others (outbound_no);
CREATE INDEX idx_wmsoutboundorderothers_relatedno ON wms_outbound_order_others (related_no);
CREATE INDEX idx_wmsoutboundorderothers_createddt ON wms_outbound_order_others (created_dt);

COMMENT ON COLUMN "wms_outbound_order_others"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_others"."outbound_no" IS '出库单号';
COMMENT ON COLUMN "wms_outbound_order_others"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_outbound_order_others"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_outbound_order_others"."outbound_warehouse" IS '出库仓库';
COMMENT ON COLUMN "wms_outbound_order_others"."outbound_area" IS '出库库区';
COMMENT ON COLUMN "wms_outbound_order_others"."cost_center" IS '成本中心';
COMMENT ON COLUMN "wms_outbound_order_others"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_outbound_order_others"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_outbound_order_others"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_outbound_order_others"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_outbound_order_others"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_others"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_others"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_others"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_others"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_others"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_others"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_others"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_others"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_others" IS '其他出库单表';

CREATE
SEQUENCE IF NOT EXISTS wms_outbound_order_others_detail_id_seq;
CREATE TABLE "wms_outbound_order_others_detail"
(
    "id"                       int4 NOT NULL  DEFAULT nextval('wms_outbound_order_others_detail_id_seq'::regclass),
    "outbound_order_others_id" int4,
    "line_status"              varchar(64) COLLATE "pg_catalog"."default",
    "material_no"              varchar(64) COLLATE "pg_catalog"."default",
    "material_name"            varchar(128) COLLATE "pg_catalog"."default",
    "available_qty"            numeric(11, 3) DEFAULT 0.000,
    "request_qty"              numeric(11, 3) DEFAULT 0.000,
    "ship_qty"                 numeric(11, 3) DEFAULT 0.000,
    "outbound_qty"             numeric(11, 3) DEFAULT 0.000,
    "specify_bin"              varchar(64) COLLATE "pg_catalog"."default",
    "ship_bin"                 varchar(64) COLLATE "pg_catalog"."default",
    "specify_lot"              varchar(64) COLLATE "pg_catalog"."default",
    "specify_dc_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"                   varchar(255) COLLATE "pg_catalog"."default",
    "org_code"                 varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"               bool NOT NULL  DEFAULT false,
    "creator"                  varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"               int4 NOT NULL  DEFAULT 0,
    "created_dt"               int8,
    "last_editor"              varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"           int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"           int8,
    CONSTRAINT "wms_outbound_order_others_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsoutboundorderothersdetail_headerid ON wms_outbound_order_others_detail (outbound_order_others_id);

COMMENT ON COLUMN "wms_outbound_order_others_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."outbound_order_others_id" IS '其他出库单id';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."available_qty" IS '可用数量';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."request_qty" IS '申请数量';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."ship_qty" IS '拣货数量';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."outbound_qty" IS '出库数量';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."specify_bin" IS '指定储位';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."ship_bin" IS '拣货储位';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."specify_lot" IS '指定批次';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."specify_dc_code" IS '指定DC Code（生成日期）';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_outbound_order_others_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_outbound_order_others_detail" IS '其他出库单物料明细表';




/*=============================================================库存管理=====================================================================*/

/*===============================储位转移单===============================*/


CREATE
SEQUENCE IF NOT EXISTS wms_bin_transfer_record_id_seq;
CREATE TABLE "wms_bin_transfer_record"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_bin_transfer_record_id_seq'::regclass),
    "transfer_no"        varchar(64) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "transfer_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "source_area"        varchar(64) COLLATE "pg_catalog"."default",
    "target_area"        varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_bin_transfer_record_pkey" PRIMARY KEY ("id")
)
;


CREATE INDEX idx_wmsbintransferrecord_transferno ON wms_bin_transfer_record (transfer_no);
CREATE INDEX idx_wmsbintransferrecord_relatedno ON wms_bin_transfer_record (related_no);
CREATE INDEX idx_wmsbintransferrecord_createddt ON wms_bin_transfer_record (created_dt);

COMMENT ON COLUMN "wms_bin_transfer_record"."id" IS '主键id';
COMMENT ON COLUMN "wms_bin_transfer_record"."transfer_no" IS '转移单号';
COMMENT ON COLUMN "wms_bin_transfer_record"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_bin_transfer_record"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_bin_transfer_record"."transfer_warehouse" IS '仓库';
COMMENT ON COLUMN "wms_bin_transfer_record"."source_area" IS '来源库区';
COMMENT ON COLUMN "wms_bin_transfer_record"."target_area" IS '目标库区';
COMMENT ON COLUMN "wms_bin_transfer_record"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_bin_transfer_record"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_bin_transfer_record"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_bin_transfer_record"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_bin_transfer_record"."remark" IS '备注';
COMMENT ON COLUMN "wms_bin_transfer_record"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_bin_transfer_record"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_bin_transfer_record"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_bin_transfer_record"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_bin_transfer_record"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_bin_transfer_record"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_bin_transfer_record"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_bin_transfer_record" IS '储位转移记录表';



CREATE
SEQUENCE IF NOT EXISTS wms_bin_transfer_record_detail_id_seq;
CREATE TABLE "wms_bin_transfer_record_detail"
(
    "id"                     int4 NOT NULL  DEFAULT nextval('wms_bin_transfer_record_detail_id_seq'::regclass),
    "bin_transfer_record_id" int4,
    "line_status"            varchar(64) COLLATE "pg_catalog"."default",
    "material_no"            varchar(64) COLLATE "pg_catalog"."default",
    "material_name"          varchar(128) COLLATE "pg_catalog"."default",
    "material_lot"           varchar(64) COLLATE "pg_catalog"."default",
    "source_bin"             varchar(64) COLLATE "pg_catalog"."default",
    "target_bin"             varchar(64) COLLATE "pg_catalog"."default",
    "transfer_qty"           numeric(11, 3) DEFAULT 0.000,
    "remark"                 varchar(255) COLLATE "pg_catalog"."default",
    "org_code"               varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"             bool NOT NULL  DEFAULT false,
    "creator"                varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"             int4 NOT NULL  DEFAULT 0,
    "created_dt"             int8,
    "last_editor"            varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"         int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"         int8,
    CONSTRAINT "wms_bin_transfer_record_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsbintransferrecorddetail_headerid ON wms_bin_transfer_record_detail (bin_transfer_record_id);

COMMENT ON COLUMN "wms_bin_transfer_record_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."bin_transfer_record_id" IS '储位转移记录id';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."material_lot" IS '物料批次';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."source_bin" IS '来源储位';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."target_bin" IS '目标储位';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."transfer_qty" IS '转移数量';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_bin_transfer_record_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_bin_transfer_record_detail" IS '储位转移记录明细表';



CREATE
SEQUENCE IF NOT EXISTS wms_bin_transfer_record_label_id_seq;
CREATE TABLE "wms_bin_transfer_record_label"
(
    "id"                     int4 NOT NULL  DEFAULT nextval('wms_bin_transfer_record_label_id_seq'::regclass),
    "bin_transfer_record_id" int4,
    "label_no"               varchar(128) COLLATE "pg_catalog"."default",
    "material_no"            varchar(64) COLLATE "pg_catalog"."default",
    "material_name"          varchar(128) COLLATE "pg_catalog"."default",
    "qty"                    numeric(11, 3) DEFAULT 0.000,
    "lot_no"                 varchar(64) COLLATE "pg_catalog"."default",
    "source_type"            varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"            varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"            varchar(128) COLLATE "pg_catalog"."default",
    "org_code"               varchar(64) COLLATE "pg_catalog"."default",
    "remark"                 varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"             bool NOT NULL  DEFAULT false,
    "creator"                varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"             int4 NOT NULL  DEFAULT 0,
    "created_dt"             int8,
    "last_editor"            varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"         int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"         int8,
    CONSTRAINT "wms_bin_transfer_record_label_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsbintransferrecordlabel_headerid ON wms_bin_transfer_record_label (bin_transfer_record_id);

COMMENT ON COLUMN "wms_bin_transfer_record_label"."id" IS '主键id';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."bin_transfer_record_id" IS '转移单id';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_bin_transfer_record_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_bin_transfer_record_label" IS '储位转移记录标签表';


/*===============================物料调拨单===============================*/


CREATE
SEQUENCE IF NOT EXISTS wms_allocate_order_id_seq;
CREATE TABLE "wms_allocate_order"
(
    "id"               int4 NOT NULL DEFAULT nextval('wms_allocate_order_id_seq'::regclass),
    "allocate_no"      varchar(64) COLLATE "pg_catalog"."default",
    "order_type"       varchar(64) COLLATE "pg_catalog"."default",
    "order_status"     varchar(64) COLLATE "pg_catalog"."default",
    "source_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "source_area"      varchar(64) COLLATE "pg_catalog"."default",
    "transit_bin"      varchar(64) COLLATE "pg_catalog"."default",
    "target_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "target_area"      varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"    varchar(64) COLLATE "pg_catalog"."default",
    "related_no"       varchar(64) COLLATE "pg_catalog"."default",
    "source_type"      varchar(64) COLLATE "pg_catalog"."default",
    "sap_proof_no"     varchar(128) COLLATE "pg_catalog"."default",
    "source_org_code"  varchar(64) COLLATE "pg_catalog"."default",
    "target_org_code"  varchar(64) COLLATE "pg_catalog"."default",
    "org_code"         varchar(64) COLLATE "pg_catalog"."default",
    "remark"           varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"       bool NOT NULL DEFAULT false,
    "creator"          varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"       int4 NOT NULL DEFAULT 0,
    "created_dt"       int8,
    "last_editor"      varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"   int4 NOT NULL DEFAULT 0,
    "last_edited_dt"   int8,
    CONSTRAINT "wms_allocate_order_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsallocateorder_allocateno ON wms_allocate_order (allocate_no);
CREATE INDEX idx_wmsallocateorder_relatedno ON wms_allocate_order (related_no);
CREATE INDEX idx_wmsallocateorder_createddt ON wms_allocate_order (created_dt);

COMMENT ON COLUMN "wms_allocate_order"."id" IS '主键id';
COMMENT ON COLUMN "wms_allocate_order"."allocate_no" IS '调拨单号';
COMMENT ON COLUMN "wms_allocate_order"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_allocate_order"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_allocate_order"."source_warehouse" IS '来源仓库';
COMMENT ON COLUMN "wms_allocate_order"."source_area" IS '来源库区';
COMMENT ON COLUMN "wms_allocate_order"."transit_bin" IS '中转储位';
COMMENT ON COLUMN "wms_allocate_order"."target_warehouse" IS '目标仓库';
COMMENT ON COLUMN "wms_allocate_order"."target_area" IS '目标库区';
COMMENT ON COLUMN "wms_allocate_order"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_allocate_order"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_allocate_order"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_allocate_order"."sap_proof_no" IS '过账凭证';
COMMENT ON COLUMN "wms_allocate_order"."source_org_code" IS '来源组织';
COMMENT ON COLUMN "wms_allocate_order"."target_org_code" IS '目标组织';
COMMENT ON COLUMN "wms_allocate_order"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_allocate_order"."remark" IS '备注';
COMMENT ON COLUMN "wms_allocate_order"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_allocate_order"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_allocate_order"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_allocate_order"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_allocate_order"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_allocate_order"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_allocate_order"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_allocate_order" IS '物料调拨单表';


CREATE
SEQUENCE IF NOT EXISTS wms_allocate_order_detail_id_seq;
CREATE TABLE "wms_allocate_order_detail"
(
    "id"                int4 NOT NULL  DEFAULT nextval('wms_allocate_order_detail_id_seq'::regclass),
    "allocate_order_id" int4,
    "line_status"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_name"     varchar(128) COLLATE "pg_catalog"."default",
    "apply_qty"         numeric(11, 3) DEFAULT 0.000,
    "transfer_out_qty"  numeric(11, 3) DEFAULT 0.000,
    "transfer_in_qty"   numeric(11, 3) DEFAULT 0.000,
    "specify_bin"       varchar(64) COLLATE "pg_catalog"."default",
    "specify_lot"       varchar(64) COLLATE "pg_catalog"."default",
    "specify_dc_code"   varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL  DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL  DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_allocate_order_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsallocateorderdetail_headerid ON wms_allocate_order_detail (allocate_order_id);

COMMENT ON COLUMN "wms_allocate_order_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_allocate_order_detail"."allocate_order_id" IS '物料调拨单id';
COMMENT ON COLUMN "wms_allocate_order_detail"."line_status" IS '行状态';
COMMENT ON COLUMN "wms_allocate_order_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_allocate_order_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_allocate_order_detail"."apply_qty" IS '申请数量';
COMMENT ON COLUMN "wms_allocate_order_detail"."transfer_out_qty" IS '调出数量';
COMMENT ON COLUMN "wms_allocate_order_detail"."transfer_in_qty" IS '调入数量';
COMMENT ON COLUMN "wms_allocate_order_detail"."specify_bin" IS '指定储位';
COMMENT ON COLUMN "wms_allocate_order_detail"."specify_lot" IS '指定批次';
COMMENT ON COLUMN "wms_allocate_order_detail"."specify_dc_code" IS '指定D/C';
COMMENT ON COLUMN "wms_allocate_order_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_allocate_order_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_allocate_order_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_allocate_order_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_allocate_order_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_allocate_order_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_allocate_order_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_allocate_order_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_allocate_order_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_allocate_order_detail" IS '物料调拨单明细表';


CREATE
SEQUENCE IF NOT EXISTS wms_allocate_order_execution_id_seq;
CREATE TABLE "wms_allocate_order_execution"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('wms_allocate_order_execution_id_seq'::regclass),
    "allocate_order_id"   int4,
    "execution_line_no"   varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(128) COLLATE "pg_catalog"."default",
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "transfer_out_qty"    numeric(11, 3) DEFAULT 0.000,
    "transfer_out_bin"    varchar(64) COLLATE "pg_catalog"."default",
    "transit_bin"         varchar(64) COLLATE "pg_catalog"."default",
    "transfer_out_person" varchar(64) COLLATE "pg_catalog"."default",
    "transfer_out_dt"     int8,
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "remark"              varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"          bool NOT NULL  DEFAULT false,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4 NOT NULL  DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"      int8,
    CONSTRAINT "wms_allocate_order_execution_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsallocateorderexecution_headerid ON wms_allocate_order_execution (allocate_order_id);

COMMENT ON COLUMN "wms_allocate_order_execution"."id" IS '主键id';
COMMENT ON COLUMN "wms_allocate_order_execution"."allocate_order_id" IS '物料调拨单id';
COMMENT ON COLUMN "wms_allocate_order_execution"."execution_line_no" IS '执行行号';
COMMENT ON COLUMN "wms_allocate_order_execution"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_allocate_order_execution"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_allocate_order_execution"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_allocate_order_execution"."transfer_out_qty" IS '调出数量';
COMMENT ON COLUMN "wms_allocate_order_execution"."transfer_out_bin" IS '调出储位';
COMMENT ON COLUMN "wms_allocate_order_execution"."transit_bin" IS '中转储位';
COMMENT ON COLUMN "wms_allocate_order_execution"."transfer_out_person" IS '调出人';
COMMENT ON COLUMN "wms_allocate_order_execution"."transfer_out_dt" IS '调出时间';
COMMENT ON COLUMN "wms_allocate_order_execution"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_allocate_order_execution"."remark" IS '备注';
COMMENT ON COLUMN "wms_allocate_order_execution"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_allocate_order_execution"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_allocate_order_execution"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_allocate_order_execution"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_allocate_order_execution"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_allocate_order_execution"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_allocate_order_execution"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_allocate_order_execution" IS '物料调拨单执行明细表';


CREATE
SEQUENCE IF NOT EXISTS wms_allocate_order_inbound_id_seq;
CREATE TABLE "wms_allocate_order_inbound"
(
    "id"                 int4 NOT NULL  DEFAULT nextval('wms_allocate_order_inbound_id_seq'::regclass),
    "allocate_order_id"  int4,
    "execution_line_no"  varchar(64) COLLATE "pg_catalog"."default",
    "material_no"        varchar(64) COLLATE "pg_catalog"."default",
    "material_name"      varchar(128) COLLATE "pg_catalog"."default",
    "lot_no"             varchar(64) COLLATE "pg_catalog"."default",
    "transfer_in_qty"    numeric(11, 3) DEFAULT 0.000,
    "source_bin"         varchar(64) COLLATE "pg_catalog"."default",
    "transfer_in_bin"    varchar(64) COLLATE "pg_catalog"."default",
    "transfer_in_person" varchar(64) COLLATE "pg_catalog"."default",
    "transfer_in_dt"     int8,
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL  DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL  DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_allocate_order_inbound_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsallocateorderinbound_headerid ON wms_allocate_order_inbound (allocate_order_id);

COMMENT ON COLUMN "wms_allocate_order_inbound"."id" IS '主键id';
COMMENT ON COLUMN "wms_allocate_order_inbound"."allocate_order_id" IS '物料调拨单id';
COMMENT ON COLUMN "wms_allocate_order_inbound"."execution_line_no" IS '执行行号';
COMMENT ON COLUMN "wms_allocate_order_inbound"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_allocate_order_inbound"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_allocate_order_inbound"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_allocate_order_inbound"."transfer_in_qty" IS '调入数量';
COMMENT ON COLUMN "wms_allocate_order_inbound"."source_bin" IS '来源储位';
COMMENT ON COLUMN "wms_allocate_order_inbound"."transfer_in_bin" IS '调入储位';
COMMENT ON COLUMN "wms_allocate_order_inbound"."transfer_in_person" IS '调入人';
COMMENT ON COLUMN "wms_allocate_order_inbound"."transfer_in_dt" IS '调入时间';
COMMENT ON COLUMN "wms_allocate_order_inbound"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_allocate_order_inbound"."remark" IS '备注';
COMMENT ON COLUMN "wms_allocate_order_inbound"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_allocate_order_inbound"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_allocate_order_inbound"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_allocate_order_inbound"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_allocate_order_inbound"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_allocate_order_inbound"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_allocate_order_inbound"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_allocate_order_inbound" IS '物料调拨单调入明细表';


CREATE
SEQUENCE IF NOT EXISTS wms_allocate_order_label_id_seq;
CREATE TABLE "wms_allocate_order_label"
(
    "id"                int4 NOT NULL  DEFAULT nextval('wms_allocate_order_label_id_seq'::regclass),
    "allocate_order_id" int4,
    "execution_line_no" varchar(64) COLLATE "pg_catalog"."default",
    "label_no"          varchar(128) COLLATE "pg_catalog"."default",
    "material_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_name"     varchar(128) COLLATE "pg_catalog"."default",
    "qty"               numeric(11, 3) DEFAULT 0.000,
    "lot_no"            varchar(64) COLLATE "pg_catalog"."default",
    "source_type"       varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"       varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"       varchar(128) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL  DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL  DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_allocate_order_label_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsallocateorderlabel_headerid ON wms_allocate_order_label (allocate_order_id);

COMMENT ON COLUMN "wms_allocate_order_label"."id" IS '主键id';
COMMENT ON COLUMN "wms_allocate_order_label"."allocate_order_id" IS '物料调拨单id';
COMMENT ON COLUMN "wms_allocate_order_label"."execution_line_no" IS '执行行号';
COMMENT ON COLUMN "wms_allocate_order_label"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_allocate_order_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_allocate_order_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_allocate_order_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_allocate_order_label"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_allocate_order_label"."source_type" IS '来源类型';
COMMENT ON COLUMN "wms_allocate_order_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_allocate_order_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_allocate_order_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_allocate_order_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_allocate_order_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_allocate_order_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_allocate_order_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_allocate_order_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_allocate_order_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_allocate_order_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_allocate_order_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_allocate_order_label" IS '物料调拨单标签表';




/*===============================库存初始化===============================*/


CREATE
SEQUENCE IF NOT EXISTS wms_inventory_initialization_id_seq;
CREATE TABLE "wms_inventory_initialization"
(
    "id"             int4 NOT NULL  DEFAULT nextval('wms_inventory_initialization_id_seq'::regclass),
    "warehouse_code" varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_name" varchar(64) COLLATE "pg_catalog"."default",
    "area_code"      varchar(64) COLLATE "pg_catalog"."default",
    "area_name"      varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(128) COLLATE "pg_catalog"."default",
    "existing_qty"   numeric(11, 3) DEFAULT 0.000,
    "init_qty"       numeric(11, 3) DEFAULT 0.000,
    "init_bin"       varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"         varchar(64) COLLATE "pg_catalog"."default",
    "label_no"       varchar(128) COLLATE "pg_catalog"."default",
    "init_status"    varchar(64) COLLATE "pg_catalog"."default",
    "inbound_no"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL  DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL  DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL  DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_inventory_initialization_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsinventoryinitialization_warehousecode ON wms_inventory_initialization (warehouse_code);
CREATE INDEX idx_wmsinventoryinitialization_areacode ON wms_inventory_initialization (area_code);
CREATE INDEX idx_wmsinventoryinitialization_materialno ON wms_inventory_initialization (material_no);
CREATE INDEX idx_wmsinventoryinitialization_status ON wms_inventory_initialization (init_status);
CREATE INDEX idx_wmsinventoryinitialization_createddt ON wms_inventory_initialization (created_dt);

COMMENT ON COLUMN "wms_inventory_initialization"."id" IS '主键id';
COMMENT ON COLUMN "wms_inventory_initialization"."warehouse_code" IS '仓库编码';
COMMENT ON COLUMN "wms_inventory_initialization"."warehouse_name" IS '仓库名称';
COMMENT ON COLUMN "wms_inventory_initialization"."area_code" IS '库区编码';
COMMENT ON COLUMN "wms_inventory_initialization"."area_name" IS '库区名称';
COMMENT ON COLUMN "wms_inventory_initialization"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_inventory_initialization"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_inventory_initialization"."existing_qty" IS '现有数量';
COMMENT ON COLUMN "wms_inventory_initialization"."init_qty" IS '初始化数量';
COMMENT ON COLUMN "wms_inventory_initialization"."init_bin" IS '初始化储位';
COMMENT ON COLUMN "wms_inventory_initialization"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_inventory_initialization"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_inventory_initialization"."init_status" IS '初始化状态';
COMMENT ON COLUMN "wms_inventory_initialization"."inbound_no" IS '入库单号';
COMMENT ON COLUMN "wms_inventory_initialization"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_inventory_initialization"."remark" IS '备注';
COMMENT ON COLUMN "wms_inventory_initialization"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_inventory_initialization"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_inventory_initialization"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_inventory_initialization"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_inventory_initialization"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_inventory_initialization"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_inventory_initialization"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_inventory_initialization" IS '库存初始化表';





/*===============================批次属性变更单===============================*/


CREATE
SEQUENCE IF NOT EXISTS wms_material_lot_attr_adjust_id_seq;
CREATE TABLE "wms_material_lot_attr_adjust"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_material_lot_attr_adjust_id_seq'::regclass),
    "lot_attr_adjust_no" varchar(64) COLLATE "pg_catalog"."default",
    "order_type"         varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"             varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"        varchar(64) COLLATE "pg_catalog"."default",
    "material_name"      varchar(128) COLLATE "pg_catalog"."default",
    "spec_model"         varchar(64) COLLATE "pg_catalog"."default",
    "source_no"          varchar(64) COLLATE "pg_catalog"."default",
    "submitter"          varchar(64) COLLATE "pg_catalog"."default",
    "submit_time"        int8,
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "adjust_reason"      varchar(256) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_material_lot_attr_adjust_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsmateriallotattradjust_lotattradjustno ON wms_material_lot_attr_adjust (lot_attr_adjust_no);
CREATE INDEX idx_wmsmateriallotattradjust_sourceno ON wms_material_lot_attr_adjust (source_no);
CREATE INDEX idx_wmsmateriallotattradjust_materialno ON wms_material_lot_attr_adjust (material_no);
CREATE INDEX idx_wmsmateriallotattradjust_createddt ON wms_material_lot_attr_adjust (created_dt);

COMMENT ON COLUMN "wms_material_lot_attr_adjust"."id" IS '主键id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."lot_attr_adjust_no" IS '批次属性变更单号';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."order_type" IS '单据类型';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."spec_model" IS '规格型号';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."source_no" IS '来源单号';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."submitter" IS '提交人';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."submit_time" IS '提交时间';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."source_type" IS '来源类型，web/app';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."adjust_reason" IS '变更原因';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_lot_attr_adjust" IS '批次属性更变单表';



CREATE
SEQUENCE IF NOT EXISTS wms_material_lot_attr_adjust_detail_id_seq;
CREATE TABLE "wms_material_lot_attr_adjust_detail"
(
    "id"                          int4 NOT NULL DEFAULT nextval('wms_material_lot_attr_adjust_detail_id_seq'::regclass),
    "material_lot_attr_adjust_id" int4,
    "attr_code"                   varchar(64) COLLATE "pg_catalog"."default",
    "attr_name"                   varchar(64) COLLATE "pg_catalog"."default",
    "attr_desc"                   varchar(64) COLLATE "pg_catalog"."default",
    "input_type"                  varchar(64) COLLATE "pg_catalog"."default",
    "field_type"                  varchar(128) COLLATE "pg_catalog"."default",
    "old_attr_value"              varchar(64) COLLATE "pg_catalog"."default",
    "new_attr_value"              varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                    varchar(64) COLLATE "pg_catalog"."default",
    "remark"                      varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"                  bool NOT NULL DEFAULT false,
    "creator"                     varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"                  int4 NOT NULL DEFAULT 0,
    "created_dt"                  int8,
    "last_editor"                 varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"              int4 NOT NULL DEFAULT 0,
    "last_edited_dt"              int8,
    CONSTRAINT "wms_material_lot_attr_adjust_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsmateriallotattradjustdetail_headerid ON wms_material_lot_attr_adjust_detail (material_lot_attr_adjust_id);

COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."material_lot_attr_adjust_id" IS '批次属性变更单id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."attr_code" IS '属性编码';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."attr_name" IS '属性名称';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."attr_desc" IS '属性说明';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."input_type" IS '输入控制';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."field_type" IS '字段类型';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."old_attr_value" IS '原属性值';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."new_attr_value" IS '新属性值';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_lot_attr_adjust_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_lot_attr_adjust_detail" IS '批次属性更变单明细表';



/*=============================================================工单借料=====================================================================*/

/*===============================收货工单借料===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_borrow_material_wo_id_seq;
CREATE TABLE "wms_borrow_material_wo"
(
    "id"                 int4 NOT NULL DEFAULT nextval('wms_borrow_material_wo_id_seq'::regclass),
    "borrow_order_no"    varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_type"     varchar(64) COLLATE "pg_catalog"."default",
    "outbound_warehouse" varchar(64) COLLATE "pg_catalog"."default",
    "outbound_area"      varchar(64) COLLATE "pg_catalog"."default",
    "order_status"       varchar(64) COLLATE "pg_catalog"."default",
    "wo_no"              varchar(64) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "type"               varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"         bool NOT NULL DEFAULT false,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    CONSTRAINT "wms_borrow_material_wo_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsborrowmaterialwo_borroworderno ON wms_borrow_material_wo (borrow_order_no);
CREATE INDEX idx_wmsborrowmaterialwo_wono ON wms_borrow_material_wo (wo_no);
CREATE INDEX idx_wmsborrowmaterialwo_relatedno ON wms_borrow_material_wo (related_no);
CREATE INDEX idx_wmsborrowmaterialwo_createddt ON wms_borrow_material_wo (created_dt);

COMMENT ON COLUMN "wms_borrow_material_wo"."id" IS '主键id';
COMMENT ON COLUMN "wms_borrow_material_wo"."borrow_order_no" IS '借料单号';
COMMENT ON COLUMN "wms_borrow_material_wo"."warehouse_type" IS '仓库类型';
COMMENT ON COLUMN "wms_borrow_material_wo"."outbound_warehouse" IS '出库仓库';
COMMENT ON COLUMN "wms_borrow_material_wo"."outbound_area" IS '出库库区';
COMMENT ON COLUMN "wms_borrow_material_wo"."order_status" IS '单据状态';
COMMENT ON COLUMN "wms_borrow_material_wo"."wo_no" IS '工单号';
COMMENT ON COLUMN "wms_borrow_material_wo"."related_no" IS '相关单号';
COMMENT ON COLUMN "wms_borrow_material_wo"."urgency_level" IS '紧急程度';
COMMENT ON COLUMN "wms_borrow_material_wo"."type" IS '类型';
COMMENT ON COLUMN "wms_borrow_material_wo"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_borrow_material_wo"."remark" IS '备注';
COMMENT ON COLUMN "wms_borrow_material_wo"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_borrow_material_wo"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_borrow_material_wo"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_borrow_material_wo"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_borrow_material_wo"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_borrow_material_wo"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_borrow_material_wo"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_borrow_material_wo" IS '工单借料表';

CREATE
SEQUENCE IF NOT EXISTS wms_borrow_material_wo_detail_id_seq;
CREATE TABLE "wms_borrow_material_wo_detail"
(
    "id"                    int4 NOT NULL  DEFAULT nextval('wms_borrow_material_wo_detail_id_seq'::regclass),
    "borrow_material_wo_id" int4,
    "material_no"           varchar(64) COLLATE "pg_catalog"."default",
    "material_name"         varchar(128) COLLATE "pg_catalog"."default",
    "demand_qty"            numeric(11, 3) DEFAULT 0.000,
    "outbound_qty"          numeric(11, 3) DEFAULT 0.000,
    "specify_bin"           varchar(64) COLLATE "pg_catalog"."default",
    "specify_dc_code"       varchar(64) COLLATE "pg_catalog"."default",
    "specify_lot"           varchar(64) COLLATE "pg_catalog"."default",
    "org_code"              varchar(64) COLLATE "pg_catalog"."default",
    "remark"                varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"            bool NOT NULL  DEFAULT false,
    "creator"               varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"            int4 NOT NULL  DEFAULT 0,
    "created_dt"            int8,
    "last_editor"           varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"        int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"        int8,
    CONSTRAINT "wms_borrow_material_wo_detail_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsborrowmaterialwodetail_headerid ON wms_borrow_material_wo_detail (borrow_material_wo_id);
CREATE INDEX idx_wmsborrowmaterialwodetail_materialno ON wms_borrow_material_wo_detail (material_no);

COMMENT ON COLUMN "wms_borrow_material_wo_detail"."id" IS '主键id';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."borrow_material_wo_id" IS '工单借料表id';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."demand_qty" IS '需求数量';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."outbound_qty" IS '出库数量';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."specify_bin" IS '指定储位';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."specify_lot" IS '指定批次';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."specify_dc_code" IS '指定D/C';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."remark" IS '备注';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_borrow_material_wo_detail"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_borrow_material_wo_detail" IS '工单借料物料表';

CREATE
SEQUENCE IF NOT EXISTS wms_borrow_material_wo_label_id_seq;
CREATE TABLE "wms_borrow_material_wo_label"
(
    "id"                    int4 NOT NULL  DEFAULT nextval('wms_borrow_material_wo_label_id_seq'::regclass),
    "borrow_material_wo_id" int4,
    "label_no"              varchar(128) COLLATE "pg_catalog"."default",
    "material_no"           varchar(64) COLLATE "pg_catalog"."default",
    "material_name"         varchar(128) COLLATE "pg_catalog"."default",
    "qty"                   numeric(11, 3) DEFAULT 0.000,
    "vendor_code"           varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"           varchar(128) COLLATE "pg_catalog"."default",
    "date_code"             varchar(64) COLLATE "pg_catalog"."default",
    "label_content"         text COLLATE "pg_catalog"."default",
    "org_code"              varchar(64) COLLATE "pg_catalog"."default",
    "remark"                varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"            bool NOT NULL  DEFAULT false,
    "creator"               varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"            int4 NOT NULL  DEFAULT 0,
    "created_dt"            int8,
    "last_editor"           varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"        int4 NOT NULL  DEFAULT 0,
    "last_edited_dt"        int8,
    CONSTRAINT "wms_borrow_material_wo_label_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsborrowmaterialwolabel_headerid ON wms_borrow_material_wo_label (borrow_material_wo_id);
CREATE INDEX idx_wmsborrowmaterialwolabel_labelno ON wms_borrow_material_wo_label (label_no);
CREATE INDEX idx_wmsborrowmaterialwolabel_materialno ON wms_borrow_material_wo_label (material_no);

COMMENT ON COLUMN "wms_borrow_material_wo_label"."id" IS '主键id';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."borrow_material_wo_id" IS '工单借料表id';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."label_no" IS '标签号';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."date_code" IS 'D/C编码';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."label_content" IS '标签内容';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_borrow_material_wo_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_borrow_material_wo_label" IS '工单借料标签表';


/*=============================================================AGV相关管理=====================================================================*/

/*===============================AGV位置操作记录===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_agv_location_operate_record_id_seq;
CREATE TABLE "wms_agv_location_operate_record"
(
    "id"             int4 NOT NULL DEFAULT nextval('wms_agv_location_operate_record_id_seq'::regclass),
    "rack_code"      varchar(64) COLLATE "pg_catalog"."default",
    "location_code"  varchar(64) COLLATE "pg_catalog"."default",
    "operation_type" varchar(64) COLLATE "pg_catalog"."default",
    "rack_direction" varchar(64) COLLATE "pg_catalog"."default",
    "operate_time"   int8,
    "return_result"  varchar(255) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_agv_location_operate_record_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsagvlocationoperaterecord_rackcode ON wms_agv_location_operate_record (rack_code);
CREATE INDEX idx_wmsagvlocationoperaterecord_locationcode ON wms_agv_location_operate_record (location_code);
CREATE INDEX idx_wmsagvlocationoperaterecord_operatetime ON wms_agv_location_operate_record (operate_time);

COMMENT ON COLUMN "wms_agv_location_operate_record"."id" IS '主键id';
COMMENT ON COLUMN "wms_agv_location_operate_record"."rack_code" IS '货架编码';
COMMENT ON COLUMN "wms_agv_location_operate_record"."location_code" IS '位置编码';
COMMENT ON COLUMN "wms_agv_location_operate_record"."operation_type" IS '操作类型';
COMMENT ON COLUMN "wms_agv_location_operate_record"."rack_direction" IS '货架方向';
COMMENT ON COLUMN "wms_agv_location_operate_record"."operate_time" IS '操作时间';
COMMENT ON COLUMN "wms_agv_location_operate_record"."return_result" IS '返回结果';
COMMENT ON COLUMN "wms_agv_location_operate_record"."remark" IS '备注';
COMMENT ON COLUMN "wms_agv_location_operate_record"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_agv_location_operate_record"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_agv_location_operate_record"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_agv_location_operate_record"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_agv_location_operate_record"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_agv_location_operate_record"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_agv_location_operate_record"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_agv_location_operate_record"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_agv_location_operate_record" IS 'AGV位置操作记录表';




/*=============================================================标签管理=====================================================================*/

/*===============================物料标签表===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_material_label_id_seq;
CREATE TABLE "wms_material_label"
(
    "id"              int4                                       NOT NULL DEFAULT nextval('"wms".wms_material_label_id_seq'::regclass),
    "label_no"        varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "material_no"     varchar(64) COLLATE "pg_catalog"."default",
    "material_name"   varchar(128) COLLATE "pg_catalog"."default",
    "upper_label_no"  varchar(32) COLLATE "pg_catalog"."default",
    "parent_label_no" varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"          varchar(64) COLLATE "pg_catalog"."default",
    "product_date"    int8,
    "date_code"       varchar(32) COLLATE "pg_catalog"."default",
    "batch_code"      varchar(32) COLLATE "pg_catalog"."default",
    "qty"             numeric(18, 3),
    "vendor_code"     varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"     varchar(64) COLLATE "pg_catalog"."default",
    "customer_code"   varchar(128) COLLATE "pg_catalog"."default",
    "customer_name"   varchar(64) COLLATE "pg_catalog"."default",
    "wo_no"           varchar(64) COLLATE "pg_catalog"."default",
    "company_code"    varchar(32) COLLATE "pg_catalog"."default",
    "shelf_life"      int4,
    "relation_no"     varchar(64) COLLATE "pg_catalog"."default",
    "is_close_box"    bool                                                DEFAULT false,
    "is_scrap"        bool                                                DEFAULT false,
    "status"          varchar(36) COLLATE "pg_catalog"."default",
    "pack_rule_code"  varchar(64) COLLATE "pg_catalog"."default",
    "pack_uom_code"   varchar(64) COLLATE "pg_catalog"."default",
    "print_times"     varchar(64) COLLATE "pg_catalog"."default"          DEFAULT '0'::character varying,
    "is_print"        int4                                                DEFAULT 0,
    "prepare_status"  varchar(64) COLLATE "pg_catalog"."default",
    "source_type"     varchar(64) COLLATE "pg_catalog"."default",
    "po_no"           varchar(255) COLLATE "pg_catalog"."default",
    "po_line_no"      varchar(255) COLLATE "pg_catalog"."default",
    "is_freeze"       bool                                                DEFAULT false,
    "weight"          numeric(18, 3),
    "weight_unit"     varchar(64) COLLATE "pg_catalog"."default",
    "org_code"        varchar(64) COLLATE "pg_catalog"."default",
    "remark"          varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"      bool                                       NOT NULL DEFAULT false,
    "creator"         varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"      int4                                       NOT NULL DEFAULT 0,
    "created_dt"      int8,
    "last_editor"     varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"  int4                                       NOT NULL DEFAULT 0,
    "last_edited_dt"  int8,
    CONSTRAINT "wms_material_label_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX "idx_wmsmateriallabel_createddt" ON "wms_material_label" USING btree (
    "created_dt" "pg_catalog"."int8_ops" ASC NULLS LAST
    );

CREATE INDEX "idx_wmsmateriallabel_labelno" ON "wms_material_label" USING btree (
    "label_no" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
    );
CREATE UNIQUE INDEX uk_wms_material_label_labelNo_orgCode
    ON wms_material_label (label_no, org_code);


COMMENT ON COLUMN "wms_material_label"."id" IS '包装条码ID';
COMMENT ON COLUMN "wms_material_label"."label_no" IS '包装条码';
COMMENT ON COLUMN "wms_material_label"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_material_label"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_material_label"."upper_label_no" IS '上级条码';
COMMENT ON COLUMN "wms_material_label"."parent_label_no" IS '父包装条码';
COMMENT ON COLUMN "wms_material_label"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms_material_label"."product_date" IS '生产日期';
COMMENT ON COLUMN "wms_material_label"."date_code" IS 'D/C编码';
COMMENT ON COLUMN "wms_material_label"."batch_code" IS '生产批次';
COMMENT ON COLUMN "wms_material_label"."qty" IS '数量';
COMMENT ON COLUMN "wms_material_label"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms_material_label"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms_material_label"."customer_code" IS '客户代码';
COMMENT ON COLUMN "wms_material_label"."customer_name" IS '客户名称';
COMMENT ON COLUMN "wms_material_label"."wo_no" IS '工单号';
COMMENT ON COLUMN "wms_material_label"."company_code" IS '公司编码';
COMMENT ON COLUMN "wms_material_label"."shelf_life" IS '保质期';
COMMENT ON COLUMN "wms_material_label"."relation_no" IS '相关单号';
COMMENT ON COLUMN "wms_material_label"."is_close_box" IS '是否关箱';
COMMENT ON COLUMN "wms_material_label"."is_scrap" IS '是否报废';
COMMENT ON COLUMN "wms_material_label"."status" IS '条码状态';
COMMENT ON COLUMN "wms_material_label"."pack_rule_code" IS '包装规则代码';
COMMENT ON COLUMN "wms_material_label"."pack_uom_code" IS '包装单位代码';
COMMENT ON COLUMN "wms_material_label"."print_times" IS '打印次数';
COMMENT ON COLUMN "wms_material_label"."is_print" IS '打印状态 0:未打印 1:已打印';
COMMENT ON COLUMN "wms_material_label"."prepare_status" IS '备料状态';
COMMENT ON COLUMN "wms_material_label"."source_type" IS '来源类型 WMS_DATA_SOURCE_TYPE';
COMMENT ON COLUMN "wms_material_label"."po_no" IS 'PO单号';
COMMENT ON COLUMN "wms_material_label"."po_line_no" IS 'PO行号';
COMMENT ON COLUMN "wms_material_label"."is_freeze" IS '是否冻结';
COMMENT ON COLUMN "wms_material_label"."weight" IS '重量';
COMMENT ON COLUMN "wms_material_label"."weight_unit" IS '重量单位';
COMMENT ON COLUMN "wms_material_label"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_label"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_label"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_label"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_label"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_label"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_label"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_label"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_label"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_label" IS '物料标签表';




/*===============================物料标签履历表===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_material_label_record_id_seq;
CREATE TABLE "wms_material_label_record"
(
    "id"                    int4 NOT NULL DEFAULT nextval('"wms".wms_material_label_record_id_seq'::regclass),
    "order_no"              varchar(64) COLLATE "pg_catalog"."default",
    "order_line_no"         varchar(32) COLLATE "pg_catalog"."default",
    "material_label_id"     int4,
    "label_no"              varchar(256) COLLATE "pg_catalog"."default",
    "uom_code"              varchar(64) COLLATE "pg_catalog"."default",
    "operate_type"          varchar(32) COLLATE "pg_catalog"."default",
    "operate_desc"          varchar(64) COLLATE "pg_catalog"."default",
    "is_scrap"              bool,
    "material_no"           varchar(64) COLLATE "pg_catalog"."default",
    "material_name"         varchar(128) COLLATE "pg_catalog"."default",
    "lot_no"                varchar(64) COLLATE "pg_catalog"."default",
    "parent_label_no"       varchar(64) COLLATE "pg_catalog"."default",
    "upper_label_no"        varchar(64) COLLATE "pg_catalog"."default",
    "qty"                   numeric(11, 3),
    "from_bin_code"         varchar(64) COLLATE "pg_catalog"."default",
    "to_bin_code"           varchar(64) COLLATE "pg_catalog"."default",
    "transaction_record_id" varchar(64) COLLATE "pg_catalog"."default",
    "org_code"              varchar(64) COLLATE "pg_catalog"."default",
    "remark"                varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"            bool NOT NULL DEFAULT false,
    "creator"               varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"            int4 NOT NULL DEFAULT 0,
    "created_dt"            int8,
    "last_editor"           varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"        int4 NOT NULL DEFAULT 0,
    "last_edited_dt"        int8,
    CONSTRAINT "wms_material_label_record_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX "idx_wmsmateriallabelrecord_createddt" ON "wms_material_label_record" USING btree (
    "created_dt" "pg_catalog"."int8_ops" ASC NULLS LAST
    );

CREATE INDEX "idx_wmsmateriallabelrecord_labelno" ON "wms_material_label_record" USING btree (
    "label_no" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
    );

COMMENT ON COLUMN "wms_material_label_record"."id" IS '物料标签履历ID';
COMMENT ON COLUMN "wms_material_label_record"."order_no" IS '单号';
COMMENT ON COLUMN "wms_material_label_record"."order_line_no" IS '单据行号';
COMMENT ON COLUMN "wms_material_label_record"."material_label_id" IS '物料标签id';
COMMENT ON COLUMN "wms_material_label_record"."label_no" IS '包装条码';
COMMENT ON COLUMN "wms_material_label_record"."uom_code" IS '包装单位';
COMMENT ON COLUMN "wms_material_label_record"."operate_type" IS '操作类型';
COMMENT ON COLUMN "wms_material_label_record"."operate_desc" IS '操作原因';
COMMENT ON COLUMN "wms_material_label_record"."is_scrap" IS '是否报废';
COMMENT ON COLUMN "wms_material_label_record"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_material_label_record"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_material_label_record"."lot_no" IS '物料批次号';
COMMENT ON COLUMN "wms_material_label_record"."parent_label_no" IS '父条码';
COMMENT ON COLUMN "wms_material_label_record"."upper_label_no" IS '上一级条码';
COMMENT ON COLUMN "wms_material_label_record"."qty" IS '数量';
COMMENT ON COLUMN "wms_material_label_record"."from_bin_code" IS '来源储位编码';
COMMENT ON COLUMN "wms_material_label_record"."to_bin_code" IS '目标储位编码';
COMMENT ON COLUMN "wms_material_label_record"."transaction_record_id" IS '事务交易ID';
COMMENT ON COLUMN "wms_material_label_record"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_label_record"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_label_record"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_label_record"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_label_record"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_label_record"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_label_record"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_label_record"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_label_record"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_label_record" IS '物料标签履历表';



/*===============================物料标签位置表===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_material_label_position_id_seq;
CREATE TABLE "wms_material_label_position"
(
    "id"                int4 NOT NULL DEFAULT nextval('wms_material_label_position_id_seq'::regclass),
    "material_label_id" int4,
    "material_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_name"     varchar(128) COLLATE "pg_catalog"."default",
    "bin_code"          varchar(64) COLLATE "pg_catalog"."default",
    "bin_name"          varchar(128) COLLATE "pg_catalog"."default",
    "area_code"         varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_code"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"          varchar(64) COLLATE "pg_catalog"."default",
    "remark"            varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"        bool NOT NULL DEFAULT false,
    "creator"           varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"        int4 NOT NULL DEFAULT 0,
    "created_dt"        int8,
    "last_editor"       varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"    int4 NOT NULL DEFAULT 0,
    "last_edited_dt"    int8,
    CONSTRAINT "wms_material_label_position_pkey" PRIMARY KEY ("id")
)
;

CREATE INDEX idx_wmsmateriallabelposition_materiallabelid ON wms_material_label_position (material_label_id);
CREATE INDEX idx_wmsmateriallabelposition_createddt ON wms_material_label_position (created_dt);
CREATE UNIQUE INDEX uk_wms_material_label_position_materialLabelId_orgCode
    ON wms_material_label_position (material_label_id, org_code);

COMMENT ON COLUMN "wms_material_label_position"."id" IS '物料标签位置ID';
COMMENT ON COLUMN "wms_material_label_position"."material_label_id" IS '物料标签id';
COMMENT ON COLUMN "wms_material_label_position"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms_material_label_position"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms_material_label_position"."bin_code" IS '储位编码';
COMMENT ON COLUMN "wms_material_label_position"."bin_name" IS '储位名称';
COMMENT ON COLUMN "wms_material_label_position"."area_code" IS '库区编码';
COMMENT ON COLUMN "wms_material_label_position"."warehouse_code" IS '仓库编码';
COMMENT ON COLUMN "wms_material_label_position"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_material_label_position"."remark" IS '备注';
COMMENT ON COLUMN "wms_material_label_position"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_material_label_position"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_material_label_position"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_material_label_position"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_material_label_position"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_material_label_position"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_material_label_position"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_material_label_position" IS '物料标签位置表';


/*===============================第三方物料库存表===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_third_inventory_stock_id_seq;
CREATE TABLE "wms_third_inventory_stock"
(
    "id"             int4 NOT NULL  DEFAULT nextval('wms_third_inventory_stock_id_seq'::regclass),
    "warehouse_code" varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "qty"            numeric(10, 3) DEFAULT 0.000,
    "inspect_qty"    numeric(10, 3) DEFAULT 0.000,
    "frozen_qty"     numeric(10, 3) DEFAULT 0.000,
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "is_deleted"     bool NOT NULL  DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL  DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL  DEFAULT 0,
    "last_edited_dt" int8,
    CONSTRAINT "wms_third_inventory_stock_pkey" PRIMARY KEY ("id")
)
;

CREATE UNIQUE INDEX idx_wmsthirdinventorystock_warehousecode_materialno ON wms_third_inventory_stock (warehouse_code, material_no);
CREATE INDEX idx_wmsthirdinventorystock_createddt ON wms_third_inventory_stock (created_dt);

COMMENT ON COLUMN "wms_third_inventory_stock"."id" IS '主键Id';
COMMENT ON COLUMN "wms_third_inventory_stock"."warehouse_code" IS '仓库代码';
COMMENT ON COLUMN "wms_third_inventory_stock"."material_no" IS '料号';
COMMENT ON COLUMN "wms_third_inventory_stock"."qty" IS '库存数量';
COMMENT ON COLUMN "wms_third_inventory_stock"."inspect_qty" IS '检验数量';
COMMENT ON COLUMN "wms_third_inventory_stock"."frozen_qty" IS '冻结数量';
COMMENT ON COLUMN "wms_third_inventory_stock"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms_third_inventory_stock"."remark" IS '备注';
COMMENT ON COLUMN "wms_third_inventory_stock"."is_deleted" IS '是否已删除，true：已删除 false：未删除';
COMMENT ON COLUMN "wms_third_inventory_stock"."creator" IS '创建人code';
COMMENT ON COLUMN "wms_third_inventory_stock"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms_third_inventory_stock"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms_third_inventory_stock"."last_editor" IS '修改人code';
COMMENT ON COLUMN "wms_third_inventory_stock"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms_third_inventory_stock"."last_edited_dt" IS '修改时间';
COMMENT ON TABLE "wms_third_inventory_stock" IS '第三方物料库存表';



/*===============================事务交易记录表表===============================*/

CREATE
SEQUENCE IF NOT EXISTS wms_transaction_record_id_seq;
CREATE TABLE "wms"."wms_transaction_record"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('"wms".wms_transaction_record_id_seq'::regclass),
    "order_no"            varchar(64) COLLATE "pg_catalog"."default",
    "order_id"            int4,
    "order_type"          varchar(64) COLLATE "pg_catalog"."default",
    "detail_line_no"      varchar(64) COLLATE "pg_catalog"."default",
    "order_detail_id"     int4,
    "from_bin_code"       varchar(64) COLLATE "pg_catalog"."default",
    "from_bin_id"         int4,
    "from_area_code"      varchar(64) COLLATE "pg_catalog"."default",
    "from_area_id"        int4,
    "from_warehouse_code" varchar(64) COLLATE "pg_catalog"."default",
    "from_warehouse_id"   int4,
    "from_org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "to_bin_code"         varchar(64) COLLATE "pg_catalog"."default",
    "to_bin_id"           int4,
    "to_area_code"        varchar(64) COLLATE "pg_catalog"."default",
    "to_area_id"          int4,
    "to_warehouse_code"   varchar(64) COLLATE "pg_catalog"."default",
    "to_warehouse_id"     int4,
    "to_org_code"         varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(1024) COLLATE "pg_catalog"."default",
    "material_id"         int4,
    "uom_code"            varchar(64) COLLATE "pg_catalog"."default",
    "lot_id"              int4,
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "transaction_type"    varchar(64) COLLATE "pg_catalog"."default",
    "transaction_date"    int8,
    "qty"                 numeric(18, 3) DEFAULT NULL::numeric,
    "customer_code"       varchar(64) COLLATE "pg_catalog"."default",
    "customer_name"       varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"         varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"         varchar(64) COLLATE "pg_catalog"."default",
    "upload_flag"         bit(1)         DEFAULT NULL::"bit",
    "return_message"      varchar(6400) COLLATE "pg_catalog"."default",
    "upload_result"       bit(1)         DEFAULT NULL::"bit",
    "upload_id"           varchar(255) COLLATE "pg_catalog"."default",
    "upload_date"         int8,
    "sap_doc_no"          varchar(64) COLLATE "pg_catalog"."default",
    "sap_doc_item_no"     varchar(64) COLLATE "pg_catalog"."default",
    "sap_doc_year"        varchar(64) COLLATE "pg_catalog"."default",
    "sap_doc_month"       varchar(64) COLLATE "pg_catalog"."default",
    "sap_move_type"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"              varchar(5000) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "created_dt"          int8,
    "creator_id"          varchar(64) COLLATE "pg_catalog"."default",
    "creator"             varchar(255) COLLATE "pg_catalog"."default",
    "last_edited_dt"      int8,
    "last_editor_id"      varchar(64) COLLATE "pg_catalog"."default",
    "last_editor"         varchar(255) COLLATE "pg_catalog"."default",
    CONSTRAINT "wms_transaction_record_pkey" PRIMARY KEY ("id")
)
;

COMMENT ON COLUMN "wms"."wms_transaction_record"."id" IS '主键id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."order_no" IS '交易单号';
COMMENT ON COLUMN "wms"."wms_transaction_record"."order_id" IS '交易单ID';
COMMENT ON COLUMN "wms"."wms_transaction_record"."order_type" IS '单据类型，采购入库、成品入库等等';
COMMENT ON COLUMN "wms"."wms_transaction_record"."detail_line_no" IS '交易单明细行号';
COMMENT ON COLUMN "wms"."wms_transaction_record"."order_detail_id" IS '交易单据明细id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_bin_code" IS '来源储位编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_bin_id" IS '来源储位id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_area_code" IS '来源库区编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_area_id" IS '来源库区id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_warehouse_code" IS '来源仓库编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_warehouse_id" IS '来源仓库id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."from_org_code" IS '来源组织编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_bin_code" IS '目标储位编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_bin_id" IS '目标储位id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_area_code" IS '目标库区编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_area_id" IS '目标库区id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_warehouse_code" IS '目标仓库编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_warehouse_id" IS '目标仓库id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."to_org_code" IS '目标组织编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."material_no" IS '物料编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."material_name" IS '物料名称';
COMMENT ON COLUMN "wms"."wms_transaction_record"."material_id" IS '物料id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."uom_code" IS '单位编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."lot_id" IS '批次id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."lot_no" IS '批次号';
COMMENT ON COLUMN "wms"."wms_transaction_record"."transaction_type" IS '交易类型';
COMMENT ON COLUMN "wms"."wms_transaction_record"."transaction_date" IS '交易日期';
COMMENT ON COLUMN "wms"."wms_transaction_record"."qty" IS '交易数量';
COMMENT ON COLUMN "wms"."wms_transaction_record"."customer_code" IS '客户编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."customer_name" IS '客户名称';
COMMENT ON COLUMN "wms"."wms_transaction_record"."vendor_code" IS '供应商编码';
COMMENT ON COLUMN "wms"."wms_transaction_record"."vendor_name" IS '供应商名称';
COMMENT ON COLUMN "wms"."wms_transaction_record"."upload_flag" IS '上传标志';
COMMENT ON COLUMN "wms"."wms_transaction_record"."return_message" IS '返回消息';
COMMENT ON COLUMN "wms"."wms_transaction_record"."upload_result" IS '上传结果';
COMMENT ON COLUMN "wms"."wms_transaction_record"."upload_id" IS 'ebs上传表主键id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."upload_date" IS '上传时间';
COMMENT ON COLUMN "wms"."wms_transaction_record"."sap_doc_no" IS 'SAP过账凭证';
COMMENT ON COLUMN "wms"."wms_transaction_record"."sap_doc_item_no" IS 'SAP过账凭证行号';
COMMENT ON COLUMN "wms"."wms_transaction_record"."sap_doc_year" IS 'SAP凭证年份';
COMMENT ON COLUMN "wms"."wms_transaction_record"."sap_doc_month" IS 'SAP凭证月份';
COMMENT ON COLUMN "wms"."wms_transaction_record"."sap_move_type" IS 'sap移动类型';
COMMENT ON COLUMN "wms"."wms_transaction_record"."remark" IS '备注';
COMMENT ON COLUMN "wms"."wms_transaction_record"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms"."wms_transaction_record"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms"."wms_transaction_record"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."creator" IS '创建人';
COMMENT ON COLUMN "wms"."wms_transaction_record"."last_edited_dt" IS '修改时间';
COMMENT ON COLUMN "wms"."wms_transaction_record"."last_editor_id" IS '修改人id';
COMMENT ON COLUMN "wms"."wms_transaction_record"."last_editor" IS '修改人';
COMMENT ON TABLE "wms"."wms_transaction_record" IS '事务交易记录表';

CREATE UNIQUE INDEX uk_wms_stock_binCode_materialNo_orgCode
    ON wms_stock (bin_code, material_no, org_code);

CREATE UNIQUE INDEX uk_wms_stock_lot_lotNo_binCode_materialNo_orgCode
    ON wms_stock_lot (lot_no, bin_code, material_no, org_code);


/*=============================================================盘点单管理=====================================================================*/

/*==============================================================*/
/* table: wms_inventory                                         */
/*==============================================================*/
drop table if exists wms.wms_inventory;
drop
sequence if exists  wms_inventory_id_seq;
create
sequence wms_inventory_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_inventory
(
    "id"                 int4 not null default nextval('wms.wms_inventory_id_seq'::regclass),
    "doc_no"             varchar(64) COLLATE "pg_catalog"."default",
    "diff_inventory_no"  varchar(64) COLLATE "pg_catalog"."default",
    "operation_type"     varchar(64) COLLATE "pg_catalog"."default",
    "status"             varchar(64) COLLATE "pg_catalog"."default",
    "urgency_level"      varchar(64) COLLATE "pg_catalog"."default",
    "source_type"        varchar(64) COLLATE "pg_catalog"."default",
    "random_number"      varchar(64) COLLATE "pg_catalog"."default",
    "related_no"         varchar(64) COLLATE "pg_catalog"."default",
    "recheck_no"         varchar(64) COLLATE "pg_catalog"."default",
    "remark"             varchar(64) COLLATE "pg_catalog"."default",
    "review_person_code" varchar(64) COLLATE "pg_catalog"."default",
    "review_person_name" varchar(64) COLLATE "pg_catalog"."default",
    "review_time"        int8,
    "assign_person_code" varchar(64) COLLATE "pg_catalog"."default",
    "assign_person_name" varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"         bool          DEFAULT false,
    "deleted_dt"         int8,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    constraint "wms_inventory_pkey" primary key ("id")
);


alter table "wms"."wms_inventory"
    owner to "cloudmes";


create index iX_wms_inventory_org_code on "wms"."wms_inventory" ("org_code");
create index iX_wms_inventory_is_deleted on "wms"."wms_inventory" ("is_deleted");



comment on column "wms"."wms_inventory"."id" is '主键';
comment on column "wms"."wms_inventory"."doc_no" is '盘点单号';
comment on column "wms"."wms_inventory"."diff_inventory_no" is '盘点单号-差异单号';
comment on column "wms"."wms_inventory"."operation_type" is '操作类型';
comment on column "wms"."wms_inventory"."status" is '盘点状态';
comment on column "wms"."wms_inventory"."urgency_level" is '紧急程度';
comment on column "wms"."wms_inventory"."source_type" is '来源类型';
comment on column "wms"."wms_inventory"."random_number" is '随即个数';
comment on column "wms"."wms_inventory"."related_no" is '相关单号';
comment on column "wms"."wms_inventory"."recheck_no" is '复核单号';
comment on column "wms"."wms_inventory"."remark" is '备注';
comment on column "wms"."wms_inventory"."review_person_code" is '审核人编码';
comment on column "wms"."wms_inventory"."review_person_name" is '审核人姓名';
comment on column "wms"."wms_inventory"."review_time" is '审核时间';
comment on column "wms"."wms_inventory"."assign_person_code" is '分配人编码';
comment on column "wms"."wms_inventory"."assign_person_name" is '分配人姓名';
comment on column "wms"."wms_inventory"."org_code" is '组织编码';
comment on column "wms"."wms_inventory"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_inventory"."deleted_dt" is '删除时间';
comment on column "wms"."wms_inventory"."creator" is '创建人';
comment on column "wms"."wms_inventory"."creator_id" is '创建人id';
comment on column "wms"."wms_inventory"."created_dt" is '创建时间';
comment on column "wms"."wms_inventory"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_inventory"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_inventory"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_inventory" is ' 盘点主表';



/*==============================================================*/
/* table: wms_inventory_range                                   */
/*==============================================================*/
drop table if exists wms.wms_inventory_range;
drop
sequence if exists  wms_inventory_range_id_seq;
create
sequence wms_inventory_range_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_inventory_range
(
    "id"                 int4 not null default nextval('wms.wms_inventory_range_id_seq'::regclass),
    "inventory_id"       int4,
    "warehouse_code"     varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_name"     varchar(64) COLLATE "pg_catalog"."default",
    "area_code"          varchar(64) COLLATE "pg_catalog"."default",
    "area_name"          varchar(64) COLLATE "pg_catalog"."default",
    "bin_code"           varchar(64) COLLATE "pg_catalog"."default",
    "bin_name"           varchar(64) COLLATE "pg_catalog"."default",
    "material_no"        varchar(64) COLLATE "pg_catalog"."default",
    "material_name"      varchar(64) COLLATE "pg_catalog"."default",
    "inventory_detail"   varchar(64) COLLATE "pg_catalog"."default",
    "is_compulsory_scan" bool          default false,
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"         bool          DEFAULT false,
    "deleted_dt"         int8,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4 NOT NULL DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4 NOT NULL DEFAULT 0,
    "last_edited_dt"     int8,
    constraint "wms_inventory_range_pkey" primary key ("id")
);


alter table "wms"."wms_inventory_range"
    owner to "cloudmes";


create index iX_wms_inventory_range_org_code on "wms"."wms_inventory_range" ("org_code");
create index iX_wms_inventory_range_inventory_id on "wms"."wms_inventory_range" ("inventory_id");
create index iX_wms_inventory_range_is_deleted on "wms"."wms_inventory_range" ("is_deleted");



comment on column "wms"."wms_inventory_range"."id" is '主键';
comment on column "wms"."wms_inventory_range"."inventory_id" is '盘点表主键';
comment on column "wms"."wms_inventory_range"."warehouse_code" is '仓库编码';
comment on column "wms"."wms_inventory_range"."warehouse_name" is '仓库名称';
comment on column "wms"."wms_inventory_range"."area_code" is '库区编码';
comment on column "wms"."wms_inventory_range"."area_name" is '库区名称';
comment on column "wms"."wms_inventory_range"."bin_code" is '储位编码';
comment on column "wms"."wms_inventory_range"."bin_name" is '储位名称';
comment on column "wms"."wms_inventory_range"."material_no" is '物料编码';
comment on column "wms"."wms_inventory_range"."material_name" is '物料名称';
comment on column "wms"."wms_inventory_range"."inventory_detail" is '盘点细度';
comment on column "wms"."wms_inventory_range"."is_compulsory_scan" is '是否强制扫码';
comment on column "wms"."wms_inventory_range"."org_code" is '组织编码';
comment on column "wms"."wms_inventory_range"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_inventory_range"."deleted_dt" is '删除时间';
comment on column "wms"."wms_inventory_range"."creator" is '创建人';
comment on column "wms"."wms_inventory_range"."creator_id" is '创建人id';
comment on column "wms"."wms_inventory_range"."created_dt" is '创建时间';
comment on column "wms"."wms_inventory_range"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_inventory_range"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_inventory_range"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_inventory_range" is ' 盘点范围表';




/*==============================================================*/
/* table: wms_inventory_sn                                      */
/*==============================================================*/
drop table if exists wms.wms_inventory_sn;
drop
sequence if exists  wms_inventory_sn_id_seq;
create
sequence wms_inventory_sn_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
CREATE TABLE "wms"."wms_inventory_sn"
(
    "id"                  int4 NOT NULL  DEFAULT nextval('"wms".wms_inventory_sn_id_seq'::regclass),
    "inventory_id"        int4,
    "inventory_detail_id" int4,
    "line_no"             varchar(64) COLLATE "pg_catalog"."default",
    "label_no"            varchar(64) COLLATE "pg_catalog"."default",
    "material_no"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"       varchar(512) COLLATE "pg_catalog"."default",
    "qty"                 numeric(11, 3) DEFAULT 0.000,
    "vendor_code"         varchar(64) COLLATE "pg_catalog"."default",
    "product_date"        varchar(64) COLLATE "pg_catalog"."default",
    "date_code"           varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"              varchar(64) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"          bool           DEFAULT false,
    "deleted_dt"          int8,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4           DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4           DEFAULT 0,
    "last_edited_dt"      int8,
    CONSTRAINT "wms_inventory_sn_pkey" PRIMARY KEY ("id")
)
;

ALTER TABLE "wms"."wms_inventory_sn"
    OWNER TO "cloudmes";

CREATE INDEX "ix_wms_inventory_sn_inventory_id" ON "wms"."wms_inventory_sn" USING btree (
    "inventory_id" "pg_catalog"."int4_ops" ASC NULLS LAST
    );

CREATE INDEX "ix_wms_inventory_sn_is_deleted" ON "wms"."wms_inventory_sn" USING btree (
    "is_deleted" "pg_catalog"."bool_ops" ASC NULLS LAST
    );

CREATE INDEX "ix_wms_inventory_sn_org_code" ON "wms"."wms_inventory_sn" USING btree (
    "org_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
    );

COMMENT ON COLUMN "wms"."wms_inventory_sn"."id" IS '主键';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."inventory_id" IS '盘点表主键';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."inventory_detail_id" IS '盘点明细表主键';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."line_no" IS '行号';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."label_no" IS '条码号';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."material_name" IS '物料名称';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."qty" IS '数量';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."vendor_code" IS '供应商编码';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."product_date" IS '生产日期';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."date_code" IS 'DC编码';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."lot_no" IS '批次号';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."org_code" IS '组织编码';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."is_deleted" IS '0：有效，1：删除';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."deleted_dt" IS '删除时间';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."creator" IS '创建人';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."last_editor" IS '最后一次编辑人';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."last_editor_id" IS '最后一次编辑人id';

COMMENT ON COLUMN "wms"."wms_inventory_sn"."last_edited_dt" IS '最后一次编辑时间';

COMMENT ON TABLE "wms"."wms_inventory_sn" IS ' 盘点条码明细表';


/*==============================================================*/
/* table: wms_inventory_detail                                  */
/*==============================================================*/
drop table if exists wms.wms_inventory_detail;
drop
sequence if exists  wms_inventory_detail_id_seq;
create
sequence wms_inventory_detail_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
CREATE TABLE wms.wms_inventory_detail
(
    "id"               int4 NOT NULL  DEFAULT nextval('wms_inventory_detail_id_seq'::regclass),
    "inventory_id"     int4,
    "line_no"          varchar(64) COLLATE "pg_catalog"."default",
    "line_status"      varchar(64) COLLATE "pg_catalog"."default",
    "material_no"      varchar(64) COLLATE "pg_catalog"."default",
    "material_name"    varchar(128) COLLATE "pg_catalog"."default",
    "spec_model"       varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_code"   varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_name"   varchar(64) COLLATE "pg_catalog"."default",
    "area_code"        varchar(64) COLLATE "pg_catalog"."default",
    "area_name"        varchar(64) COLLATE "pg_catalog"."default",
    "bin_code"         varchar(64) COLLATE "pg_catalog"."default",
    "bin_name"         varchar(64) COLLATE "pg_catalog"."default",
    "qty"              numeric(11, 3) DEFAULT 0.000,
    "actual_qty"       numeric(11, 3) DEFAULT 0.000,
    "difference_qty"   numeric(11, 3) DEFAULT 0.000,
    "sap_inventory"    numeric(11, 3) DEFAULT 0.000,
    "material_lot"     varchar(64) COLLATE "pg_catalog"."default",
    "remark"           varchar(64) COLLATE "pg_catalog"."default",
    "inventory_time"   int8,
    "inventory_person" varchar(64) COLLATE "pg_catalog"."default",
    "org_code"         varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"       bool           DEFAULT false,
    "deleted_dt"       int8,
    "creator"          varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"       int4           DEFAULT 0,
    "created_dt"       int8,
    "last_editor"      varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"   int4           DEFAULT 0,
    "last_edited_dt"   int8,
    CONSTRAINT "wms_inventory_detail_pkey" PRIMARY KEY ("id")
);


alter table "wms"."wms_inventory_detail"
    owner to "cloudmes";

create index iX_wms_inventory_detail_org_code on "wms"."wms_inventory_detail" ("org_code");
create index iX_wms_inventory_detail_inventory_id on "wms"."wms_inventory_detail" ("inventory_id");
create index iX_wms_inventory_detail_is_deleted on "wms"."wms_inventory_detail" ("is_deleted");


comment on column "wms"."wms_inventory_detail"."id" is '主键';
comment on column "wms"."wms_inventory_detail"."inventory_id" is '盘点表主键';
comment on column "wms"."wms_inventory_detail"."line_no" is '行号';
comment on column "wms"."wms_inventory_detail"."line_status" is '行状态';
comment on column "wms"."wms_inventory_detail"."material_no" is '物料编码';
comment on column "wms"."wms_inventory_detail"."material_name" is '物料名称';
comment on column "wms"."wms_inventory_detail"."spec_model" is '规格型号';
comment on column "wms"."wms_inventory_detail"."warehouse_code" is '仓库编码';
comment on column "wms"."wms_inventory_detail"."warehouse_name" is '仓库名称';
comment on column "wms"."wms_inventory_detail"."area_code" is '库区编码';
comment on column "wms"."wms_inventory_detail"."area_name" is '库区名称';
comment on column "wms"."wms_inventory_detail"."bin_code" is '储位编码';
comment on column "wms"."wms_inventory_detail"."bin_name" is '储位名称';
comment on column "wms"."wms_inventory_detail"."qty" is '现有量';
comment on column "wms"."wms_inventory_detail"."actual_qty" is '实盘数量';
comment on column "wms"."wms_inventory_detail"."difference_qty" is '差异数量';
comment on column "wms"."wms_inventory_detail"."sap_inventory" is 'SAP库存量';
comment on column "wms"."wms_inventory_detail"."material_lot" is '物料批次';
comment on column "wms"."wms_inventory_detail"."remark" is '备注';
comment on column "wms"."wms_inventory_detail"."inventory_time" is '盘点时间';
comment on column "wms"."wms_inventory_detail"."inventory_person" is '盘点人';
comment on column "wms"."wms_inventory_detail"."org_code" is '组织编码';
comment on column "wms"."wms_inventory_detail"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_inventory_detail"."deleted_dt" is '删除时间';
comment on column "wms"."wms_inventory_detail"."creator" is '创建人';
comment on column "wms"."wms_inventory_detail"."creator_id" is '创建人id';
comment on column "wms"."wms_inventory_detail"."created_dt" is '创建时间';
comment on column "wms"."wms_inventory_detail"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_inventory_detail"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_inventory_detail"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_inventory_detail" is ' 盘点物料明细表';


/*==============================================================*/
/* table: wms_inventory_material_rel                            */
/*==============================================================*/
drop table if exists wms.wms_inventory_material_rel;
drop
sequence if exists wms.wms_inventory_material_rel_id_seq;
create
sequence wms.wms_inventory_material_rel_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;

ALTER
SEQUENCE "wms"."wms_inventory_material_rel_id_seq"
    owner to "cloudmes";


create table wms.wms_inventory_material_rel
(
    "id"             int4 not null default nextval('wms.wms_inventory_material_rel_id_seq'::regclass),
    "inventory_id"   int4,
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_inventory_material_rel_pkey" primary key ("id")
);

alter table "wms"."wms_inventory_material_rel"
    owner to "cloudmes";

create index ix_wms_inventory_material_rel_inventory_org_deleted on "wms"."wms_inventory_material_rel" ("inventory_id", "org_code", "is_deleted");
create index ix_wms_inventory_material_rel_material_org_deleted on "wms"."wms_inventory_material_rel" ("material_no", "org_code", "is_deleted");

comment on column "wms"."wms_inventory_material_rel"."id" is '主键';
comment on column "wms"."wms_inventory_material_rel"."inventory_id" is '盘点主表ID';
comment on column "wms"."wms_inventory_material_rel"."material_no" is '物料编码';
comment on column "wms"."wms_inventory_material_rel"."org_code" is '组织编码';
comment on column "wms"."wms_inventory_material_rel"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_inventory_material_rel"."deleted_dt" is '删除时间';
comment on column "wms"."wms_inventory_material_rel"."creator" is '创建人';
comment on column "wms"."wms_inventory_material_rel"."creator_id" is '创建人id';
comment on column "wms"."wms_inventory_material_rel"."created_dt" is '创建时间';
comment on column "wms"."wms_inventory_material_rel"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_inventory_material_rel"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_inventory_material_rel"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_inventory_material_rel" is '盘点单料号关系表';

/*==============================================================*/
/* table: wms_inventory_cyclical_material                       */
/*==============================================================*/
drop table if exists wms.wms_inventory_cyclical_material;
drop
sequence if exists wms.wms_inventory_cyclical_material_id_seq;
create
sequence wms.wms_inventory_cyclical_material_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;

ALTER
SEQUENCE "wms"."wms_inventory_cyclical_material_id_seq"
    owner to "cloudmes";

create table wms.wms_inventory_cyclical_material
(
    "id"             int4 not null default nextval('wms.wms_inventory_cyclical_material_id_seq'::regclass),
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 NOT NULL DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 NOT NULL DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_inventory_cyclical_material_pkey" primary key ("id")
);

alter table "wms"."wms_inventory_cyclical_material"
    owner to "cloudmes";

create unique index uk_wms_inventory_cyclical_material_material_org
    on "wms"."wms_inventory_cyclical_material" ("material_no", "org_code");

comment on column "wms"."wms_inventory_cyclical_material"."id" is '主键';
comment on column "wms"."wms_inventory_cyclical_material"."material_no" is '物料编码';
comment on column "wms"."wms_inventory_cyclical_material"."org_code" is '组织编码';
comment on column "wms"."wms_inventory_cyclical_material"."is_deleted" is 'false：有效，true：删除';
comment on column "wms"."wms_inventory_cyclical_material"."creator" is '创建人';
comment on column "wms"."wms_inventory_cyclical_material"."creator_id" is '创建人id';
comment on column "wms"."wms_inventory_cyclical_material"."created_dt" is '创建时间';
comment on column "wms"."wms_inventory_cyclical_material"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_inventory_cyclical_material"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_inventory_cyclical_material"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_inventory_cyclical_material" is '循环盘点物料记录表';


CREATE TABLE "wms"."wms_material_bin"
(
    "id"               int4                                       NOT NULL DEFAULT nextval('"wms".wms_materialbin_id_seq'::regclass),
    "creator_id"       varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "creator"          varchar(64) COLLATE "pg_catalog"."default",
    "created_dt"       int8,
    "last_editor_id"   varchar(64) COLLATE "pg_catalog"."default",
    "last_editor"      varchar(64) COLLATE "pg_catalog"."default",
    "last_edited_dt"   int8,
    "org_code"         varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "sort_no"          varchar(64) COLLATE "pg_catalog"."default",
    "material_id"      int4,
    "warehouse_id"     int4,
    "bin_id"           int4,
    "material_no"      varchar(32) COLLATE "pg_catalog"."default",
    "warehouse_code"   varchar(64) COLLATE "pg_catalog"."default",
    "bin_code"         varchar(64) COLLATE "pg_catalog"."default",
    "material_name"    varchar(64) COLLATE "pg_catalog"."default",
    "material_version" varchar(64) COLLATE "pg_catalog"."default",
    "material_type"    varchar(64) COLLATE "pg_catalog"."default",
    "material_desc"    varchar(64) COLLATE "pg_catalog"."default",
    "bin_name"         varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_name"   varchar(64) COLLATE "pg_catalog"."default",
    "area_code"        varchar(64) COLLATE "pg_catalog"."default",
    "area_name"        varchar(64) COLLATE "pg_catalog"."default",
    "area_id"          int4,
    "is_deleted"       bool                                       NOT NULL DEFAULT false
)
;

ALTER TABLE "wms"."wms_material_bin"
    OWNER TO "cloudmes";


COMMENT ON COLUMN "wms"."wms_material_bin"."id" IS '主键id';

COMMENT ON COLUMN "wms"."wms_material_bin"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms"."wms_material_bin"."creator" IS '创建人';

COMMENT ON COLUMN "wms"."wms_material_bin"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms"."wms_material_bin"."last_editor_id" IS '最后修改者id';

COMMENT ON COLUMN "wms"."wms_material_bin"."last_editor" IS '最后一次编辑人';

COMMENT ON COLUMN "wms"."wms_material_bin"."last_edited_dt" IS '最后一次编辑时间';

COMMENT ON COLUMN "wms"."wms_material_bin"."org_code" IS '组织代码';

COMMENT ON COLUMN "wms"."wms_material_bin"."sort_no" IS '排序号';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_id" IS '料号id';

COMMENT ON COLUMN "wms"."wms_material_bin"."warehouse_id" IS '仓库id';

COMMENT ON COLUMN "wms"."wms_material_bin"."bin_id" IS '储位id';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_no" IS '料号编号';

COMMENT ON COLUMN "wms"."wms_material_bin"."warehouse_code" IS '仓库编码';

COMMENT ON COLUMN "wms"."wms_material_bin"."bin_code" IS '储位编码';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_name" IS '料号名称';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_version" IS '料号版次';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_type" IS '料号类型';

COMMENT ON COLUMN "wms"."wms_material_bin"."material_desc" IS '料号描述';

COMMENT ON COLUMN "wms"."wms_material_bin"."bin_name" IS '储位名称';

COMMENT ON COLUMN "wms"."wms_material_bin"."warehouse_name" IS '仓库名称';

COMMENT ON COLUMN "wms"."wms_material_bin"."area_code" IS '库区编码';

COMMENT ON COLUMN "wms"."wms_material_bin"."area_name" IS '库区名称';

COMMENT ON COLUMN "wms"."wms_material_bin"."area_id" IS '库区Id';

COMMENT ON COLUMN "wms"."wms_material_bin"."is_deleted" IS '数据状态（0=正常、1=删除、2=禁用）';

COMMENT ON TABLE "wms"."wms_material_bin" IS '料号储位关系表';


alter table "wms"."wms_inbound_order_hk"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_inbound_order_hk"."assign_user" is '分配人工号';

alter table "wms"."wms_inbound_order_hk"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_inbound_order_hk"."assign_user_name" is '分配人姓名';


alter table "wms"."wms_inbound_order_others"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_inbound_order_others"."assign_user" is '分配人工号';

alter table "wms"."wms_inbound_order_others"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_inbound_order_others"."assign_user_name" is '分配人姓名';


alter table "wms"."wms_inbound_order_purchase"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_inbound_order_purchase"."assign_user" is '分配人工号';

alter table "wms"."wms_inbound_order_purchase"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_inbound_order_purchase"."assign_user_name" is '分配人姓名';


alter table "wms"."wms_inbound_order_wo"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_inbound_order_wo"."assign_user" is '分配人工号';

alter table "wms"."wms_inbound_order_wo"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_inbound_order_wo"."assign_user_name" is '分配人姓名';

alter table "wms"."wms_outbound_order_wo"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_outbound_order_wo"."assign_user" is '分配人工号';

alter table "wms"."wms_outbound_order_wo"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_outbound_order_wo"."assign_user_name" is '分配人姓名';

alter table "wms"."wms_outbound_order_purchase"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_outbound_order_purchase"."assign_user" is '分配人工号';

alter table "wms"."wms_outbound_order_purchase"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_outbound_order_purchase"."assign_user_name" is '分配人姓名';

alter table "wms"."wms_outbound_order_others"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_outbound_order_others"."assign_user" is '分配人工号';

alter table "wms"."wms_outbound_order_others"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_outbound_order_others"."assign_user_name" is '分配人姓名';

alter table "wms"."wms_allocate_order"
    add column "assign_user" varchar(64);

comment on column "wms"."wms_allocate_order"."assign_user" is '分配人工号';

alter table "wms"."wms_allocate_order"
    add column "assign_user_name" varchar(64);

comment on column "wms"."wms_allocate_order"."assign_user_name" is '分配人姓名';


alter table "wms"."wms_material_label"
    add column "vendor_lot_no" varchar(64);

comment on column "wms"."wms_material_label"."vendor_lot_no" is '供应商批次';


/*==============================================================*/
/* table: wms_agv_task_config                                   */
/*==============================================================*/
drop table if exists wms.wms_agv_task_config;
drop
sequence if exists  wms_agv_task_config_id_seq;
create
sequence wms_agv_task_config_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_agv_task_config
(
    "id"                  int4 not null default nextval('wms.wms_agv_task_config_id_seq'::regclass),
    "task_code"           varchar(64) COLLATE "pg_catalog"."default",
    "task_name"           varchar(64) COLLATE "pg_catalog"."default",
    "container_type"      varchar(64) COLLATE "pg_catalog"."default",
    "task_type"           varchar(64) COLLATE "pg_catalog"."default",
    "start_location"      varchar(64) COLLATE "pg_catalog"."default",
    "start_location_type" varchar(64) COLLATE "pg_catalog"."default",
    "end_location"        varchar(64) COLLATE "pg_catalog"."default",
    "end_location_type"   varchar(64) COLLATE "pg_catalog"."default",
    "org_code"            varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"          bool          DEFAULT false,
    "deleted_dt"          int8,
    "creator"             varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"          int4          DEFAULT 0,
    "created_dt"          int8,
    "last_editor"         varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"      int4          DEFAULT 0,
    "last_edited_dt"      int8,
    constraint "wms_agv_task_config_pkey" primary key ("id")
);


alter table "wms"."wms_agv_task_config"
    owner to "cloudmes";

create index iX_wms_agv_task_config_org_code on "wms"."wms_agv_task_config" ("org_code");
create index iX_wms_agv_task_config_task_code on "wms"."wms_agv_task_config" ("task_code");
create index iX_wms_agv_task_config_is_deleted on "wms"."wms_agv_task_config" ("is_deleted");


comment on column "wms"."wms_agv_task_config"."id" is '主键';
comment on column "wms"."wms_agv_task_config"."task_code" is '任务编码';
comment on column "wms"."wms_agv_task_config"."task_name" is '任务名称';
comment on column "wms"."wms_agv_task_config"."container_type" is '容器类型';
comment on column "wms"."wms_agv_task_config"."task_type" is '任务类型';
comment on column "wms"."wms_agv_task_config"."start_location" is '起点位置';
comment on column "wms"."wms_agv_task_config"."start_location_type" is '起点任务类型';
comment on column "wms"."wms_agv_task_config"."end_location" is '终点位置';
comment on column "wms"."wms_agv_task_config"."end_location_type" is '终点任务类型';
comment on column "wms"."wms_agv_task_config"."org_code" is '组织编码';
comment on column "wms"."wms_agv_task_config"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_agv_task_config"."deleted_dt" is '删除时间';
comment on column "wms"."wms_agv_task_config"."creator" is '创建人';
comment on column "wms"."wms_agv_task_config"."creator_id" is '创建人id';
comment on column "wms"."wms_agv_task_config"."created_dt" is '创建时间';
comment on column "wms"."wms_agv_task_config"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_agv_task_config"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_agv_task_config"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_agv_task_config" is ' agv任务配置信息表';


/*==============================================================*/
/* table: wms_agv_task_staff                                    */
/*==============================================================*/
drop table if exists wms.wms_agv_task_staff;
drop
sequence if exists  wms_agv_task_staff_id_seq;
create
sequence wms_agv_task_staff_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_agv_task_staff
(
    "id"             int4 not null default nextval('wms.wms_agv_task_staff_id_seq'::regclass),
    "task_id"        int4,
    "staff_id"       int4,
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4          DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4          DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_agv_task_staff_pkey" primary key ("id")
);


alter table "wms"."wms_agv_task_staff"
    owner to "cloudmes";

create index iX_wms_agv_task_staff_org_code on "wms"."wms_agv_task_staff" ("org_code");
create index iX_wms_agv_task_staff_task_id on "wms"."wms_agv_task_staff" ("task_id");
create index iX_wms_agv_task_staff_is_deleted on "wms"."wms_agv_task_staff" ("is_deleted");


comment on column "wms"."wms_agv_task_staff"."id" is '主键';
comment on column "wms"."wms_agv_task_staff"."task_id" is '任务id';
comment on column "wms"."wms_agv_task_staff"."staff_id" is '员工id';
comment on column "wms"."wms_agv_task_staff"."org_code" is '组织编码';
comment on column "wms"."wms_agv_task_staff"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_agv_task_staff"."deleted_dt" is '删除时间';
comment on column "wms"."wms_agv_task_staff"."creator" is '创建人';
comment on column "wms"."wms_agv_task_staff"."creator_id" is '创建人id';
comment on column "wms"."wms_agv_task_staff"."created_dt" is '创建时间';
comment on column "wms"."wms_agv_task_staff"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_agv_task_staff"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_agv_task_staff"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_agv_task_staff" is ' agv任务人员信息表';


/*==============================================================*/
/* table: wms_agv_temp_material_label                      */
/*==============================================================*/
drop table if exists wms.wms_agv_temp_material_label;
CREATE TABLE "wms"."wms_agv_temp_material_label"
(
    "label_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "shelves_code"   varchar(64) COLLATE "pg_catalog"."default",
    "status"         int4 DEFAULT 0,
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4 DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4 DEFAULT 0,
    "last_edited_dt" int8
)
;

ALTER TABLE "wms"."wms_agv_temp_material_label"
    OWNER TO "cloudmes";

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."label_no" IS '标签号';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."material_no" IS '物料编码';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."shelves_code" IS '货架号';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."status" IS '状态；0.AGV执行上架；1.上架；2.AGV执行下架；3.下架';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."org_code" IS '组织编码';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."creator" IS '创建人';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."creator_id" IS '创建人id';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."created_dt" IS '创建时间';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."last_editor" IS '最后一次编辑人';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."last_editor_id" IS '最后一次编辑人id';

COMMENT ON COLUMN "wms"."wms_agv_temp_material_label"."last_edited_dt" IS '最后一次编辑时间';

COMMENT ON TABLE "wms"."wms_agv_temp_material_label" IS 'AGV暂存料号信息表';



/*==============================================================*/
/* table: wms_print_shelf_bin                                   */
/*==============================================================*/
drop table if exists wms.wms_print_shelf_bin;
drop
sequence if exists  wms_print_shelf_bin_id_seq;
create
sequence wms_print_shelf_bin_id_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_print_shelf_bin
(
    "id"             int4 not null default nextval('wms.wms_print_shelf_bin_id_seq'::regclass),
    "shelves_code"   varchar(64) COLLATE "pg_catalog"."default",
    "bin_code"       varchar(64) COLLATE "pg_catalog"."default",
    "time"           varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4          DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4          DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_print_shelf_bin_pkey" primary key ("id")
);


alter table "wms"."wms_print_shelf_bin"
    owner to "cloudmes";

create index iX_wms_print_shelf_bin_org_code on "wms"."wms_print_shelf_bin" ("org_code");
create index iX_wms_print_shelf_bin_created_dt on "wms"."wms_print_shelf_bin" ("created_dt");


comment on column "wms"."wms_print_shelf_bin"."id" is '主键';
comment on column "wms"."wms_print_shelf_bin"."shelves_code" is '货架';
comment on column "wms"."wms_print_shelf_bin"."bin_code" is '储位';
comment on column "wms"."wms_print_shelf_bin"."time" is '时间';
comment on column "wms"."wms_print_shelf_bin"."org_code" is '组织编码';
comment on column "wms"."wms_print_shelf_bin"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_print_shelf_bin"."deleted_dt" is '删除时间';
comment on column "wms"."wms_print_shelf_bin"."creator" is '创建人';
comment on column "wms"."wms_print_shelf_bin"."creator_id" is '创建人id';
comment on column "wms"."wms_print_shelf_bin"."created_dt" is '创建时间';
comment on column "wms"."wms_print_shelf_bin"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_print_shelf_bin"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_print_shelf_bin"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_print_shelf_bin" is ' WMS打印存储货架储位信息';



alter table "wms"."wms_inbound_order_purchase"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_inbound_order_purchase"."organization_code" is 'ERP所需组织编码';



/*==============================================================*/
/* table: wms_material_frozen_thaw                              */
/*==============================================================*/
drop table if exists wms.wms_material_frozen_thaw;
drop
sequence if exists  wms_material_frozen_thaw_seq;
create
sequence wms_material_frozen_thaw_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_material_frozen_thaw
(
    "id"               int4 not null default nextval('wms.wms_material_frozen_thaw_seq'::regclass),
    "frozen_no"        varchar(64) COLLATE "pg_catalog"."default",
    "frozen_parent_no" varchar(64) COLLATE "pg_catalog"."default",
    "order_type"       varchar(64) COLLATE "pg_catalog"."default",
    "status"           varchar(64) COLLATE "pg_catalog"."default",
    "material_no"      varchar(64) COLLATE "pg_catalog"."default",
    "material_name"    varchar(64) COLLATE "pg_catalog"."default",
    "warehouse_code"   varchar(64) COLLATE "pg_catalog"."default",
    "area_code"        varchar(64) COLLATE "pg_catalog"."default",
    "bin_code"         varchar(64) COLLATE "pg_catalog"."default",
    "lot_no"           varchar(64) COLLATE "pg_catalog"."default",
    "date_code"        varchar(64) COLLATE "pg_catalog"."default",
    "frozen_reason"    varchar(64) COLLATE "pg_catalog"."default",
    "remark"           varchar(64) COLLATE "pg_catalog"."default",
    "org_code"         varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"       bool          DEFAULT false,
    "deleted_dt"       int8,
    "creator"          varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"       int4          DEFAULT 0,
    "created_dt"       int8,
    "last_editor"      varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"   int4          DEFAULT 0,
    "last_edited_dt"   int8,
    constraint "wms_material_frozen_thaw_pkey" primary key ("id")
);


alter table "wms"."wms_material_frozen_thaw"
    owner to "cloudmes";

create index iX_wms_material_frozen_thaw_org_code on "wms"."wms_material_frozen_thaw" ("org_code");
create index iX_wms_material_frozen_thaw_is_deleted on "wms"."wms_material_frozen_thaw" ("is_deleted");


comment on column "wms"."wms_material_frozen_thaw"."id" is '主键';
comment on column "wms"."wms_material_frozen_thaw"."frozen_no" is '冻结或解冻单号';
comment on column "wms"."wms_material_frozen_thaw"."frozen_parent_no" is '冻结单号';
comment on column "wms"."wms_material_frozen_thaw"."order_type" is '单据类型';
comment on column "wms"."wms_material_frozen_thaw"."status" is '状态';
comment on column "wms"."wms_material_frozen_thaw"."material_no" is '物料编码';
comment on column "wms"."wms_material_frozen_thaw"."material_name" is '物料名称';
comment on column "wms"."wms_material_frozen_thaw"."warehouse_code" is '仓库编码';
comment on column "wms"."wms_material_frozen_thaw"."area_code" is '库区编码';
comment on column "wms"."wms_material_frozen_thaw"."bin_code" is '储位编码';
comment on column "wms"."wms_material_frozen_thaw"."lot_no" is '批次号';
comment on column "wms"."wms_material_frozen_thaw"."date_code" is 'DC code';
comment on column "wms"."wms_material_frozen_thaw"."frozen_reason" is '冻结原因';
comment on column "wms"."wms_material_frozen_thaw"."remark" is '备注';
comment on column "wms"."wms_material_frozen_thaw"."org_code" is '组织编码';
comment on column "wms"."wms_material_frozen_thaw"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_material_frozen_thaw"."deleted_dt" is '删除时间';
comment on column "wms"."wms_material_frozen_thaw"."creator" is '创建人';
comment on column "wms"."wms_material_frozen_thaw"."creator_id" is '创建人id';
comment on column "wms"."wms_material_frozen_thaw"."created_dt" is '创建时间';
comment on column "wms"."wms_material_frozen_thaw"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_material_frozen_thaw"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_material_frozen_thaw"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_material_frozen_thaw" is ' 物料冻结or解冻表';



/*==============================================================*/
/* table: wms_material_frozen_thaw_detail                       */
/*==============================================================*/
drop table if exists wms.wms_material_frozen_thaw_detail;
drop
sequence if exists  wms_material_frozen_thaw_detail_seq;
create
sequence wms_material_frozen_thaw_detail_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
create table wms.wms_material_frozen_thaw_detail
(
    "id"                      int4 not null default nextval('wms.wms_material_frozen_thaw_detail_seq'::regclass),
    "material_frozen_thaw_id" int4,
    "label_no"                varchar(64) COLLATE "pg_catalog"."default",
    "line_status"             varchar(64) COLLATE "pg_catalog"."default",
    "material_no"             varchar(64) COLLATE "pg_catalog"."default",
    "material_name"           varchar(64) COLLATE "pg_catalog"."default",
    "qty"                     numeric(11, 3),
    "lot_no"                  varchar(64) COLLATE "pg_catalog"."default",
    "org_code"                varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"              bool          DEFAULT false,
    "deleted_dt"              int8,
    "creator"                 varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"              int4          DEFAULT 0,
    "created_dt"              int8,
    "last_editor"             varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"          int4          DEFAULT 0,
    "last_edited_dt"          int8,
    constraint "wms_material_frozen_thaw_detail_pkey" primary key ("id")
);


alter table "wms"."wms_material_frozen_thaw_detail"
    owner to "cloudmes";

create index iX_wms_material_frozen_thaw_detail_org_code on "wms"."wms_material_frozen_thaw_detail" ("org_code");
create index iX_wms_material_frozen_thaw_detail_main_id on "wms"."wms_material_frozen_thaw_detail" ("material_frozen_thaw_id");
create index iX_wms_material_frozen_thaw_detail_is_deleted on "wms"."wms_material_frozen_thaw_detail" ("is_deleted");


comment on column "wms"."wms_material_frozen_thaw_detail"."id" is '主键';
comment on column "wms"."wms_material_frozen_thaw_detail"."material_frozen_thaw_id" is '冻结或解冻主表id';
comment on column "wms"."wms_material_frozen_thaw_detail"."label_no" is '标签号';
comment on column "wms"."wms_material_frozen_thaw_detail"."line_status" is '行状态';
comment on column "wms"."wms_material_frozen_thaw_detail"."material_no" is '物料编码';
comment on column "wms"."wms_material_frozen_thaw_detail"."material_name" is '物料名称';
comment on column "wms"."wms_material_frozen_thaw_detail"."qty" is '数量';
comment on column "wms"."wms_material_frozen_thaw_detail"."lot_no" is '批次号';
comment on column "wms"."wms_material_frozen_thaw_detail"."org_code" is '组织编码';
comment on column "wms"."wms_material_frozen_thaw_detail"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_material_frozen_thaw_detail"."deleted_dt" is '删除时间';
comment on column "wms"."wms_material_frozen_thaw_detail"."creator" is '创建人';
comment on column "wms"."wms_material_frozen_thaw_detail"."creator_id" is '创建人id';
comment on column "wms"."wms_material_frozen_thaw_detail"."created_dt" is '创建时间';
comment on column "wms"."wms_material_frozen_thaw_detail"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_material_frozen_thaw_detail"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_material_frozen_thaw_detail"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_material_frozen_thaw_detail" is ' 物料冻结or解冻表标签明细表';



alter table "wms"."wms_inbound_order_purchase"
    add column "accept_order_id" int4;

comment on column "wms"."wms_inbound_order_purchase"."accept_order_id" is 'ERP验收单id';



alter table "wms"."wms_outbound_order_wo"
    add column "accept_order_id" int4;

comment on column "wms"."wms_outbound_order_wo"."accept_order_id" is 'ERP主单id';



alter table "wms"."wms_outbound_order_wo"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_outbound_order_wo"."organization_code" is 'ERP所需组织编码';



alter table "wms"."wms_outbound_order_purchase"
    add column "accept_order_id" int4;

comment on column "wms"."wms_outbound_order_purchase"."accept_order_id" is 'ERP主单id';



alter table "wms"."wms_outbound_order_purchase"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_outbound_order_purchase"."organization_code" is 'ERP所需组织编码';


alter table "wms"."wms_inbound_order_wo"
    add column "accept_order_id" int4;

comment on column "wms"."wms_inbound_order_wo"."accept_order_id" is 'ERP主单id';



alter table "wms"."wms_inbound_order_wo"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_inbound_order_wo"."organization_code" is 'ERP所需组织编码';


alter table "wms"."wms_inbound_order_others"
    add column "accept_order_id" int4;

comment on column "wms"."wms_inbound_order_others"."accept_order_id" is 'ERP主单id';



alter table "wms"."wms_inbound_order_others"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_inbound_order_others"."organization_code" is 'ERP所需组织编码';


alter table "wms"."wms_outbound_order_others"
    add column "accept_order_id" int4;

comment on column "wms"."wms_outbound_order_others"."accept_order_id" is 'ERP主单id';



alter table "wms"."wms_outbound_order_others"
    add column "organization_code" varchar(64);

comment on column "wms"."wms_outbound_order_others"."organization_code" is 'ERP所需组织编码';



/*==============================================================*/
/* table: wms_erp_to_wms_wo_picking_detail                      */
/*==============================================================*/
drop table if exists wms.wms_erp_to_wms_wo_picking_detail;
drop
sequence if exists  wms_erp_to_wms_wo_picking_detail_seq;
create
sequence wms_erp_to_wms_wo_picking_detail_seq
start
with 1
increment by 1
no minvalue
no maxvalue
cache
1;
CREATE TABLE wms.wms_erp_to_wms_wo_picking_detail
(
    "id"                          int4 not null default nextval('wms.wms_erp_to_wms_wo_picking_detail_seq'::regclass),
    "outbound_order_wo_id"        int4,
    "outbound_order_wo_detail_id" int4,
    "accept_order_id"             int4,
    "organization_code"           varchar(64) COLLATE "pg_catalog"."default",
    "erp_order_no"                varchar(64) COLLATE "pg_catalog"."default",
    "wo_no"                       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"                 varchar(64) COLLATE "pg_catalog"."default",
    "qty"                         varchar(64) COLLATE "pg_catalog"."default",
    "created_dt"                  int8
);

alter table "wms"."wms_erp_to_wms_wo_picking_detail"
    owner to "cloudmes";



create index iX_wms_erp_to_wms_wo_picking_detail_detail_id on "wms"."wms_erp_to_wms_wo_picking_detail" ("outbound_order_wo_detail_id");
create index iX_wms_erp_to_wms_wo_picking_detail_wo_id on "wms"."wms_erp_to_wms_wo_picking_detail" ("outbound_order_wo_id");

comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."id" is 'id';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."outbound_order_wo_id" is '工单出库表id';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."outbound_order_wo_detail_id" is '工单出库明细表id';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."accept_order_id" is 'ERP_ID';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."organization_code" is 'ERP_CODE';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."erp_order_no" is 'ERP单号';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."wo_no" is '工单号';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."material_no" is '料号';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."qty" is '数量';
comment on column "wms"."wms_erp_to_wms_wo_picking_detail"."created_dt" is '创建时间';
comment on table "wms"."wms_erp_to_wms_wo_picking_detail" is 'WMS与ERP工单出库明细中间表';


alter table "wms"."wms_outbound_order_wo_detail"
    add column "erp_source_location" varchar(64);
comment on column "wms"."wms_outbound_order_wo_detail"."erp_source_location" is 'ERP来源位置信息';

alter table "wms"."wms_outbound_order_others"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_outbound_order_others"."keeper_code" is 'ERP Keeper Code';

alter table "wms"."wms_outbound_order_purchase"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_outbound_order_purchase"."keeper_code" is 'ERP Keeper Code';

alter table "wms"."wms_outbound_order_wo"
    add column "line_code" varchar(64);
comment on column "wms"."wms_outbound_order_wo"."line_code" is 'ERP线别代码';

alter table "wms"."wms_outbound_order_wo"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_outbound_order_wo"."keeper_code" is 'ERP Keeper Code';

alter table "wms"."wms_outbound_order_wo_detail"
    add column "erp_source_location" varchar(64);
comment on column "wms"."wms_outbound_order_wo_detail"."erp_source_location" is 'ERP来源位置信息';

alter table "wms"."wms_inbound_order_others"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_inbound_order_others"."keeper_code" is 'ERP Keeper Code';

alter table "wms"."wms_inbound_order_purchase"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_inbound_order_purchase"."keeper_code" is 'ERP Keeper Code';

alter table "wms"."wms_inbound_order_wo"
    add column "keeper_code" varchar(64);
comment on column "wms"."wms_inbound_order_wo"."keeper_code" is 'ERP Keeper Code';

/*==============================================================*/
/* add unique keys                                              */
/*==============================================================*/
ALTER TABLE wms.wms_stock_lot
    ADD CONSTRAINT uk_wms_stock_lot UNIQUE (lot_no, bin_code, material_no, org_code);

ALTER TABLE wms.wms_stock
    ADD CONSTRAINT uk_wms_stock UNIQUE (bin_code, material_no, org_code);

ALTER TABLE wms.wms_material_label
    ADD CONSTRAINT uk_wms_material_label UNIQUE (label_no, org_code);

ALTER TABLE wms.wms_material_label_position
    ADD CONSTRAINT uk_wms_material_label_position UNIQUE (material_label_id, org_code);

/*==============================================================*/
/* others出入库增加erp_bin                                        */
/*==============================================================*/
ALTER TABLE "wms"."wms_inbound_order_others"
    ADD COLUMN "erp_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_inbound_order_others"."erp_bin" IS 'ERP储位';

ALTER TABLE "wms"."wms_outbound_order_others"
    ADD COLUMN "erp_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_outbound_order_others"."erp_bin" IS 'ERP储位';

/*==============================================================*/
/* label出入库增加上架与下架储位、入库与出库储位                        */
/*==============================================================*/

ALTER TABLE "wms"."wms_inbound_order_label"
    ADD COLUMN "putaway_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_inbound_order_label"."putaway_bin" IS '上架储位';

ALTER TABLE "wms"."wms_inbound_order_label"
    ADD COLUMN "inbound_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_inbound_order_label"."inbound_bin" IS '入库储位';


ALTER TABLE "wms"."wms_outbound_order_label"
    ADD COLUMN "take_off_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_outbound_order_label"."take_off_bin" IS '下架储位';

ALTER TABLE "wms"."wms_outbound_order_label"
    ADD COLUMN "outbound_bin" varchar(255);
COMMENT ON COLUMN "wms"."wms_outbound_order_label"."outbound_bin" IS '出库储位';


/*==============================================================*/
/* table: wms_erp_material_keeper                       */
/*==============================================================*/
drop table if exists wms.wms_erp_material_keeper;
drop
sequence if exists  wms_erp_material_keeper_id_seq;
create
sequence wms_erp_material_keeper_id_seq
    start
with 1
    increment by 1
    no minvalue
    no maxvalue
    cache
1;
create table wms.wms_erp_material_keeper
(
    "id"                 int4 not null default nextval('wms.wms_erp_material_keeper_id_seq'::regclass),
    "material_no"        varchar(64) COLLATE "pg_catalog"."default",
    "keeper_code"        varchar(64) COLLATE "pg_catalog"."default",
    "keeper_employee_no" varchar(64) COLLATE "pg_catalog"."default",
    "org_code"           varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"         bool          DEFAULT false,
    "deleted_dt"         int8,
    "creator"            varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"         int4          DEFAULT 0,
    "created_dt"         int8,
    "last_editor"        varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id"     int4          DEFAULT 0,
    "last_edited_dt"     int8,
    constraint "wms_erp_material_keeper_pkey" primary key ("id")
);


alter table "wms"."wms_erp_material_keeper"
    owner to "cloudmes";

create index ix_wms_erp_material_keeper_org_code on "wms"."wms_erp_material_keeper" ("org_code");
create index ix_wms_erp_material_keeper_keeper_code on "wms"."wms_erp_material_keeper" ("keeper_code");
create index ix_wms_erp_material_keeper_material_no on "wms"."wms_erp_material_keeper" ("material_no");
create index ix_wms_erp_material_keeper_is_deleted on "wms"."wms_erp_material_keeper" ("is_deleted");

comment on column "wms"."wms_erp_material_keeper"."id" is '主键';
comment on column "wms"."wms_erp_material_keeper"."material_no" is '物料编码';
comment on column "wms"."wms_erp_material_keeper"."keeper_code" is 'KeeperCode';
comment on column "wms"."wms_erp_material_keeper"."keeper_employee_no" is 'Keeper工号';
comment on column "wms"."wms_erp_material_keeper"."org_code" is '组织编码';
comment on column "wms"."wms_erp_material_keeper"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_erp_material_keeper"."deleted_dt" is '删除时间';
comment on column "wms"."wms_erp_material_keeper"."creator" is '创建人';
comment on column "wms"."wms_erp_material_keeper"."creator_id" is '创建人id';
comment on column "wms"."wms_erp_material_keeper"."created_dt" is '创建时间';
comment on column "wms"."wms_erp_material_keeper"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_erp_material_keeper"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_erp_material_keeper"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_erp_material_keeper" is ' 物料与Keeper关系表';


/*==============================================================*/
/* table: 删除data_status                                        */
/*==============================================================*/

ALTER TABLE "wms"."wms_material_batch_program"
    DROP COLUMN "data_status";


alter table "wms"."wms_material_batch_program"
    add column "is_deleted" bool default false;

comment on column "wms"."wms_material_batch_program"."is_deleted" is '是否删除';



ALTER TABLE "wms"."wms_material_batch_program_detail"
    DROP COLUMN "data_status";


alter table "wms"."wms_material_batch_program_detail"
    add column "is_deleted" bool default false;

comment on column "wms"."wms_material_batch_program_detail"."is_deleted" is '是否删除';



ALTER TABLE "wms"."wms_material_bin"
    ALTER COLUMN "is_deleted" SET DEFAULT false;



/*==============================================================*/
/* table: wms_material_bin_rule                       */
/*==============================================================*/
drop table if exists wms.wms_material_bin_rule;
drop
sequence if exists wms.wms_material_bin_rule_id_seq;
CREATE
SEQUENCE "wms"."wms_material_bin_rule_id_seq"
    INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START
1
CACHE
1;
SELECT setval('"wms"."wms_material_bin_rule_id_seq"', 0, true);
ALTER
SEQUENCE "wms"."wms_material_bin_rule_id_seq" OWNER TO "cloudmes";
CREATE TABLE "wms"."wms_material_bin_rule"
(
    "id"             int4 NOT NULL DEFAULT nextval('"wms".wms_material_bin_rule_id_seq'::regclass),
    "material_rule"  varchar(64) COLLATE "pg_catalog"."default",
    "bin_rule"       varchar(64) COLLATE "pg_catalog"."default",
    "remark"         varchar(255) COLLATE "pg_catalog"."default",
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4,
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "created_dt"     int8,
    "last_edited_dt" int8,
    "is_deleted"     bool          DEFAULT false,
    CONSTRAINT "wms_material_bin_rule_pkey" PRIMARY KEY ("id")
)
;

ALTER TABLE "wms"."wms_material_bin_rule"
    OWNER TO "cloudmes";

COMMENT ON COLUMN "wms"."wms_material_bin_rule"."id" IS '主键id';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."material_rule" IS '料号规则';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."bin_rule" IS '储位规则';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."remark" IS '备注';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."creator" IS '创建人code';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."creator_id" IS '创建人id';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."last_editor" IS '最后一次编辑人code';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."last_editor_id" IS '最后一次编辑人id';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."org_code" IS '工厂组织';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."created_dt" IS '创建时间';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."last_edited_dt" IS '最后一次编辑时间';
COMMENT ON COLUMN "wms"."wms_material_bin_rule"."is_deleted" IS '是否删除';
COMMENT ON TABLE "wms"."wms_material_bin_rule" IS '储位料号关系规则表';


/*==============================================================*/
/* table: wms_agv_task_config                                   */
/*==============================================================*/

alter table "wms"."wms_agv_task_config"
    add column "shelves_config" varchar(255);

comment on column "wms"."wms_agv_task_config"."shelves_config" is '存放货架配置';


/*==============================================================*/
/* table: wms_agv_task_config                                   */
/*==============================================================*/

alter table "wms"."wms_agv_task_config"
    add column "remark" varchar(255);

comment on column "wms"."wms_agv_task_config"."remark" is '备注';


ALTER TABLE wms.wms_inbound_order_purchase_detail
    ALTER COLUMN lot_no TYPE VARCHAR (256);

ALTER TABLE wms.wms_inbound_order_hk_detail
    ALTER COLUMN lot_no TYPE VARCHAR (256);

ALTER TABLE wms.wms_inbound_order_wo_detail
    ALTER COLUMN lot_no TYPE VARCHAR (256);

ALTER TABLE wms.wms_inbound_order_others_detail
    ALTER COLUMN lot_no TYPE VARCHAR (256);

ALTER TABLE wms.wms_outbound_order_wo
    ALTER COLUMN sap_proof_no TYPE VARCHAR (2056);

ALTER TABLE wms.wms_outbound_order_others
    ALTER COLUMN sap_proof_no TYPE VARCHAR (2056);

ALTER TABLE wms.wms_outbound_order_purchase
    ALTER COLUMN sap_proof_no TYPE VARCHAR (2056);

/** 盘点单修改脚本 **/
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN warehouse_name TYPE character varying (256) COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN area_name TYPE character varying (256) COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN bin_name TYPE character varying (2048) COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN material_no TYPE character varying (2048) COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN material_name TYPE character varying (2048) COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN inventory_detail TYPE character varying (2048) COLLATE pg_catalog."default";

/** 修改数据表栏位 数字小数位数 */
SELECT format(
               'ALTER TABLE %I.%I ALTER COLUMN %I TYPE numeric(18, 5);',
               table_schema,
               table_name,
               column_name
       ) AS alter_sql
FROM information_schema.columns
WHERE table_schema = 'wms'
  AND data_type = 'numeric'
ORDER BY table_name, ordinal_position;

INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2067444892469497858, NULL, 17, 'WMS', 'import-third', '导入库存', 1986350873501437954, '1', '2', '', '', 4, 'f',
        'f', '', 'warehouse-sotck:import-third', 'f', 'f', '', 2, 'platform', 0, 1781752248291, 'platform', 0,
        1781752331965, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2067444673245810689, NULL, 17, 'WMS', 'sync-third', '同步库存', 1986350873501437954, '1', '2', '', '', 3, 'f',
        'f', '', 'warehouse-stock:sync-third', 'f', 'f', '', 2, 'platform', 0, 1781752196024, 'platform', 0,
        1781752353595, NULL, NULL);

INSERT INTO "basic_sys"."sys_dict" ("dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES ('WMS_INVENTORY_CHECK_TYPE', 'CHANGES', '异动盘点', 70, NULL, NULL, NULL, NULL, 'MC00051', 4, 1781765070936,
        'MC00051', 4, 1781765070936, 'f');
INSERT INTO "basic_sys"."sys_dict" ("dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES ('WMS_INVENTORY_CHECK_TYPE', 'CYCLICAL', '循环盘点', 60, NULL, NULL, NULL, NULL, 'MC00051', 4, 1781764927921,
        'MC00051', 4, 1781764927921, 'f');


alter table "wms"."wms_inventory"
    rename column "review_person" to "review_person_code";
comment on column "wms"."wms_inventory"."review_person_code" is '审核人编码';


alter table "wms"."wms_inventory"
    add column if not exists "review_person_name" varchar (64);
comment on column "wms"."wms_inventory"."review_person_name" is '审核人姓名';

alter table "wms"."wms_inventory"
    add column if not exists "assign_person_code" varchar (64);
comment on column "wms"."wms_inventory"."assign_person_code" is '分配人编码';

alter table "wms"."wms_inventory"
    add column if not exists "assign_person_name" varchar (64);
comment on column "wms"."wms_inventory"."assign_person_name" is '分配人姓名';

ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN material_no TYPE text COLLATE pg_catalog."default";
ALTER TABLE wms.wms_inventory_range
    ALTER COLUMN material_name TYPE text COLLATE pg_catalog."default";

--新增菜单及字典
INSERT INTO "basic_sys"."sys_dict_type" ("id", "dict_type_name", "dict_type_type", "dict_en_name", "dict_tw_name",
                                         "dict_zh_name", "creator", "creator_id", "created_dt", "last_editor",
                                         "last_editor_id", "last_edited_dt", "is_deleted")
VALUES (667, 'WMS CKD出货装箱状态', 'WMS_SHIPMENT_PACKING_CKD_STATUS', NULL, NULL, NULL, 'MC00051', 4, 1782814175612,
        'MC00051', 4, 1782814175612, 'f');

INSERT INTO "basic_sys"."sys_dict" ("id", "dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES (3520, 'WMS_SHIPMENT_PACKING_CKD_STATUS', 'PACKED', '已装箱', 20, NULL, NULL, NULL, NULL, 'MC00051', 4,
        1782814302712, 'MC00051', 4, 1782814302712, 'f');
INSERT INTO "basic_sys"."sys_dict" ("id", "dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES (3521, 'WMS_SHIPMENT_PACKING_CKD_STATUS', 'PALLETING', '上栈板', 30, NULL, NULL, NULL, NULL, 'MC00051', 4,
        1782814333470, 'MC00051', 4, 1782814333470, 'f');
INSERT INTO "basic_sys"."sys_dict" ("id", "dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES (3522, 'WMS_SHIPMENT_PACKING_CKD_STATUS', 'COMPLETED', '已完成', 40, NULL, NULL, NULL, NULL, 'MC00051', 4,
        1782814344006, 'MC00051', 4, 1782814344006, 'f');
INSERT INTO "basic_sys"."sys_dict" ("id", "dict_type", "dict_code", "dict_name", "sort_no", "dict_desc", "dict_en_name",
                                    "dict_tw_name", "dict_zh_name", "creator", "creator_id", "created_dt",
                                    "last_editor", "last_editor_id", "last_edited_dt", "is_deleted")
VALUES (3523, 'WMS_SHIPMENT_PACKING_CKD_STATUS', 'OPEN', '开立', 10, NULL, NULL, NULL, NULL, 'MC00051', 4,
        1782814270901, 'MC00051', 4, 1782814270901, 'f');

INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072123782492262401, NULL, 17, '', 'shipment', '出货管理', 2000, '1', '1', '', '', 115000, 'f', 'f',
        'iconfont iconchejianwuliu', '', 'f', 'f', '', 2, 'platform', 0, 1782867782602, 'platform', 0, 1782867793145,
        NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072124165704847361, NULL, 17, '', 'ckd-packing', 'CKD出货装箱', 2072123782492262401, '1', '1',
        '/wms/shipment/ckd-packing', '', 115010, 'f', 'f', 'iconfont icongaojipaichan', '', 'f', 'f', '', 2, 'platform',
        0, 1782867873967, 'platform', 0, 1782867961644, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072124714596634625, NULL, 17, '', 'view', '查看', 2072124165704847361, '1', '2', '', '', 1, 'f', 'f', '',
        'ckd-picking:view', 'f', 'f', '', 2, 'platform', 0, 1782868004833, 'platform', 0, 1782868029128, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072124902136549377, NULL, 17, '', 'add', '新增', 2072124165704847361, '1', '2', '', '', 2, 'f', 'f', '',
        'ckd-picking:add', 'f', 'f', '', 2, 'platform', 0, 1782868049545, 'platform', 0, 1782868049545, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072124986676940801, NULL, 17, '', 'edit', '编辑', 2072124165704847361, '1', '2', '', '', 3, 'f', 'f', '',
        'ckd-picking:edit', 'f', 'f', '', 2, 'platform', 0, 1782868069702, 'platform', 0, 1782868069702, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072125064149929985, NULL, 17, '', 'delete', '删除', 2072124165704847361, '1', '2', '', '', 4, 'f', 'f', '',
        'ckd-picking:delete', 'f', 'f', '', 2, 'platform', 0, 1782868088173, 'platform', 0, 1782868088173, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072125790540468226, NULL, 17, '', 'export', '导出', 2072124165704847361, '1', '2', '', '', 5, 'f', 'f', '',
        'ckd-picking:export', 'f', 'f', '', 2, 'platform', 0, 1782868261358, 'platform', 0, 1782868261358, NULL, NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072125253417897986, NULL, 17, '', 'packing', '继续装箱', 2072124165704847361, '1', '2', '', '', 6, 'f', 'f',
        '', 'ckd-picking:packing', 'f', 'f', '', 2, 'platform', 0, 1782868133298, 'platform', 0, 1782868278619, NULL,
        NULL);
INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072125555680415746, NULL, 17, '', 'palleting', '继续上栈板', 2072124165704847361, '1', '2', '', '', 7, 'f',
        'f', '', 'ckd-picking:palleting', 'f', 'f', '', 2, 'platform', 0, 1782868205363, 'platform', 0, 1782868288118,
        NULL, NULL);

INSERT INTO "management"."plat_factory_route" ("id", "version_type", "module_id", "module_name", "function_code",
                                               "function_name", "parent_id", "terminal_type", "function_type", "path",
                                               "function_desc", "sort_no", "is_hide", "is_open", "source", "authorize",
                                               "is_out_link", "short_cut", "short_cut_icon", "route_type", "creator",
                                               "creator_id", "created_dt", "last_editor", "last_editor_id",
                                               "last_edited_dt", "product_type", "product_type_name")
VALUES (2072136573122973698, NULL, 6, '', 'app:wms:shipment-packing-ckd', 'CKD出货装箱', 1988790123803119617, '2', '1',
        '/warehouse/shipment/packing-ckd', '', 630, 'f', 'f',
        '/cloudpaas/upload/2026-07-01/851d24ae1531403fa15a9a9c814393c9.png', '', 'f', 'f', '', 2, 'platform', 0,
        1782870832126, 'platform', 0, 1782870832126, NULL, NULL);



/*==============================================================*/
/* table: wms_shipment_packing_ckd                              */
/*==============================================================*/
drop table if exists wms.wms_shipment_packing_ckd;
drop
sequence if exists  wms.wms_shipment_packing_ckd_id_seq;
create
sequence wms.wms_shipment_packing_ckd_id_seq
    start
with 1
    increment by 1
    no minvalue
    no maxvalue
    cache
1;

ALTER
SEQUENCE "wms"."wms_shipment_packing_ckd_id_seq" OWNER TO "cloudmes";

create table wms.wms_shipment_packing_ckd
(
    "id"             int4 not null default nextval('wms.wms_shipment_packing_ckd_id_seq'::regclass),
    "packing_no"     varchar(64) COLLATE "pg_catalog"."default",
    "packing_type"   varchar(64) COLLATE "pg_catalog"."default",
    "status"         varchar(64) COLLATE "pg_catalog"."default",
    "pallet_no"      varchar(64) COLLATE "pg_catalog"."default",
    "carton_no"      varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "packing_date"   int8,
    "mark_in"        varchar(64) COLLATE "pg_catalog"."default",
    "mark_out"       varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4          DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4          DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_shipment_packing_ckd_pkey" primary key ("id")
);


alter table "wms"."wms_shipment_packing_ckd"
    owner to "cloudmes";

create index ix_wms_shipment_packing_ckd_org_code on "wms"."wms_shipment_packing_ckd" ("org_code");
create index ix_wms_shipment_packing_ckd_is_deleted on "wms"."wms_shipment_packing_ckd" ("is_deleted");

comment on column "wms"."wms_shipment_packing_ckd"."id" is '主键';
comment on column "wms"."wms_shipment_packing_ckd"."packing_no" is '备料单号';
comment on column "wms"."wms_shipment_packing_ckd"."packing_type" is '装箱类型';
comment on column "wms"."wms_shipment_packing_ckd"."status" is '状态';
comment on column "wms"."wms_shipment_packing_ckd"."pallet_no" is '栈板号';
comment on column "wms"."wms_shipment_packing_ckd"."carton_no" is '箱号';
comment on column "wms"."wms_shipment_packing_ckd"."material_no" is '料号';
comment on column "wms"."wms_shipment_packing_ckd"."packing_date" is '装箱日期';
comment on column "wms"."wms_shipment_packing_ckd"."mark_in" is '唛头';
comment on column "wms"."wms_shipment_packing_ckd"."mark_out" is '港口';
comment on column "wms"."wms_shipment_packing_ckd"."org_code" is '组织编码';
comment on column "wms"."wms_shipment_packing_ckd"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_shipment_packing_ckd"."deleted_dt" is '删除时间';
comment on column "wms"."wms_shipment_packing_ckd"."creator" is '创建人';
comment on column "wms"."wms_shipment_packing_ckd"."creator_id" is '创建人id';
comment on column "wms"."wms_shipment_packing_ckd"."created_dt" is '创建时间';
comment on column "wms"."wms_shipment_packing_ckd"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_shipment_packing_ckd"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_shipment_packing_ckd"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_shipment_packing_ckd" is ' CKD出货装箱表';



/*==============================================================*/
/* table: wms_shipment_packing_label                            */
/*==============================================================*/
drop table if exists wms.wms_shipment_packing_label;
drop
sequence if exists  wms.wms_shipment_packing_label_id_seq;
create
sequence wms.wms_shipment_packing_label_id_seq
    start
with 1
    increment by 1
    no minvalue
    no maxvalue
    cache
1;

ALTER
SEQUENCE "wms"."wms_shipment_packing_label_id_seq" OWNER TO "cloudmes";

create table wms.wms_shipment_packing_label
(
    "id"             int4 not null default nextval('wms.wms_shipment_packing_label_id_seq'::regclass),
    "packing_ckd_id"        int4,
    "label_no"       varchar(64) COLLATE "pg_catalog"."default",
    "material_no"    varchar(64) COLLATE "pg_catalog"."default",
    "material_name"  varchar(64) COLLATE "pg_catalog"."default",
    "qty"            numeric(10, 5),
    "date_code"      varchar(64) COLLATE "pg_catalog"."default",
    "vendor_code"    varchar(64) COLLATE "pg_catalog"."default",
    "vendor_name"    varchar(64) COLLATE "pg_catalog"."default",
    "org_code"       varchar(64) COLLATE "pg_catalog"."default",
    "is_deleted"     bool          DEFAULT false,
    "deleted_dt"     int8,
    "creator"        varchar(64) COLLATE "pg_catalog"."default",
    "creator_id"     int4          DEFAULT 0,
    "created_dt"     int8,
    "last_editor"    varchar(64) COLLATE "pg_catalog"."default",
    "last_editor_id" int4          DEFAULT 0,
    "last_edited_dt" int8,
    constraint "wms_shipment_packing_label_pkey" primary key ("id")
);


alter table "wms"."wms_shipment_packing_label"
    owner to "cloudmes";

create index ix_wms_shipment_packing_label_org_code on "wms"."wms_shipment_packing_label" ("org_code");
create index ix_wms_shipment_packing_label_is_deleted on "wms"."wms_shipment_packing_label" ("is_deleted");

comment on column "wms"."wms_shipment_packing_label"."id" is '主键';
comment on column "wms"."wms_shipment_packing_label"."packing_ckd_id" is '装箱主键';
comment on column "wms"."wms_shipment_packing_label"."label_no" is '标签号';
comment on column "wms"."wms_shipment_packing_label"."material_no" is '料号';
comment on column "wms"."wms_shipment_packing_label"."material_name" is '品名规格';
comment on column "wms"."wms_shipment_packing_label"."qty" is '数量';
comment on column "wms"."wms_shipment_packing_label"."date_code" is 'DC';
comment on column "wms"."wms_shipment_packing_label"."vendor_code" is '供应商编码';
comment on column "wms"."wms_shipment_packing_label"."vendor_name" is '供应商名称';
comment on column "wms"."wms_shipment_packing_label"."org_code" is '组织编码';
comment on column "wms"."wms_shipment_packing_label"."is_deleted" is '0：有效，1：删除';
comment on column "wms"."wms_shipment_packing_label"."deleted_dt" is '删除时间';
comment on column "wms"."wms_shipment_packing_label"."creator" is '创建人';
comment on column "wms"."wms_shipment_packing_label"."creator_id" is '创建人id';
comment on column "wms"."wms_shipment_packing_label"."created_dt" is '创建时间';
comment on column "wms"."wms_shipment_packing_label"."last_editor" is '最后一次编辑人';
comment on column "wms"."wms_shipment_packing_label"."last_editor_id" is '最后一次编辑人id';
comment on column "wms"."wms_shipment_packing_label"."last_edited_dt" is '最后一次编辑时间';
comment on table "wms"."wms_shipment_packing_label" is ' 出货装箱标签表';

