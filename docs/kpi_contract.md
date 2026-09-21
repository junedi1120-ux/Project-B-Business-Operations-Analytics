# KPI Contract

This contract fixes calculation rules before interpreting results. Every result in Phase 1 and Power BI Phase 2 must use these definitions unless a later, documented decision explicitly changes the definition.

## Common scope and grain

- **Source version:** the frozen Phase 0 processed CSV and SQLite dataset documented in `docs/phase_0_validation_results.md`.
- **Opportunity grain:** one distinct `opportunity_id`.
- **Account segmentation:** `region`, `company_size`, and `industry` come from `accounts` through `opportunities.account_id`.
- **Deal-size segmentation:** `deal_size_band` comes from `opportunities`.
- **Completed sales outcome:** an opportunity with `outcome IN ('Won', 'Lost')`.
- **Activated onboarding scope:** an onboarding record with `onboarding_status = 'Activated'`. Unfinished records are excluded from completed cycle-time and completed SLA rate denominators, but must be shown separately as backlog.
- **Snapshot date:** 2026-08-31. `sla_status_as_of` derives Attained/Breached for completed cases; for unfinished cases, due date before snapshot means Overdue Open, otherwise Within SLA Open. Due on snapshot is not yet overdue.
- **Activity scope:** activity frequency is derived by counting `activities.activity_id` per opportunity. It must be aggregated before joining to opportunity outcomes.
- **Date treatment:** funnel measures use the current frozen snapshot rather than a fully mature cohort. Open opportunities can have reached a stage but not yet have a closed outcome.

## Core commercial KPIs

| KPI | Business question | Numerator | Denominator | Inclusion / exclusion | Validation rule |
|---|---|---|---|---|---|
| Lead-to-Qualified conversion | How many leads progressed to qualification? | Distinct opportunities with non-null `qualified_date` | All distinct opportunities | All frozen opportunities | Numerator cannot exceed denominator. |
| Qualified-to-Proposal conversion | How efficiently do qualified deals reach proposal? | Distinct opportunities with non-null `proposal_date` | Distinct opportunities with non-null `qualified_date` | All opportunities that reached Qualified | Proposal count cannot exceed Qualified count. |
| Proposal-to-Won conversion | How many proposals have converted to Won in the snapshot? | Distinct opportunities with `outcome = 'Won'` | Distinct opportunities with non-null `proposal_date` | Includes still-open proposals in denominator; label as snapshot conversion. | Won count cannot exceed proposal count. |
| Closed-opportunity win rate | Of closed deals, how often do we win? | Distinct Won opportunities | Distinct Won plus Lost opportunities | Excludes open opportunities | Won + Lost must equal completed-sales count. |
| Snapshot not-yet-progressed rate (legacy SQL: drop_off) | Which opportunities have not reached the next stage as of snapshot? | Prior-stage count minus next-stage count | Prior-stage count | May include open cases, not confirmed losses. Display as snapshot non-progression, not permanent drop-off. | Rate must be between 0% and 100%. |
| Average deal value | What is the average simulated commercial value in the selected population? | Sum of `deal_value_usd` | Distinct opportunities | Default: all filtered opportunities; report Won-only value separately where relevant. | Average equals total value divided by distinct opportunity count. |
| Sales cycle time | How long do closed sales opportunities take from Lead to outcome? | Sum of `closed_date - lead_date` | Distinct closed opportunities | Won and Lost only; excludes open opportunities | No included record can have negative days. |
| Onboarding cycle time | How long does activation take after onboarding starts? | Sum of `activation_date - onboarding_start_date` | Distinct Activated onboarding records | Excludes In Progress records | No included record can have negative days. |
| SLA attainment rate | Among completed onboardings, how often is activation on or before SLA? | Activated records with `sla_status = 'Attained'` | Activated records with `sla_status IN ('Attained', 'Breached')` | Excludes Pending records | Attained + Breached must equal activated count. |
| SLA breach rate | Among completed onboardings, how often is activation after SLA? | Activated records with `sla_status = 'Breached'` | Activated records with `sla_status IN ('Attained', 'Breached')` | Excludes Pending records | Attainment rate + breach rate = 100%. |
| Follow-up activity frequency | How much sales follow-up is logged per opportunity? | Count of activity records | Distinct opportunities | Use all logged activities; show completed count separately when needed. | Aggregate activities by opportunity before joining to outcomes. |

## Required segmentation

### Additional onboarding controls (same page, no added scope)

- Open onboarding count: cases not activated by snapshot.
- Overdue open count: open cases with due date before snapshot.
- Overdue share of open backlog: overdue open / all open, blank if denominator is zero.
- Open age: snapshot minus onboarding start, reported separately from completed cycle time.
- Completed SLA targets differ by company size; Enterprise generated durations cannot exceed its SLA. Display this limitation next to segment comparisons.

Legacy baseline column names `drop_off` and unqualified `sla_*` are retained to avoid silently replacing historical exports; Power BI labels must use the precise definitions above. Baselines cover completed SLA only, not open backlog.

All core KPI outputs must support, where the metric's grain permits it:

- Region
- Company size
- Industry
- Deal-size band

For cross-segment analyses such as APAC Enterprise, the denominator is only the relevant filtered population; it must not be compared with a different denominator without being labelled.

## Interpretation rules

- Segment differences are descriptive of this simulated dataset.
- The activity analysis is association-only. It does not establish that activity volume caused a deal outcome.
- Pre-embedded mechanisms, exploratory findings, and null results must use the labels defined in `docs/hypothesis_register.md`.
- Phase 1 produces validated numeric outputs, not the final three findings or management recommendations. Those remain Phase 3 work.
