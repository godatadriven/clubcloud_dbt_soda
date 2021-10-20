with repos as (
    select *
    from {{ref('stg_repos')}}


)
select * from repos
