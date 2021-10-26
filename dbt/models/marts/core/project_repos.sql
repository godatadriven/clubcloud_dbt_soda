{{
    config(
    materialized='table'
    , schema='marts_core'
    , unique_key='project_id'
    )
}}


with project_repos as (
    select *
    from {{ ref('int_project_repos') }}

)
select * from project_repos