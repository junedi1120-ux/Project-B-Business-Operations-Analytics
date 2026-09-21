# Data Dictionary

All fields describe simulated data. Dates use ISO-8601 (`YYYY-MM-DD`); monetary values use simulated USD.

## `accounts`

Grain: one B2B customer account. Primary key: `account_id`.

| Field | Type | Description |
|---|---|---|
| `account_id` | INTEGER | Unique simulated account identifier. |
| `account_name` | TEXT | Synthetic account label; not a real company. |
| `region` | TEXT | Commercial region: NA, EMEA, APAC, or LATAM. |
| `company_size` | TEXT | Segment: SMB, Mid-market, or Enterprise. |
| `industry` | TEXT | Synthetic industry category. |
| `employee_band` | TEXT | Approximate employee-size band associated with the segment. |
| `account_created_date` | TEXT | Simulated account creation date. |

## `opportunities`

Grain: one sales opportunity. Primary key: `opportunity_id`. Foreign key: `account_id -> accounts.account_id`.

| Field | Type | Description |
|---|---|---|
| `opportunity_id` | INTEGER | Unique simulated opportunity identifier. |
| `account_id` | INTEGER | Account that owns the opportunity. |
| `lead_date` | TEXT | Date the opportunity entered the funnel. |
| `qualified_date` | TEXT | Date qualified; null when not reached. |
| `proposal_date` | TEXT | Date proposal issued; null when not reached. |
| `closed_date` | TEXT | Date Won or Lost; null for open opportunities. |
| `current_stage` | TEXT | Lead, Qualified, Proposal, Won, or Lost. |
| `outcome` | TEXT | Won, Lost, or Open. |
| `deal_size_band` | TEXT | Small, Medium, or Large simulated deal band. |
| `deal_value_usd` | REAL | Simulated deal value. |
| `lead_source` | TEXT | Inbound, Outbound, Partner, or Event. Not used to generate outcomes. |
| `owner_team` | TEXT | Simulated regional sales team. |
| `lost_reason` | TEXT | Synthetic lost reason; populated only for Lost opportunities. |

## `onboarding`

Grain: one onboarding record for one won opportunity. Primary key: `onboarding_id`. Foreign keys: `opportunity_id -> opportunities.opportunity_id`; `account_id -> accounts.account_id`.

| Field | Type | Description |
|---|---|---|
| `onboarding_id` | INTEGER | Unique simulated onboarding identifier. |
| `opportunity_id` | INTEGER | Won opportunity entering onboarding. Unique in this table. |
| `account_id` | INTEGER | Account receiving onboarding. |
| `won_date` | TEXT | Copied from the related opportunity closed date. |
| `onboarding_start_date` | TEXT | Simulated start date after Won. |
| `activation_date` | TEXT | Activation date; null for In Progress records. |
| `onboarding_status` | TEXT | Activated or In Progress. |
| `sla_due_date` | TEXT | Segment-specific activation deadline. |
| `sla_status` | TEXT | Attained, Breached, or Pending. Derived from dates and SLA. |
| `implementation_tier` | TEXT | Standard or Guided implementation service tier. |

## `activities`

Grain: one sales follow-up activity. Primary key: `activity_id`. Foreign key: `opportunity_id -> opportunities.opportunity_id`.

| Field | Type | Description |
|---|---|---|
| `activity_id` | INTEGER | Unique simulated activity identifier. |
| `opportunity_id` | INTEGER | Opportunity receiving the follow-up. |
| `activity_date` | TEXT | Activity date within the simulated sales period. |
| `activity_type` | TEXT | Email, Call, Meeting, Demo, or Proposal Follow-up. |
| `channel` | TEXT | Email, Phone, Video, or In-person. |
| `activity_status` | TEXT | Completed or No Response. |

## Relationship and counting rules

- One account can have many opportunities and onboarding records.
- One opportunity can have many activities.
- One Won opportunity has exactly one onboarding record; Lost and Open opportunities have none.
- Funnel and win-rate calculations must count distinct `opportunity_id`.
- Follow-up frequency must be calculated from `activities`, grouped by `opportunity_id` before joining to opportunity outcomes.
- Onboarding cycle time is `activation_date - onboarding_start_date` for Activated records only. Pending records must not be counted as either attained or breached.
