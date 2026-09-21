.bail on
.headers on
.mode column
.read sql/01_create_analysis_views.sql

-- Business question 1: What is the current executive commercial-health baseline?
-- Grain: one distinct opportunity, except onboarding measures which use one Activated onboarding record.
-- Validation: funnel counts must be monotonic; Won + Lost equals completed opportunities.
SELECT
  COUNT(*) AS lead_count,
  SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) AS qualified_count,
  SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END) AS proposal_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count,
  SUM(CASE WHEN outcome = 'Lost' THEN 1 ELSE 0 END) AS lost_count,
  ROUND(100.0 * SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS lead_to_qualified_conversion_pct,
  ROUND(100.0 * SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END), 0), 1) AS qualified_to_proposal_conversion_pct,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END), 0), 1) AS proposal_to_won_snapshot_conversion_pct,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END), 0), 1) AS closed_opportunity_win_rate_pct,
  ROUND(100.0 * (COUNT(*) - SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END)) / COUNT(*), 1) AS lead_to_qualified_drop_off_pct,
  ROUND(100.0 * (SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) -
    SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END)) /
    NULLIF(SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END), 0), 1) AS qualified_to_proposal_drop_off_pct,
  ROUND(AVG(deal_value_usd), 2) AS average_deal_value_usd,
  ROUND(AVG(CASE WHEN outcome = 'Won' THEN deal_value_usd END), 2) AS average_won_deal_value_usd,
  ROUND(AVG(sales_cycle_days), 1) AS average_closed_sales_cycle_days,
  (SELECT ROUND(AVG(onboarding_cycle_days), 1) FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS average_onboarding_cycle_days,
  (SELECT ROUND(100.0 * SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) / COUNT(*), 1)
   FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS sla_attainment_rate_pct,
  (SELECT ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 1)
   FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS sla_breach_rate_pct
FROM analysis_opportunities;

-- Business question 2: How does commercial health differ by approved segment?
-- Grain: one distinct opportunity per segment row. Win rate excludes open opportunities.
WITH segment_rows AS (
  SELECT 'Region' AS segment_type, region AS segment_value, * FROM analysis_opportunities
  UNION ALL
  SELECT 'Company size', company_size, * FROM analysis_opportunities
  UNION ALL
  SELECT 'Industry', industry, * FROM analysis_opportunities
  UNION ALL
  SELECT 'Deal size', deal_size_band, * FROM analysis_opportunities
)
SELECT
  segment_type,
  segment_value,
  COUNT(*) AS opportunity_count,
  SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END) AS proposal_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count,
  SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS closed_opportunity_count,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END), 0), 1) AS closed_win_rate_pct,
  ROUND(AVG(deal_value_usd), 2) AS average_deal_value_usd,
  ROUND(AVG(sales_cycle_days), 1) AS average_closed_sales_cycle_days
FROM segment_rows
GROUP BY segment_type, segment_value
ORDER BY segment_type, segment_value;

-- Business question 3: Where does the current funnel lose progression?
-- Grain: one funnel stage. This is a snapshot; Proposal includes open and closed proposals.
-- Non-progression includes unresolved open cases; do not label it permanent loss.
WITH funnel_stages AS (
  SELECT 1 AS stage_order, 'Lead' AS funnel_stage, COUNT(*) AS opportunity_count FROM analysis_opportunities
  UNION ALL
  SELECT 2, 'Qualified', SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) FROM analysis_opportunities
  UNION ALL
  SELECT 3, 'Proposal', SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END) FROM analysis_opportunities
  UNION ALL
  SELECT 4, 'Won', SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) FROM analysis_opportunities
)
SELECT
  funnel_stage,
  opportunity_count,
  ROUND(100.0 * opportunity_count /
    (SELECT opportunity_count FROM funnel_stages WHERE funnel_stage = 'Lead'), 1) AS conversion_from_lead_pct
FROM funnel_stages
ORDER BY stage_order;

-- Business question 4: How do onboarding cycle time and SLA performance vary by company size?
-- Grain: one Activated onboarding record. Pending onboardings are excluded from rates and cycle time.
SELECT
  company_size,
  COUNT(*) AS activated_onboarding_count,
  ROUND(AVG(onboarding_cycle_days), 1) AS average_onboarding_cycle_days,
  SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) AS attained_count,
  SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) AS breached_count,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_attainment_rate_pct,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_breach_rate_pct
FROM analysis_onboarding
WHERE onboarding_status = 'Activated'
GROUP BY company_size
ORDER BY company_size;

-- Companion to question 4: Which unfinished onboardings are overdue at snapshot?
-- Completed SLA rates above exclude these records; show both on the diagnostics page.
SELECT company_size,
  COUNT(*) AS open_onboarding_count,
  SUM(CASE WHEN sla_status_as_of = 'Overdue Open' THEN 1 ELSE 0 END) AS overdue_open_count,
  ROUND(100.0 * SUM(CASE WHEN sla_status_as_of = 'Overdue Open' THEN 1 ELSE 0 END) / COUNT(*), 1) AS overdue_share_of_open_pct,
  ROUND(AVG(open_age_days), 1) AS average_open_age_days
FROM analysis_onboarding
WHERE sla_status_as_of IN ('Overdue Open', 'Within SLA Open')
GROUP BY company_size
ORDER BY company_size;

-- Business question 5: Among Large deals, how is logged follow-up frequency associated with closed-opportunity win rate?
-- Grain: one Large opportunity after activities have been aggregated. This is descriptive association only.
SELECT
  CASE WHEN activity_count <= 2 THEN 'Low follow-up (0-2)'
       WHEN activity_count <= 4 THEN 'Standard follow-up (3-4)'
       ELSE 'High follow-up (5+)' END AS follow_up_band,
  COUNT(*) AS large_opportunity_count,
  SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS closed_opportunity_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END), 0), 1) AS closed_win_rate_pct
FROM analysis_opportunity_activity
WHERE deal_size_band = 'Large'
GROUP BY follow_up_band
ORDER BY follow_up_band;

-- Business question 6: For proposal-stage opportunities, how does Proposal-to-Won snapshot conversion vary by region and company size?
-- Grain: one proposal-stage opportunity. This query supplies the pre-embedded H2 test; it is not a causal conclusion.
SELECT
  region,
  company_size,
  COUNT(*) AS proposal_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS proposal_to_won_snapshot_conversion_pct
FROM analysis_opportunities
WHERE proposal_date IS NOT NULL
GROUP BY region, company_size
ORDER BY region, company_size;

-- Business question 7: Does lead source meet the pre-registered practical-null test for closed-opportunity win rate?
-- Grain: one completed sales opportunity. Interpret later under H4 rules; do not convert this output into a finding in Phase 1.
SELECT
  lead_source,
  COUNT(*) AS closed_opportunity_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS closed_win_rate_pct
FROM analysis_opportunities
WHERE outcome IN ('Won', 'Lost')
GROUP BY lead_source
ORDER BY lead_source;
