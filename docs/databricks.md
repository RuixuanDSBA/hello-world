# Databricks 使用说明（占位）

## 导入仓库/笔记本
- 方式一：Databricks Repos 连接此 Git 仓库；
- 方式二：将 `data_pipeline/processing/notebooks/*.py` 导入到工作区。

## 创建作业（Jobs）
- 使用 `infra/templates/databricks_job.json` 作为参考，通过 UI 或 `databricks-cli`/API 创建：
  - 配置 `notebook_path` 指向你的工作区路径；
  - 调整 `node_type_id`、`num_workers` 与 `spark_version`；
  - 根据需要设置 `RAW_BASE/CURATED_BASE/GOLD_BASE` 环境变量。

## 机密与存储
- 在 Key Vault/Databricks Secrets 中存储 GSSA 端点或令牌；
- 挂载 ADLS Gen2（可选），或直接使用 ABFS 路径访问；
- 为作业的服务主体授予最小访问权限（Storage Blob Data Contributor 等）。

## 运行与调度
- 在 Jobs 中配置 Quartz Cron（每月 1 日 03:00 UTC）；
- 或使用 `.github/workflows/run-databricks-job.yml` 以手动触发 `run-now`；
- 运行参数 `EXECUTION_DATE=YYYY-MM-01` 可覆盖默认值。