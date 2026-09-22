# Reproduction and Refresh Runbook

Run all commands from the repository root. Required command-line dependency: SQLite 3.

## Review the frozen v2 analysis

These commands are read-only and do not change the packaged data:

```sh
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/00_validate_simulated_data.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/01_validate_sql_analysis.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/02_end_to_end_analysis.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/03_quality_review.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/04_phase3_comparisons.sql
```

Expected validation result: 15 structural checks PASS, 9 analysis checks PASS, quality-review violations equal zero, and SQLite integrity equals `ok`.

## Rebuild the simulated data without overwriting the package

Use a disposable directory because the export scripts write relative paths:

```sh
mkdir -p tmp/rebuild/data/processed tmp/rebuild/data/sample
cp -R sql tmp/rebuild/
cd tmp/rebuild
sqlite3 project_b_rebuild.sqlite < sql/00_generate_simulated_data.sql
sqlite3 project_b_rebuild.sqlite < sql/00_export_processed_data.sql
sqlite3 -readonly project_b_rebuild.sqlite < sql/00_validate_simulated_data.sql
sqlite3 -readonly project_b_rebuild.sqlite < sql/01_validate_sql_analysis.sql
sqlite3 -readonly project_b_rebuild.sqlite < sql/02_end_to_end_analysis.sql
sqlite3 -readonly project_b_rebuild.sqlite < sql/03_quality_review.sql
sqlite3 -readonly project_b_rebuild.sqlite < sql/04_phase3_comparisons.sql
```

The generator is deterministic. Rebuilt CSV checksums should match the frozen values recorded in `docs/phase_0_validation_results.md`.

## Refresh Power BI on another computer

Open only `powerbi/Project-B-Business-Operations-Analytics-v2.pbix`.

The PBIX imports these local files:

- `data/processed/accounts.csv`
- `data/processed/opportunities.csv`
- `data/processed/onboarding.csv`
- `data/processed/activities.csv`

If Power BI reports a missing source path:

1. Open **Transform data**.
2. For each of the four queries, edit the **Source** step or use **Data source settings > Change Source**.
3. Point it to the matching CSV under this repository's `data/processed/` directory.
4. Apply changes and refresh.
5. Reconcile the overall dashboard values with `data/processed/sql_kpi_baseline.csv` and company-size SLA values with `data/processed/sql_onboarding_performance.csv`.

Power BI Desktop authoring was completed on Windows 11 through Parallels. The PBIX is the editable report; screenshots are review aids, not substitutes for interaction testing.

