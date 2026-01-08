SELECT
	Info.CampaignKey AS CampaignKey,
	Info.Name AS Name,
	Info.Id AS Id,
	Total.collect_date AS collectDate,
	IFNULL(Total.Impressions, 0) AS impression,
	IFNULL(Total.Clickthrus, 0) AS clicks,
	IFNULL(Total.Clickthrus / Total.Impressions, 0) AS ctr,
	IFNULL(Total.Cpm, 0) AS cpm,
	IFNULL(Total.Cpc, 0) AS cpc,
	IFNULL(Total.Cost, 0) AS cost,
	IFNULL(Total.conversions, 0) AS conversions,
	IFNULL(Total.sales, 0) AS sales,
	IFNULL(Total.carts, 0) AS carts,
	IFNULL(Total.cartSales, 0) AS cartSales,
	IFNULL(Total.`start`, 0) AS `start`,
	IFNULL(Total.firstQuarter, 0) AS firstQuarter,
	IFNULL(Total.secondQuarter, 0) AS secondQuarter,
	IFNULL(Total.thirdQuarter, 0) AS thirdQuarter,
	IFNULL(Total.completed, 0) AS completed,
	IFNULL(Total.skip, 0) AS skip,
	IFNULL(Total.progress, 0) AS progress
FROM (
	SELECT
		DISTINCT cam.Id AS Id, cam.Name AS Name, cam.CampaignKey AS CampaignKey
	FROM OAS.Campaign cam
	JOIN RETAIL.account acc ON acc.advertiser_key = cam.AdvertiserKey
	JOIN (SELECT AvCampaignKey FROM OAS.rCam WHERE AccountKey = 1003) rc ON rc.AvCampaignKey = cam.AvCampaignKey
	-- 修正点1: アカウント絞り込みを削除 (全アカウント対応)
) Info
LEFT JOIN (
	SELECT
		Id, collect_date,
        SUM(Impressions) AS Impressions, SUM(Clickthrus) AS Clickthrus, SUM(Cpm) AS Cpm, SUM(Cpc) AS Cpc, SUM(Cost) AS Cost, 
        SUM(conversions) AS conversions, SUM(sales) AS sales, SUM(carts) AS carts, SUM(cartSales) AS cartSales, 
        SUM(`start`) AS `start`, SUM(firstQuarter) AS firstQuarter, SUM(secondQuarter) AS secondQuarter, SUM(thirdQuarter) AS thirdQuarter, SUM(completed) AS completed, SUM(skip) AS skip, SUM(progress) AS progress
	FROM (
		-- === 動画トラッキングデータ ===
		SELECT
			video.Id AS Id, video.event_date AS collect_date, 0 AS Impressions, 0 AS Clickthrus, 0 AS Cpm, 0 AS Cpc, 0 AS Cost, 0 AS conversions, 0 AS sales, 0 AS carts, 0 AS cartSales,
            SUM(video.track_sv) AS `start`, 
            SUM(video.track_1v) AS firstQuarter, 
            SUM(video.track_2v) AS secondQuarter, 
            SUM(video.track_3v) AS thirdQuarter, 
            SUM(video.track_vc) AS completed, 
            SUM(video.track_kv) AS skip, 
            SUM(video.track_vt) AS progress
		FROM (
			SELECT vc.Id, rcb.rmWhen AS event_date, rcb.Impressions AS track_sv, 0 AS track_1v, 0 AS track_2v, 0 AS track_3v, 0 AS track_vc, 0 AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_sv' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, rcb.Impressions AS track_1v, 0 AS track_2v, 0 AS track_3v, 0 AS track_vc, 0 AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_1v' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, 0 AS track_1v, rcb.Impressions AS track_2v, 0 AS track_3v, 0 AS track_vc, 0 AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_2v' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, 0 AS track_1v, 0 AS track_2v, rcb.Impressions AS track_3v, 0 AS track_vc, 0 AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_3v' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, 0 AS track_1v, 0 AS track_2v, 0 AS track_3v, rcb.Impressions AS track_vc, 0 AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_vc' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, 0 AS track_1v, 0 AS track_2v, 0 AS track_3v, 0 AS track_vc, rcb.Impressions AS track_vt, 0 AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_vt' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
			UNION ALL
			SELECT vc.Id, rcb.rmWhen AS event_date, 0 AS track_sv, 0 AS track_1v, 0 AS track_2v, 0 AS track_3v, 0 AS track_vc, 0 AS track_vt, rcb.Impressions AS track_kv FROM RETAIL.campaign vc JOIN OAS.Creative cr ON vc.CampaignKey = cr.CampaignKey JOIN OAS.rCamBan rcb ON cr.AvCreativeKey = rcb.AvCreativeKey WHERE cr.Name = 'track_kv' AND rcb.RmWhen BETWEEN '2025-09-01' AND '2025-11-20'
		) video
		WHERE video.Id IN (
			SELECT
				DISTINCT cam.Id
			FROM OAS.Campaign cam
			JOIN RETAIL.account acc ON acc.advertiser_key = cam.AdvertiserKey
			JOIN (SELECT AvCampaignKey FROM OAS.rCam WHERE AccountKey = 1003 AND RmWhen BETWEEN '2025-09-01' AND '2025-11-20') rc ON rc.AvCampaignKey = cam.AvCampaignKey
			-- 修正点2: Video Trackingのフィルタを削除
		)
		GROUP BY Id, collect_date
		UNION ALL
		-- === 費用・クリックデータ ===
		SELECT
			c.Id AS Id,
			rc.RmWhen AS collect_date,
			rc.Impressions,
			rc.Clickthrus,
			cb.Cpm,
			cb.Cpc,
			GREATEST(cb.Cpc * rc.Clickthrus, rc.Impressions * cb.Cpm / 1000) AS Cost,
			0 AS conversions,
			0 AS sales,
			0 AS carts,
			0 AS cartSales,
			0 AS `start`,
			0 AS firstQuarter,
			0 AS secondQuarter,
			0 AS thirdQuarter,
			0 AS completed,
			0 AS `skip`,
			0 AS `progress`
		FROM (
			SELECT
				AvCampaignKey, RmWhen, Impressions, Clickthrus
			FROM OAS.rCam
			WHERE AccountKey = 1003
			AND RmWhen BETWEEN '2025-09-01' AND '2025-11-20') rc
		-- 修正点3: Campaign BillingのJOIN条件からアカウント絞り込みを削除
		JOIN (SELECT cam.* FROM OAS.Campaign cam JOIN RETAIL.account acc ON acc.advertiser_key = cam.AdvertiserKey) c ON rc.AvCampaignKey = c.AvCampaignKey
		JOIN OAS.CamBilling cb ON c.CampaignKey = cb.CampaignKey
		UNION ALL
		-- === コンバージョンデータ ===
		SELECT
			singleone_ad_id AS Id,
			collect_date,
			0 AS Impressions,
			0 AS Clickthrus,
			0 AS Cpm,
			0 AS Cpc,
			0 AS Cost,
			conversions,
			sales,
			carts,
			cart_sales,
			0 AS `start`,
			0 AS firstQuarter,
			0 AS secondQuarter,
			0 AS thirdQuarter,
			0 AS completed,
			0 AS `skip`,
			0 AS `progress`
		FROM RETAIL.conversion_stat
		WHERE collect_date BETWEEN '2025-09-01' AND '2025-11-20'
		AND singleone_ad_id IN (
			SELECT
				DISTINCT cam.Id
			FROM OAS.Campaign cam
			JOIN RETAIL.account acc ON acc.advertiser_key = cam.AdvertiserKey
			JOIN (SELECT AvCampaignKey FROM OAS.rCam WHERE AccountKey = 1003 AND RmWhen BETWEEN '2025-09-01' AND '2025-11-20') rc ON rc.AvCampaignKey = cam.AvCampaignKey
			-- 修正点4: Conversion Trackingのフィルタを削除
		)
		) summagtion
	GROUP BY Id, collect_date
) Total ON Total.Id = Info.Id
ORDER BY Id ASc, collect_date ASC