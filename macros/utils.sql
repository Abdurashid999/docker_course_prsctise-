{% macro concat_column(columns, delit = ' ,') %}
  {% for column in columns %} 
    {{ column }} {% if not loop.last %} || '{{ delit }}' || {% endif %}
  {% endfor %}
{% endmacro %}


{% macro drop_old_relations(dryrun = false) %}
  {% if execute %}
    {% set current_models = [] %}

    {% for node in graph.nodes.values() | selectattr("resource_type", "in",["model", "snapshot", "seed"]) %}
        {% do current_models.append(node.name) %}
    {% endfor %}

{% set cleanup_query %}
WITH MODELS_TO_DROP AS ( 
select 
        CASE
            WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
            WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
        END AS RELATION_TYPE,
        CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) as RELATION_NAME
from 
    {{target.database}}.INFORMATION_SCHEMA.TABLES
where 
    TABLE_SCHEMA = '{{ target.schema}}'
    and upper(TABLE_NAME) NOT IN ( 
    {%- for model in  current_models -%}
    '{{ model.upper() }}'
     {%- if not loop.last -%}
       ,
     {%- endif -%}
    {%- endfor -%}
    )

)

SELECT 
    'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' AS DROP_COMMAND
FROM 
    MODELS_TO_DROP;
    

{% endset %}
  

{% do log( cleanup_query, true)  %}

{% set drop_commands = run_query(cleanup_query).columns[0].values() %}
        
        
        {% if drop_commands %}
            {% if dryrun | as_bool == False %}
                {% do log('Executing DROP commands ...', True) %}
            {% else %}
                {% do log('Printing DROP commands ...', True) %}
            {% endif %}
        
            {% for drop_command in drop_commands %}
                {% do log(drop_command, True) %}
                {% if  dryrun | as_bool == False %}
                    {% do run_query(drop_command) %}
                {% endif %}
            {% endfor %}
        {% else %}
             {% do log('No relations to clean', True) %}
        {% endif %}

  {% endif %}
{% endmacro %}