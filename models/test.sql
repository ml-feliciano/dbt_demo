{{ config(materialized='table') }}
select *
from {{ source('demo', 'bike') }}
limit 5