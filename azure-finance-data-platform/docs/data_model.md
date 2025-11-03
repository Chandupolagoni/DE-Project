# Data Model – Bronze, Silver, Gold

## Bronze Layer
- **Schema**: Flexible ingestion preserving source attributes.
- **Tables**: `transactions_bronze` (raw transactional feeds).
- **Key Columns**: `transaction_id`, `account_id`, ingestion metadata.
- **Purpose**: Immutable raw history with metadata for traceability.

## Silver Layer
- **Schema**: Structured DataFrame with enforced types and deduplicated keys.
- **Tables**: `transactions_silver` storing cleansed financial transactions.
- **Key Columns**: Standardized `currency`, `amount`, `transaction_ts`, quality validation results.
- **Purpose**: Ready for downstream aggregations, ensures referential integrity.

## Gold Layer
- **Schema**: Curated analytics datasets optimized for BI.
- **Tables**:
  - `daily_account_metrics` – aggregated KPIs per account per day.
  - `fraud_scores` – fraud probabilities and predictions.
- **Key Columns**: `account_id`, `transaction_date`, aggregated metrics, `fraud_probability`.
- **Purpose**: Serve executive dashboards, anomaly detection, and regulatory reporting.

## Catalog Organization
Unity Catalog organizes the model inside the `finance_analytics` catalog with schemas:
- `bronze` – external location mapped to bronze container.
- `silver` – cleansed tables with limited write access.
- `gold` – curated tables, restricted to analytics personas.
