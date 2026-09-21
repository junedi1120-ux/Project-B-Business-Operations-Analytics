# Phase 0 Environment Notes

## Decision

The project will use SQLite as its local analytical database for Phase 0 and Phase 1.

- SQLite CLI was verified at `/usr/bin/sqlite3` on 2026-09-13.
- DuckDB CLI was not detected. SQLite meets the approved "DuckDB or SQLite" tool requirement, so no new dependency will be installed.
- The dataset exchange contract for Power BI is four UTF-8 CSV files in `data/processed/`. The SQLite database is retained as the reproducible source.

## Power BI readiness

2026-09-19 gate: this host is an Apple Silicon Mac; no Windows/Power BI Desktop authoring environment has been confirmed. CSV handoff does not solve the authoring-platform requirement. [Microsoft's current Desktop requirements](https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-get-the-desktop) specify Windows. Confirm an existing usable Windows PC or remote Windows before Phase 2. No installation, purchase or account creation is authorized by this plan revision. Environment acceptance requires importing data, creating a relationship and measure, then saving and reopening a PBIX; browser access alone is not accepted as that test.

No Power BI Desktop application was confirmed in `/Applications` during Phase 0 environment inspection. This does not block synthetic-data generation or SQL work. Before Phase 2 begins, confirm a working Power BI environment that can import the four processed CSV files. If direct SQLite connectivity is unavailable, the CSV contract remains the supported path; no additional database, pipeline, or BI tool will be added.

## Reproducible run order

Run from the repository root:

```bash
sqlite3 data/processed/project_b_simulated.sqlite < sql/00_generate_simulated_data.sql
sqlite3 data/processed/project_b_simulated.sqlite < sql/00_export_processed_data.sql
sqlite3 data/processed/project_b_simulated.sqlite < sql/00_validate_simulated_data.sql
```

The generator uses deterministic integer formulas rather than SQLite's non-seeded `random()` function. Re-running it produces the same dataset.

## Scope boundary

This setup supports only the approved four-table simulated dataset and CSV handoff. It does not add Python, data engineering, forecasting, machine learning, a second dataset, or a second business case.
