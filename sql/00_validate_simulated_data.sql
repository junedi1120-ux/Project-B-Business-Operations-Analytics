.bail on
.headers on
.mode column

SELECT
  'accounts row count' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) BETWEEN 200 AND 300 THEN 'PASS' ELSE 'FAIL' END AS status
FROM accounts;

SELECT
  'opportunities row count' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) BETWEEN 800 AND 1200 THEN 'PASS' ELSE 'FAIL' END AS status
FROM opportunities;

SELECT
  'onboarding row count' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) BETWEEN 200 AND 300 THEN 'PASS' ELSE 'FAIL' END AS status
FROM onboarding;

SELECT
  'activities row count' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) BETWEEN 3000 AND 5000 THEN 'PASS' ELSE 'FAIL' END AS status
FROM activities;

SELECT
  'unique account IDs' AS check_name,
  COUNT(*) - COUNT(DISTINCT account_id) AS observed_value,
  CASE WHEN COUNT(*) = COUNT(DISTINCT account_id) THEN 'PASS' ELSE 'FAIL' END AS status
FROM accounts;

SELECT
  'unique opportunity IDs' AS check_name,
  COUNT(*) - COUNT(DISTINCT opportunity_id) AS observed_value,
  CASE WHEN COUNT(*) = COUNT(DISTINCT opportunity_id) THEN 'PASS' ELSE 'FAIL' END AS status
FROM opportunities;

SELECT
  'orphan opportunities' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM opportunities o
LEFT JOIN accounts a ON a.account_id = o.account_id
WHERE a.account_id IS NULL;

SELECT
  'orphan onboarding records' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM onboarding ob
LEFT JOIN opportunities o ON o.opportunity_id = ob.opportunity_id
WHERE o.opportunity_id IS NULL;

SELECT
  'onboarding only for Won opportunities' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM onboarding ob
JOIN opportunities o ON o.opportunity_id = ob.opportunity_id
WHERE o.outcome <> 'Won';

SELECT
  'every Won opportunity has one onboarding record' AS check_name,
  ABS(
    (SELECT COUNT(*) FROM opportunities WHERE outcome = 'Won') -
    (SELECT COUNT(*) FROM onboarding)
  ) AS observed_value,
  CASE WHEN (SELECT COUNT(*) FROM opportunities WHERE outcome = 'Won') = (SELECT COUNT(*) FROM onboarding)
       THEN 'PASS' ELSE 'FAIL' END AS status;

SELECT
  'orphan activities' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM activities ac
LEFT JOIN opportunities o ON o.opportunity_id = ac.opportunity_id
WHERE o.opportunity_id IS NULL;

SELECT
  'opportunity date order violations' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM opportunities
WHERE (qualified_date IS NOT NULL AND qualified_date < lead_date)
   OR (proposal_date IS NOT NULL AND (qualified_date IS NULL OR proposal_date < qualified_date))
   OR (closed_date IS NOT NULL AND (proposal_date IS NULL OR closed_date < proposal_date));

SELECT
  'onboarding date order violations' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM onboarding
WHERE onboarding_start_date < won_date
   OR (activation_date IS NOT NULL AND activation_date < onboarding_start_date)
   OR (onboarding_status = 'Activated' AND activation_date IS NULL)
   OR (onboarding_status = 'In Progress' AND activation_date IS NOT NULL);

SELECT
  'activity outside sales period' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM activities ac
JOIN opportunities o ON o.opportunity_id = ac.opportunity_id
WHERE ac.activity_date < o.lead_date
   OR (o.closed_date IS NOT NULL AND ac.activity_date > o.closed_date);

SELECT
  'stage and outcome consistency violations' AS check_name,
  COUNT(*) AS observed_value,
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM opportunities
WHERE (current_stage = 'Won' AND outcome <> 'Won')
   OR (current_stage = 'Lost' AND outcome <> 'Lost')
   OR (current_stage IN ('Lead', 'Qualified', 'Proposal') AND outcome <> 'Open')
   OR (outcome = 'Won' AND closed_date IS NULL)
   OR (outcome = 'Lost' AND lost_reason IS NULL)
   OR (outcome <> 'Lost' AND lost_reason IS NOT NULL);
