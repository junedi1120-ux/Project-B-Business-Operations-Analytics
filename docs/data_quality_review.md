# 資料／KPI 品質修訂｜2026-09-19

這是方法與資料品質核對，不是 Phase 3 的最終 findings。保留原始 v2 四表與 CSV，不重新生成或改動商機結果。

## 問題、處理與限制

| 問題 | 本次查證 | 處理 |
|---|---|---|
| 未完成 onboarding 一律 Pending，會隱藏逾期 | snapshot 2026-08-31：17 件皆逾期；Enterprise 2、Mid-market 7、SMB 8 | 分析 view 新增 snapshot-aware SLA、open age／SLA target；端到端腳本補 backlog，保留 source label |
| Enterprise 零完成違約受生成規則保證 | 生成範圍 18–43 天，SLA 45 天；目前已完成實際 18–42 天 | 不解讀為優秀團隊；揭露分群 SLA 不同、生成限制；不調資料製造違約 |
| SLA 分母不清楚 | 完成 238 件：Attained 156、Breached 82；另外 17 件 open | completed breach rate 與 overdue open backlog 分開呈現，不能藏掉未完成案件 |
| logged 不等於 completed activities | 3,898 筆＝Completed 3,428＋No Response 470 | 主分析使用 all logged；已修正 H3／assumptions 文字 |
| snapshot drop-off 可能含尚未進展，而非真正流失 | 原公式是 prior stage 減 next stage，包含 open | 保留 legacy 欄名供對帳，Dashboard 必須標示 snapshot 未進展；不稱永久流失 |
| 先看結果再調資料 | 歷史 v1→v2 改 score 及 win thresholds | 撤回「完全分析前凍結／獨立生成」說法；v2 僅作模擬方法示範，不稱獨立驗證商業假設 |
| 強求非預埋發現／null result | 不保證探索比較一定有可用結論 | 至少保留一項非預埋比較，允許不確定；3 findings 總數不變 |

## 可重跑驗證

從專案根目錄執行（只讀來源庫；view 為連線內暫存）：

```sh
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/03_quality_review.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/01_validate_sql_analysis.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/00_validate_simulated_data.sql
sqlite3 -readonly data/processed/project_b_simulated.sqlite < sql/02_end_to_end_analysis.sql
```

新檢查：onboarding account mismatch、join count 差、activity count 差、completed SLA label 差、future onboarding dates、future activities 全為 0。Integrity 為 `ok`；foreign key check 無違規。原 Phase 1 九項檢查均 PASS。

原 Phase 0 結構檢查全部 PASS；端到端分析修訂後執行成功。四份來源 CSV 的 SHA-256 與原 v2 凍結紀錄完全一致，未重新生成資料。

資料品質檢查通過不等於沒有生成偏差，也不代表使用者已會 SQL。SQL baseline 仍是歷史完成案件指標；新增 backlog 使用本次查詢對帳，Power BI 尚未驗證。
