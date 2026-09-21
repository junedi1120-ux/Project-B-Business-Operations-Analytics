# Phase 0 Validation Results

Validated on 2026-09-13 after generating the SQLite database and processed CSV exports twice in succession. This document records **dataset v2**, the current frozen source for Phase 1.

## Dataset freeze

The following SHA-256 values were identical after the second full build and export. They identify the frozen CSV version for Phase 1 and later reconciliation.

| File | Rows excluding header | SHA-256 |
|---|---:|---|
| `data/processed/accounts.csv` | 240 | `8464530e77455db826b3917dd1d36a23168d7010e6c1d9f1d4f68de7836ecbb2` |
| `data/processed/opportunities.csv` | 1,000 | `fe5ad6d89c15e9654734dbf9920c49a638789cb8ce6a227144b6d6da6b1459f8` |
| `data/processed/onboarding.csv` | 255 | `80f6d8f443b3b3ecabcf413ffdbedbc9b99c6d65d4878000478148c044f8825b` |
| `data/processed/activities.csv` | 3,898 | `d5961d5aafe603670210fccb6dc3b34062289cefd2f3bd5f0fe347e9f145a8a2` |

## Automated validation

| Check | Result |
|---|---|
| Accounts count within 200-300 | PASS: 240 |
| Opportunities count within 800-1,200 | PASS: 1,000 |
| Onboarding count within 200-300 | PASS: 255 |
| Activities count within 3,000-5,000 | PASS: 3,898 |
| Duplicate account IDs | PASS: 0 |
| Duplicate opportunity IDs | PASS: 0 |
| Orphan opportunities | PASS: 0 |
| Orphan onboarding records | PASS: 0 |
| Onboarding associated with non-Won opportunity | PASS: 0 |
| Won opportunities without exactly one onboarding record | PASS: 0 |
| Orphan activities | PASS: 0 |
| Opportunity stage-date order violations | PASS: 0 |
| Onboarding date-order or status-date violations | PASS: 0 |
| Activity outside related sales period | PASS: 0 |
| Stage/outcome/lost-reason consistency violations | PASS: 0 |
| SQLite `PRAGMA foreign_key_check` | PASS: no returned rows |

## Corrective actions before the v2 freeze

1. The first structural validation found 70 opportunity date-order violations: the original Proposal and Closed date ranges overlapped. The generator was corrected so qualification, proposal, and closed dates are strictly sequential.
2. The initial Phase 1 smoke test inspected outcomes and found correlated deterministic scores, an opposite-direction Large-deal activity association, and a lead-source difference. v1 was then regenerated as v2 with different modular formulas and changed win thresholds (APAC Enterprise 28→25, low-activity Large 34→28, other proposals 52→55). These were outcome-informed design changes, not purely structural repairs. Independence was not established. This limits claims of independent discovery; v2 is retained without further tuning.

No v1 output may be used for SQL, Power BI, findings, screenshots, or portfolio materials. All Phase 1 artifacts refer only to the v2 checksums above.

## Phase 0 completion boundary

This validation confirms data structure and process consistency only. It does not validate, interpret, or report business findings. Phase 1 is the first phase authorised to calculate and evaluate commercial KPIs.

## 2026-09-19 acceptance correction

The historical PASS checks do not certify KPI semantics, personal proficiency, or Power BI readiness. See `data_quality_review.md` for overdue-open SLA handling and generation limitations, and `implementation_plan_revised.md` for current acceptance gates. Historical planned hours are not measured hours worked.
