WITH account_table AS (
    SELECT 
        a.account_id,
        a.name AS account_name,
        a.account_group_id,
        ag.company_name, 
        a.country_code 
    FROM account a  
    LEFT JOIN account_group ag 
        ON a.account_group_id = ag.account_group_id 
    WHERE a.account_group_id IS NOT NULL
),
cost_summary AS (
    SELECT 
        vd.account_id,
        SUM(vd.cost) AS total_cost
    FROM v_dashboard vd
    WHERE vd.collect_date BETWEEN '2025-08-27' AND '2025-08-30'
    GROUP BY vd.account_id
)
SELECT 
    at.account_group_id,
    at.company_name
FROM account_table at
LEFT JOIN cost_summary cs 
    ON at.account_id = cs.account_id
GROUP BY at.account_group_id, at.company_name
HAVING 
    COALESCE(SUM(cs.total_cost), 0) = 0
ORDER BY at.company_name;
