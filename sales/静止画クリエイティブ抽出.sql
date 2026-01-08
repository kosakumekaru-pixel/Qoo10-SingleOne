with cr_table as (
select t.ad_id ,
t.account_id ,
t.adgroup_name ,
t.media ,
t.collect_date ,
am.conversion_event,
am.custom_audience,
SUM(t.cost) as cost ,
SUM(t.impression) as imp ,
SUM(t.click) as cl ,
SUM(t.cv_conversion) as cv ,
SUM(t.cv_purchased) as sales 
FROM ad_stat t 
left join adgroup_meta am on t.adgroup_id = am.adgroup_id 
WHERE t.collect_date >= '${start_date}' AND t.collect_date <= '${end_date}'
AND t.account_id IN (${account_id})
and t.media = '${media}'
AND (( t.cost IS NOT NULL AND t.cost > 0 )
OR ( t.cv_conversion  IS NOT NULL AND t.cv_conversion >= 1 ))
group by t.collect_date , t.adgroup_name
),
img_url as(
select ad.ad_id,
i.origin_file_name,
i.saved_file_name 
from image i 
left join ${ad_media} ad on i.image_id  = ad.image 
where ad.image IS NOT NULL
)
SELECT iu.origin_file_name ,
concat('https://www.singleone.jp/upload/IMAGE/', iu.saved_file_name ) as img_url,
ct.account_id ,
ct.adgroup_name ,
ct.conversion_event ,
ct.custom_audience ,
ct.collect_date ,
ct.cost,
ct.imp ,
ct.cl ,
ct.cv ,
ct.sales 
FROM cr_table ct
left join img_url iu on ct.ad_id = iu.ad_id 
where iu.saved_file_name IS NOT NULL
and ct.account_id IN (${account_id})
group by iu.origin_file_name , ct.adgroup_name, ct.collect_date 
order by cost desc ;