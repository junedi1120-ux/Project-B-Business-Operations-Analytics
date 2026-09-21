# 正式執行計畫修訂｜2026-09-19

## 目標與完成線

用同一個模擬 B2B Sales & Onboarding 案例，補上可驗證的 SQL／Power BI 能力，支援 Operations、Sales／Commercial Operations、Strategy／Program／Project 等投遞方向；不限定 BizOps Manager，也不轉向 Data Analyst。

作品是能力佐證，不等於企業實務年資、進階 SQL 能力或錄取保證。職缺要求對照見 `job_skill_evidence.md`。以基本 SQL、報表、營運判斷為要求的職缺最接近本案完成線；要求大型資料分析、系統維運或特定工具實務經驗者，標明缺口，不擴大本案。

## 固定範圍與工時

總上限仍為 **50 小時**，不是從今天另起 50 小時。以下是原定預算，不是已花時間。既往實際投入未完整記錄，不能宣稱已完成 9 小時、剩 41 小時，也不能用檔案數推算工時。

| Phase | 預算 | 具體產出／工作配置 | 驗收 |
|---|---:|---|---|
| 0 環境與資料 | 8h | 環境與 JD 對照 1.5h；四表生成 3h；dictionary／假設／品質檢查 3.5h。沿用 v2，不重建資料 | 四表筆數、鍵值、日期與狀態核對；明示 simulated；披露生成修訂與 SLA 限制；Windows 作者環境另列未解決門檻 |
| 1 SQL | 12h | 基本 SQL 實作 5h；AI 輔助理解與修改 3h；端到端查詢與數字驗證 4h | 使用者完成 `phase_1_handson_checklist.md`；查詢可執行不等於個人通過 |
| 2 Power BI | 18h | 可用環境／匯入 1h；Power Query 清理 3h；relationships／calendar 3h；基本 DAX／KPI 4h；兩頁視覺與互動 3h；SQL 對帳 2h；美化最多 2h | 本人實作匯入、模型與 measure；兩頁可互動；整體＋一個分群對帳；PBIX 可儲存並重開 |
| 3 判讀與建議 | 5h | 分析比較 2h；3 findings／3 recommendations 2h；假設與限制核對 1h | 每項 finding 有查詢／數值來源；每項建議有 baseline、target、estimated impact、responsible role、tracking metric |
| 4 作品包裝 | 4h | 一頁摘要 1h；README 1.5h；兩張截圖、SQL、sample／processed data、PBIX 與揭露核對 1.5h | Hiring Manager 不開 PBIX 也能理解問題、方法、判斷、限制；不得宣稱真實營運成效 |
| 5 面試 | 3h | 英文 1h；簡潔日文 1h；追問與現場改題 1h | 本人能回答 KPI 理由、JOIN、驗證、最重要 finding、管理下一步；能修改一個篩選條件並解釋結果 |
| 合計 | **50h** | 修訂與品質工作包含在上述配額，不另外追加 | 時數與能力分開記錄 |

新增修訂工作優先使用原 Phase 中尚未使用的時間，取代重複教學與裝飾，不增加時數。因缺少既往紀錄，目前不能保證所有剩餘工作能在剩餘預算內完成。後續逐次記錄實際主動投入；若超出可用時間，先刪裝飾與重複範例，不刪必要驗證；到 50h 仍未通過的項目誠實標示未完成，不延至 60–70h。

## 兩頁 Dashboard，不加第三頁

1. Executive Commercial Health：funnel／snapshot conversion、closed win rate、deal value、sales cycle、segment performance。
2. Funnel & Process Diagnostics：completed onboarding cycle、completed SLA breach、overdue open 件數／age、snapshot 未進展比例、logged activity frequency、bottleneck。

保留 region、company size、industry、deal size 篩選。Calendar 是原規格中的模型輔助表，不是第二個 dataset。日期角色必須標示：sales 預設 lead cohort，onboarding 預設 start cohort；不能把不同時間基準當同一轉換率。避免多重篩選路徑；activities 先彙總或用明確 measures，不能造成商機重複計數。四份原始 CSV 是來源；SQL baseline 只作對帳，不當作代替 DAX 的儀表板來源。

## 分析可信度修訂

- 保留 3 個預埋情境，但不得叫作獨立發現。原資料曾在查看結果後改生成規則，必須揭露。
- 至少做一項非預埋比較（例如 lead source），可得到差異、無明顯差異或證據不足；不強迫湊出新發現或 null result。
- 最終仍只有 3 findings，可選一項探索性比較納入；其餘檢查放方法／限制，不另加第四個 finding。
- 各分群附樣本數；活動量與 win rate 只談關聯，記錄活動機會長短、deal mix 等限制。
- SLA 顯示完成案件分母，同時揭露逾期未完成 backlog；Enterprise 不違約不能解讀成營運優秀。
- estimated impact 是有假設的情境估算，不是已發生改善。金額如無可靠轉換依據，使用天數或件數。

## AI 與本人分工

AI 可起草程式、解釋錯誤、產生測試與文件草稿。本人必須能從白話題目寫基本 SQL，說明 JOIN 如何避免重複、KPI 分母與排除範圍，修改 AI 查詢並檢查結果；亦須實際操作 Power BI 建模與 measures。教學可在 Chat 進行，回報題目、本人答案、驗證結果；不以「Chat 說通過」直接驗收。

目前已有資料與 SQL 草稿；**Phase 1 已於 2026-09-20 依約定完成線通過個人驗收，Power BI 尚未完成**。下一階段先確認 Parallels／Windows／Power BI Desktop 實作環境，不重複從頭生成資料，也不把 SQL 通過誇大為進階 SQL 獨立熟練。

## 主要超時風險與停止條件

- SQL 基礎尚未穩固：一次只練一個觀念，先給欄位／值／完整題意，不讓使用者猜欄位。
- Mac 無已確認的 Power BI Desktop 作者環境：Phase 2 開始前解決；不得先購買、建立帳號或改用其他 BI。
- 清理生成偏差變成重做資料：保留 v2，改解釋與計算層；不為 desired result 調整原資料。
- 美化無止境：2h 即停；只保留兩頁。
- 工時缺少可信歷史：不造估算進度；先標記未知，後續記錄日期、工作、本人投入分鐘、驗收證據。

## 不變的 Stop Line

不加入 Python、ML、forecasting model、高階 DAX、資料工程 pipeline、網站、第二 dataset／case、PL-300、Tableau／Looker、第三頁，亦不為展示 Window Function 硬塞分析。
