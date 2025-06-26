  {{
    config(
        materialized = 'table'
    )  
}}

     select
        airport_code,
        airport_name,
        city,
        coordinates,
        timezone,
        'bookings' as RECORD_SOURSE,
        now() as LOAD_DATE

      from 
      {{ source('demo_src', 'airports') }} 