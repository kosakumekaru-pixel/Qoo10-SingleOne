WITH account_table AS (
    SELECT 
        a.account_id,
        a.name AS account_name,
        a.account_group_id,
        ag.company_name,
        a.country_code
    FROM 
        account a 
        LEFT JOIN account_group ag ON a.account_group_id = ag.account_group_id 
  ),
  base as (
  select at.account_id ,
  at.account_name,
         at.account_group_id,
         at.company_name,
         at.country_code,
         c.credit_id 
	from account_table at
	left join credit c on at.account_id = c.account_id 
  )
SELECT b.account_id ,
  b.account_name,
         b.account_group_id,
         b.company_name,
         b.country_code,
         ca.`type` ,
         ca.amount ,
         ca.balance ,
         ca.created_at ,
         ca.created_by 
FROM credit_audit ca 
left join 
base b on b.credit_id = ca.credit_id 