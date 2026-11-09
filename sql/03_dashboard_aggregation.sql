-- Daily aggregation layer that feeds the Power BI data model (Query1).
-- Grain: campaign_date x channel_used x campaign_type x customer_segment.
SELECT
    Channel_used,
    Campaign_type,
    Customer_segment,
    SUM(Acquisition_cost) AS Total_Spend,
    SUM(Clicks) AS Total_Clicks,
    SUM(Revenue) AS Total_Revenue,
    ROUND((SUM(Clicks) / NULLIF(SUM(Impressions), 0)::NUMERIC) * 100, 2) AS CTR_Percentage,
    ROUND(SUM(Revenue) / NULLIF(SUM(Acquisition_cost), 0), 2) AS ROAS,
    TO_DATE(Campaign_date, 'DD-MM-YYYY') AS Campaign_date,
    CASE
       WHEN Channel_used LIKE '%,%' THEN 'Data Driven'
       ELSE 'Last Click'
    END AS Attribution_model
FROM
    raw_campaign_data
GROUP BY
    Channel_used, TO_DATE(Campaign_date, 'DD-MM-YYYY'), campaign_type, customer_segment
ORDER BY
    TO_DATE(Campaign_date, 'DD-MM-YYYY') DESC, Total_Revenue DESC;
