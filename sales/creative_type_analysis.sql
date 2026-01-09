WITH account_table AS (
    SELECT 
        ac.account_id,
        ac.name AS account_name,
        ac.account_group_id,
        ag.company_name,
        ac.account_category_id,
        ca.name AS category_name,
        ac.country_code
    FROM 
        account ac
        left join account_group ag on ac.account_group_id = ag.account_group_id 
        LEFT JOIN account_category ca  ON ac.account_category_id = ca.account_category_id 
),
filtered_costs AS (
    SELECT
        account_id,
        media,
        adgroup_id,
        adgroup_name,
        ad_id,
        ad_name,
        DATE_FORMAT(collect_date, '%Y-%m-%d') AS day,
        SUM(cost) AS report_cost,
        SUM(impression) AS report_imp,
        SUM(click) AS report_click,
        SUM(cv_conversion) AS report_cv,
        SUM(cv_purchased ) AS report_purchased,
        SUM(cv_add_cart_conversion) AS report_cart_cv
    FROM
        v_dashboard
    WHERE
        collect_date BETWEEN '${start_date}' AND '${end_date}'
    GROUP BY
        ad_id , media, day -- account_idと抽出した年月でグループ化
)
SELECT 
    at.account_id,
    at.account_name,
    at.account_group_id ,
    at.company_name,
    at.country_code,
    at.category_name,
    fc.media,
    fc.adgroup_id,
    fc.adgroup_name,
    fc.ad_id,
    fc.ad_name,
    fc.day,
    fc.report_cost,
    fc.report_imp,
    fc.report_click,
    fc.report_cv,
    fc.report_purchased,
	fc.report_cart_cv
FROM 
    account_table at
LEFT JOIN 
    filtered_costs fc ON at.account_id = fc.account_id
WHERE
    fc.report_cost IS NOT NULL
    AND fc.report_cost > 0
	AND at.account_group_id  IS NOT NULL
ORDER BY
    fc.ad_id , fc.media, fc.day;