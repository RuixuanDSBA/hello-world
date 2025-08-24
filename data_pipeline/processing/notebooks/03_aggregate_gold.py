# Databricks notebook source
# COMMAND ----------
# MAGIC %md
# MAGIC # 03 - Aggregate to Gold
# MAGIC - 构建聚合指标与空间汇总
# MAGIC - 输出 Gold 表供报表与查询使用

# COMMAND ----------
import os

curated_base = os.getenv("CURATED_BASE", "/mnt/datalake/curated/gssa")
gold_base = os.getenv("GOLD_BASE", "/mnt/datalake/gold/gssa")

# TODO: 从 Curated 生成 Gold 聚合表
print(f"[PLACEHOLDER] aggregate from {curated_base} to {gold_base}")