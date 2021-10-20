{{
    config(
    materialized='table'
    , schema='staging'
    , unique_key='id'
    )
}}


SELECT *
FROM {{ source('libraries_io', 'dependencies') }}
