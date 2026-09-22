# Business Operations Analytics

## Sales Funnel and Customer Onboarding

### Project objective

Build a decision-ready SQL and Power BI analysis for a simulated B2B sales and onboarding process. The project focuses on the practical Business Operations questions behind the dashboard: which metrics can be trusted, where management attention is required, and what actions can be tracked without overstating causality.

### Scope and method

- **Data:** 240 accounts, 1,000 opportunities, 255 won-opportunity onboarding records, and 3,898 logged sales activities.
- **Period:** 2025-01-01 through the 2026-08-31 snapshot.
- **Tools:** SQL and Power BI Desktop.
- **Workflow:** define KPI denominators → validate four source tables → build SQL baselines → create the Power BI model and measures → reconcile results → test segment comparisons → develop recommendations.

### Executive KPI baseline

| Commercial health | Result | Process health | Result |
|---|---:|---|---:|
| Lead-to-Qualified | 78.0% | Avg. completed onboarding cycle | 27.1 days |
| Qualified-to-Proposal | 73.6% | Completed SLA attainment | 65.5% |
| Proposal-to-Won snapshot | 44.4% | Overdue open onboardings | 17 |
| Closed win rate | 49.0% | Avg. logged activities / opportunity | 3.9 |
| Average deal value | $64.4K | Avg. closed sales cycle | 61.0 days |

### Three management findings

1. **The completed SLA denominator hides unresolved risk.** Completed SLA attainment is 65.5%, but all 17 unfinished onboardings are overdue and excluded from that rate. Mid-market has 37.4% completed SLA attainment and a 33.0-day average cycle.

2. **Activity volume is not a reliable win-rate lever by itself.** For Large deals, closed win rate rises from 30.4% at ≤3 activities to 43.5% at four, then falls to 38.9% at 5+. Small deals show the opposite direction. The result supports better activity and next-step coverage, not a generic contact quota.

3. **APAC Enterprise is the priority Proposal-stage segment.** It records 9 wins from 37 proposals, or 24.3%, versus approximately 45.8% for all other region × company-size segments combined. The result is a review signal, not a causal diagnosis.

### Recommended management actions

- Triage all 17 overdue cases within 10 business days, assign an owner and recovery action, and use a maximum 30-day Mid-market average cycle because that is the simulated SLA threshold.
- Do not set an activity-count target. Add next-step owner, due-date, and blocker fields within 30 days, then require 100% completeness for the next Large-deal pilot cohort. The current data cannot calculate this baseline.
- Review all 3 open APAC Enterprise proposals within 10 business days and the 25 losses within 30 days. Treat 35% only as a midpoint sensitivity scenario, not a forecast or performance commitment.

### Validation and limitations

All dashboard KPIs were reconciled to SQL baselines, including one company-size segmentation. Activities were aggregated to one row per opportunity before outcome analysis. The data is entirely synthetic and deterministic; all three findings confirm embedded mechanisms rather than independent discoveries. Snapshot denominators and non-causal interpretations are disclosed. Estimated impacts are scenario calculations—not realised performance, revenue, or market benchmarks.

### Deliverables

- Two-page interactive Power BI dashboard
- Reproducible SQL analysis and validation scripts
- Processed and sample datasets with a data dictionary
- KPI contract, evidence record, findings, recommendations, and dashboard screenshots
