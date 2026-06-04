{{ config(materialized='view') }}

with source as (

    select * from {{ ref('acmemart_customers') }}

),

renamed as (

    select
        -- identifiers
        cast(customer_id        as varchar)     as customer_id,

        -- names
        {{ clean_string('first_name') }}        as first_name,
        {{ clean_string('last_name') }}         as last_name,

        -- contact
        lower(trim(email))                      as email,
        cast(phone as varchar)                  as phone,

        -- demographics
        try_cast(date_of_birth as date)         as date_of_birth,
        try_cast(registration_date as date)     as registration_date,

        -- segmentation
        {{ clean_string('loyalty_tier') }}      as loyalty_tier,
        {{ clean_string('gender') }}            as gender,

        -- location
        {{ clean_string('city') }}              as city,
        {{ clean_string('country') }}           as country,

        -- metadata
        _airbyte_emitted_at

    from source
    where customer_id is not null

)

select * from renamed
