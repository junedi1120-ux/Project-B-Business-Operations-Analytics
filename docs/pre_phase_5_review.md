# Pre-Phase 5 Publication Review

Reviewed 2026-09-22 before interview preparation.

## Review result

The project is suitable to enter Phase 5 after the corrections below. No new dashboard feature was required.

| Review area | Issue found | Correction |
|---|---|---|
| Finding-to-recommendation logic | Finding 2 rejected a simple activity-volume interpretation, but the recommendation still targeted fewer deals with ≤3 activities. | Removed the activity-count target. The action now creates missing next-step／due-date／blocker fields and tests a future cohort. |
| Target rationale | 60%, 40%, and 35% were presented without sufficiently clear bases. | Removed 60% and 40% as performance targets. The 30-day target is tied to the simulated Mid-market SLA. The 35% value is labelled a midpoint sensitivity scenario, not a commitment. |
| Recommendation feasibility | `next-step completeness` was not calculable from the existing activity table. | Marked the current baseline unavailable and defined the fields as future data collection. |
| Sample-size wording | n=37 risked being treated as automatic proof of weak evidence. | Clarified that snapshot censoring and the embedded mechanism are the primary interpretation limits; sample size affects precision but does not erase the observed difference. |
| Contribution clarity | README's “What I built” did not distinguish Andy's hands-on work from AI-assisted scaffolding and documentation. | Added an explicit contribution and AI-assistance section based on Phase 1 and Phase 2 acceptance evidence. |
| Reproducibility | SQL order, safe rebuild steps, and Power BI source-path changes were not documented. | Added `RUNBOOK.md` with read-only analysis, disposable rebuild, validation, and PBIX refresh instructions. |
| Version clarity | Two repository PBIX files could cause reviewers to open the wrong one. | Added `powerbi/README.md`; v2 is the only current deliverable and the earlier file is labelled history. |
| Validation language | Phase 4 screenshots could be read as proof of interaction testing. | Limited screenshot evidence to visible content; retained the earlier Phase 2 interaction record separately. |
| One-page summary | “One-page” risked being interpreted as a PDF or printed-page requirement not present in the plan. | Kept `PROJECT_SUMMARY.md` as a compact Executive Summary and evaluated it against the hiring-manager comprehension criterion; no PDF was added. |
| Embedded findings | Portfolio headings could still be read as independent discoveries. | Added an explicit statement that all three findings confirm embedded simulation mechanisms. |
| Target explainability | Even revised targets could be mistaken for statistically derived optima. | Added a target-setting section distinguishing SLA-derived thresholds, proposed operating cadence, required-field controls, and sensitivity scenarios. |
| Numeric consistency | README, SQL, dashboard screenshots, and Phase 3 evidence could drift after revisions. | Rechecked the overall KPI baseline, three finding inputs, APAC Enterprise outcome counts, and dashboard labels; no numeric mismatch remains. |
| Rebuild test | Written commands alone did not prove another reviewer could reproduce the frozen data. | Ran the disposable rebuild sequence successfully; all four rebuilt CSV SHA-256 values matched the frozen package. |

## Remaining boundaries for Phase 5

- Andy must explain why the project does not support causal claims about activity volume.
- Andy must describe the 30-day target as SLA-based and the 35% value as sensitivity analysis only.
- Andy must state which work was personal and which was AI-assisted without implying independent advanced-SQL mastery.
- Andy must be able to change one dashboard filter and explain the denominator and resulting comparison.
- Phase 5 cannot be marked PASS from a written script alone; it requires Andy's spoken／hands-on practice evidence.
