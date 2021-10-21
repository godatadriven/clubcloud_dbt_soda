{{
     config(
         materialized='incremental',
         incremental_strategy = 'insert_overwrite',
         schema = 'core',
         unique_key='version_id',
         partition_by={
             "field": "version_created_timestamp",
             "data_type": "timestamp"
        }
     )
}}



with project_versions as (

    select *
    from {{ ref('int_project_versions') }}

)

select * from project_versions