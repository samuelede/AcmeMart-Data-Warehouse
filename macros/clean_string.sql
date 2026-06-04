{% macro clean_string(column_name) %}
    initcap(trim(lower({{ column_name }})))
{% endmacro %}
