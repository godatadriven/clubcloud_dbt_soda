{{
    config(
    materialized='table'
    , schema='intermediate'
    , unique_key='project_id'
    )
}}


with projects as (

    select *
    from {{ ref('stg_projects') }}


),

repos as (

    select *
    from {{ ref('stg_repos') }}


),


project_repos as (
    select
           projects.* except(id, name, created_timestamp, description),
           projects.id as project_id,
           projects.name as project_name,
           projects.created_timestamp as project_created_timestamp,
           projects.description as project_description,
           repos.description as repo_description,
           {{ dbt_utils.split_part(string_text= 'name_with_owner', delimiter_text='"/"', part_number=1) }} as repo_name,
           {{ dbt_utils.split_part(string_text= 'name_with_owner', delimiter_text='"/"', part_number=2) }} as repo_owner,
           repos.created_timestamp as repo_created_timestamp,
           repos.updated_timestamp as repo_updated_timestamp,
           repos.last_pushed_timestamp,
           repos.size,
           repos.stars_count,
           repos.issues_enabled,
           repos.wiki_enabled,
           repos.pages_enabled,
           repos.forks_count,
           repos.open_issues_count
    from projects
    left join repos on repos.id = projects.repository_id





)
select * from project_repos