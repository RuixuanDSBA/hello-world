-- Unity Catalog bootstrap (placeholder). Adjust names to your environment.
-- 目标：创建目录/模式、存储凭据、外部位置，以及基础权限。

-- 1) 基础命名（请替换）
-- 使用一个清晰、简短的业务名，便于跨团队沟通。
-- 例如：catalog gssa, schema bronze/raw, silver/curated, gold/gold

-- CREATE CATALOG IF NOT EXISTS gssa COMMENT '南澳地学与矿业数据（GSSA）主目录，面向分析与报表';
-- CREATE SCHEMA IF NOT EXISTS gssa.raw COMMENT '原始数据层（Raw），保留来源字段与原貌';
-- CREATE SCHEMA IF NOT EXISTS gssa.curated COMMENT '清洗标准化层（Curated），字段命名与类型统一';
-- CREATE SCHEMA IF NOT EXISTS gssa.gold COMMENT '聚合指标层（Gold），面向可视化与报表';

-- 2) 存储凭据与外部位置（示例，仅占位）
-- 需要先在云账户创建好存储账号与权限，再在 UC 中注册。
-- CREATE STORAGE CREDENTIAL gssa_kv_cred
--   WITH AZURE_MANAGED_IDENTITY
--   COMMENT '通过托管身份访问 ADLS Gen2 的凭据（示例）';

-- CREATE EXTERNAL LOCATION gssa_raw_loc URL 'abfss://raw@<storage>.dfs.core.windows.net/gssa'
--   WITH (STORAGE CREDENTIAL gssa_kv_cred)
--   COMMENT 'GSSA 原始层外部位置';

-- 3) 基础权限（按需收敛最小权限原则）
-- GRANT USAGE ON CATALOG gssa TO `data-engineers`, `data-analysts`;
-- GRANT CREATE, USAGE ON SCHEMA gssa.raw TO `data-engineers`;
-- GRANT SELECT ON ANY FILE TO `data-engineers`;
-- GRANT SELECT ON SCHEMA gssa.curated TO `data-analysts`;
-- GRANT SELECT ON SCHEMA gssa.gold TO `report-users`;

-- 4) 审计与注释规范
-- - 对 catalog/schema/table/column 添加 COMMENT，描述目的、来源、口径与更新时间；
-- - 使用简明语言，避免术语堆砌；首次出现的专有名词请在术语表中定义。