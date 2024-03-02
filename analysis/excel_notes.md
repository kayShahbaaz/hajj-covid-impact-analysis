# Excel Cleaning & Exploration Notes
# ملاحظات تنظيف واستكشاف البيانات في Excel

**Author / المؤلف:** Kay Shahbaaz / خ شهباز  
**File worked on:** `attendance.csv`, `economic.csv`, `deaths.csv`, `countries.csv`  
**Tool:** Microsoft Excel 2021

---

## Why Excel first / لماذا Excel أولاً

Before I moved anything into SQLite I wanted to just *look* at the data. Excel is good for that. You can scroll through it, spot weird things quickly, and make pivot tables without writing a single line of code. I used it mostly for the cleaning and the early exploration, then moved into SQL once I knew what I was actually working with.

---

## attendance.csv — steps taken

### 1. Checked for missing values
- Opened the file, used **Filter** on every column to check for blanks
- `official_cap` column had blanks for 2017, 2018, 2019, 2023 — these are correct (no cap existed in those years), left as empty
- No other missing values found

### 2. Formatted numbers
- `total_pilgrims`, `internal_pilgrims`, `external_pilgrims` columns — applied **Number format** with comma separator so they were readable (e.g. 2,352,122 instead of 2352122)
- Confirmed no decimal values — these should all be whole numbers

### 3. Added a calculated column: `recovery_pct`
- Formula used: `=ROUND(B2/2489406*100, 2)` where B2 = total_pilgrims, 2489406 = 2019 baseline
- Dragged down for all 7 rows
- This gave me: 94.5%, 95.3%, 100%, 0.04%, 2.41%, 36.13%, 74.11%
- Used this column to quickly visualise the dip and recovery

### 4. Added a column: `yoy_change_pct`
- Formula: `=ROUND((B3-B2)/B2*100, 2)` from row 3 onwards (2018 onwards)
- Showed me the -99.96% drop in 2020 immediately — that was the moment I knew this data told a real story

### 5. Quick bar chart in Excel
- Selected `year` and `total_pilgrims` columns
- Insert > Clustered Bar Chart
- Just for my own reference — the actual dashboard is in HTML

---

## economic.csv — steps taken

### 1. Verified revenue figures
- Cross-checked the `estimated_revenue_usd_billion` column against Arab News and Halal Times sources
- 2019 figure of $12B confirmed by Arab News official data
- 2020 figure of $0.1B is an estimate — noted this clearly in the `notes` column

### 2. Added column: `revenue_loss_vs_2019`
- Formula: `=C2-12` where C2 = estimated_revenue_usd_billion, 12 = 2019 baseline
- 2020 shows -11.9, which became a key number in the final report

### 3. Pivot table — average revenue by period
- Rows: `year`
- Values: `estimated_revenue_usd_billion` (Average)
- Grouped manually into Pre-COVID, Lockdown, Recovery
- Pre-COVID average: ~$9.8B / Lockdown average: ~$0.45B / Recovery average: ~$7.85B

---

## deaths.csv — steps taken

### 1. Conditional formatting
- Applied **colour scale** to `reported_deaths` column (green = low, red = high)
- Made 2023's 240 deaths stand out immediately against the 0s of 2020-2021

### 2. Noted data quality issue
- 2020 and 2021 deaths = 0, but this partly reflects the tiny crowd size, not necessarily better safety management
- Added a note in the `notes` column to flag this for the SQL analysis

### 3. Added column: `deaths_per_100k` (manual check)
- Formula: `=ROUND(B2/C2*100000, 2)` — used this to verify my SQL query later gave the same result
- 2023: 13.02 deaths per 100k is notably higher than pre-COVID years (around 1.5–1.8)

---

## countries.csv — steps taken

### 1. Added column: `pct_of_top10_total_2017`
- Formula: `=ROUND(D2/SUM($D$2:$D$11)*100, 1)` where D = pilgrims_2017
- Indonesia: 22.2%, Pakistan: 18.0%, India: 17.1% — the top 3 account for 57.3% of top-10 pilgrims

### 2. Pivot table — regional breakdown
- Rows: `region`
- Values: `pilgrims_2017` (Sum)
- South Asia dominates: 476,408 pilgrims (47.8% of top 10 total)
- Southeast Asia: 221,000 (22.2%)
- Arab: 108,000 (10.8%)

### 3. Sorted by `pilgrims_2017` descending
- Indonesia consistently #1 — world's largest Muslim-majority nation

---

## General notes

- I kept the original CSVs untouched and did all Excel work in a separate workbook. The CSVs in `/data/` are the clean versions I exported after.
- Some numbers (especially economic impact) are estimates, not hard official figures. I've been transparent about this in both the SQL notes and the final report.
- Excel pivot tables were mainly to sanity-check what I was seeing — the real analysis lives in the SQL file.

---

*KayShahbaaz / خ شهباز*
