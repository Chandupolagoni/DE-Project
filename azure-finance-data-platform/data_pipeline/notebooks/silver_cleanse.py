# Databricks notebook source
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import (StructType, StructField, StringType, DoubleType,
                               TimestampType)

from data_pipeline.libs import quality_checks, utils

spark = SparkSession.builder.getOrCreate()

config = utils.load_pipeline_config()
bronze_path = utils.get_storage_path(config, container="bronze", table="transactions")
silver_path = utils.get_storage_path(config, container="silver", table="transactions")

schema = StructType([
    StructField("transaction_id", StringType(), False),
    StructField("account_id", StringType(), False),
    StructField("transaction_ts", TimestampType(), False),
    StructField("amount", DoubleType(), False),
    StructField("currency", StringType(), False),
    StructField("ingest_ts", TimestampType(), True),
])

bronze_df = spark.read.format("delta").load(bronze_path)

clean_df = (
    bronze_df.select("transaction_id", "account_id", "transaction_ts", "amount", "currency", "ingest_ts")
    .dropDuplicates(["transaction_id"])
    .withColumn("currency", F.upper(F.col("currency")))
    .filter(F.col("amount") != 0)
)

validated_df = spark.createDataFrame(clean_df.rdd, schema=schema)

quality_checks.assert_no_nulls(validated_df, ["transaction_id", "account_id", "transaction_ts", "amount"])
quality_checks.assert_positive(validated_df, "amount", allow_zero=False)
quality_checks.assert_unique(validated_df, ["transaction_id"])

(
    validated_df.write.mode("overwrite")
    .format("delta")
    .option("overwriteSchema", "true")
    .save(silver_path)
)
