.bail on
PRAGMA foreign_keys = ON;

BEGIN;

DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS onboarding;
DROP TABLE IF EXISTS opportunities;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
  account_id INTEGER PRIMARY KEY,
  account_name TEXT NOT NULL UNIQUE,
  region TEXT NOT NULL CHECK (region IN ('NA', 'EMEA', 'APAC', 'LATAM')),
  company_size TEXT NOT NULL CHECK (company_size IN ('SMB', 'Mid-market', 'Enterprise')),
  industry TEXT NOT NULL CHECK (industry IN ('Technology', 'Financial Services', 'Manufacturing', 'Professional Services', 'Healthcare')),
  employee_band TEXT NOT NULL,
  account_created_date TEXT NOT NULL
);

CREATE TABLE opportunities (
  opportunity_id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL,
  lead_date TEXT NOT NULL,
  qualified_date TEXT,
  proposal_date TEXT,
  closed_date TEXT,
  current_stage TEXT NOT NULL CHECK (current_stage IN ('Lead', 'Qualified', 'Proposal', 'Won', 'Lost')),
  outcome TEXT NOT NULL CHECK (outcome IN ('Won', 'Lost', 'Open')),
  deal_size_band TEXT NOT NULL CHECK (deal_size_band IN ('Small', 'Medium', 'Large')),
  deal_value_usd REAL NOT NULL CHECK (deal_value_usd > 0),
  lead_source TEXT NOT NULL CHECK (lead_source IN ('Inbound', 'Outbound', 'Partner', 'Event')),
  owner_team TEXT NOT NULL,
  lost_reason TEXT,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE onboarding (
  onboarding_id INTEGER PRIMARY KEY,
  opportunity_id INTEGER NOT NULL UNIQUE,
  account_id INTEGER NOT NULL,
  won_date TEXT NOT NULL,
  onboarding_start_date TEXT NOT NULL,
  activation_date TEXT,
  onboarding_status TEXT NOT NULL CHECK (onboarding_status IN ('Activated', 'In Progress')),
  sla_due_date TEXT NOT NULL,
  sla_status TEXT NOT NULL CHECK (sla_status IN ('Attained', 'Breached', 'Pending')),
  implementation_tier TEXT NOT NULL CHECK (implementation_tier IN ('Standard', 'Guided')),
  FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE activities (
  activity_id INTEGER PRIMARY KEY,
  opportunity_id INTEGER NOT NULL,
  activity_date TEXT NOT NULL,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('Email', 'Call', 'Meeting', 'Demo', 'Proposal Follow-up')),
  channel TEXT NOT NULL CHECK (channel IN ('Email', 'Phone', 'Video', 'In-person')),
  activity_status TEXT NOT NULL CHECK (activity_status IN ('Completed', 'No Response')),
  FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id)
);

WITH RECURSIVE account_numbers(n) AS (
  VALUES(1)
  UNION ALL
  SELECT n + 1 FROM account_numbers WHERE n < 240
)
INSERT INTO accounts (
  account_id, account_name, region, company_size, industry, employee_band, account_created_date
)
SELECT
  n,
  printf('Simulated Account %03d', n),
  CASE ((n * 37 + 11) % 100)
    WHEN 0 THEN 'LATAM'
    WHEN 1 THEN 'LATAM'
    WHEN 2 THEN 'LATAM'
    WHEN 3 THEN 'LATAM'
    WHEN 4 THEN 'LATAM'
    WHEN 5 THEN 'LATAM'
    WHEN 6 THEN 'LATAM'
    WHEN 7 THEN 'LATAM'
    WHEN 8 THEN 'LATAM'
    WHEN 9 THEN 'LATAM'
    WHEN 10 THEN 'APAC'
    WHEN 11 THEN 'APAC'
    WHEN 12 THEN 'APAC'
    WHEN 13 THEN 'APAC'
    WHEN 14 THEN 'APAC'
    WHEN 15 THEN 'APAC'
    WHEN 16 THEN 'APAC'
    WHEN 17 THEN 'APAC'
    WHEN 18 THEN 'APAC'
    WHEN 19 THEN 'APAC'
    WHEN 20 THEN 'APAC'
    WHEN 21 THEN 'APAC'
    WHEN 22 THEN 'APAC'
    WHEN 23 THEN 'APAC'
    WHEN 24 THEN 'APAC'
    WHEN 25 THEN 'APAC'
    WHEN 26 THEN 'APAC'
    WHEN 27 THEN 'APAC'
    WHEN 28 THEN 'APAC'
    WHEN 29 THEN 'APAC'
    WHEN 30 THEN 'APAC'
    WHEN 31 THEN 'APAC'
    WHEN 32 THEN 'APAC'
    WHEN 33 THEN 'APAC'
    WHEN 34 THEN 'APAC'
    WHEN 35 THEN 'EMEA'
    WHEN 36 THEN 'EMEA'
    WHEN 37 THEN 'EMEA'
    WHEN 38 THEN 'EMEA'
    WHEN 39 THEN 'EMEA'
    WHEN 40 THEN 'EMEA'
    WHEN 41 THEN 'EMEA'
    WHEN 42 THEN 'EMEA'
    WHEN 43 THEN 'EMEA'
    WHEN 44 THEN 'EMEA'
    WHEN 45 THEN 'EMEA'
    WHEN 46 THEN 'EMEA'
    WHEN 47 THEN 'EMEA'
    WHEN 48 THEN 'EMEA'
    WHEN 49 THEN 'EMEA'
    WHEN 50 THEN 'EMEA'
    WHEN 51 THEN 'EMEA'
    WHEN 52 THEN 'EMEA'
    WHEN 53 THEN 'EMEA'
    WHEN 54 THEN 'EMEA'
    WHEN 55 THEN 'EMEA'
    WHEN 56 THEN 'EMEA'
    WHEN 57 THEN 'EMEA'
    WHEN 58 THEN 'EMEA'
    WHEN 59 THEN 'EMEA'
    WHEN 60 THEN 'EMEA'
    WHEN 61 THEN 'EMEA'
    WHEN 62 THEN 'EMEA'
    WHEN 63 THEN 'EMEA'
    WHEN 64 THEN 'EMEA'
    ELSE 'NA'
  END,
  CASE WHEN ((n * 29 + 7) % 100) < 40 THEN 'SMB'
       WHEN ((n * 29 + 7) % 100) < 80 THEN 'Mid-market'
       ELSE 'Enterprise' END,
  CASE ((n * 17 + 3) % 5)
    WHEN 0 THEN 'Technology'
    WHEN 1 THEN 'Financial Services'
    WHEN 2 THEN 'Manufacturing'
    WHEN 3 THEN 'Professional Services'
    ELSE 'Healthcare'
  END,
  CASE WHEN ((n * 29 + 7) % 100) < 40 THEN '50-249'
       WHEN ((n * 29 + 7) % 100) < 80 THEN '250-999'
       ELSE '1000+' END,
  date('2023-01-01', '+' || ((n * 41 + 19) % 730) || ' days')
FROM account_numbers;

CREATE TEMP TABLE opportunity_staging AS
WITH RECURSIVE opportunity_numbers(n) AS (
  VALUES(1)
  UNION ALL
  SELECT n + 1 FROM opportunity_numbers WHERE n < 1000
), base AS (
  SELECT
    n AS opportunity_id,
    ((n * 17 + 29) % 240) + 1 AS account_id,
    (((n * n * 37 + n * 71 + (((n * 17 + 29) % 240) + 1) * 13 + 19) % 997) % 100) AS progression_score,
    (((n * n * 53 + n * 29 + (((n * 17 + 29) % 240) + 1) * 31 + 47) % 997) % 100) AS close_score,
    (((n * n * 73 + n * 41 + (((n * 17 + 29) % 240) + 1) * 17 + 59) % 997) % 100) AS win_score,
    (((n * n * 89 + n * 23 + (((n * 17 + 29) % 240) + 1) * 43 + 11) % 997) % 100) AS deal_score,
    (((n * n * 97 + n * 67 + (((n * 17 + 29) % 240) + 1) * 19 + 83) % 997) % 100) AS activity_score,
    (((n * n * 43 + n * 79 + (((n * 17 + 29) % 240) + 1) * 37 + 31) % 997) % 100) AS source_score,
    (((n * n * 61 + n * 13 + (((n * 17 + 29) % 240) + 1) * 47 + 71) % 997) % 100) AS timing_score
  FROM opportunity_numbers
), segmented AS (
  SELECT
    b.*,
    a.region,
    a.company_size,
    CASE
      WHEN b.deal_score < 12 OR (a.company_size = 'Enterprise' AND b.deal_score < 45) THEN 'Large'
      WHEN b.deal_score < 66 THEN 'Medium'
      ELSE 'Small'
    END AS deal_size_band,
    date('2025-01-01', '+' || ((b.opportunity_id * 31 + b.account_id * 13) % 480) || ' days') AS lead_date
  FROM base b
  JOIN accounts a ON a.account_id = b.account_id
), progressed AS (
  SELECT
    *,
    CASE WHEN progression_score < 78 THEN 1 ELSE 0 END AS reached_qualified,
    CASE WHEN progression_score < 58 THEN 1 ELSE 0 END AS reached_proposal,
    CASE WHEN deal_size_band = 'Large' AND activity_score < 55 THEN 1 ELSE 0 END AS low_activity_large_deal
  FROM segmented
), outcome_rules AS (
  SELECT
    *,
    CASE WHEN reached_proposal = 1 AND close_score < 90 THEN 1 ELSE 0 END AS is_closed,
    CASE
      WHEN region = 'APAC' AND company_size = 'Enterprise' THEN 25
      WHEN low_activity_large_deal = 1 THEN 28
      ELSE 55
    END AS win_threshold
  FROM progressed
)
SELECT
  opportunity_id,
  account_id,
  lead_date,
  CASE WHEN reached_qualified = 1 THEN date(lead_date, '+' || (2 + (timing_score % 14)) || ' days') END AS qualified_date,
  CASE WHEN reached_proposal = 1 THEN date(lead_date, '+' || (18 + (timing_score % 22)) || ' days') END AS proposal_date,
  CASE
    WHEN reached_proposal = 1 AND is_closed = 1 THEN date(lead_date, '+' || (45 + (timing_score % 35)) || ' days')
  END AS closed_date,
  CASE
    WHEN reached_qualified = 0 THEN 'Lead'
    WHEN reached_proposal = 0 THEN 'Qualified'
    WHEN is_closed = 0 THEN 'Proposal'
    WHEN win_score < win_threshold THEN 'Won'
    ELSE 'Lost'
  END AS current_stage,
  CASE
    WHEN reached_proposal = 1 AND is_closed = 1 AND win_score < win_threshold THEN 'Won'
    WHEN reached_proposal = 1 AND is_closed = 1 THEN 'Lost'
    ELSE 'Open'
  END AS outcome,
  deal_size_band,
  CASE deal_size_band
    WHEN 'Small' THEN 12000 + ((opportunity_id * 211 + account_id * 31) % 18000)
    WHEN 'Medium' THEN 35000 + ((opportunity_id * 317 + account_id * 47) % 45000)
    ELSE 90000 + ((opportunity_id * 521 + account_id * 71) % 130000)
  END AS deal_value_usd,
  CASE
    WHEN source_score < 35 THEN 'Inbound'
    WHEN source_score < 65 THEN 'Outbound'
    WHEN source_score < 85 THEN 'Partner'
    ELSE 'Event'
  END AS lead_source,
  region || ' Sales' AS owner_team,
  CASE
    WHEN reached_proposal = 1 AND is_closed = 1 AND win_score >= win_threshold THEN
      CASE (opportunity_id * 19 + account_id * 7) % 4
        WHEN 0 THEN 'Budget'
        WHEN 1 THEN 'Timing'
        WHEN 2 THEN 'Competitor'
        ELSE 'No Decision'
      END
  END AS lost_reason,
  CASE
    WHEN low_activity_large_deal = 1 THEN 2
    WHEN activity_score < 20 THEN 3
    WHEN activity_score < 75 THEN 4
    ELSE 5
  END AS activity_target
FROM outcome_rules;

INSERT INTO opportunities (
  opportunity_id, account_id, lead_date, qualified_date, proposal_date, closed_date,
  current_stage, outcome, deal_size_band, deal_value_usd, lead_source, owner_team, lost_reason
)
SELECT
  opportunity_id, account_id, lead_date, qualified_date, proposal_date, closed_date,
  current_stage, outcome, deal_size_band, deal_value_usd, lead_source, owner_team, lost_reason
FROM opportunity_staging;

CREATE TEMP TABLE onboarding_staging AS
WITH won_opportunities AS (
  SELECT
    o.opportunity_id,
    o.account_id,
    o.closed_date AS won_date,
    a.company_size,
    ((o.opportunity_id * 97 + o.account_id * 13) % 100) AS onboarding_score,
    ((o.opportunity_id * 73 + o.account_id * 41) % 100) AS activation_score
  FROM opportunities o
  JOIN accounts a ON a.account_id = o.account_id
  WHERE o.outcome = 'Won'
), calculated AS (
  SELECT
    *,
    date(won_date, '+' || (1 + (onboarding_score % 3)) || ' days') AS onboarding_start_date,
    CASE company_size
      WHEN 'SMB' THEN 28
      WHEN 'Mid-market' THEN 30
      ELSE 45
    END AS sla_days,
    CASE
      WHEN company_size = 'Mid-market' THEN 21 + (activation_score % 24)
      WHEN company_size = 'Enterprise' THEN 18 + (activation_score % 26)
      ELSE 10 + (activation_score % 23)
    END AS planned_cycle_days
  FROM won_opportunities
)
SELECT
  opportunity_id AS onboarding_id,
  opportunity_id,
  account_id,
  won_date,
  onboarding_start_date,
  CASE WHEN onboarding_score < 8 THEN NULL
       ELSE date(onboarding_start_date, '+' || planned_cycle_days || ' days') END AS activation_date,
  CASE WHEN onboarding_score < 8 THEN 'In Progress' ELSE 'Activated' END AS onboarding_status,
  date(onboarding_start_date, '+' || sla_days || ' days') AS sla_due_date,
  CASE
    WHEN onboarding_score < 8 THEN 'Pending'
    WHEN planned_cycle_days > sla_days THEN 'Breached'
    ELSE 'Attained'
  END AS sla_status,
  CASE WHEN company_size = 'Enterprise' OR onboarding_score % 5 = 0 THEN 'Guided' ELSE 'Standard' END AS implementation_tier
FROM calculated;

INSERT INTO onboarding (
  onboarding_id, opportunity_id, account_id, won_date, onboarding_start_date,
  activation_date, onboarding_status, sla_due_date, sla_status, implementation_tier
)
SELECT
  onboarding_id, opportunity_id, account_id, won_date, onboarding_start_date,
  activation_date, onboarding_status, sla_due_date, sla_status, implementation_tier
FROM onboarding_staging;

WITH RECURSIVE activity_sequence(n) AS (
  VALUES(1)
  UNION ALL
  SELECT n + 1 FROM activity_sequence WHERE n < 5
), activity_rows AS (
  SELECT
    o.opportunity_id,
    o.lead_date,
    o.closed_date,
    o.activity_target,
    s.n AS activity_number,
    ((o.opportunity_id * 31 + s.n * 17) % 100) AS type_score,
    ((o.opportunity_id * 23 + s.n * 29) % 100) AS status_score,
    CASE
      WHEN o.closed_date IS NULL THEN 45
      ELSE CAST(julianday(o.closed_date) - julianday(o.lead_date) AS INTEGER)
    END AS available_sales_days
  FROM opportunity_staging o
  CROSS JOIN activity_sequence s
  WHERE s.n <= o.activity_target
)
INSERT INTO activities (
  activity_id, opportunity_id, activity_date, activity_type, channel, activity_status
)
SELECT
  opportunity_id * 10 + activity_number AS activity_id,
  opportunity_id,
  date(lead_date, '+' || MIN(available_sales_days, 2 + activity_number * 5 + (type_score % 4)) || ' days') AS activity_date,
  CASE type_score % 5
    WHEN 0 THEN 'Email'
    WHEN 1 THEN 'Call'
    WHEN 2 THEN 'Meeting'
    WHEN 3 THEN 'Demo'
    ELSE 'Proposal Follow-up'
  END AS activity_type,
  CASE type_score % 4
    WHEN 0 THEN 'Email'
    WHEN 1 THEN 'Phone'
    WHEN 2 THEN 'Video'
    ELSE 'In-person'
  END AS channel,
  CASE WHEN status_score < 88 THEN 'Completed' ELSE 'No Response' END AS activity_status
FROM activity_rows;

CREATE INDEX idx_opportunities_account_id ON opportunities(account_id);
CREATE INDEX idx_opportunities_stage ON opportunities(current_stage);
CREATE INDEX idx_opportunities_dates ON opportunities(lead_date, closed_date);
CREATE INDEX idx_onboarding_opportunity_id ON onboarding(opportunity_id);
CREATE INDEX idx_onboarding_account_id ON onboarding(account_id);
CREATE INDEX idx_activities_opportunity_id ON activities(opportunity_id);
CREATE INDEX idx_activities_activity_date ON activities(activity_date);

DROP TABLE opportunity_staging;
DROP TABLE onboarding_staging;

COMMIT;
