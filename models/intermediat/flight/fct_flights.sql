{{
  config(
    materialized = 'table',
    )
}}
select flight_id,
          flight_no,
          scheduled_departure,
          scheduled_arrival,
          departure_airport,
          arrival_airport,
          "status",
          aircraft_code,
          actual_departure,
          actual_arrival,
          {{concat_column(['flight_id', 'flight_no'])}}
from {{ ref('stg_flight__flights') }}