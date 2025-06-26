{% set aircraft_query %}
select distinct 
    aircraft_code
from 
    {{ ref('fct_flights') }}
{%endset%}

{% set aircraft_query_result = run_query(aircraft_query) %}
{%if execute %}
    {% set importand_aircraft = aircraft_query_result.columns[0].values() %}
{% else %}
    {% set importand_aircraft = [] %}
{% endif %}

select 
        {% for aircraft in importand_aircraft -%}
        sum(case when aircraft_code = '{{ aircraft }}' then 1 else 0 end) as flights_{{ aircraft }} 
        {%- if not loop.last %}, {% endif %}
        --{{loop.cycle(' +',' -')}}
        {% endfor %}
from 
    {{ ref('fct_flights') }}

    