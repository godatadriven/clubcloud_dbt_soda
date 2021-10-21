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

with projects_repos as (
    select *,
           {{ dbt_utils.split_part(string_text= 'repo_name_with_owner', delimiter_text='"/"', part_number=1) }} as repo_name,
           {{ dbt_utils.split_part(string_text= 'repo_name_with_owner', delimiter_text='"/"', part_number=2) }} as repo_owner
    from {{ ref('int_project_repo') }}

)
select * from projects_repos