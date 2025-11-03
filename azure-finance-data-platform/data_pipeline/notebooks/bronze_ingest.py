# Databricks notebook source
from pyspark.sql.functions import input_file_name, current_timestamp
from pyspark.sql import SparkSession

from data_pipeline.libs import utils

spark = SparkSession.builder.getOrCreate()

config = utils.load_pipeline_config()

auto_loader_options = {
    "cloudFiles.format": "csv",
    "cloudFiles.inferColumnTypes": "true",
    "cloudFiles.schemaEvolutionMode": "addNewColumns",
    "cloudFiles.schemaLocation": utils.get_checkpoint_path(config, layer="bronze"),
}

landing_path = utils.get_storage_path(config, container="landing", table="transactions")
bronze_path = utils.get_storage_path(config, container="bronze", table="transactions")

raw_df = (
    spark.readStream.format("cloudFiles")
    .options(**auto_loader_options)
    .load(landing_path)
    .withColumn("ingest_file", input_file_name())
    .withColumn("ingest_ts", current_timestamp())
)

query = (
    raw_df.writeStream.format("delta")
    .option("checkpointLocation", utils.get_checkpoint_path(config, layer="bronze", table="transactions"))
    .outputMode("append")
    .trigger(availableNow=True)
    .start(bronze_path)
)

query.awaitTermination()
