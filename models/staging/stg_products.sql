{{ config(materialized='view') }}

with source as (

    select * from {{ ref('acmemart_products') }}

),

renamed as (

    select
        -- identifiers
        cast(product_id         as varchar)     as product_id,
        cast(supplier_id        as varchar)     as supplier_id,

        -- descriptors
        {{ clean_string('product_name') }}      as product_name,
        {{ clean_string('category') }}          as category,
        {{ clean_string('sub_category') }}      as sub_category,
        {{ clean_string('brand') }}             as brand,

        -- pricing
        try_cast(unit_cost      as float)       as unit_cost,
        try_cast(unit_price     as float)       as unit_price,

        -- computed
        try_cast(unit_price as float)
            - try_cast(unit_cost as float)      as gross_margin,

        -- flags
        case
            when lower(trim(is_active)) in ('true','1','yes') then true
            else false
        end                                     as is_active,

        -- metadata
        _airbyte_emitted_at

    from source
    where product_id is not null

)

select * from renamed
