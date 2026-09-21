.bail on
.headers on
.mode csv

.once data/processed/accounts.csv
SELECT * FROM accounts ORDER BY account_id;

.once data/processed/opportunities.csv
SELECT * FROM opportunities ORDER BY opportunity_id;

.once data/processed/onboarding.csv
SELECT * FROM onboarding ORDER BY onboarding_id;

.once data/processed/activities.csv
SELECT * FROM activities ORDER BY activity_id;

.once data/sample/accounts_sample.csv
SELECT * FROM accounts ORDER BY account_id LIMIT 25;

.once data/sample/opportunities_sample.csv
SELECT * FROM opportunities ORDER BY opportunity_id LIMIT 25;

.once data/sample/onboarding_sample.csv
SELECT * FROM onboarding ORDER BY onboarding_id LIMIT 25;

.once data/sample/activities_sample.csv
SELECT * FROM activities ORDER BY activity_id LIMIT 25;
