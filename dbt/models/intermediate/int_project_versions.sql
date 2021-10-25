{{
    config(
    materialized='table'
    , schema='intermediate'
    , unique_key='version_id'
    )
}}

with versions as (

    select
           id as version_id,
           project_id,
           number,
           published_timestamp as version_published_timestamp,
           created_timestamp as version_created_timestamp,
           updated_timestamp as version_updated_timestamp

    from {{ ref ('stg_versions') }}

),

project_versions as (

    select versions.*,
           project_repos.* except (project_id),

    from versions
    left join {{ ref('int_project_repos') }} on project_repos.project_id = versions.project_id

)

select * from project_versions