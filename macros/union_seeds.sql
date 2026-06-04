{% macro union_seeds(pattern) %}

{#
    Dynamically unions all seed tables whose name contains the given pattern.

    Usage in a model:
        {{ union_seeds('transactions') }}
        {{ union_seeds('customers') }}
        {{ union_seeds('products') }}
        {{ union_seeds('stores') }}

    This handles seed files named like:
        transactions.csv
        01_transactions.csv
        02_transactions.csv
        acmemart_transactions.csv
        acmemart_transactions_2024.csv
        ...as long as the word appears anywhere in the filename.
#}

{%- set seed_nodes = [] -%}

{%- for node in graph.sources.values() | list + graph.nodes.values() | list -%}
    {%- if node.resource_type == 'seed'
        and pattern | lower in node.name | lower -%}
        {%- do seed_nodes.append(node.name) -%}
    {%- endif -%}
{%- endfor -%}

{%- if seed_nodes | length == 0 -%}
    {{ exceptions.raise_compiler_error(
        "union_seeds: no seed tables found matching pattern '" ~ pattern ~ "'. "
        ~ "Make sure you have run `dbt seed` first."
    ) }}
{%- endif -%}

{%- for seed_name in seed_nodes -%}
    select * from {{ ref(seed_name) }}
    {%- if not loop.last %} union all {% endif %}
{%- endfor -%}

{% endmacro %}
