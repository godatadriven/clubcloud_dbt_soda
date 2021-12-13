{{
    config(
    materialized='table'
    , schema='marts_core'
    , unique_key='project_id'
    )
}}


with project_repos as (
    select *
         except(homepage_url)
        , case when homepage_url = 'UNKNOWN' then null else homepage_url end as homepage_url
    from {{ ref('int_project_repos') }}

)
select * from project_repos