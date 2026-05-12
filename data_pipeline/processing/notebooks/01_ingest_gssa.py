# Databricks notebook source
# COMMAND ----------
# MAGIC %md
# MAGIC # 01 - Ingest GSSA
# MAGIC - 拉取 GSSA 数据（WFS/API/下载）
# MAGIC - 写入 ADLS Gen2 原始分区（Raw）

# COMMAND ----------
import os
from datetime import datetime

raw_base = os.getenv("RAW_BASE", "/mnt/datalake/raw/gssa")
execution_date = os.getenv("EXECUTION_DATE", datetime.utcnow().strftime("%Y-%m-01"))

# TODO: 根据 GSSA 端点实现实际拉取逻辑
print(f"[PLACEHOLDER] ingest to {raw_base}, for {execution_date}")