# KPI Contract

This document fixes the calculation rules used throughout the SQL analysis and Power BI report.

## Common scope and grain

- **Source version:** the frozen processed CSV and SQLite dataset under `data/processed/`.
- **Opportunity grain:** one distinct `opportunity_id`.
- **Account segmentation:** `region`, `company_size`, and `industry` come from `accounts` through `opportunities.account_id`.
- **Deal-size segmentation:** `deal_size_band` comes from `opportunities`.
- **Completed sales outcome:** an opportunity with `outcome IN ('Won', 'Lost')`.
- **Activated onboarding scope:** an onboarding record with `onboarding_status = 'Activated'`. Unfinished records are excluded from completed cycle-time and completed SLA rate denominators, but are reported separately as backlog.
- **Snapshot date:** 2026-08-31. For unfinished cases, a due date before the snapshot is Overdue Open; due on the snapshot is not yet overdue.
- **Activity scope:** activity frequency is derived by counting `activities.activity_id` per opportunity. Activities are aggregated before joining to opportunity outcomes.
- **Date treatment:** funnel measures use the frozen snapshot rather than a fully mature cohort.

## Core commercial KPIs

| KPI | Business question | Numerator | Denominator | Inclusion / exclusion | Validation rule |
|---|---|---|---|---|---|
| Lead-to-Qualified conversion | How many leads progressed to qualification? | Distinct opportunities with non-null `qualified_date` | All distinct opportunities | All frozen opportunities | Numerator cannot exceed denominator. |
| Qualified-to-Proposal conversion | How efficiently do qualified deals reach proposal? | Distinct opportunities with non-null `proposal_date` | Distinct opportunities with non-null `qualified_date` | Opportunities that reached Qualified | Proposal count cannot exceed Qualified count. |
| Proposal-to-Won conversion | How many proposals have converted to Won in the snapshot? | Distinct opportunities with `outcome = 'Won'` | Distinct opportunities with non-null `proposal_date` | Includes still-open proposals; label as snapshot conversion | Won count cannot exceed proposal count. |
| Closed-opportunity win rate | Of closed deals, how often do we win? | Distinct Won opportunities | Distinct Won plus Lost opportunities | Excludes open opportunities | Won + Lost must equal completed-sales count. |
| Snapshot not-yet-progressed rate | Which opportunities have not reached the next stage as of snapshot? | Prior-stage count minus next-stage count | Prior-stage count | May include open cases, not confirmed losses | Rate must be between 0% and 100%. |
| Average deal value | What is the average simulated commercial value? | Sum of `deal_value_usd` | Distinct opportunities | Default: all filtered opportunities | Average equals total value divided by distinct opportunity count. |
| Sales cycle time | How long do closed sales opportunities take from Lead to outcome? | Sum of `closed_date - lead_date` | Distinct closed opportunities | Won and Lost only | No included record can have negative days. |
| Onboarding cycle time | How long does activation take after onboarding starts? | Sum of `activation_date - onboarding_start_date` | Distinct Activated onboarding records | Excludes In Progress records | No included record can have negative days. |
| SLA attainment rate | Among completed onboardings, how often is activation on or before SLA? | Activated records with `sla_status = 'Attained'` | Activated records with `sla_status IN ('Attained', 'Breached')` | Excludes Pending records | Attained + Breached must equal activated count. |
| SLA breach rate | Among completed onboardings, how often is activation after SLA? | Activated records with `sla_status = 'Breached'` | Activated records with `sla_status IN ('Attained', 'Breached')` | Excludes Pending records | Attainment rate + breach rate = 100%. |
| Follow-up activity frequency | How much sales follow-up is logged per opportunity? | Count of activity records | Distinct opportunities | Use all logged activities | Aggregate activities before joining to outcomes. |

## Onboarding controls

- Open onboarding count: cases not activated by snapshot.
- Overdue open count: open cases with due date before snapshot.
- Overdue share of open backlog: overdue open / all open, blank if denominator is zero.
- Open age: snapshot minus onboarding start, reported separately from completed cycle time.
- Completed SLA targets differ by company size. Enterprise generated durations cannot exceed its SLA, so this limitation must accompany segment comparisons.

Legacy baseline column names such as `drop_off` and unqualified `sla_*` remain in historical exports for reproducibility; report labels use the precise definitions above.

## Required segmentation

Where the metric grain permits, outputs support:

- Region
- Company size
- Industry
- Deal-size band

For cross-segment analyses such as APAC Enterprise, the denominator is only the relevant filtered population.

## Interpretation rules

- Segment differences are descriptive of this simulated dataset.
- Activity analysis is association-only and does not establish causation.
- Embedded simulation mechanisms must be distinguished from exploratory comparisons.
- Scenario impacts are assumptions, not realised business outcomes or forecasts.
