select
	ce.account_group_id,
	ce.account_id,
	ce.amount,
	ce.created_at 
FROM 
	credit_exchange ce 
where
	created_at >= '2025-06-01'