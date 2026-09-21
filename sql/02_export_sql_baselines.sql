.bail on
.headers on
.mode csv
.read sql/01_create_analysis_views.sql

.once data/processed/sql_kpi_baseline.csv
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
  ROUND(AVG(deal_value_usd), 2) AS average_deal_value_usd,
  ROUND(AVG(sales_cycle_days), 1) AS average_closed_sales_cycle_days,
  (SELECT ROUND(AVG(onboarding_cycle_days), 1) FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS average_onboarding_cycle_days,
  (SELECT ROUND(100.0 * SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) / COUNT(*), 1)
   FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS sla_attainment_rate_pct,
  (SELECT ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 1)
   FROM analysis_onboarding WHERE onboarding_status = 'Activated') AS sla_breach_rate_pct
FROM analysis_opportunities;

.once data/processed/sql_segment_performance.csv
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

.once data/processed/sql_onboarding_performance.csv
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
