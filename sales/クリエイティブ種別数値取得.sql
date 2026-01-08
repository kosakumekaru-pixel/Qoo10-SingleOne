SELECT t.collect_date ,
vau.account_id ,
vau.image_id ,
vau.video_id ,
am.conversion_event,
am.custom_audience,
SUM(t.cost) AS cost ,
SUM(t.impression ) as imp,
SUM(t.click) AS cl ,
SUM(t.cv_conversion) AS cv ,
SUM(t.cv_purchased ) AS sales,
sum(t.cv_add_cart_conversion )as cart
FROM ad_stat t 
LEFT JOIN v_ad_unified vau ON t.ad_id = vau.ad_id 
left join adgroup_meta am on t.adgroup_id = am.adgroup_id 
WHERE t.collect_date >= '${start_date}' AND t.collect_date <= '${end_date}'
AND vau.account_id IN (${account_id})
AND ( t.cost IS NOT NULL AND t.cost > 0 )
OR ( t.cv_conversion  IS NOT NULL AND t.cv_conversion >= 1 )
group by t.collect_date , t.adgroup_name ,vau.image_id ,vau.video_id 