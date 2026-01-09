WITH account_list AS (
SELECT 
New.jaehu_id ,
New.account_id,
old.account_id AS OLD,
New.name ,
New.account_group_id ,
New.country_code ,
New.account_category_id
FROM qsm_mpa.account New 
left join qsm_v2.account old on New.jaehu_id = old.jaehu_id
),
account_table AS (
    SELECT 
        al.account_id,
        al.`OLD` ,
        al.name AS account_name,
        al.account_group_id,
        ag.company_name,
        al.country_code,
        al.account_category_id,
        ca.name AS category_name
    FROM 
        account_list al
        LEFT JOIN account_group ag ON al.account_group_id = ag.account_group_id 
        LEFT JOIN account_category ca ON al.account_category_id = ca.account_category_id 
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
    FROM qsm_v2.v_dashboard t  
    WHERE t.collect_date >= '${start_date}' AND t.collect_date <= '${end_date}'
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
    /*fc.report_cart_cv*/
FROM 
    account_table at
    LEFT JOIN filtered_costs fc ON at.`OLD`  = fc.account_id 
WHERE
    ( fc.cost IS NOT NULL AND fc.cost > 0 )
    OR ( fc.report_cv IS NOT NULL AND fc.report_cv >= 1 )
order by fc.collect_date ,at.account_id 