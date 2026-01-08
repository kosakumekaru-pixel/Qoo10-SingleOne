SELECT 
	rc.account_id ,
	rc.account_name ,
	rc.media ,
	rc.collect_date ,
	SUM(rc.cost) AS Gross ,
	SUM(rc.media_cost) AS Net 
FROM
	report_campaign rc
WHERE 
	rc.cost > 0
GROUP BY
	rc.account_id , rc.media ,rc.collect_date 