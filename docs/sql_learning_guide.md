# Phase 1 SQL Learning Guide

## Purpose

The goal is not to memorise advanced SQL syntax. The goal is to explain, modify, and validate an end-to-end business-operations analysis using the frozen simulated dataset.

## Run order

Run these commands from the repository root:

```bash
sqlite3 data/processed/project_b_simulated.sqlite < sql/01_sql_learning_basics.sql
sqlite3 data/processed/project_b_simulated.sqlite < sql/02_end_to_end_analysis.sql
sqlite3 data/processed/project_b_simulated.sqlite < sql/02_export_sql_baselines.sql
sqlite3 data/processed/project_b_simulated.sqlite < sql/01_validate_sql_analysis.sql
```

`02_end_to_end_analysis.sql` is the portfolio's main analysis script. `01_create_analysis_views.sql` is a reusable setup file called by the end-to-end, export, and validation scripts.

## What Andy must be able to explain

1. **SELECT / WHERE / GROUP BY:** which rows are selected, which filters apply before aggregation, and what one output row represents.
2. **JOIN:** `accounts` is one-to-many with `opportunities`; raw `activities` is many-to-one with opportunities and therefore must be aggregated first for KPI analysis.
3. **CASE:** how stage, outcome, and follow-up categories are converted into business-readable groups.
4. **CTE:** why a named intermediate result can make a KPI calculation more readable and testable.
5. **Subquery:** why a scalar or grouped subquery can calculate a separate denominator without duplicating rows.
6. **Validation:** how to compare row counts, distinct opportunity counts, and complementary SLA / outcome totals after a query change.

## Deliberate exclusions

- No Window Function is included in the business-analysis script because none is necessary for the approved business questions.
- No query exists merely to demonstrate syntax.
- No Python, forecasting, machine learning, second dataset, or additional business case is introduced.

## AI usage rule

Use AI to explain an error, propose a first draft, or challenge a validation check. Before retaining any query, Andy should be able to answer:

- What business question does it answer?
- What is its unit of analysis?
- Which table supplies the numerator and denominator?
- Could this JOIN duplicate an opportunity?
- How would I spot-check one output number?

If any answer is unclear, revise the query or ask for an explanation before proceeding.
