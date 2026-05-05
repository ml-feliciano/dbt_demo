{{ config(materialized='table') }}

with cte as
(
    select 
        to_timestamp(started_at) started_at,
        date(to_timestamp(started_at)) date_started_at,
        hour(to_timestamp(started_at)) hour_started_at,
        dayname(to_timestamp(started_at)) dayname_started_at,
        case 
            when dayname(to_timestamp(started_at)) not in ('Sat', 'Sun') then 'business_days' 
            else 'nonbusiness_days'
        end bd_started_at
    from {{ source('demo', 'bike') }}
    where started_at != 'started_at'
)

select *
from cte