{{ config(materialized="table",
            transient = false) }}

select * from {{ source('jaffle_shop', 'orders') }}