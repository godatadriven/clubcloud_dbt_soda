with projects as (

    select *
    from {{ ref('stg_projects') }}


),

repos as (

    select *
    from {{ ref('stg_repos') }}


),


projects_repos as (
    select projects.*,
           repos.description,
           repos.created_timestamp,
           repos.updated_timestamp,
           repos.last_pushed_timestamp,
           repos.size,
           repos.stars_count,
           repos.issues_enabled,
           repos.wiki_enabled,
           repos.pages_enabled,
           repos.forks_count,
           repos.open_issues_count
    from projects
    left join repos using (repository_id)





)