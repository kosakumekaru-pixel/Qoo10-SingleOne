with criteo_table as (
select t.campaign_id ,
t.collect_date ,
t.media ,
t.cost ,
t.impression ,
t.click ,
t.cv_conversion ,
t.cv_purchased 
from ad_stat t 
where t.cost is not null
and t.cost > 0
and t.media = 'criteo'
union all 
SELECT t2.campaign_id ,
t2.collect_date ,
t2.media ,
t2.cost ,
t2.impression ,
t2.click ,
t2.cv_conversion ,
t2.cv_purchased
from ad_stat_criteo t2 
WHERE  t2.cost is not NULL 
and t2.cost > 0
),
account_tabel as( 
select a.account_id as shop_id,
a.name as shop_name,
a.account_group_id as company_id,
ag.company_name as conmpany_name
from account a 
left join account_group ag on a.account_group_id = ag.account_group_id 
),
base as( 
select csc.criteo_seller_campaign_id ,
at.shop_id ,
at.shop_name ,
at.company_id ,
at.conmpany_name
from criteo_seller_campaign csc 
left join account_tabel at on csc.account_id = at.shop_id  
)
select b.shop_id ,
b.shop_name ,
b.company_id ,
b.conmpany_name ,
ct.collect_date ,
ct.media ,
ct.cost ,
ct.impression ,
ct.click ,
ct.cv_conversion ,
ct.cv_purchased
from criteo_table ct
left join base b on ct.campaign_id = b.criteo_seller_campaign_id  
where ct.collect_date BETWEEN '${start_date}' AND '${end_date}'