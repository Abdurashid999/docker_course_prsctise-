  {{
      config(
          materialized = 'table',
          tags = ['bookings']

      )  
  }}
  
        select 
            book_ref,
            book_date,
            total_amount 
  from                                                        
   {{ source('demo_src', 'bookings') }}
   
  {{limit_date_dev('book_date', 3000)}}


      