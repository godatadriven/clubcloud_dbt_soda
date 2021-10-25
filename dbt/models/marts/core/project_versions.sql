{{
    config(
    materialized='table'
    , schema='marts_core'
    , unique_key='version_id'
    )
}}



with project_versions as (

    select *
    from {{ ref('int_project_versions') }}

)

select * from project_versions