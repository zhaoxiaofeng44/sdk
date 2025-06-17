--odps sql 
--********************************************************************--
--author:令孝
--create time:2025-02-24 10:53:54
--********************************************************************--
SET odps.instance.priority = 0;
SET odps.sql.mapper.split.size = 2056;



-- SELECT 
--     a.case_id,
--     b.spm_b,
--     --b.tabType,
--     COUNT(DISTINCT b.user_id) AS case_uv
-- FROM 
--     (
--         SELECT 
--             client_id,
--             case_id
--         FROM 
--             alsc_tech.alsc_victoria_abtest_tt_divide_flow_hour_inc
--         WHERE 
--             ds = '20250417'
--             AND case_id IN ('2802916', '2802924')  -- 用IN替代OR提升可读性和潜在索引命中
--             -- 若表分区合理，此处已触发分区裁剪
--     ) a
-- JOIN 
--     (
--         SELECT 
--             user_id, spm_b
--             --keyvalue (args, ',', '=', 'tab_type') as tabType
--         FROM 
--             --alsc_cdm.dwd_alsc_log_exp_base_hi
--             --salsc_cdm.dwd_ele_log_clk_hi 
--             alsc_cdm.dwd_ele_log_page_hi
--         WHERE 
--             ds = '20250417'
--             AND app_version = '11.21.90'
--             AND spm_a = 'a2ogi'     
--             AND spm_b IN ('b68407963', '11834809')
--             AND spm_c = 'payments_Button_custom'      
--     ) b 
-- ON 
--     a.client_id = b.user_id
-- GROUP BY 
--     a.case_id, b.spm_b
-- ORDER BY 
--     a.case_id, b.spm_b;   -- 若结果集较小，排序开销可忽略





-- SELECT 
--     user_id, spm_c 
--     --,keyvalue (args, ',', '=', 'tab_name') as title
-- FROM 
--     alsc_cdm.dwd_alsc_log_exp_base_hi
--     --alsc_cdm.dwd_ele_log_clk_hi 
-- WHERE 
--     ds = '20250406'
--     AND spm_a = 'a2ogi'         
--     AND spm_b = 'b68407963'
--     AND spm_c = 'payments_Button_custom'
-- Limit 100;

    
 


-- SELECT 
--     user_id 
--         --,keyvalue (args, ',', '=', 'tab_name') as title
-- FROM 
--     alsc_cdm.dwd_alsc_log_exp_base_hi
--     --alsc_cdm.dwd_ele_log_clk_hi 
-- WHERE 
--     ds = '20250407'
--     AND spm_a = 'a2ogi'         
--     AND spm_b IN ('b68407963', '11834809')
-- GROUP BY user_id
-- HAVING SUM(CASE WHEN spm_c = 'tab' THEN 1 ELSE 0 END) > 0
-- AND SUM(CASE WHEN spm_c != 'payments_Button' THEN 1 ELSE 0 END) = 0



--  SELECT 
--             user_id, spm_b, spm_c,
--             keyvalue (args, ',', '=', 'tab_name') as title
--         FROM 
--             alsc_cdm.dwd_alsc_log_exp_base_hi
--             --alsc_cdm.dwd_ele_log_clk_hi 
--         WHERE 
--             ds = '20250410'
--             AND app_version = '11.21.90'
--             AND spm_a = 'a2ogi'         
--             AND spm_b IN ('b68407963', '11834809')
--             AND spm_c = 'tab'





SELECT 
    c.case_id,
    d.user_id
FROM 
    (
        SELECT 
            client_id,
            case_id
        FROM 
            alsc_tech.alsc_victoria_abtest_tt_divide_flow_hour_inc
        WHERE 
            ds = '20250417'
            AND case_id = '2802924'
    ) c
JOIN 
    (
        SELECT 
            a.user_id,
            b.spm_b
        FROM 
            (
                SELECT user_id
                FROM alsc_cdm.dwd_alsc_log_exp_base_hi
                GROUP BY user_id
                HAVING COUNT(CASE WHEN b = 'payments_Button_custom' THEN 1 END) = 0
            ) a
        JOIN 
            (
                SELECT 
                    user_id, spm_b
                FROM 
                    alsc_cdm.dwd_ele_log_page_hi
                WHERE 
                    ds = '20250417'
                    AND app_version = '11.21.90'
                    AND spm_a = 'a2ogi'     
                    AND spm_b = 'b68407963'    
            ) b 
        ON 
            a.user_id = b.user_id
    ) d 
ON 
    c.client_id = d.user_id
LIMIT 2000;