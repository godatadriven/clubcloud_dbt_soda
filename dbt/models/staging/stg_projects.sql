{{
     config(
         materialized='incremental',
         incremental_strategy = 'insert_overwrite',
         schema = 'staging',
         unique_key='id',
         partition_by={
             "field": "created_timestamp",
             "data_type": "timestamp"
        }
     )
}}

{% set days_back = 1200 %}

SELECT * 
FROM {{source('libraries_io', 'projects')}}
WHERE TRUE

{% if is_incremental() %}
    AND DATE(created_timestamp) = DATE_SUB(CURRENT_DATE(), INTERVAL {{days_back}} DAY)
{% else %}
    AND DATE(created_timestamp) < DATE_SUB(CURRENT_DATE(), INTERVAL {{days_back}} DAY)
{% endif %}
