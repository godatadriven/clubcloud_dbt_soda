{{
     config(
         materialized='incremental',
         incremental_strategy = 'insert_overwrite',
         schema = 'core',
         unique_key='project_id',
         partition_by={
             "field": "project_created_timestamp",
             "data_type": "timestamp"
        }
     )
}}
{% set days_back = 7 %}

with latest_date as (
    select
            max(version_updated_timestamp) as latest_date
    from    {{ ref('project_versions') }}


),

project_versions as(
    select
           project_id,
           project_name,
           project_description,
           repo_name,
           repo_owner,
           platform,
           repository_url,
           language,
           project_created_timestamp,
           count(*) as total_version_count,
           sum(case when DATE(version_updated_timestamp) >= date_sub(DATE(latest_date.latest_date), interval {{days_back}} day) then 1 else 0 end ) as releases_last_week
    from {{ ref('project_versions') }}
    cross join latest_date
    group by
           1,2,3,4,5,6,7,8,9
)
select * from project_versions
