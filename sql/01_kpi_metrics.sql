UPDATE raw_campaign_data
SET channel_used = TRIM(BOTH '""' FROM channel_used);

SELECT 
    Channel_used,
    SUM(Acquisition_cost) AS Total_Spend,
    SUM(Clicks) AS Total_Clicks,
    SUM(Revenue) AS Total_Revenue,
    ROUND((SUM(Clicks) / NULLIF(SUM(Impressions), 0)::NUMERIC) * 100, 2) AS CTR_Percentage,
    ROUND(SUM(Revenue) / NULLIF(SUM(Acquisition_cost), 0), 2) AS ROAS
FROM 
    raw_campaign_data
WHERE
    Channel_used NOT LIKE '%,%'
GROUP BY 
    Channel_used
ORDER BY 
    Total_Revenue DESC;