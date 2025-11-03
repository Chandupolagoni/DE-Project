# Databricks notebook source
"""Silver to Gold aggregation notebook."""

# COMMAND ----------

from pyspark.sql import functions as F

spark.conf.set("bundle.stage", "silver_to_gold")

silver_df = spark.table("silver_events")

gold_df = silver_df.groupBy("status").agg(F.count("*").alias("record_count"))

gold_df.createOrReplaceTempView("gold_metrics")

gold_df.display()
