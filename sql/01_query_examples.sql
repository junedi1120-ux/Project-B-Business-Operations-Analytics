.bail on
.headers on
.mode column

-- Table volumes
SELECT 'accounts' AS table_name, COUNT(*) AS row_count FROM accounts
UNION ALL
SELECT 'opportunities', COUNT(*) FROM opportunities
UNION ALL
SELECT 'onboarding', COUNT(*) FROM onboarding
UNION ALL
SELECT 'activities', COUNT(*) FROM activities;

-- Current pipeline distribution
SELECT
  current_stage,
  COUNT(*) AS opportunity_count
FROM opportunities
GROUP BY current_stage
ORDER BY opportunity_count DESC;

-- Large closed opportunities above USD 100,000
SELECT
  opportunity_id,
  account_id,
  current_stage,
  outcome,
  deal_size_band,
  deal_value_usd,
  closed_date
FROM opportunities
WHERE outcome IN ('Won', 'Lost')
  AND deal_size_band = 'Large'
  AND deal_value_usd > 100000
ORDER BY deal_value_usd DESC
LIMIT 10;

-- Average simulated deal value by deal-size band
SELECT
  deal_size_band,
  COUNT(*) AS opportunity_count,
  ROUND(AVG(deal_value_usd), 2) AS average_deal_value_usd
FROM opportunities
GROUP BY deal_size_band
ORDER BY average_deal_value_usd;

-- Opportunity count by account segment
SELECT
  a.region,
  a.company_size,
  COUNT(DISTINCT o.opportunity_id) AS opportunity_count
FROM opportunities o
JOIN accounts a ON a.account_id = o.account_id
GROUP BY a.region, a.company_size
ORDER BY a.region, a.company_size;

-- Aggregate the many-side activity table before joining to opportunity outcomes
WITH activity_counts AS (
  SELECT
    opportunity_id,
    COUNT(*) AS activity_count
  FROM activities
  GROUP BY opportunity_id
)
SELECT
  o.opportunity_id,
  o.deal_size_band,
  o.outcome,
  ac.activity_count
FROM opportunities o
JOIN activity_counts ac ON ac.opportunity_id = o.opportunity_id
ORDER BY ac.activity_count, o.opportunity_id
LIMIT 10;

-- Closed-opportunity win rate by region
WITH closed_opportunities AS (
  SELECT
    a.region,
    o.outcome
  FROM opportunities o
  JOIN accounts a ON a.account_id = o.account_id
  WHERE o.outcome IN ('Won', 'Lost')
)
SELECT
  region,
  COUNT(*) AS closed_opportunity_count,
  SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_opportunity_count,
  ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 1) AS closed_win_rate_pct
FROM closed_opportunities
GROUP BY region
ORDER BY closed_win_rate_pct DESC;
