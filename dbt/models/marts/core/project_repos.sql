{{
    config(
    materialized='table'
    , schema='marts_core'
    , unique_key='project_id'
    )
}}


with project_repos as (
    select *,
           {{ dbt_utils.split_part(string_text= 'repo_name_with_owner', delimiter_text='"/"', part_number=1) }} as repo_name,
           {{ dbt_utils.split_part(string_text= 'repo_name_with_owner', delimiter_text='"/"', part_number=2) }} as repo_owner
    from {{ ref('int_project_repos') }}

)
select * from project_repos