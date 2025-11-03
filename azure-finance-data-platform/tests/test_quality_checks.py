import pytest
from pyspark.sql import SparkSession
from pyspark.sql import Row

from data_pipeline.libs import quality_checks


@pytest.fixture(scope="session")
def spark():
    session = (
        SparkSession.builder.master("local[1]")
        .appName("quality-check-tests")
        .getOrCreate()
    )
    session.sparkContext.setLogLevel("ERROR")
    yield session
    session.stop()


def test_assert_no_nulls_passes(spark):
    df = spark.createDataFrame([Row(id="1", amount=100.0)])
    assert quality_checks.assert_no_nulls(df, ["id", "amount"]) is True


def test_assert_no_nulls_fails(spark):
    df = spark.createDataFrame([Row(id=None, amount=100.0)])
    with pytest.raises(ValueError):
        quality_checks.assert_no_nulls(df, ["id"])  # type: ignore[list-item]


def test_assert_positive(spark):
    df = spark.createDataFrame([Row(amount=10.0), Row(amount=1.2)])
    assert quality_checks.assert_positive(df, "amount") is True


def test_assert_positive_fails_on_zero(spark):
    df = spark.createDataFrame([Row(amount=0.0)])
    with pytest.raises(ValueError):
        quality_checks.assert_positive(df, "amount")


def test_assert_unique(spark):
    df = spark.createDataFrame([Row(id="1"), Row(id="2")])
    assert quality_checks.assert_unique(df, ["id"]) is True


def test_assert_unique_detects_duplicates(spark):
    df = spark.createDataFrame([Row(id="1"), Row(id="1")])
    with pytest.raises(ValueError):
        quality_checks.assert_unique(df, ["id"])
