{% set aircrafts_codes_with_flights = dbt_utils.get_column_values(
    table= ref('stg_flight__flights'),
    column='aircraft_code'
) %}

select
    *
from 
    {{ ref('stg_flight__aircrafts') }}
WHERE
    aircraft_code in ('{{aircrafts_codes_with_flights | join("', '")}}') aircrafts_with_flights