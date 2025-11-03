# Operations Runbook

## Rerun Failed Jobs
1. Navigate to the Databricks workspace and open **Workflows > Jobs**.
2. Locate `finance-daily-batch` and select the failed run.
3. Review task output for bronze, silver, gold, and fraud tasks.
4. Fix any data or configuration issues, then click **Run now** to rerun the failed task or the full job.
5. Monitor the rerun until completion; verify Delta tables updated successfully.

## Backfill a Day
1. Identify the date range requiring backfill and gather raw files in the landing container.
2. Use the bronze Auto Loader notebook with an override parameter (`backfill_date`) to process files for that day.
3. Trigger the silver and gold notebooks manually with parameters specifying the backfill date.
4. Execute the fraud scoring notebook to regenerate fraud predictions for the backfilled period.
5. Validate aggregated metrics and fraud scores before releasing to downstream consumers.

## Incident Escalation
- Contact the data platform on-call engineer via Teams if failures persist beyond two retries.
- Escalate to the security team when masking policies or access controls behave unexpectedly.
- Document incidents in the operational log and create follow-up tasks for remediation.
