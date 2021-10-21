{{
     config(
         materialized='incremental',
         incremental_strategy = 'insert_overwrite',
         schema = 'core',
         unique_key='id',
         partition_by={
             "field": "created_timestamp",
             "data_type": "timestamp"
        }
     )
}}

with repos as (
    select *
    from {{ref('stg_repos')}}


)
select * from repos
