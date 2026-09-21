-- Phase 3 comparison queries
-- Source: data/processed/project_b_simulated.sqlite (frozen v2, simulated data)
-- Snapshot date: 2026-08-31 (see docs/kpi_contract.md)
-- Read-only. Each block is the cited source for one Phase 3 comparison.

-- C1 (H1, pre-embedded mechanism)
-- Onboarding cycle time and completed-case SLA attainment by company size.
SELECT a.company_size,
       COUNT(*)                                                                   AS activated_cases,
       ROUND(AVG(julianday(o.activation_date) - julianday(o.onboarding_start_date)), 1) AS avg_cycle_days,
       SUM(CASE WHEN o.sla_status = 'Breached' THEN 1 ELSE 0 END)                 AS breached,
       ROUND(100.0 * SUM(CASE WHEN o.sla_status = 'Attained' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_attainment_pct
FROM onboarding o
JOIN accounts a ON a.account_id = o.account_id
WHERE o.activation_date IS NOT NULL
GROUP BY 1 ORDER BY 1;

-- C2 (H1 disclosure) Open onboarding backlog and overdue count as of the snapshot.
-- Completed-case SLA rates exclude these; they must be reported alongside C1.
SELECT a.company_size,
       COUNT(*)                                                                  AS open_cases,
       SUM(CASE WHEN date(o.sla_due_date) < date('2026-08-31') THEN 1 ELSE 0 END) AS overdue_open
FROM onboarding o
JOIN accounts a ON a.account_id = o.account_id
WHERE o.activation_date IS NULL
GROUP BY 1 ORDER BY 1;

-- C3 (H2, pre-embedded mechanism)
-- Snapshot Proposal-to-Won conversion by region and company size.
-- Denominator includes proposals still open, so this is snapshot conversion, not a matured cohort.
SELECT a.region, a.company_size,
       COUNT(*)                                                     AS proposals,
       SUM(CASE WHEN op.outcome = 'Won' THEN 1 ELSE 0 END)          AS won,
       ROUND(100.0 * SUM(CASE WHEN op.outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS proposal_to_won_pct
FROM opportunities op
JOIN accounts a ON a.account_id = op.account_id
WHERE op.proposal_date IS NOT NULL
GROUP BY 1, 2 ORDER BY proposal_to_won_pct;

-- C4 (H3, association only)
-- Closed win rate by logged-activity volume, within each deal size band.
-- Activities are aggregated to one row per opportunity first, so no opportunity is double counted.
WITH act AS (SELECT opportunity_id, COUNT(*) AS n FROM activities GROUP BY 1)
SELECT op.deal_size_band,
       CASE WHEN COALESCE(act.n, 0) >= 5 THEN '5+'
            WHEN COALESCE(act.n, 0) = 4  THEN '4'
            ELSE '<=3' END                                          AS activity_band,
       COUNT(*)                                                     AS closed_cases,
       ROUND(100.0 * SUM(CASE WHEN op.outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_rate_pct
FROM opportunities op
LEFT JOIN act ON act.opportunity_id = op.opportunity_id
WHERE op.outcome IN ('Won', 'Lost')
GROUP BY 1, 2 ORDER BY 1, 2;

-- C5 (H4, exploratory comparison, not pre-embedded)
-- Closed win rate by lead source at opportunity grain.
SELECT op.lead_source,
       COUNT(*)                                                     AS closed_cases,
       SUM(CASE WHEN op.outcome = 'Won' THEN 1 ELSE 0 END)          AS won,
       ROUND(100.0 * SUM(CASE WHEN op.outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_rate_pct
FROM opportunities op
WHERE op.outcome IN ('Won', 'Lost')
GROUP BY 1 ORDER BY win_rate_pct DESC;
