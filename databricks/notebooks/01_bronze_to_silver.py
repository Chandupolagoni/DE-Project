# Databricks notebook source
"""Bronze to Silver transformation notebook.

This placeholder notebook documents how the Databricks Asset Bundle deploys
workspace content.  Replace the logic with the real transformation steps.
"""

# COMMAND ----------

from pyspark.sql import functions as F

spark.conf.set("bundle.stage", "bronze_to_silver")

bronze_df = spark.range(0, 10).withColumn("ingested_at", F.current_timestamp())
bronze_df.createOrReplaceTempView("bronze_events")

# COMMAND ----------

silver_df = bronze_df.withColumn("status", F.lit("processed"))
silver_df.createOrReplaceTempView("silver_events")

# COMMAND ----------

silver_df.display()
