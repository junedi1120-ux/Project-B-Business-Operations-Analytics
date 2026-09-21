.bail on

DROP VIEW IF EXISTS temp.analysis_opportunities;
DROP VIEW IF EXISTS temp.analysis_onboarding;
DROP VIEW IF EXISTS temp.analysis_opportunity_activity;

CREATE TEMP VIEW analysis_opportunities AS
SELECT
  o.opportunity_id,
  o.account_id,
  a.region,
  a.company_size,
  a.industry,
  o.lead_date,
  o.qualified_date,
  o.proposal_date,
  o.closed_date,
  o.current_stage,
  o.outcome,
  o.deal_size_band,
  o.deal_value_usd,
  o.lead_source,
  o.owner_team,
  o.lost_reason,
  CASE
    WHEN o.closed_date IS NOT NULL THEN CAST(julianday(o.closed_date) - julianday(o.lead_date) AS INTEGER)
  END AS sales_cycle_days
FROM opportunities o
JOIN accounts a ON a.account_id = o.account_id;

CREATE TEMP VIEW analysis_onboarding AS
SELECT
  ob.onboarding_id,
  ob.opportunity_id,
  ob.account_id,
  a.region,
  a.company_size,
  a.industry,
  o.deal_size_band,
  o.deal_value_usd,
  ob.won_date,
  ob.onboarding_start_date,
  ob.activation_date,
  ob.onboarding_status,
  ob.sla_due_date,
  ob.sla_status,
  '2026-08-31' AS snapshot_date,
  CAST(julianday(ob.sla_due_date) - julianday(ob.onboarding_start_date) AS INTEGER) AS sla_target_days,
  CASE
    WHEN ob.activation_date IS NOT NULL AND ob.activation_date <= '2026-08-31'
      THEN CASE WHEN ob.activation_date <= ob.sla_due_date THEN 'Attained' ELSE 'Breached' END
    WHEN ob.sla_due_date < '2026-08-31' THEN 'Overdue Open'
    ELSE 'Within SLA Open'
  END AS sla_status_as_of,
  CASE WHEN ob.activation_date IS NULL OR ob.activation_date > '2026-08-31'
    THEN CAST(julianday('2026-08-31') - julianday(ob.onboarding_start_date) AS INTEGER)
  END AS open_age_days,
  ob.implementation_tier,
  CASE
    WHEN ob.activation_date IS NOT NULL THEN CAST(julianday(ob.activation_date) - julianday(ob.onboarding_start_date) AS INTEGER)
  END AS onboarding_cycle_days
FROM onboarding ob
JOIN opportunities o ON o.opportunity_id = ob.opportunity_id
JOIN accounts a ON a.account_id = ob.account_id;

CREATE TEMP VIEW analysis_opportunity_activity AS
WITH activity_counts AS (
  SELECT
    opportunity_id,
    COUNT(*) AS activity_count,
    SUM(CASE WHEN activity_status = 'Completed' THEN 1 ELSE 0 END) AS completed_activity_count
  FROM activities
  GROUP BY opportunity_id
)
SELECT
  ao.*,
  COALESCE(ac.activity_count, 0) AS activity_count,
  COALESCE(ac.completed_activity_count, 0) AS completed_activity_count
FROM analysis_opportunities ao
LEFT JOIN activity_counts ac ON ac.opportunity_id = ao.opportunity_id;
