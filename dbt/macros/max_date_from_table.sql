{% macro max_date_from_table(date_column_name, table_name) %}

    {% set max_ingested_date = '2020-07-01' %}
    {% set query %}
        SELECT MAX(DATE({{ date_column_name }})) FROM {{ ref(table_name) }}
    {% endset %}
    {% set results = run_query(query) %}
    {% if results|length %}
        {% set max_ingested_date = results.columns[0].values()[0] %}
    {% endif %}
    {{ return(max_ingested_date) }}

{% endmacro %}