 SELECT js.submission_number ,
        js.company_name,
        js.company_registration_number,
        js.country_code ,
        js.company_zipcode ,
        js.company_address ,
        js.ad_manager_name ,
        js.ad_manager_email ,
        js.finance_manager_name ,
        js.finance_manager_email ,
        js.company_phone ,
        js.seller_name AS shop_name,
        js.seller_id,
        js.seller_url,
        js.created_at 
    FROM join_submission js 
    UNION ALL
    SELECT 
    	NULL AS submission_number ,
        NULL  AS company_name,
        NULL AS company_registration_number,
        NULL AS country_code,
        NULL AS company_zipcode ,
        NULL AS company_address ,
        NULL AS ad_manager_name,
        am.created_by AS ad_manager_email ,
        NULL AS finance_manager_name,
        NULL AS finance_manager_email,
        NULL AS company_phone ,
        am.seller_name AS shop_name,
        am.seller_id,
        am.seller_url,
        am.created_at 
    FROM account_management am 
    WHERE am.type = 'CREATE_REQUEST'