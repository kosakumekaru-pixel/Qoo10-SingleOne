    SELECT 
        NULL AS account_group_id,
        aa.corporation_name AS company_name,
        aa.corporate_number AS company_registration_number,
        NULL AS account_id,
        aa.qoo10_shop_name AS shop_name,
        aa.ad_manager AS ad_manager_name,
        aa.contact_email AS ad_manager_email,
        aa.financial_officer AS finance_manager_name,
        aa.email_address AS finance_manager_email,
        aa.qoo10_seller_id AS seller_id,
        aa.page_url AS seller_url
    FROM account_application aa 
    UNION ALL
    SELECT 
    	NULL AS account_group_id,
        js.company_name,
        js.company_registration_number,
        NULL AS account_id,
        js.seller_name AS shop_name,
        js.ad_manager_name,
        js.ad_manager_email,
        js.finance_manager_name,
        js.finance_manager_email,
        js.seller_id,
        js.seller_url
    FROM join_submission js 
    UNION ALL
    SELECT 
    	am.account_group_id ,
        ag.name  AS company_name,
        NULL AS company_registration_number,
        a.account_id ,
        am.seller_name AS shop_name,
        NULL AS ad_manager_name,
        am.created_by AS ad_manager_email,
        NULL AS finance_manager_name,
        NULL AS finance_manager_email,
        am.seller_id,
        am.seller_url
    FROM account_management am 
    left join account a on am.seller_name = a.name 
    left join account_group ag on am.account_group_id = ag.account_group_id 
    WHERE am.type = 'CREATE_REQUEST'