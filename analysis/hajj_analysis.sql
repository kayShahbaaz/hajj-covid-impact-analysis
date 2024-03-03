-- ============================================================
-- Hajj COVID Impact Analysis
-- تحليل أثر كوفيد-19 على موسم الحج
-- Author: Kay Shahbaaz / خ شهباز
-- Date: Early 2024
-- Database: SQLite
-- ============================================================

-- ============================================================
-- STEP 1: Create tables
-- إنشاء الجداول
-- ============================================================

CREATE TABLE IF NOT EXISTS attendance (
    year INTEGER PRIMARY KEY,
    total_pilgrims INTEGER,
    internal_pilgrims INTEGER,
    external_pilgrims INTEGER,
    official_cap INTEGER,
    phase TEXT
);

CREATE TABLE IF NOT EXISTS policy (
    year INTEGER PRIMARY KEY,
    phase TEXT,
    who_allowed TEXT,
    age_limit TEXT,
    covid_requirement TEXT,
    international_allowed TEXT,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS countries (
    rank INTEGER,
    country TEXT,
    region TEXT,
    pilgrims_2017 INTEGER,
    pilgrims_2023 INTEGER,
    quota_per_million INTEGER
);

CREATE TABLE IF NOT EXISTS economic (
    year INTEGER PRIMARY KEY,
    estimated_revenue_usd_billion REAL,
    jobs_supported INTEGER,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS deaths (
    year INTEGER PRIMARY KEY,
    reported_deaths INTEGER,
    primary_cause TEXT,
    severity TEXT,
    notes TEXT
);

-- ============================================================
-- STEP 2: Insert data
-- إدخال البيانات
-- ============================================================

INSERT INTO attendance VALUES (2017, 2352122, 612000,  1740122, NULL,    'Normal');
INSERT INTO attendance VALUES (2018, 2371675, 612953,  1758722, NULL,    'Normal');
INSERT INTO attendance VALUES (2019, 2489406, 634379,  1855027, NULL,    'Pre-COVID Peak');
INSERT INTO attendance VALUES (2020, 1000,    1000,    0,       10000,   'Strictest Lockdown');
INSERT INTO attendance VALUES (2021, 60000,   60000,   0,       60000,   'Locals Only');
INSERT INTO attendance VALUES (2022, 899353,  119434,  779919,  1000000, 'Controlled Reopening');
INSERT INTO attendance VALUES (2023, 1845045, 221854,  1611310, NULL,    'Near-Normal Return');

INSERT INTO economic VALUES (2017, 8.5,  280000, 'Normal year');
INSERT INTO economic VALUES (2018, 9.0,  290000, 'Slight growth');
INSERT INTO economic VALUES (2019, 12.0, 350000, 'Peak revenue year');
INSERT INTO economic VALUES (2020, 0.1,  15000,  'Near total loss');
INSERT INTO economic VALUES (2021, 0.8,  40000,  'Marginal recovery');
INSERT INTO economic VALUES (2022, 5.2,  236897, 'International pilgrims restored');
INSERT INTO economic VALUES (2023, 10.5, 350000, 'Strong rebound');

INSERT INTO deaths VALUES (2017, 35,  'Natural causes and heat', 'Low',      'No major incidents');
INSERT INTO deaths VALUES (2018, 31,  'Natural causes',          'Low',      'Quiet year');
INSERT INTO deaths VALUES (2019, 42,  'Natural causes and heat', 'Low',      'Pre-COVID peak year');
INSERT INTO deaths VALUES (2020, 0,   'N/A',                     'None',     'Controlled bubble');
INSERT INTO deaths VALUES (2021, 0,   'N/A',                     'None',     'Zero incidents');
INSERT INTO deaths VALUES (2022, 15,  'Natural causes',          'Low',      'Controlled reopening');
INSERT INTO deaths VALUES (2023, 240, 'Heat and natural causes', 'Moderate', 'Rising heat concern');

INSERT INTO countries VALUES (1,  'Indonesia', 'Southeast Asia', 221000, 221000, 1000);
INSERT INTO countries VALUES (2,  'Pakistan',  'South Asia',     179210, 179210, 1000);
INSERT INTO countries VALUES (3,  'India',     'South Asia',     170000, 175000, 1000);
INSERT INTO countries VALUES (4,  'Bangladesh','South Asia',     127198, 127000, 1000);
INSERT INTO countries VALUES (5,  'Egypt',     'Arab',           108000, 108000, 1000);
INSERT INTO countries VALUES (6,  'Iran',      'Middle East',    86500,  87500,  1000);
INSERT INTO countries VALUES (7,  'Nigeria',   'Africa',         79000,  95000,  1000);
INSERT INTO countries VALUES (8,  'Turkey',    'Middle East',    79000,  79000,  1000);
INSERT INTO countries VALUES (9,  'Algeria',   'Africa',         36000,  36000,  1000);
INSERT INTO countries VALUES (10, 'Morocco',   'Africa',         31000,  31000,  1000);

-- ============================================================
-- STEP 3: Exploratory queries
-- استعلامات استكشافية
-- ============================================================

-- Q1: Full attendance overview
-- نظرة عامة على الحضور الكامل
SELECT
    year                                            AS "Year / السنة",
    total_pilgrims                                  AS "Total Pilgrims / إجمالي الحجاج",
    phase                                           AS "Phase / المرحلة",
    ROUND(total_pilgrims * 100.0 / 2489406, 2)     AS "% of 2019 Baseline / % من 2019"
FROM attendance
ORDER BY year;

-- Q2: Year-on-year change using LAG window function
-- التغيير من سنة لأخرى
SELECT
    year,
    total_pilgrims,
    LAG(total_pilgrims) OVER (ORDER BY year)        AS prev_year_pilgrims,
    total_pilgrims - LAG(total_pilgrims) OVER (ORDER BY year) AS absolute_change,
    ROUND(
        (total_pilgrims - LAG(total_pilgrims) OVER (ORDER BY year)) * 100.0
        / LAG(total_pilgrims) OVER (ORDER BY year),
    2)                                              AS pct_change
FROM attendance
ORDER BY year;

-- Q3: COVID impact — label each year with a phase category
-- تصنيف كل سنة حسب المرحلة
SELECT
    year,
    total_pilgrims,
    CASE
        WHEN year < 2020              THEN 'Pre-COVID Normal / ما قبل كوفيد'
        WHEN year = 2020              THEN 'Full Lockdown / إغلاق كامل'
        WHEN year = 2021              THEN 'Domestic Only / محلي فقط'
        WHEN year = 2022              THEN 'Partial Reopening / إعادة فتح جزئي'
        WHEN year = 2023              THEN 'Near Normal / شبه طبيعي'
        ELSE                               'Unknown'
    END                                             AS covid_phase
FROM attendance
ORDER BY year;

-- Q4: Average attendance pre-COVID vs during vs recovery
-- متوسط الحضور قبل وخلال وبعد كوفيد
SELECT
    CASE
        WHEN year BETWEEN 2017 AND 2019 THEN 'Pre-COVID (2017-2019)'
        WHEN year BETWEEN 2020 AND 2021 THEN 'Lockdown (2020-2021)'
        WHEN year BETWEEN 2022 AND 2023 THEN 'Recovery (2022-2023)'
    END                                             AS period,
    COUNT(*)                                        AS years_count,
    ROUND(AVG(total_pilgrims), 0)                   AS avg_pilgrims,
    MIN(total_pilgrims)                             AS min_pilgrims,
    MAX(total_pilgrims)                             AS max_pilgrims
FROM attendance
GROUP BY period
ORDER BY MIN(year);

-- Q5: Internal vs external split by year
-- الانقسام بين الحجاج الداخليين والخارجيين
SELECT
    year,
    total_pilgrims,
    internal_pilgrims,
    external_pilgrims,
    ROUND(internal_pilgrims * 100.0 / total_pilgrims, 1) AS internal_pct,
    ROUND(external_pilgrims * 100.0 / total_pilgrims, 1) AS external_pct
FROM attendance
ORDER BY year;

-- Q6: Economic impact per pilgrim (revenue efficiency)
-- الأثر الاقتصادي لكل حاج
SELECT
    a.year,
    a.total_pilgrims,
    e.estimated_revenue_usd_billion,
    ROUND(
        (e.estimated_revenue_usd_billion * 1000000000) / a.total_pilgrims,
    0)                                              AS revenue_per_pilgrim_usd
FROM attendance a
JOIN economic e ON a.year = e.year
ORDER BY a.year;

-- Q7: Deaths per 100,000 pilgrims (mortality rate)
-- معدل الوفيات لكل 100,000 حاج
SELECT
    a.year,
    a.total_pilgrims,
    d.reported_deaths,
    d.primary_cause,
    CASE
        WHEN a.total_pilgrims = 0 THEN 0
        ELSE ROUND(d.reported_deaths * 100000.0 / a.total_pilgrims, 2)
    END                                             AS deaths_per_100k
FROM attendance a
JOIN deaths d ON a.year = d.year
ORDER BY a.year;

-- Q8: Top countries — total quota and regional breakdown
-- أفضل الدول من حيث الحصة والتوزيع الإقليمي
SELECT
    region,
    COUNT(*)                                        AS country_count,
    SUM(pilgrims_2017)                              AS total_pilgrims_2017,
    SUM(pilgrims_2023)                              AS total_pilgrims_2023,
    ROUND(SUM(pilgrims_2017) * 100.0 /
        (SELECT SUM(pilgrims_2017) FROM countries), 1) AS share_pct_2017
FROM countries
GROUP BY region
ORDER BY total_pilgrims_2017 DESC;

-- Q9: Recovery milestones — how many years to reach each threshold
-- معالم التعافي
SELECT
    year,
    total_pilgrims,
    ROUND(total_pilgrims * 100.0 / 2489406, 1)     AS recovery_pct,
    CASE
        WHEN total_pilgrims >= 2489406 * 0.75 THEN '75% recovered'
        WHEN total_pilgrims >= 2489406 * 0.50 THEN '50% recovered'
        WHEN total_pilgrims >= 2489406 * 0.25 THEN '25% recovered'
        WHEN total_pilgrims >= 2489406 * 0.10 THEN '10% recovered'
        ELSE 'Under 10%'
    END                                             AS recovery_milestone
FROM attendance
WHERE year >= 2020
ORDER BY year;

-- Q10: Combined summary view — all key metrics in one place
-- ملخص شامل لجميع المؤشرات الرئيسية
SELECT
    a.year,
    a.total_pilgrims,
    a.phase,
    ROUND(a.total_pilgrims * 100.0 / 2489406, 1)   AS recovery_pct,
    e.estimated_revenue_usd_billion                 AS revenue_b,
    e.jobs_supported,
    d.reported_deaths,
    d.primary_cause
FROM attendance a
LEFT JOIN economic e ON a.year = e.year
LEFT JOIN deaths   d ON a.year = d.year
ORDER BY a.year;
