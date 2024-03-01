WITH CountryMedians AS (
    SELECT
        country,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(daily_vaccinations AS FLOAT)) OVER (PARTITION BY country) AS median_vaccinations
    FROM
        dbo.country_vaccination_stats
),
ImputedData AS (
    SELECT
        v.country,
        v.date,
        COALESCE(v.daily_vaccinations, cm.median_vaccinations, 0) AS daily_vaccinations
    FROM
        dbo.country_vaccination_stats v
    LEFT JOIN CountryMedians cm ON v.country = cm.country
)

SELECT *
FROM ImputedData;
