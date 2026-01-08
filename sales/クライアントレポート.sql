WITH account_table AS (
    SELECT 
        ac.account_id,
        ac.name AS account_name,
        ac.account_group_id,
        ag.company_name,
        ac.country_code 
    FROM 
        account ac
        LEFT JOIN account_group ag ON ac.account_group_id = ag.account_group_id
),
filtered_costs AS (
    SELECT
        at.account_id,
        at.country_code ,
        media,
        campaign_name,
        adgroup_id,
        adgroup_name, -- ← The comma was added here
        DATE_FORMAT(collect_date, '%Y-%m-%d') AS day,
        DATE_FORMAT(collect_date, '%Y-%m') AS report_month,
        CONCAT(
            DATE_FORMAT(DATE_SUB(collect_date, INTERVAL WEEKDAY(collect_date) DAY), '%c/%e'),
            '～',
            DATE_FORMAT(DATE_ADD(DATE_SUB(collect_date, INTERVAL WEEKDAY(collect_date) DAY), INTERVAL 6 DAY), '%c/%e')
        ) AS report_week,
        SUM(cost) AS cost,
        SUM(impression) AS imp,
        SUM(click) AS click,
        SUM(click) / NULLIF(SUM(impression), 0) AS CTR,
        SUM(cost) / NULLIF(SUM(click), 0) AS CPC,
        SUM(cv_conversion) AS cv,
        SUM(cv_conversion) / NULLIF(SUM(click), 0) AS CVR,
        SUM(cost) / NULLIF(SUM(cv_conversion), 0) AS CPA,
        SUM(cv_purchased) AS purchased,
        SUM(cv_purchased) / NULLIF(SUM(cost), 0) AS ROAS, 
        SUM(cv_add_cart_conversion) AS Cart_cv,
        SUM(cv_add_cart_conversion) / NULLIF(SUM(click), 0) AS Cart_CVR
    FROM
        v_dashboard vd
        LEFT JOIN account_table at ON vd.account_id = at.account_id
    WHERE
        collect_date BETWEEN '${start_date}' AND '${end_date}'
        /*AND at.account_group_id = '${account_group_id}'*/
    GROUP BY
        at.account_id, adgroup_id, media, day, report_month, report_week
)
SELECT 
	at.account_id, 
    at.account_name,
    at.account_group_id ,
    at.company_name,
    at.country_code ,
    fc.report_month,
    fc.cost
FROM 
    account_table at
LEFT JOIN 
    filtered_costs fc ON at.account_id = fc.account_id
WHERE
    fc.cost IS NOT NULL
    AND fc.cost > 0
    AND at.account_group_id IS NOT NULL