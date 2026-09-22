# Data Generation Assumptions

## Disclosure

All records in this project are synthetic and simulated for portfolio demonstration. They do not represent an actual company, customer, employee, internal process, or commercial result.

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
- Some opportunities remain at Lead, Qualified, or Proposal; closed proposals become Won or Lost.
- Deal values vary by deal-size band and account profile. The design aims for plausible portfolio-scale values, not a claimed market benchmark.
- Activities are generated only from the opportunity's sales period.
- Every Won opportunity receives exactly one onboarding record. A small share remains In Progress; the rest are Activated.
- Source SLA status is completion-based: unfinished records are labelled Pending even if overdue. The analysis view adds `sla_status_as_of` at 2026-08-31 to distinguish overdue open cases.

## Intended issue mechanisms

These are data-generation mechanisms, not real-world findings.

1. **Mid-market onboarding:** Mid-market onboardings are assigned longer completion ranges against a 30-day SLA.
2. **APAC Enterprise conversion:** APAC Enterprise proposals receive a lower simulated win threshold than other proposal segments.
3. **High-value follow-up:** some Large deals receive fewer follow-up activities and a lower simulated win threshold unless the APAC Enterprise rule already applies.

## Plausibility controls

- Funnel movement is stochastic in appearance but deterministic in implementation, using modular score formulas. Statistical independence has not been established.
- Approximate design targets were 70-80% Lead-to-Qualified and 50-65% Lead-to-Proposal progression.
- The current v2 dataset was regenerated after earlier results were inspected, including changes to win thresholds. It is therefore not an untouched pre-analysis sample.
- Sales-cycle and onboarding durations stay positive and respect process order.
- No personally identifiable, employee, or real-company data is used.

## Anti-circularity controls

- The current dataset is frozen; no further values are changed to make a preferred finding appear.
- Embedded mechanisms and exploratory comparisons are labelled separately.
- `lead_source` and `industry` are not explicit outcome-rule inputs, but deterministic formulas do not guarantee independence.
- Exploratory differences are treated as descriptive unless supported by stronger evidence.

## Known limitations

- Simulated relationships illustrate an analytical workflow; they are not external evidence of causal effects in a real business.
- The dataset does not model finance, renewals, customer support, marketing attribution, staffing capacity, or product telemetry.
- Enterprise planned cycles are 18–43 days against a 45-day SLA, structurally preventing completed breaches.
- In Progress is assigned by a score rather than a realistic observation-window censoring model. Open-age results illustrate backlog reporting, not a calibrated operational distribution.
