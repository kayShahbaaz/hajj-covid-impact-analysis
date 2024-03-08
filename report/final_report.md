# Final Report: Hajj Pilgrimage COVID-19 Impact Analysis (2017–2023)
# التقرير النهائي: تحليل أثر كوفيد-19 على موسم الحج (2017–2023)

**Author / المؤلف:** kayShahbaaz / خ شهباز   
**Dataset period / فترة البيانات:** 2017–2023  
**Tools / الأدوات:** SQLite · Microsoft Excel · HTML/CSS/JS · Chart.js

---

## 1. Introduction / المقدمة

Hajj is one of the five pillars of Islam and the largest annual human gathering on the planet. In normal years, somewhere between 2 and 2.5 million Muslims travel to Makkah, Saudi Arabia, to perform rituals that have been carried out for over 1,400 years. The pilgrimage is deeply personal for the people who make it — many save for decades, and for some it's a once-in-a-lifetime journey.

When COVID-19 hit in 2020, Saudi Arabia made a decision that shocked a lot of people: they restricted Hajj to just 1,000 residents. That's a 99.96% reduction from the 2.49 million who attended in 2019.

This project is an attempt to actually sit with that number and understand what it means — for the pilgrims, for the Saudi economy, and for the recovery that followed. I collected seven years of data (2017 to 2023), cleaned it in Excel, queried it in SQLite, and built a dashboard to visualise the findings.

---

## 2. Data Overview / نظرة عامة على البيانات

The dataset covers seven consecutive Hajj seasons:

| Year | Total Pilgrims | Phase |
|------|---------------|-------|
| 2017 | 2,352,122 | Normal |
| 2018 | 2,371,675 | Normal |
| 2019 | 2,489,406 | Pre-COVID Peak |
| 2020 | 1,000 | Strictest Lockdown |
| 2021 | 60,000 | Locals Only |
| 2022 | 899,353 | Controlled Reopening |
| 2023 | 1,845,045 | Near-Normal Return |

**Data sources:** GASTAT (Saudi General Authority for Statistics), Saudi Ministry of Hajj and Umrah, CDC Yellow Book, Arab News, Al Jazeera, AFP.

All attendance figures are official counts published by GASTAT on the 9th of Dhu al-Hijjah each year — the final day of the main Hajj rituals.

---

## 3. Pre-COVID Baseline (2017–2019) / الخط الأساسي قبل كوفيد

Between 2017 and 2019, Hajj attendance was growing steadily:

- 2017: 2,352,122
- 2018: 2,371,675 (+0.83% YoY)
- 2019: 2,489,406 (+4.96% YoY)

The average annual attendance across these three years was **2,404,401 pilgrims.** The 2019 figure became my baseline for all recovery calculations throughout this project — it represents the last "normal" year before the pandemic.

The pre-COVID pilgrim split was roughly **75% international, 25% internal (Saudi).** Saudi Arabia operates a quota system allocating approximately 1,000 Hajj permits per 1 million Muslims in each country, which is why Indonesia (world's largest Muslim population) consistently sends the most pilgrims.

---

## 4. The COVID Years (2020–2021) / سنوات كوفيد

### 2020 — Strictest Lockdown / أشد القيود صرامة

The 2020 Hajj season was unlike anything in modern history. Saudi Arabia announced that only Saudi residents — approximately 1,000 people — would be permitted. The reasons were straightforward: COVID-19 was spreading rapidly, vaccines didn't exist yet, and a gathering of 2+ million people from 180+ countries would have been an epidemiological disaster.

**Key restrictions in 2020:**
- Saudi residents only (no international pilgrims)
- Age limit: under 65
- Required: negative PCR test (vaccines not yet available)
- No physical contact with the Kaaba permitted

The result: **1,000 pilgrims.** A 99.96% drop from 2019.

My SQL query for year-on-year change showed:
```
2019 → 2020: -2,488,406 pilgrims (-99.96%)
```

That's not a typo. Two and a half million people to one thousand.

### 2021 — Domestic Only / السعوديون فقط

In 2021, restrictions eased slightly. Saudi nationals and residents were permitted — up to 60,000 vaccinated individuals under 65. International pilgrims were still banned entirely.

**Key restrictions in 2021:**
- Saudi nationals and residents only
- Must be vaccinated (Pfizer, Moderna, AstraZeneca, J&J approved)
- Age limit: under 65
- Capacity set at 60,000

Year-on-year change from my SQL:
```
2020 → 2021: +59,000 pilgrims (+5,900%)
```

The percentage looks dramatic but in absolute terms it's still just 60,000 people — 2.41% of the 2019 baseline.

---

## 5. The Recovery (2022–2023) / مرحلة التعافي

### 2022 — Controlled Reopening / إعادة الفتح المنضبط

2022 was the first year international pilgrims were allowed back since 2019. The Saudi government set a cap of 1 million — roughly 50% of pre-COVID international quotas. Only vaccinated pilgrims under 65 were permitted.

**Final 2022 count: 899,353 pilgrims** (just under the 1M cap — some countries couldn't fill their quota due to ongoing logistics and visa delays)

Recovery percentage: **36.1% of the 2019 baseline**

### 2023 — Near-Normal Return / العودة شبه الطبيعية

2023 saw all COVID restrictions officially lifted. No age limits, no vaccine mandates, full international quotas restored. The result was the largest Hajj since the pandemic.

**Final 2023 count: 1,845,045 pilgrims**  
Recovery percentage: **74.1% of the 2019 baseline**

The YoY jump from 2022 to 2023:
```
2022 → 2023: +945,692 pilgrims (+105.2%)
```

Still not fully back to pre-COVID levels — there's a 26% gap remaining — but the trajectory is clearly upward and strong.

---

## 6. Makkah vs Madinah / مكة المكرمة والمدينة المنورة

While the official GASTAT Hajj count refers to Makkah attendance (where the core Hajj rituals take place), the vast majority of pilgrims also visit Madinah to pray at the Prophet's Mosque. Historically, Madinah visits track at roughly 80–85% of the Makkah figure.

During 2020 and 2021, Madinah visits dropped to near zero — the controlled bubble made movement between cities extremely limited. The 2022 and 2023 recoveries restored both cities.

---

## 7. Country of Origin Analysis / تحليل دول المنشأ

Based on 2017 data (the most complete year in the dataset):

**Top 5 sending countries:**
1. Indonesia — 221,000 (22.2% of top-10 total)
2. Pakistan — 179,210 (18.0%)
3. India — 170,000 (17.1%)
4. Bangladesh — 127,198 (12.8%)
5. Egypt — 108,000 (10.8%)

**Regional breakdown (from my SQL pivot):**
- South Asia: 47.8% (India, Pakistan, Bangladesh combined)
- Southeast Asia: 22.2% (Indonesia)
- Arab countries: 10.8% (Egypt)
- Middle East/Africa: remaining share

The Saudi quota system (1,000 permits per million Muslims) means this distribution roughly mirrors global Muslim population distribution. In 2020 and 2021, all international quotas were suspended. In 2022, they were restored at ~50%.

---

## 8. Economic Impact / الأثر الاقتصادي

Hajj and Umrah combined generate approximately **$12 billion annually** for Saudi Arabia in normal years — about 20% of non-oil GDP.

| Year | Est. Revenue (USD) | Jobs Supported |
|------|-------------------|----------------|
| 2019 | $12.0B | 350,000 |
| 2020 | $0.1B | 15,000 |
| 2021 | $0.8B | 40,000 |
| 2022 | $5.2B | 236,897 |
| 2023 | $10.5B | 350,000 |

**Estimated 2020 revenue loss vs 2019: ~$11.9 billion**

The hospitality, transport, and retail sectors in Makkah and Madinah were effectively shut down for two years. The 2022 recovery was significant but incomplete — international pilgrims at 50% quota meant hotels and operators were running at partial capacity.

By 2023, the economic recovery appears to be running slightly ahead of the attendance recovery — 2023 revenue (~$10.5B) is about 87.5% of the 2019 figure, while attendance is at 74.1%. This makes sense: 2023 pilgrims included more international visitors (who spend more per person than domestic pilgrims) and Saudi infrastructure had been upgraded during the pandemic period.

Saudi Arabia's Vision 2030 has set a target of $350 billion from the Hajj and Umrah tourism market by 2032 — an extremely ambitious figure that would require nearly 30x growth from current levels.

---

## 9. Safety & Deaths / السلامة والوفيات

Pilgrims who pass away during Hajj are considered to have died in a blessed state of worship — this is a great honour. From a data perspective, deaths do occur each year due to extreme heat, the physically demanding rituals, and the scale of the gathering. The 2020 and 2021 zeros are an artifact of the tiny, tightly-controlled crowds — not evidence of improved safety management.

| Year | Deaths | Deaths per 100K Pilgrims |
|------|--------|--------------------------|
| 2017 | 35 | 1.49 |
| 2018 | 31 | 1.31 |
| 2019 | 42 | 1.69 |
| 2020 | 0 | 0 |
| 2021 | 0 | 0 |
| 2022 | 15 | 1.67 |
| 2023 | 240 | 13.02 |

The 2020 and 2021 zeros are an artifact of the tiny, tightly-controlled crowds — not evidence of improved safety management.

The 2023 figure is concerning. 240 deaths — mostly Indonesian pilgrims, mostly heat-related — gives a mortality rate of **13.02 per 100,000**, which is roughly 8x higher than the pre-COVID average. Temperatures in Makkah have been rising by approximately 0.4°C per decade, and the 2023 Hajj coincided with a particularly hot period.

This is a data story that doesn't appear in the attendance numbers at all. The recovery looks clean on a chart — but 2023 also had the deadliest season since 2019 in terms of per-capita mortality. Something worth watching.

The worst single incident in Hajj history was the 2015 Mina stampede, which killed an estimated 2,400+ pilgrims. By comparison, the COVID years were ironically among the safest in terms of crowd incidents — for obvious reasons.

---

## 10. 2024 Forecast / توقعات 2024

As of early 2024, this analysis is a retrospective. The 2024 Hajj season hasn't happened yet.

Based on the recovery trajectory:
- 2021: 2.4% of 2019
- 2022: 36.1% of 2019
- 2023: 74.1% of 2019

The trend suggests 2024 could reach or surpass the 2019 baseline. My estimate is **1.9M–2.3M pilgrims**, with a point estimate around **2.1M**.

Factors supporting this:
- All COVID restrictions lifted
- No age limits
- Strong pent-up demand (millions couldn't attend 2020–2022)
- Saudi government actively incentivising return
- Masjid al-Haram expansion increasing physical capacity

Factors that could limit it:
- Heat risk (2023 deaths may discourage some elderly pilgrims)
- Visa and logistics backlogs in some countries
- Economic pressures in major sending countries reducing affordability

My forecast is cautiously optimistic. The structural demand for Hajj doesn't disappear — it accumulates. The people who couldn't go in 2020, 2021, and 2022 didn't stop wanting to go.

---

## 11. Limitations / القيود

I want to be honest about what this analysis can and can't do.

1. **Economic figures are estimates.** The $12B baseline comes from Arab News citing official 2019 data. The other years are proportional estimates based on attendance. Real revenue data would require access to Saudi tourism ministry financial reports.

2. **Deaths data is likely undercounted.** Official Saudi figures tend to be conservative. The 2015 stampede official count was 769; independent estimates put it at 2,400+. The 2023 figure of 240 is an official count and the real number may be higher.

3. **Madinah figures are estimated.** GASTAT publishes Hajj (Makkah) counts. Madinah visitor numbers are estimated at 80–85% of Makkah based on historical reporting patterns, not official data.

4. **Country data for 2020–2022 is incomplete.** Due to restrictions, the country-of-origin breakdown wasn't publicly reported in the same detail as normal years.

5. **This is a solo student project.** I've been careful with the data but I'm not a professional analyst. Please verify key figures against the primary sources listed below before citing this work.

---

## 12. Conclusion / الخلاصة

The COVID-19 pandemic reduced Hajj attendance by 99.96% in a single year. That's a number that's hard to really absorb until you look at it on a chart.

What I find genuinely interesting about this data is how *deliberate* the Saudi government's response looks in retrospect. The 2020 shutdown was total. The 2021 easing was cautious and domestic only. The 2022 reopening was capped and conditional. The 2023 return was full. Each step was calculated — and the data shows it clearly.

By 2023, attendance was back to 74% of the 2019 peak. The economy was close behind. The deaths data is a quiet warning that not everything recovered cleanly.

The 2024 season should, if the trend holds, bring us close to or past the 2019 baseline. When that happens, the COVID disruption will look like a sharp V on a chart. But for the 2+ million people who couldn't make the journey in 2020, the chart doesn't really capture it.

---

## Sources / المصادر

1. GASTAT — gastat.gov.sa — official Hajj statistics 2017–2023
2. Saudi Ministry of Hajj and Umrah — haj.gov.sa
3. CDC Yellow Book 2024 — Health requirements for Hajj
4. Arab News — "Unpacking the Hajj dividend" (2023)
5. Al Jazeera — Country breakdown figures 2017
6. AFP / PBS NewsHour — 2023 deaths reporting
7. Halal Times — Hajj industry economic analysis
8. Future Market Insights — Vision 2030 projections
9. About Islam / IlmFeed — 2017 country pilgrim numbers

---

*KyayShahbaaz / خ شهباز*
