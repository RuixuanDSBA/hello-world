-- Unity Catalog DDL（示例，带本科生可读注释）
-- 目标：在 UC 下建立 Curated 与 Gold 层示例表，并给每个字段写清楚“是什么、单位/范围、为什么需要”。

-- 使用前：请先在 UC 中创建好 catalog/schema（见 infra/templates/unity_catalog_bootstrap.sql）。

-- 示例：Curated 层钻孔主表
-- 表说明：本表整理自 GSSA 钻孔数据，字段已统一命名与类型，坐标采用 WGS84，经纬度单位为度。
-- 数据更新：每月一次（通常在每月 1 日 UTC 后的 24 小时内完成）。

-- CREATE TABLE IF NOT EXISTS gssa.curated.drillhole (
--   drillhole_id STRING COMMENT '钻孔唯一编号：用于唯一标识一个钻孔，便于关联测井与样品数据',
--   hole_name STRING COMMENT '钻孔名称：数据源记录的可读名称，方便人工查找',
--   lat_wgs84 DOUBLE COMMENT '纬度（WGS84，度）：范围 -90 到 90，用于地图定位',
--   lon_wgs84 DOUBLE COMMENT '经度（WGS84，度）：范围 -180 到 180，用于地图定位',
--   collar_elevation_m DOUBLE COMMENT '孔口高程（米）：用于三维地形与地质解释',
--   start_date DATE COMMENT '开钻日期（YYYY-MM-DD）：用于时间序列分析（钻探活跃程度）',
--   end_date DATE COMMENT '完钻日期（YYYY-MM-DD）：和开钻日期一起用于计算钻探周期',
--   purpose STRING COMMENT '钻探目的（如勘探/科研/验证）：理解数据使用背景',
--   source_system STRING COMMENT '来源系统（如 GSSA/SARIG 具体数据集名）：便于追溯与核验',
--   record_updated_utc TIMESTAMP COMMENT '记录更新时间（UTC）：增量抽取与变更追踪使用'
-- )
-- COMMENT 'GSSA 钻孔数据的标准化表（Curated），用于分析与地图展示';

-- 示例：Gold 层按月份的钻探活跃度（按区域聚合）
-- 表说明：用于月度报告中的“钻探活跃度趋势”，按行政区或矿区聚合。

-- CREATE TABLE IF NOT EXISTS gssa.gold.drilling_activity_monthly (
--   period_month STRING COMMENT '月份（YYYY-MM）：用于时间序列可视化的维度',
--   region_name STRING COMMENT '区域名称（行政区或矿区）：用于地理聚合展示',
--   num_active_holes BIGINT COMMENT '当月活跃钻孔数量：衡量当月钻探活跃程度',
--   avg_duration_days DOUBLE COMMENT '当月平均钻探周期（天）：反映施工强度与复杂度',
--   metadata_json STRING COMMENT '聚合口径与数据来源说明（JSON）：便于审计与复现'
-- )
-- COMMENT '月度钻探活跃度指标（Gold），面向报表与趋势分析';