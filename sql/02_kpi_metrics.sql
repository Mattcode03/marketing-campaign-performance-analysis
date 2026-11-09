UPDATE raw_campaign_data
SET channel_used = TRIM(BOTH '""' FROM channel_used);

WITH roas_calc AS (
  SELECT
    campaign_type,
    ROUND(revenue / acquisition_cost, 2) AS roas
  FROM raw_campaign_data
),
categorised AS (
  SELECT
    campaign_type,
    CASE
      WHEN LENGTH(FLOOR(roas)::TEXT) >= 4 THEN 'very profitable'
      WHEN LENGTH(FLOOR(roas)::TEXT) = 3  THEN 'fairly profitable'
      ELSE 'barely profitable'
    END AS profitability
  FROM roas_calc
)
SELECT
  campaign_type,
  profitability,
  COUNT(*) AS total_campaigns
FROM categorised
GROUP BY campaign_type, profitability
ORDER BY campaign_type, total_campaigns DESC;