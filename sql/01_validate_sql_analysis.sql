.bail on
.headers on
.mode column
.read sql/01_create_analysis_views.sql

SELECT
  'opportunity-account join preserves opportunity grain' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM opportunities) THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_opportunities;

SELECT
  'activity aggregation preserves opportunity grain' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM opportunities) THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_opportunity_activity;

SELECT
  'all opportunities have at least one activity' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_opportunity_activity
WHERE activity_count = 0;

SELECT
  'funnel count order violations' AS check_name,
  CASE WHEN qualified_count > lead_count OR proposal_count > qualified_count OR won_count > proposal_count THEN 1 ELSE 0 END AS observed_value,
  CASE WHEN qualified_count <= lead_count AND proposal_count <= qualified_count AND won_count <= proposal_count THEN 'PASS' ELSE 'FAIL' END AS status
FROM (
  SELECT
    COUNT(*) AS lead_count,
    SUM(CASE WHEN qualified_date IS NOT NULL THEN 1 ELSE 0 END) AS qualified_count,
    SUM(CASE WHEN proposal_date IS NOT NULL THEN 1 ELSE 0 END) AS proposal_count,
    SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_count
  FROM analysis_opportunities
);

SELECT
  'completed outcome reconciliation difference' AS check_name,
  ABS(
    SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END) -
    SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) -
    SUM(CASE WHEN outcome = 'Lost' THEN 1 ELSE 0 END)
  ) AS observed_value,
  CASE WHEN SUM(CASE WHEN outcome IN ('Won', 'Lost') THEN 1 ELSE 0 END) =
            SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) +
            SUM(CASE WHEN outcome = 'Lost' THEN 1 ELSE 0 END)
       THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_opportunities;

SELECT
  'negative closed sales-cycle records' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_opportunities
WHERE sales_cycle_days < 0;

SELECT
  'negative onboarding-cycle records' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_onboarding
WHERE onboarding_cycle_days < 0;

SELECT
  'activated SLA reconciliation difference' AS check_name,
  ABS(
    COUNT(*) - SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) - SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END)
  ) AS observed_value,
  CASE WHEN COUNT(*) = SUM(CASE WHEN sla_status = 'Attained' THEN 1 ELSE 0 END) + SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END)
       THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_onboarding
WHERE onboarding_status = 'Activated';

SELECT
  'pending onboarding records excluded from completed SLA denominator' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM analysis_onboarding
WHERE onboarding_status = 'In Progress'
  AND sla_status <> 'Pending';
