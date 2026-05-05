with daily_weather as
(
    select 
    date(time) as daily_weather,
    weather,
    temp,
    pressure,
    humidity,
    clouds
    from {{ source('demo', 'weather') }}
)

,daily_weather_agg as(
    select 
        daily_weather,
        weather,
        row_number() over (partition by daily_weather order by count(weather) desc),
        round(avg(temp),2),
        round(avg(pressure),2),
        round(avg(humidity),2),
        round(avg(clouds),2)
    from daily_weather
    group by daily_weather, weather
    qualify row_number() over (partition by daily_weather order by count(weather) desc) = 1
)

select *
from daily_weather_agg
