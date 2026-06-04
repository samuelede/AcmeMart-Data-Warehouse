{{ config(materialized='view') }}

with source as (

    select * from {{ ref('acmemart_stores') }}

),

renamed as (

    select
        -- identifiers
        cast(store_id           as varchar)     as store_id,
        cast(manager_id         as varchar)     as manager_id,

        -- descriptors
        {{ clean_string('store_name') }}        as store_name,
        {{ clean_string('store_type') }}        as store_type,  -- 'physical' | 'online'

        -- location
        {{ clean_string('city') }}              as city,
        {{ clean_string('region') }}            as region,
        {{ clean_string('country') }}           as country,

        -- dates
        try_cast(open_date as date)             as open_date,

        -- metadata
        _airbyte_emitted_at

    from source
    where store_id is not null

)

select * from renamed
