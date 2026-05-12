# Databricks notebook source
# COMMAND ----------
# MAGIC %md
# MAGIC # 02 - Standardize to Curated
# MAGIC - 统一字段与坐标系
# MAGIC - 输出 Delta/Parquet 到 Curated 层

# COMMAND ----------
import os

raw_base = os.getenv("RAW_BASE", "/mnt/datalake/raw/gssa")
curated_base = os.getenv("CURATED_BASE", "/mnt/datalake/curated/gssa")

# TODO: 读取 Raw，进行 Schema 对齐与坐标转换
print(f"[PLACEHOLDER] standardize from {raw_base} to {curated_base}")