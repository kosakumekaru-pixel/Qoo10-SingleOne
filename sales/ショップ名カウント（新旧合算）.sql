WITH account_table AS(
SELECT 
a.account_id ,
a.name as account_name,
ag.account_group_id ,
ag.company_name ,
ag.country_code 
FROM account a 
left join account_group ag on a.account_group_id = ag.account_group_id 
)
SELECT 
	at.account_id,
    at.account_name,
    at.account_group_id,
    at.company_name,
    at.country_code
FROM
	account_table at
order by
	account_id 
	
	