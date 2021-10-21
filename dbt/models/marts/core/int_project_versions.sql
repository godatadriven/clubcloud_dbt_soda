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


with versions as (

    select *,
           id as version_id,
           created_timestamp as version_created_timestamp
    from {{ ref ('stg_versions') }}

),

project_versions as (

    select versions.*,
           project_repos.*
    from versions
    left join {{ ref('project_repos') }} on project_repos.project_id = versions.project_id

)

select * from project_versions