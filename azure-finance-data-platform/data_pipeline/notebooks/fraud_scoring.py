# Databricks notebook source
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.ml.classification import LogisticRegressionModel
from pyspark.ml.feature import VectorAssembler
from pyspark.ml import Pipeline

from data_pipeline.libs import utils

spark = SparkSession.builder.getOrCreate()

config = utils.load_pipeline_config()
gold_path = utils.get_storage_path(config, container="gold", table="daily_account_metrics")
fraud_scores_path = utils.get_storage_path(config, container="gold", table="fraud_scores")

metrics_df = spark.read.format("delta").load(gold_path)

feature_df = metrics_df.fillna({"total_amount": 0.0, "avg_ticket": 0.0, "max_transaction": 0.0})
feature_df = feature_df.withColumn("txn_to_amount_ratio", F.col("txn_count") / F.when(F.col("total_amount") == 0, 1).otherwise(F.col("total_amount")))

assembler = VectorAssembler(
    inputCols=["txn_count", "total_amount", "avg_ticket", "max_transaction", "txn_to_amount_ratio"],
    outputCol="features",
)

pipeline = Pipeline(stages=[assembler])
assembled_df = pipeline.fit(feature_df).transform(feature_df)

# Load a pre-trained model if available, otherwise generate rule-based score.
model_path = utils.get_storage_path(config, container="gold", table="models/fraud_lr")
try:
    model = LogisticRegressionModel.load(model_path)
    scored_df = model.transform(assembled_df).select(
        "account_id",
        "transaction_date",
        F.col("probability").getItem(1).alias("fraud_probability"),
        F.col("prediction").alias("fraud_prediction"),
        F.current_timestamp().alias("scored_ts"),
    )
except Exception:
    scored_df = assembled_df.select(
        "account_id",
        "transaction_date",
        (F.col("max_transaction") > (F.col("avg_ticket") * 5)).cast("double").alias("fraud_probability"),
        (F.col("max_transaction") > (F.col("avg_ticket") * 8)).cast("double").alias("fraud_prediction"),
        F.current_timestamp().alias("scored_ts"),
    )

(
    scored_df.write.mode("overwrite")
    .format("delta")
    .option("overwriteSchema", "true")
    .save(fraud_scores_path)
)
