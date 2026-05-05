{{ config(materialized='table') }}

with cte as
(
    select 
        to_timestamp(started_at) started_at,
        date(to_timestamp(started_at)) date_started_at,
        hour(to_timestamp(started_at)) hour_started_at,
        dayname(to_timestamp(started_at)) dayname_started_at,
        month(to_timestamp(started_at)) month_started_at,
        case 
            when dayname(to_timestamp(started_at)) not in ('Sat', 'Sun') then 'business_days' 
            else 'nonbusiness_days'
        end bd_started_at,

        case
            when month(to_timestamp(started_at)) in (12,1,2) then 'winter'
            when month(to_timestamp(started_at)) in (3,4,5) then 'spring'
            when month(to_timestamp(started_at)) in (6,7,8) then 'summer'
            else 'autumn'
        end station_of_year
    from {{ source('demo', 'bike') }}
    where started_at != 'started_at'
)

select *
from cte