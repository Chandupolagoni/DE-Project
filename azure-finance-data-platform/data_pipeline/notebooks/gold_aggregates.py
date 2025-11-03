# Databricks notebook source
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

from data_pipeline.libs import utils

spark = SparkSession.builder.getOrCreate()

config = utils.load_pipeline_config()
silver_path = utils.get_storage_path(config, container="silver", table="transactions")
gold_path = utils.get_storage_path(config, container="gold", table="daily_account_metrics")

silver_df = spark.read.format("delta").load(silver_path)

aggregated_df = (
    silver_df
    .withColumn("transaction_date", F.to_date("transaction_ts"))
    .groupBy("account_id", "transaction_date")
    .agg(
        F.count("transaction_id").alias("txn_count"),
        F.sum("amount").alias("total_amount"),
        F.avg("amount").alias("avg_ticket"),
        F.max("amount").alias("max_transaction"),
    )
    .withColumn("run_ts", F.current_timestamp())
)

(
    aggregated_df.write.mode("overwrite")
    .format("delta")
    .option("overwriteSchema", "true")
    .save(gold_path)
)
