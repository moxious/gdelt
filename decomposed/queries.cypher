WITH [
   'ECON_TAXATION',
   'WB_1285_BUSINESS_TAXATION',
   'WB_1121_TAXATION',
   'WB_983_TAX_POLICY',
   'WB_1122_TAX_EXPENDITURES',
   'WB_1893_TAX_LAW',
   'WB_382_TAX_CREDITS_AND_DIRECT_SUBSIDIES',
   'WB_1845_CARBON_TAX',
   'WB_883_TAX_INCENTIVES',
   'WB_1815_FUEL_TAXES',
   'WB_720_TAX_AND_REVENUE_POLICY_AND_ADMINISTRATION',
   'WB_2786_LABOR_TAXES',
   'WB_2527_TAX_SIMPLIFICATION',
   'WB_2525_TAX_TRANSPARENCY',
   'WB_2075_TAX_CRIME'
] as taxThemes, 

['foxnews.com', 'nytimes.com', 'cnn.com'] AS sources

MATCH (s:Source)
WHERE s.name IN sources
WITH s

/* Get all events where this source was talking about that theme set */
MATCH (s)<-[:FROM]-(:Document)<-[:DOCUMENT]-(e:Event)-[:THEME]->(t)
WITH
    s.name as source,
    t.name as Theme, 
    count(e) as DataPoints,
    avg(e.Tone) as avgTone,
    avg(e.PositiveScore) as avgPositiveScore,
    avg(e.NegativeScore) as avgNegativeScore,
    avg(e.Polarity) as avgPolarity,
    avg(e.ActivityReferenceDensity) as avgActivityReferenceDensity,
    avg(e.SelfGroupReferenceDensity) as avgSelfGroupReferenceDensity,
    avg(e.WordCount) as avgWordCount
WHERE DataPoints >= 5
RETURN source, Theme, DataPoints, avgTone, avgPositiveScore,
    avgNegativeScore, avgPolarity, avgActivityReferenceDensity,
    avgSelfGroupReferenceDensity, avgWordCount
ORDER BY Theme, DataPoints DESC;