"""Databricks job entry point orchestrated through Databricks Asset Bundles.

This script is executed as part of the CI/CD job defined in ``databricks/bundle.yml``.
It performs lightweight configuration loading and routes execution to the selected
pipeline stage.  The implementation is intentionally minimal because the real
production logic lives in the project's notebooks and libraries.  Nevertheless,
this file demonstrates how to structure a Python-based job task that can be
referenced from a bundle configuration.
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path
from typing import Any, Dict

import yaml

try:
    from pyspark.sql import SparkSession
except ImportError:  # pragma: no cover - pyspark is not installed in local CI
    SparkSession = None  # type: ignore[assignment]


LOGGER = logging.getLogger("databricks.bundle.job")


def _load_config(config_path: Path) -> Dict[str, Any]:
    """Load a YAML configuration file.

    Parameters
    ----------
    config_path:
        The path to the YAML file that contains environment specific options.
    """

    if not config_path.exists():
        raise FileNotFoundError(f"Configuration file not found: {config_path}")

    with config_path.open("r", encoding="utf-8") as handle:
        config = yaml.safe_load(handle)

    if not isinstance(config, dict):
        raise ValueError("Configuration file must contain a dictionary at the top level.")

    return config


def _get_spark_session() -> SparkSession | None:
    """Return a SparkSession when PySpark is available.

    When the script executes on a developer workstation or during repository
    validation, PySpark might not be installed.  Returning ``None`` keeps the job
    lightweight while the real Databricks runtime provides the actual session.
    """

    if SparkSession is None:
        LOGGER.warning("PySpark is not available in the current environment.")
        return None

    return SparkSession.builder.appName("bundle-cicd-pipeline").getOrCreate()


def _run_stage(stage: str, config: Dict[str, Any], spark: SparkSession | None) -> None:
    """Dispatch execution to the requested pipeline stage."""

    LOGGER.info("Starting pipeline stage '%s' with configuration: %s", stage, config)

    if stage not in {"all", "ingestion", "transformation", "quality"}:
        raise ValueError(
            "Unsupported stage '%s'. Expected one of: all, ingestion, transformation, quality" % stage
        )

    if stage in {"all", "ingestion"}:
        LOGGER.info("Executing ingestion logic (placeholder).")
    if stage in {"all", "transformation"}:
        LOGGER.info("Executing transformation logic (placeholder).")
    if stage in {"all", "quality"}:
        LOGGER.info("Executing quality checks (placeholder).")

    if spark is not None:
        spark.sql("SELECT 'bundle pipeline executed' AS status").show(truncate=False)

    LOGGER.info("Stage '%s' completed successfully.", stage)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """Parse command line arguments for the job."""

    parser = argparse.ArgumentParser(description="Databricks bundle pipeline entry point")
    parser.add_argument("--config", type=Path, required=True, help="Path to the YAML configuration file")
    parser.add_argument(
        "--stage",
        choices=["all", "ingestion", "transformation", "quality"],
        default="all",
        help="Pipeline stage to execute",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> None:
    """Entry point executed by Databricks jobs."""

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s - %(message)s")

    args = parse_args(argv)
    config = _load_config(args.config)
    spark = _get_spark_session()
    _run_stage(args.stage, config, spark)


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except Exception as exc:  # pragma: no cover - defensive logging for job runs
        LOGGER.exception("Job failed: %s", exc)
        raise
