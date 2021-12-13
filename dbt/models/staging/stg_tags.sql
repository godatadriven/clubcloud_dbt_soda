{{ 
    config(
    materialized='table'
    , schema='staging'
    , unique_key='id'
    ) 
}}

SELECT *
    , "this will break your pipelines" as terrible_column
FROM {{ source('libraries_io', 'tags') }}