SELECT
	u.account_group_id,
	ag.company_name,
	ag.country_code ,
	u.user_id,
	u.send_email,
	u.user_level
FROM
	user u
	LEFT JOIN account_group ag  ON u.account_group_id  = ag.account_group_id
WHERE 
	u.active_yn = 'Y'
	AND u.user_level ='user'
group BY
	ag.account_group_id 