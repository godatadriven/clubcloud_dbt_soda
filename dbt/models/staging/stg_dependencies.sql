{{
    config(
    materialized='table'
    , schema='staging'
    , unique_key='id'
    )
}}


SELECT *
    , "my new annoying column" as my_new_column
FROM {{ source('libraries_io', 'dependencies') }}
