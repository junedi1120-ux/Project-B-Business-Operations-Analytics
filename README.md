# Business Operations Analytics — Sales Funnel and Customer Onboarding

An end-to-end portfolio project using SQL and Power BI to analyse a simulated B2B sales and onboarding process. The project demonstrates KPI design, denominator control, data-model validation, segment analysis, and evidence-bounded operational recommendations.

> All data is synthetic. Results demonstrate an analytical workflow and do not represent a real company, customer, employee, or achieved business outcome.

## Dashboard

### Executive Commercial Health

![Executive Commercial Health dashboard](portfolio/screenshots/executive-commercial-health.png)

### Funnel & Process Diagnostics

![Funnel and Process Diagnostics dashboard](portfolio/screenshots/funnel-process-diagnostics.png)

The editable Power BI report is [`powerbi/Project-B-Business-Operations-Analytics-v2.pbix`](powerbi/Project-B-Business-Operations-Analytics-v2.pbix).

## Business problem

The simulated company needs a reliable view of commercial funnel health and onboarding execution. The analysis addresses four management questions:

1. Where does the sales funnel lose momentum?
2. Which customer segments require operational attention?
3. Does logged sales activity show a consistent relationship with closed win rate?
4. Do completed-case SLA metrics conceal unresolved backlog risk?

## Project scope

- Four-table analytical dataset covering 240 accounts and 1,000 opportunities from 2025-01-01 to the 2026-08-31 snapshot.
- SQL analysis and validation at opportunity grain, including funnel KPIs, onboarding SLA logic, segment comparisons, and reconciliation checks.
- Power BI model with a Calendar table, explicit measures, two interactive report pages, and safeguards against opportunity double counting.
- Three management findings with quantified recommendations, stated assumptions, and clear limitations.

## Core KPI baseline

| KPI | Result |
|---|---:|
| Total opportunities | 1,000 |
| Lead-to-Qualified conversion | 78.0% |
| Qualified-to-Proposal conversion | 73.6% |
| Proposal-to-Won snapshot conversion | 44.4% |
| Closed-opportunity win rate | 49.0% |
| Average deal value | $64.4K |
| Average closed sales cycle | 61.0 days |
| Average completed onboarding cycle | 27.1 days |
| Completed SLA attainment | 65.5% |
| Overdue open onboardings | 17 |

Definitions and denominator rules are documented in the [KPI contract](docs/kpi_contract.md).

## Key findings

### 1. Completed-case SLA reporting hides open backlog risk

Completed SLA attainment is 65.5%, but its denominator excludes unfinished cases. All 17 open onboardings were already overdue at the snapshot. Mid-market has 37.4% completed SLA attainment across 99 activated cases and a 33.0-day average cycle.

**Recommendation:** manage completed performance and open backlog separately. Triage all 17 overdue cases and use the simulated 30-day Mid-market SLA as the next comparable cohort's cycle-time threshold.

### 2. Logged activity volume does not show a consistent relationship with win rate

Large deals with three or fewer logged activities show a 30.4% closed win rate, versus 43.5% for four activities and 38.9% for five or more. Small deals move in the opposite direction.

**Recommendation:** do not impose an activity-count target from this dataset. Track follow-up quality with next-step owner, due date, and blocker fields before testing a future cohort.

### 3. APAC Enterprise is the weakest Proposal-to-Won segment

APAC Enterprise records 9 wins from 37 proposals, a 24.3% snapshot conversion rate. Other region × company-size segments combine to approximately 45.8%.

**Recommendation:** review the 3 open proposals and 25 losses, then track proposal age, decision-maker confirmation, and blockers for future cases.

Detailed evidence and scenario calculations are in [Findings and Recommendations](docs/findings_recommendations.md).

## Validation and analytical controls

- Opportunities remain at one row per `opportunity_id`; activities are aggregated before joining to outcomes.
- Dashboard totals and a company-size onboarding segmentation were reconciled with SQL baselines.
- Completed onboarding metrics exclude unfinished cases, while overdue open backlog is reported separately.
- Proposal conversion is labelled as a snapshot metric because open proposals remain in its denominator.
- The synthetic dataset is deterministic and reproducible from the included SQL generation scripts.
- Scenario impacts are labelled as assumptions rather than realised savings, revenue, or forecasts.

## Limitations

- The dataset is deterministic and simulated; several mechanisms were intentionally embedded and must not be interpreted as independent real-world discoveries.
- Segment differences are descriptive and do not establish causation.
- Enterprise completed SLA attainment is structurally 100% because generated durations cannot exceed its 45-day SLA.
- The model does not include staffing, finance, renewals, product telemetry, or marketing-attribution data.
- Snapshot metrics contain open cases and therefore should not be interpreted as mature-cohort conversion rates.

## Repository guide

| Location | Contents |
|---|---|
| [`portfolio/PROJECT_SUMMARY.md`](portfolio/PROJECT_SUMMARY.md) | Compact executive summary |
| [`portfolio/screenshots/`](portfolio/screenshots/) | Power BI dashboard screenshots |
| [`powerbi/`](powerbi/) | Current editable PBIX |
| [`sql/02_end_to_end_analysis.sql`](sql/02_end_to_end_analysis.sql) | End-to-end KPI analysis |
| [`sql/04_phase3_comparisons.sql`](sql/04_phase3_comparisons.sql) | Final comparison queries |
| [`data/sample/`](data/sample/) | Reviewable samples of the four source tables |
| [`data/processed/`](data/processed/) | Processed simulated data and SQL baselines |
| [`docs/kpi_contract.md`](docs/kpi_contract.md) | KPI definitions and denominator rules |
| [`docs/data_dictionary.md`](docs/data_dictionary.md) | Table and field definitions |
| [`docs/data_generation_assumptions.md`](docs/data_generation_assumptions.md) | Simulation design and disclosure |
| [`docs/findings_recommendations.md`](docs/findings_recommendations.md) | Detailed findings and recommendations |
| [`RUNBOOK.md`](RUNBOOK.md) | SQL reproduction and Power BI refresh instructions |

## Tools and demonstrated skills

- **SQL:** joins, conditional aggregation, CTEs, date logic, denominator control, validation queries, and opportunity-grain safeguards.
- **Power BI:** Power Query typing, relationships, Calendar table, DAX measures, interactive filtering, report design, and SQL reconciliation.
- **Business Operations:** KPI definition, backlog visibility, segment prioritisation, operating recommendations, and cautious interpretation.

## AI assistance

AI was used as a development assistant for scaffolding, debugging, explanation, and documentation. Final KPI definitions, dashboard results, reported numbers, and recommendations were reviewed and reconciled against the SQL baselines and project constraints.
