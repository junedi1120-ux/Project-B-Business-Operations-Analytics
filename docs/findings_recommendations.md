# Findings and Recommendations

All results in this document come from the frozen synthetic dataset in this repository. They demonstrate an analytical workflow and do not represent a real company or realised business outcome.

## 1. Completed-case SLA reporting can hide open backlog risk

Completed SLA attainment is 65.5%, but that metric excludes unfinished cases. At the 2026-08-31 snapshot, all 17 open onboardings were already overdue. Mid-market is the main completed-case concern, with 37.4% SLA attainment across 99 activated cases and a 33.0-day average cycle.

**Recommended action:** manage completed performance and open backlog separately. Triage all 17 overdue cases within 10 business days and assign an owner, next action, and recovery date. For the next comparable Mid-market cohort, use a maximum 30-day average cycle because 30 days is the simulated Mid-market SLA.

**Scenario sizing:** at the same 99-case volume, moving from 33 to 30 average days would equal about 297 fewer case-days. This is a scenario calculation, not realised savings.

## 2. Logged activity volume does not show a consistent relationship with win rate

Activities were aggregated to one row per opportunity before joining to outcomes to avoid double counting.

| Deal size | Activity band | Closed cases | Closed win rate |
|---|---:|---:|---:|
| Large | ≤3 | 56 | 30.4% |
| Large | 4 | 23 | 43.5% |
| Large | 5+ | 18 | 38.9% |
| Medium | ≤3 | 42 | 50.0% |
| Medium | 4 | 142 | 49.3% |
| Medium | 5+ | 69 | 53.6% |
| Small | ≤3 | 35 | 60.0% |
| Small | 4 | 92 | 56.5% |
| Small | 5+ | 43 | 46.5% |

The direction changes across deal sizes, so the data does not support a generic rule that more logged activities improve win rate.

**Recommended action:** do not set an activity-count quota from this dataset. Add next-step owner, due date, and blocker fields, require completeness for the next Large-deal pilot cohort, and then test whether follow-up quality has a useful relationship with outcomes.

## 3. APAC Enterprise has the weakest Proposal-to-Won snapshot conversion

APAC Enterprise records 9 wins from 37 proposals, or 24.3%. Other region × company-size segments combine to 246 wins from 537 proposals, or approximately 45.8%.

The result is a review signal rather than a causal diagnosis. Three APAC Enterprise proposals are still open, the metric is a snapshot rather than a mature cohort, and the lower conversion was intentionally embedded in the simulation.

**Recommended action:** review all 3 open APAC Enterprise proposals within 10 business days and complete a 30-day retrospective review of the 25 losses (19 Budget, 6 Competitor). Add proposal age, decision-maker confirmation, and blocker fields for future monitoring.

**Sensitivity scenario:** 35% conversion would correspond to about 13 wins from 37 proposals, four more than the current baseline. This is sizing only, not a forecast or target.

## Exploratory comparison: lead source

| Lead source | Closed cases | Won | Closed win rate |
|---|---:|---:|---:|
| Outbound | 172 | 89 | 51.7% |
| Event | 66 | 34 | 51.5% |
| Inbound | 183 | 89 | 48.6% |
| Partner | 99 | 43 | 43.4% |

The observed spread is descriptive only. The simulated generation logic is not statistically independent and the comparison does not control for region, company size, deal size, or opportunity maturity, so the evidence is insufficient to recommend changing lead allocation.

## Evidence

The detailed comparison queries are in `sql/04_findings_comparisons.sql`. Dashboard KPIs are reconciled against the SQL baselines in `data/processed/`.
