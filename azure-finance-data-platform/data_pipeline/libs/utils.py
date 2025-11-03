"""Utility helpers for configuring storage paths and checkpoints."""
from __future__ import annotations

import os
from typing import Dict


_DEFAULT_CONFIG = {
    "storage_account": os.environ.get("STORAGE_ACCOUNT_NAME", "stfinancedev"),
    "containers": {
        "landing": "landing",
        "bronze": "bronze",
        "silver": "silver",
        "gold": "gold",
        "logs": "logs",
    },
    "workspace": {
        "catalog": "finance_analytics",
    },
    "base_path": os.environ.get("DATALAKE_BASE_PATH", "abfss://{container}@{account}.dfs.core.windows.net"),
    "checkpoint_container": os.environ.get("CHECKPOINT_CONTAINER", "logs"),
}


def load_pipeline_config(overrides: Dict[str, str] | None = None) -> Dict[str, str]:
    """Load pipeline configuration with optional overrides."""
    config = {**_DEFAULT_CONFIG}
    if overrides:
        config.update(overrides)
    return config


def get_storage_path(config: Dict[str, str], container: str, table: str) -> str:
    """Build the storage path for a given container and table."""
    base_template = config.get("base_path", _DEFAULT_CONFIG["base_path"])
    account = config["storage_account"]
    container_name = config["containers"].get(container, container)
    return base_template.format(container=container_name, account=account).rstrip("/") + f"/{table}"


def get_checkpoint_path(config: Dict[str, str], layer: str, table: str | None = None) -> str:
    """Return a checkpoint path scoped by layer/table."""
    checkpoint_container = config["containers"].get("logs", config["checkpoint_container"])
    base_template = config.get("base_path", _DEFAULT_CONFIG["base_path"])
    account = config["storage_account"]
    base_path = base_template.format(container=checkpoint_container, account=account).rstrip("/")
    suffix = f"/{layer}"
    if table:
        suffix += f"/{table}"
    return base_path + suffix
