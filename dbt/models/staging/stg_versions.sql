{{
     config(
         materialized='incremental',
         incremental_strategy = 'insert_overwrite',
         schema = 'staging',
         unique_key='id',
         partition_by={
             "field": "updated_timestamp",
             "data_type": "timestamp"
        }
     )
}}

{% set days_back = 1200 %}

SELECT *
FROM {{source('libraries_io', 'versions')}}
WHERE TRUE

{% if is_incremental() %}
    AND DATE(updated_timestamp) = DATE_SUB(CURRENT_DATE(), INTERVAL {{days_back}} DAY)
{% else %}
    AND DATE(updated_timestamp) < DATE_SUB(CURRENT_DATE(), INTERVAL {{days_back}} DAY)
{% endif %}
