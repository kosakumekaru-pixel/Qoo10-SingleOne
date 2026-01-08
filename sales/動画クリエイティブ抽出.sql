with cr_table as (
select vd.ad_id ,
vd.account_id ,
vd.adgroup_id ,
vd.media ,
vd.collect_date ,
SUM(vd.cost) AS cost ,
SUM(vd.impression) AS imp ,
SUM(vd.click) AS cl ,
SUM(vd.cv_conversion) AS cv ,
SUM(vd.cv_purchased) AS sales 
FROM v_dashboard vd 
where vd.collect_date BETWEEN '${start_date}' AND '${end_date}'
and vd.media = '${media}'
and vd.cost >0
group by vd.ad_id 
),
img_url as(
select ad.ad_id,
ad.sub_media,
v.saved_file_name 
from ${ad_media} ad 
left join video v on ad.video = v.video_id 
/*where ad.video IS NOT NULL*/
)
SELECT ct.ad_id ,
/*concat('https://www.singleone.jp/upload/VIDEO/', iu.saved_file_name ) as img_url,*/
iu.sub_media ,
ct.account_id ,
ct.adgroup_id ,
ct.collect_date ,
ct.cost ,
ct.imp ,
ct.cl ,
ct.cv ,
ct.sales 
FROM cr_table ct
left join img_url iu on ct.ad_id = iu.ad_id 
/*where iu.saved_file_name IS NOT NULL*/
group by ct.ad_id/* ,iu.saved_file_name*/
order by cost desc ;