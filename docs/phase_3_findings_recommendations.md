# Phase 3｜Findings and Recommendations

完成日期：2026-09-22  
資料來源：凍結版 v2 模擬資料  
Dashboard：`powerbi/Project-B-Business-Operations-Analytics-v2.pbix`

## 結論摘要

本階段保留三項最有作品與面試價值的判讀：

1. 已完成案件的 SLA 達成率會漏掉尚未完成但已逾期的 onboarding backlog。
2. 活動量與成交率的方向在不同 deal size 間不一致，不能解讀為「增加接觸次數就會提高成交率」。
3. APAC Enterprise 是 Proposal-to-Won snapshot conversion 最弱的區隔。

三項皆為模擬資料中的描述性結果，不代表真實企業成效，也不建立因果關係。管理目標與 estimated impact 是情境估算，不是預測或已實現成果。

## 目標設定原則

- **30 天 cycle**：來自模擬資料中 Mid-market 的 SLA target，不是外部 benchmark。
- **10 個工作天／30 天 review 時限**：是讓建議可執行、可追蹤的 proposed operating cadence，不是由歷史數據推導的最佳期限。
- **100% required-field completeness**：是必填資料品質控制，不是商業績效預測。
- **35% conversion**：只作 midpoint sensitivity scenario，用來表示改善量級；不是 KPI commitment 或預測。
- 沒有資料依據的 60% SLA attainment 與 40% activity-band 占比目標已在發布前 Review 移除。

## Finding 1｜只看已完成案件會漏掉逾期 backlog

**分類：Pre-embedded mechanism**

### 證據與判讀

- 已完成 onboarding 共 238 件：156 件 Attained、82 件 Breached，整體 completed SLA attainment 為 65.5%。
- Mid-market 已完成 99 件，其中 37 件 Attained、62 件 Breached；completed SLA attainment 只有 37.4%，平均 onboarding cycle 為 33.0 天。
- 另有 17 件尚未完成，因此不在 completed SLA rate 的分母內；截至 2026-08-31，17 件全部已逾期：Enterprise 2 件、Mid-market 7 件、SMB 8 件。
- 因此，completed SLA attainment 必須和 overdue open backlog 一起呈現。不能用 65.5% 或任何 company-size completed rate 代表全部尚在處理中的案件。
- Enterprise completed SLA attainment 為 100%，但其生成天數被限制在 45 天 SLA 內，不能解讀為團隊表現優秀。

### Recommendation 1｜分開管理完成績效與未完成風險

| 項目 | 定義 |
|---|---|
| Baseline | Mid-market completed SLA attainment 37.4%（37/99）、平均 cycle 33.0 天；Mid-market 另有 7 件 overdue open。全體共有 17 件 overdue open。 |
| Target | 10 個工作天內完成 17 件 overdue open 的逐案 triage，為每件指定 owner、next action 與 recovery date。下一個可比較 Mid-market completed cohort 以平均 cycle 不超過 30 天作為流程目標；30 天來自資料中的 Mid-market SLA，不是外部 benchmark。先不設定 SLA attainment 百分比目標，待 root-cause review 與下一期分母確認後再訂。 |
| Estimated impact | Triage 會使 17 件 overdue open 全部取得明確處置責任。若未來仍有 99 件可比較的 Mid-market completed cases，平均 cycle 由 33 天降至 30 天，情境上相當於約減少 297 case-days；這不是已實現節省，也不能直接換算為 SLA 達成件數。 |
| Responsible role | Customer Operations／Implementation Lead；由 Business Operations 維護分母定義與 backlog review。 |
| Tracking metric | Completed SLA attainment、平均 completed cycle days、open onboarding count、overdue open count、overdue share of open backlog、open age。 |

### 來源

- SQL：`sql/04_phase3_comparisons.sql` 的 C1、C2。
- Dashboard：Page 2 的 `SLA Attainment by Company Size`、`Open Onboardings`、`Overdue Onboardings`、`Avg Onboarding Cycle Days`。

## Finding 2｜活動量與勝率沒有一致方向

**分類：Pre-embedded mechanism；association only**

### 證據與判讀

Activities 先彙總為一個 opportunity 一列，再與 Won／Lost 結果 JOIN；否則同一商機會因多筆 activity 被重複計數。

| Deal size | Activity band | Closed cases | Closed win rate |
|---|---:|---:|---:|
| Large | ≤3 | 56 | 30.4% |
| Large | 4 | 23 | 43.5% |
| Large | 5+ | 18 | 38.9% |
| Medium | ≤3 | 42 | 50.0% |
| Medium | 4 | 142 | 49.3% |
| Medium | 5+ | 69 | 53.6% |
| Small | ≤3 | 35 | 60.0% |
| Small | 4 | 92 | 56.5% |
| Small | 5+ | 43 | 46.5% |

- Large deals 中，≤3 次活動的 win rate 低於 4 次與 5+ 次；但 5+ 並沒有高於 4 次。
- Small deals 的方向相反，活動較多的組別反而呈現較低 win rate。
- 因此不能得到「活動越多，勝率越高」的結論。活動量可能同時反映案件難度、存續時間、deal mix 或紀錄習慣。

### Recommendation 2｜先建立可衡量的 follow-up quality，不設活動次數門檻

| 項目 | 定義 |
|---|---|
| Baseline | 97 件 closed Large deals 中，56 件（57.7%）只有 ≤3 筆 logged activities；這是分析分組，不代表活動不足。現有資料沒有 `next_step`、`next_step_due_date` 或 blocker 欄位，因此 follow-up quality／next-step completeness 的 baseline 目前無法計算。 |
| Target | 30 天內定義並開始蒐集 next-step owner、next-step due date 與 blocker／outcome 欄位；下一個 Large-deal pilot cohort 的必填欄位完整率目標為 100%。這是資料品質控制，不是「至少做幾次活動」的績效門檻。完成一個 cohort 後，再決定是否存在值得管理的活動模式。 |
| Estimated impact | 直接影響是讓下一個 pilot cohort 的 Large deals 全部具備可審查的 follow-up quality 資料；目前不能合理估算額外 wins、勝率或營收。現有 56 件 ≤3 activities 案件只能作 retrospective review 清單，不能假設補活動即可改善結果。 |
| Responsible role | Sales Operations 定義欄位與 completeness rule；Large-deal owners 維護紀錄；Sales Manager 在 pipeline review 檢查缺漏。 |
| Tracking metric | 新欄位上線後的 next-step completeness、missing-field count、逾期 next-step count；activity-band distribution 與 win rate 僅保留為診斷指標。 |

### 來源

- SQL：`sql/04_phase3_comparisons.sql` 的 C4；活動先彙總再 JOIN。
- Dashboard：Page 2 的 `Avg. Activities per Opportunity`、`Logged Activities by Status`，並以 `Deal Size` slicer提供分群脈絡。精確的 activity-band win rate 比較由 SQL 提供；Dashboard 沒有新增專用圖表。

## Finding 3｜APAC Enterprise 的 Proposal-to-Won 最弱

**分類：Pre-embedded mechanism**

### 證據與判讀

- APAC Enterprise 有 37 件 proposals、9 件 Won，Proposal-to-Won snapshot conversion 為 24.3%。
- 這是所有 region × company size 組合中最低的數值。
- 其他區隔合計為 537 件 proposals、246 件 Won，snapshot conversion 約 45.8%；與 APAC Enterprise 相差約 21.5 個百分點。
- n=37 使估計精度有限，但樣本數本身不會自動推翻觀察到的差異。更重要的限制是：資料包含 3 件仍 open 的 proposals、這是 snapshot 而非成熟 cohort，而且低轉換是預埋生成機制；因此不能單憑結果判定人員、區域或流程原因。

### Recommendation 3｜針對 APAC Enterprise 做 Proposal-stage deal review

| 項目 | 定義 |
|---|---|
| Baseline | APAC Enterprise Proposal-to-Won snapshot conversion 24.3%（9/37）；其他區隔合計約 45.8%（246/537）。 |
| Target | 10 個工作天內 review 全部 3 件 open APAC Enterprise proposals；30 天內完成 25 件 Lost proposals 的 retrospective review（19 Budget、6 Competitor），並為未來案件新增 proposal age、決策者確認與 blocker 紀錄。35% 不作績效承諾，只保留為 sizing scenario；它約位於 24.3% baseline 與其他區隔 45.8% 之間，用來展示半數差距改善的量級。 |
| Estimated impact | Review completeness 的直接影響是 3 件 open 與 25 件 Lost 全部取得結構化檢查。若只做固定分母的敏感度估算，37 件 proposal 在 35% 下約為 13 件 Won，比目前 9 件多約 4 件；這不是成交預測，也不估算營收。 |
| Responsible role | APAC Enterprise Sales Lead 負責案件 review；Sales Operations 維護 cohort、proposal aging 與 conversion 定義。 |
| Tracking metric | Proposal review completion、Proposal-to-Won snapshot conversion、matured-cohort conversion、open proposal age、proposal count、Won count、lost reason／blocker completeness。 |

### 來源

- SQL：`sql/04_phase3_comparisons.sql` 的 C3。
- Dashboard：Page 2 的 `Proposal to Won Rate`，使用 `Region = APAC` 與 `Company Size = Enterprise` slicers；比較時保留 proposals 與 Won 的樣本數。

## 探索性比較｜Lead source

**分類：Inconclusive exploratory comparison；不列為第 4 個 finding**

| Lead source | Closed cases | Won | Closed win rate |
|---|---:|---:|---:|
| Outbound | 172 | 89 | 51.7% |
| Event | 66 | 34 | 51.5% |
| Inbound | 183 | 89 | 48.6% |
| Partner | 99 | 43 | 43.4% |

最高與最低相差 8.3 個百分點，超過事先選定的 5-point 描述性門檻，但這不是統計檢定。資料生成公式具有相依性，且尚未控制 region、company size、deal size 或成熟時間；目前證據不足以據此改變 lead allocation。此比較用來證明有檢查非預埋問題，而不是強迫產生第 4 個結論。

來源：`sql/04_phase3_comparisons.sql` 的 C5。

## Phase 3 驗收

| 驗收項目 | 結果 |
|---|---|
| 最終 findings 僅 3 項 | PASS |
| 每項 finding 有 SQL／數值來源 | PASS |
| 每項 finding 引用 Dashboard 指標或篩選脈絡 | PASS |
| 每項 recommendation 有 baseline、target、estimated impact、responsible role、tracking metric | PASS |
| 預埋機制、探索性比較與因果限制已揭露 | PASS |
| 未新增 Dashboard 頁面或 Finding 2 專用圖表 | PASS |
