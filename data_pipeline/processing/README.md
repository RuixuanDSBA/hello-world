# processing（Databricks）

执行顺序（Notebook 占位示例）：
1. `notebooks/01_ingest_gssa.py`：采集 GSSA 原始数据 → Raw
2. `notebooks/02_standardize_curated.py`：标准化/投影转换 → Curated
3. `notebooks/03_aggregate_gold.py`：聚合指标/空间叠加 → Gold

环境变量（可在 Databricks Job 配置参数或集群环境变量中设置）：
- `RAW_BASE`（默认 `/mnt/datalake/raw/gssa`）
- `CURATED_BASE`（默认 `/mnt/datalake/curated/gssa`）
- `GOLD_BASE`（默认 `/mnt/datalake/gold/gssa`）
- `EXECUTION_DATE`（默认当月 1 日 UTC）

依赖：见 `requirements.txt`（仅占位，Databricks 可使用库安装或仓库依赖）。