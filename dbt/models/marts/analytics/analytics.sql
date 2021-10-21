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
{% set days_back = 7 %}

with project_versions as(
    select project_name,
           project_id,
           project_description,
           repo_name,
           repo_owner,
           platform,
           repository_url,
           language,
           project_created_timestamp,
           count(*) as total_version_count,
           sum(case when updated_timestamp >= date_sub(max(updated_timestamp), interval {{days_back}} day) then 1 else 0 end ) as releases_last_week
    from {{ ref('project_versions') }}

)
select * from project_versions
