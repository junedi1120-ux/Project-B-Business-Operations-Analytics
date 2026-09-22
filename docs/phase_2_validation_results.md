# Phase 2 Power BI Validation Results

Recorded 2026-09-21. Acceptance criteria are those in `implementation_plan_revised.md` (2026-09-19 revision).

Authoring environment: Power BI Desktop on Windows 11 in Parallels Desktop on macOS (`mac-mini-local`).

Post-validation file update, 2026-09-22: the original PBIX was locked by another Power BI Desktop process, so Andy used Save As after adding the approved Page 2 Company Size and Deal Size slicers. The current working file is `powerbi/Project-B-Business-Operations-Analytics-v2.pbix`; it supersedes the original working-file reference below. The title bar and saved state were rechecked during Phase 4 screenshot capture.

## Acceptance criteria

| Criterion | Status | Evidence |
|---|---|---|
| Personal implementation of import, model and measures | PASS | Andy performed the CSV imports, Power Query typing, the `Calendar` table and its single relationship, and every DAX measure in the guided session of 2026-09-20/21. AI assistance was limited to instructions, explanation and presentation-layer work. |
| Two interactive pages | PASS | `Executive Commercial Health` and `Funnel & Process Diagnostics`, each with a button slicer (`Company Size` / `Region`) and cross-filtering visuals. |
| Overall reconciliation against the SQL baseline | PASS | See table below. |
| One segment-level reconciliation | PASS | See table below. |
| PBIX saves, closes and reopens | PASS | Verified twice on 2026-09-21: at 08:33 before the presentation-layer changes, and again at 23:52 on the final version saved at 23:00. On reopen both pages rendered with all KPIs, charts, slicers, the data note and the `Calendar` table present, and no filter selections carried over. The saved package was also checked structurally: data model plus two pages, `Executive Commercial Health` (10 visuals) and `Funnel & Process Diagnostics` (18 visuals). |
| Cosmetic work capped at 2h | CLOSED | Layout, colour, typography and labelling work stopped; no further beautification is in scope. |

## Overall reconciliation — dashboard vs `data/processed/sql_kpi_baseline.csv`

| KPI | SQL baseline | Dashboard | Match |
|---|---:|---:|---|
| Total Opportunities | 1000 | 1,000 | yes |
| Qualified Opportunities | 780 | 780 | yes |
| Proposal Opportunities | 574 | 574 | yes |
| Won Opportunities | 255 | 255 | yes |
| Lead to Qualified Rate | 78.0% | 78% | yes |
| Qualified to Proposal Rate | 73.6% | 73.6% | yes |
| Proposal to Won Rate (snapshot) | 44.4% | 44.4% | yes |
| Closed Win Rate | 49.0% | 49% | yes |
| Average Deal Value | 64407.31 | $64.4K | yes (display rounded to one decimal) |
| Average Closed Sales Cycle Days | 61.0 | 61.0 | yes |
| Average Onboarding Cycle Days | 27.1 | 27.1 | yes |
| Completed SLA Attainment Rate | 65.5% | 65.5% | yes |

## Segment reconciliation — completed SLA attainment by company size, vs `data/processed/sql_onboarding_performance.csv`

| Company size | SQL baseline | Dashboard | Match |
|---|---:|---:|---|
| Enterprise | 100.0% | 100.0% | yes |
| Mid-market | 37.4% | 37.4% | yes |
| SMB | 80.2% | 80.2% | yes |

The Enterprise 100% figure is a structural consequence of the simulated onboarding-duration rules. The page carries a data note stating it must not be read as superior team performance.

## Resolved item

A stale duplicate `Project-B-Business-Operations-Analytics.pbix` existed outside the repository at `~/Documents/` (`C:\Mac\Home\Documents\` from inside the VM). It was an early file containing a data model but a single empty report page and no `Calendar` table, and it appeared in the Power BI recent-files list beside the real one, where it was opened by mistake once. It was deleted on 2026-09-21 after confirming its contents. At that time, the repository copy under `powerbi/` was the working file; the 2026-09-22 Save As update above subsequently made `Project-B-Business-Operations-Analytics-v2.pbix` the current deliverable.

## Corrections made during Phase 2

- The monthly volume line chart showed a false cliff. The cause was the visual's sort order being set to Total Opportunities descending, not a missing sort-by column in the model. Changing the sort to `Year Month` ascending fixed it. No model change was made. An earlier diagnosis attributing it to snapshot dates, and a later one attributing it to a missing sort column, were both wrong and are recorded here as corrections.
- Stacked-column colour semantics were inverted and were corrected to Won = dark blue (primary), Open = light blue (neutral), Lost = orange (warning).
- `Average Deal Value` was briefly converted to a text measure to force a `K` suffix. It was restored to a numeric measure with its original DIVIDE formula; the `K` display is now produced by the visual's callout formatting, so the value remains computable.
- The Power BI Desktop application language was changed to English (United States) so that automatic abbreviations and auto-generated subtitles render in English (`1,000`, `$64.4K`) instead of mixed Chinese units. This is an application-level setting, not a file or model setting; the model language was left unchanged.

## Boundaries

Phase 2 evidence covers dashboard construction and numeric agreement with the SQL baseline. It does not select findings, assign causes, set targets or make recommendations; those remain Phase 3. The dataset is simulated and the dashboard demonstrates tool capability, not real commercial results.
