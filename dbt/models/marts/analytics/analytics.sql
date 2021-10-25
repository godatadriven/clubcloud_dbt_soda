{{
    config(
    materialized='table'
    , schema='marts_analytics'
    , unique_key='project_id'
    )
}}


{% set days_back = 7 %}
{% set max_ingested_date = max_date_from_table('version_updated_timestamp', 'project_versions') %}

with project_versions as(
    select
           project_id,
           project_name,
           repo_name,
           repo_owner,
           platform,
           repository_url,
           language,
           project_created_timestamp,
           count(*) as total_version_count,
           sum(case when DATE(version_updated_timestamp) >= date_sub(DATE({{ max_ingested_date }}), interval {{days_back}} day) then 1 else 0 end ) as releases_last_week
    from {{ ref('project_versions') }}
    group by
           1,2,3,4,5,6,7,8,9
)
select * from project_versions
