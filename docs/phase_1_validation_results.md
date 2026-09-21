# Phase 1 SQL Validation Results

2026-09-19 correction: the historical execution checks below were not, by themselves, personal-learning completion. Snapshot-aware SLA backlog is checked separately in `sql/03_quality_review.sql`; historical CSV baselines retain completed-only SLA semantics. See `data_quality_review.md`. Personal acceptance evidence was subsequently completed on 2026-09-20.

Validated on 2026-09-13 against the frozen Phase 0 v2 SQLite database and its checksummed CSV exports.

## SQL deliverables verified

| Deliverable | Status |
|---|---|
| `sql/01_sql_learning_basics.sql` | Executed successfully. |
| `sql/02_end_to_end_analysis.sql` | Executed successfully. |
| `sql/02_export_sql_baselines.sql` | Executed successfully. |
| `sql/01_validate_sql_analysis.sql` | All checks passed. |
| SQLite `PRAGMA integrity_check` | PASS: `ok` |

## Baseline exports for Power BI reconciliation

| File | Purpose | Rows excluding header | SHA-256 |
|---|---|---:|---|
| `data/processed/sql_kpi_baseline.csv` | Overall executive-KPI baseline | 1 | `fe3422388a3dc2367602e0ccc5492a1072ccbea867d5a5b29af04cc4113bb8dc` |
| `data/processed/sql_segment_performance.csv` | Region, company-size, industry, and deal-size KPI baseline | 15 | `64a7e24dbb60b942a0b6095e6e5840d5cde49dfe1b3bc3552f36452aa03ffcbf` |
| `data/processed/sql_onboarding_performance.csv` | Company-size onboarding and SLA baseline | 3 | `11d4d2ec216553066e0e4ad0a7feea32bdaea505fcacc68f86f016762f077d9b` |

These files are reconciliation controls for Phase 2. They are not dashboard source tables and do not replace calculations in the PBIX.

## Automated analytical checks

| Check | Result |
|---|---:|
| Opportunity-to-account join row-count difference | PASS: 0 |
| Activity aggregation row-count difference from opportunity grain | PASS: 0 |
| Opportunities with no generated activity | PASS: 0 |
| Funnel monotonicity violations | PASS: 0 |
| Won/Lost versus completed-outcome reconciliation difference | PASS: 0 |
| Negative closed sales-cycle records | PASS: 0 |
| Negative onboarding-cycle records | PASS: 0 |
| Activated SLA denominator reconciliation difference | PASS: 0 |
| Pending onboarding records incorrectly included in SLA denominator | PASS: 0 |

## Interpretation boundary

The SQL scripts calculate KPI baselines and prescribed comparisons. They do not yet select the three final findings, assign causal explanations, set management targets, or make recommendations. Those decisions remain Phase 3 work.

## Personal-learning acceptance

Technical execution alone does not prove independent understanding. The required hands-on checks and explanations are recorded below and in `docs/phase_1_handson_checklist.md`.

## Personal execution evidence — 2026-09-20

- Guided practice: Andy personally executed a region-level Lost-opportunity JOIN query in the read-only SQLite CLI. The first version sorted by `region`; after feedback, it was changed to `ORDER BY lost_count DESC`. Results were NA 92, APAC 75, EMEA 70, and LATAM 28, reconciling to 265 Lost opportunities. This is guided practice, not an independent pass.
- Independent basic/JOIN check: Andy independently wrote and executed an accounts-to-opportunities JOIN, filtered `outcome = 'Won'`, grouped by `company_size`, and sorted by `won_count DESC`. Results were SMB 109, Mid-market 106, and Enterprise 40; the total of 255 matches the source Won count.
- Assisted advanced-query check: Andy ran an AI-provided activity-summary CTE using `activity_count >= 5` and observed 267 opportunities. Andy correctly predicted that lowering the threshold to `>= 4` would increase the result, changed the query in the CLI, and observed 739.
- Independent reconciliation confirmed that 472 opportunities have exactly four activities, which equals `739 - 267`. The threshold modification therefore behaves as predicted.

The submitted SQL and numeric reconciliations pass. Andy correctly explained that Open opportunities are excluded from closed win rate because their outcome is not yet known, and that activities must first be aggregated to one row per opportunity because one opportunity can have many activities but only one outcome; otherwise the outcome would be duplicated and the resulting counts or win rate could be distorted.

**Phase 1 personal acceptance: PASS (2026-09-20).** This means the defined portfolio completion line has been met: independent basic SQL, an independent accounts-to-opportunities JOIN, and the ability to read, modify, predict, explain, and verify an AI-provided advanced query. It does not claim independent mastery of advanced SQL or eliminate the need to consult syntax documentation.
