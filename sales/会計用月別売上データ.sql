WITH account_table AS (
    SELECT 
        ac.account_id,
        ac.name AS account_name,
        ac.account_group_id,
        ag.company_name,
        ac.country_code
    FROM 
        account ac
        left join account_group ag on ac.account_group_id = ag.account_group_id 
),
filtered_costs AS (
SELECT
    account_id,
    media,
    DATE_FORMAT(MIN(collect_date), '%Y-%m') AS month,
    SUM(cost) AS cost
FROM ad_stat t 
WHERE collect_date >= '${start_date}' AND collect_date <= '${end_date}'
GROUP BY account_id, media, YEAR(collect_date), MONTH(collect_date)
)
SELECT 
    at.account_id as shop_id,
    at.account_name as shop_name,
    at.account_group_id as company_id ,
    at.company_name as company_name ,
    at.country_code,
    fc.month,
    fc.media ,
    fc.cost
FROM 
    account_table at
LEFT JOIN 
    filtered_costs fc ON at.account_id = fc.account_id
WHERE
    fc.cost IS NOT NULL
    AND fc.cost > 0
	AND at.account_group_id  IS NOT NULL
ORDER BY
    fc.cost DESC, fc.month;