# Data Generation Assumptions

## Disclosure

All records in this project are synthetic and simulated for portfolio learning. They do not represent an actual company, customer, employee, internal process, or commercial result.

## Business scenario

The simulated company sells a B2B SaaS or enterprise-service offering through this fixed process:

`Lead -> Qualified -> Proposal -> Won/Lost -> Onboarding -> Activated`

The model covers a 2025-01-01 to 2026-08-31 operating period. Values are expressed in USD solely as a common reporting currency.

## Dataset shape

| Table | Intended grain | Generated volume |
|---|---|---:|
| `accounts` | One B2B customer account | 240 |
| `opportunities` | One sales opportunity | 1,000 |
| `onboarding` | One onboarding record for each won opportunity | 200-300 expected |
| `activities` | One logged sales follow-up activity (Completed or No Response) | 3,000-5,000 expected |

## Simulated commercial rules

- Accounts are distributed across NA, EMEA, APAC, and LATAM; SMB, Mid-market, and Enterprise; and five industries.
- Every opportunity begins as a lead. Qualification, proposal, closing, and outcome dates exist only when the preceding stage was reached.
- The intended funnel is deliberately imperfect: some opportunities remain at Lead, Qualified, or Proposal; closed proposals become Won or Lost.
- Deal values vary by deal-size band and account profile. The design aims for plausible portfolio-scale values, not a claimed market benchmark.
- Activities are generated only from the opportunity's sales period. The activity table, not a pre-calculated opportunity field, is the source of follow-up frequency analysis.
- Every Won opportunity receives exactly one onboarding record. A small, explicit share remains In Progress; the rest are Activated.
- Source SLA status is completion-based: unfinished records are labelled Pending even if overdue. The analysis view adds `sla_status_as_of` at 2026-08-31 to distinguish overdue open cases; raw labels are retained for provenance.

## Intended issue mechanisms

These are data-generation mechanisms, not conclusions to repeat uncritically in the portfolio.

1. **Primary mechanism — Mid-market onboarding:** Mid-market onboardings are assigned longer completion ranges against a 30-day SLA, making elevated cycle time and breach risk possible but not identical for every Mid-market account.
2. **Secondary mechanism — APAC Enterprise conversion:** APAC Enterprise proposals receive a lower simulated win threshold than other proposal segments.
3. **Supporting mechanism — high-value follow-up:** Some Large deals receive two follow-up activities rather than the normal three to five. Their simulated win threshold is lower unless the APAC Enterprise rule already applies.

## Plausibility controls

- Funnel movement is stochastic in appearance but deterministic in implementation, using modular score formulas. Statistical independence has not been established.
- Approximate design targets were 70-80% Lead-to-Qualified and 50-65% Lead-to-Proposal progression. v2 was regenerated after v1 results were inspected, including changes to win thresholds; it is not an untouched pre-analysis sample.
- Sales-cycle and onboarding durations stay positive and respect process order.
- No date is generated outside the stated operating period plus the time required to complete the final onboarding records.
- No personally identifiable, employee, or real-company data is used.

## Anti-circularity controls

- v2 is now frozen. Earlier inspection influenced generation changes (see phase_0_validation_results.md). No further values will be changed to make a preferred finding appear.
- Pre-embedded mechanisms, exploratory findings, and null results must be labelled separately in later project materials.
- `lead_source` and `industry` are not explicit outcome-rule inputs, but deterministic formulas do not guarantee independence. Phase 3 will retain at least one exploratory comparison; it need not produce a discovery or null result.
- An exploratory comparison may be inconclusive. A small observed difference is not proof of equivalence or an absence of a real-world effect.

## Known limitations

- Simulated relationships illustrate an analytical workflow; they are not external evidence of causal effects in a real business.
- The dataset does not model finance, renewals, customer support, marketing attribution, staffing capacity, or product telemetry.
- The four-table scope is intentionally limited to protect the 50-hour project budget.
- Enterprise planned cycles are 18–43 days against a 45-day SLA, structurally preventing completed breaches. Segment SLA comparisons cannot establish superior execution.
- In Progress is assigned by a score, not a realistic observation-window censoring model. Open-age results illustrate backlog reporting, not a calibrated operational distribution.
