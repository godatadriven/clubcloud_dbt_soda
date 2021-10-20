with projects as (
    select *
    from {{ref('stg_projects')}}


)
select * from projects
