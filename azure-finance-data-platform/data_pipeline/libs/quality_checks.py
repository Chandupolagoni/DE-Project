"""Simple data quality checks for PySpark DataFrames."""
from __future__ import annotations

from pyspark.sql import DataFrame
from pyspark.sql import functions as F


def assert_no_nulls(df: DataFrame, columns: list[str]) -> bool:
    """Return True if specified columns contain no null values, otherwise raise a ValueError."""
    null_counts = df.select([F.count(F.when(F.col(col).isNull(), col)).alias(col) for col in columns]).collect()[0]
    failures = {col: null_counts[col] for col in columns if null_counts[col] > 0}
    if failures:
        raise ValueError(f"Null values found in columns: {failures}")
    return True


def assert_positive(df: DataFrame, column: str, allow_zero: bool = False) -> bool:
    """Ensure numeric column values are positive (or non-negative if allow_zero=True)."""
    comparator = F.col(column) >= 0 if allow_zero else F.col(column) > 0
    violations = df.filter(~comparator | F.col(column).isNull()).count()
    if violations:
        raise ValueError(f"Non-positive values detected in {column}: {violations} rows")
    return True


def assert_unique(df: DataFrame, columns: list[str]) -> bool:
    """Verify that the combination of columns is unique."""
    total = df.count()
    distinct = df.select(*columns).distinct().count()
    if total != distinct:
        raise ValueError(f"Duplicate keys detected for columns {columns}")
    return True
