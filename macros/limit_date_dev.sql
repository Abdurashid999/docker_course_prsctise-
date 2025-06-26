{% macro limit_date_dev(column_name, days=2) %}
    {% if target.name == 'dev'%}
   where 
    {{column_name}} >= {{dbt.dateadd(datepart="day", interval=-days, from_date_or_timestamp="current_date")}}
    {% endif %}
{% endmacro %}

