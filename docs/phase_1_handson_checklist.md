# Phase 1 Hands-on Acceptance Checklist

Complete these checks against the frozen v2 SQLite database before treating Phase 1 as personally complete. They are intentionally narrow; they test understanding needed for this portfolio rather than broad SQL fluency.

## Core checks

### Required independent checks — added 2026-09-19

Existing items below are guided practice, not proof of independence. Before passing, give Andy one new plain-language question at a time with exact column names and valid values, but no answer template. Require:

1. Independently write SELECT/FROM/WHERE for a new condition.
2. Independently write COUNT/GROUP BY/ORDER BY for a specified business breakdown.
3. Independently JOIN accounts and opportunities for a segment count; explain the key and check totals.
4. Read and modify an AI-generated CASE/CTE or subquery, predict what should change, and verify it. Explain a Window Function on a small teaching example if needed; do not add a portfolio query just to show syntax.
5. Explain closed win-rate versus snapshot conversion denominators and why activity pre-aggregation prevents double counting.

Documentation for syntax may be consulted. AI may explain after an attempt, but an AI-supplied answer or copied query is practice, not a pass; use a new equivalent question afterwards. Record attempt, assistance, result and explanation. These checks were completed on 2026-09-20; evidence and assistance levels are recorded below.

### Guided practice

1. Run `sql/01_sql_learning_basics.sql` and explain why each `GROUP BY` query returns one row per displayed group.
2. Change the Large-deal example filter from `deal_value_usd > 100000` to `deal_value_usd > 150000`; explain what changed and why this does not change the table's grain.
3. In the regional win-rate query, change `region` to `company_size`, run it, and verify that open opportunities remain outside the denominator.
4. Explain why joining `activities` directly to `opportunities` before computing a win rate would over-count opportunities.
5. In `sql/02_end_to_end_analysis.sql`, identify the numerator and denominator for closed-opportunity win rate and SLA breach rate.
6. Run `sql/01_validate_sql_analysis.sql` after one harmless query-comment change. Explain why the validation outputs should remain unchanged.

## Completion evidence

For each item, record:

- The query or line changed.
- The result observed.
- One sentence explaining the grain, filter, or denominator.

If a query result surprises you, do not rewrite the data. Use a smaller filtered `SELECT` to inspect the contributing records and rerun the validation script.

## Evidence recorded — 2026-09-20

| Acceptance item | Evidence | Status |
|---|---|---|
| Basic `SELECT` / `WHERE` / `COUNT` / `GROUP BY` / `ORDER BY` | Chat teaching evidence plus successful local-data checks | Supported |
| Independent segment JOIN | Grouped Won opportunities by company size: 109 + 106 + 40 = 255 | Pass |
| Guided JOIN practice | Grouped Lost opportunities by region; sorting was corrected after feedback; total = 265 | Guided only |
| Read and modify AI SQL | Changed activity-summary CTE threshold from `>= 5` to `>= 4`; predicted increase; result changed 267 to 739; difference 472 equals exactly-four-activity opportunities | Pass with AI-provided starting query |
| Explain KPI denominator and activity grain | Explained that Open has no known result and should not enter closed win-rate denominator; explained that one-to-many activities would duplicate each opportunity's single outcome unless first aggregated | Pass |

This evidence does not change the 50-hour budget and does not count Power BI work as started or completed.

**Phase 1 personal acceptance: PASS (2026-09-20).** Scope is limited to the agreed completion line and is not a claim of advanced independent SQL mastery.
