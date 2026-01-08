WITH account_table AS (
    SELECT 
        a.account_id,
        a.name AS account_name,
        a.account_group_id,
        ag.company_name,
        a.country_code,
        a.account_category_id,
        ca.name AS category_name
    FROM 
        account a 
        LEFT JOIN account_group ag ON a.account_group_id = ag.account_group_id 
        LEFT JOIN account_category ca ON a.account_category_id = ca.account_category_id 
),
filtered_costs AS ( 
    SELECT
        t.account_id,
        t.media,
        t.collect_date,
        SUM(t.cost) AS cost,
        SUM(t.impression) AS report_imp,
        SUM(t.click) AS report_click,
        SUM(t.cv_conversion) AS report_cv,
        SUM(t.cv_purchased) AS report_purchased,
        SUM(t.cv_add_cart_conversion) AS report_cart_cv
    FROM ad_stat t  
    WHERE t.collect_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) 
        AND t.collect_date < CURRENT_DATE()
    GROUP BY t.account_id, t.collect_date, t.media
)
SELECT 
    at.account_id,
    at.account_name,
    at.account_group_id,
    at.company_name,
    at.country_code,
    at.category_name,
    fc.collect_date,
    fc.media,
    fc.cost,
    fc.report_imp,
    fc.report_click,
    fc.report_cv,
    fc.report_purchased,
    fc.report_cart_cv
FROM 
    account_table at
    LEFT JOIN filtered_costs fc ON at.account_id   = fc.account_id 
WHERE
    ( fc.cost IS NOT NULL AND fc.cost > 0 )
    OR ( fc.report_cv IS NOT NULL AND fc.report_cv >= 1 )
order by fc.collect_date ,at.account_id