.bail on
.headers on
.mode column
.read sql/01_create_analysis_views.sql

-- Business question: Does the snapshot hide overdue unfinished onboarding?
SELECT company_size, sla_status_as_of, COUNT(*) AS onboarding_count,
       ROUND(AVG(open_age_days), 1) AS average_open_age_days
FROM analysis_onboarding
GROUP BY company_size, sla_status_as_of
ORDER BY company_size, sla_status_as_of;

-- Business question: Are segment SLA targets comparable to generated cycle ranges?
SELECT company_size, MIN(onboarding_cycle_days) AS min_completed_days,
       MAX(onboarding_cycle_days) AS max_completed_days,
       MIN(sla_target_days) AS min_sla_days, MAX(sla_target_days) AS max_sla_days
FROM analysis_onboarding WHERE onboarding_status = 'Activated'
GROUP BY company_size;

-- Business question: Does activity frequency mean logged or completed follow-ups?
SELECT activity_status, COUNT(*) AS activity_count FROM activities GROUP BY activity_status;

-- Validation: no silent account mismatch, duplicated analysis grain or activity inflation.
SELECT 'onboarding_account_mismatch' AS check_name, COUNT(*) AS violations
FROM onboarding b JOIN opportunities o ON o.opportunity_id=b.opportunity_id
WHERE b.account_id<>o.account_id
UNION ALL
SELECT 'onboarding_join_count_difference', ABS((SELECT COUNT(*) FROM onboarding)-(SELECT COUNT(*) FROM analysis_onboarding))
UNION ALL
SELECT 'activity_total_difference', ABS((SELECT COUNT(*) FROM activities)-(SELECT SUM(activity_count) FROM analysis_opportunity_activity))
UNION ALL
SELECT 'completed_sla_label_mismatch', COUNT(*) FROM analysis_onboarding
WHERE onboarding_status='Activated' AND sla_status<>sla_status_as_of
UNION ALL
SELECT 'future_onboarding_dates', COUNT(*) FROM onboarding
WHERE onboarding_start_date>'2026-08-31' OR activation_date>'2026-08-31'
UNION ALL
SELECT 'future_activities', COUNT(*) FROM activities WHERE activity_date>'2026-08-31';

PRAGMA integrity_check;
PRAGMA foreign_key_check;
