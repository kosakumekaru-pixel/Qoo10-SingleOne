WITH account_table AS (
    SELECT 
        ac.account_id,
        ac.name AS account_name,
        ac.account_group_id,
        ac.account_category_id,
        ca.name AS category_name
    FROM 
        account ac
    LEFT JOIN 
        account_category ca  ON ac.account_category_id = ca.account_category_id 
)
SELECT 
	at.account_id,
	at.account_name,
	at.account_group_id,
	at.category_name,
	vd.adgroup_id,
	vd.adgroup_name,
	vd.collect_date,
	SUM(vd.cost) AS cost,
	SUM(vd.impression) AS imp,
	SUM(vd.cost) / NULLIF(SUM(vd.impression)/1000, 0) AS cpm,
	SUM(vd.click) AS cl,
	SUM(vd.click) / NULLIF(SUM(vd.impression), 0) AS ctr,
	SUM(vd.cost)/SUM(vd.click) AS cpc,
	SUM(vd.cv_conversion) AS cv,
	SUM(vd.cv_conversion) / NULLIF(SUM(vd.click), 0) AS cvr,
	SUM(vd.cost) / NULLIF(SUM(vd.cv_conversion), 0) AS cpa,
	SUM(vd.cv_purchased) AS sales,
	SUM(vd.cv_purchased) / NULLIF(SUM(vd.cost), 0) AS ROAS,
	SUM(vd.cv_add_cart_conversion) cart,
	SUM(vd.cv_add_cart_conversion) / NULLIF(SUM(vd.click), 0) AS cart_cvr,
	SUM(vd.cost) / NULLIF(SUM(vd.cv_add_cart_conversion), 0) AS cart_cpa
FROM 
	v_dashboard vd 
	left join account_table at on vd.account_id = at.account_id 
WHERE
	vd.collect_date BETWEEN '${start_date}' AND '${end_date}'
	AND vd.cost > 0
	AND at.account_id IS NOT NULL
	/*AND at.account_id = '${account_id}'*/
GROUP BY 
    at.account_id,
	at.account_name,
	at.account_group_id,
	at.category_name,
	vd.adgroup_id,
	vd.adgroup_name,
	vd.collect_date