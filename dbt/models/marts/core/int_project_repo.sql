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


with projects as (

    select *
    from {{ ref('stg_projects') }}


),

repos as (

    select *
    from {{ ref('stg_repos') }}


),


projects_repos as (
    select projects.id as project_id,
           projects.name as project_name,
           projects.description as project_description,
           projects.platform,
           projects.repository_url,
           projects.language,
           projects.created_timestamp as project_created_timestamp,
           repos.id as repo_id,
           repos.name_with_owner as repo_name_with_owner,
           repos.description as repos_description,
           repos.created_timestamp as repo_created_timestamp,
           repos.updated_timestamp as repo_updated_timestamp,
           repos.last_pushed_timestamp as repo_last_pushed_timestamp,
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

select * from projects_repos