{{ config(materialized='view') }}

/*
    Source: One CSV file per store (store_S001, store_S002, store_5_25-01, etc.)
    Each file is a flat transaction record containing product and customer info.
    All files share the same columns — union_seeds('store') combines them all.

    Columns from source:
        transaction_id, transaction_time, store_id, product_id, product_name,
        category, quantity, unit_price, total_amount, payment_method, customer_id
*/

with source as (

    {{ union_seeds('store') }}

),

renamed as (

    select
        -- identifiers
        cast(transaction_id     as varchar)             as transaction_id,
        cast(store_id           as varchar)             as store_id,
        cast(product_id         as varchar)             as product_id,
        cast(customer_id        as varchar)             as customer_id,

        -- dates & times
        try_cast(transaction_time as timestamp)         as transaction_timestamp,
        cast(transaction_time as date)                  as transaction_date,
        date_part('year',  try_cast(transaction_time as timestamp))    as transaction_year,
        date_part('month', try_cast(transaction_time as timestamp))    as transaction_month,
        date_part('hour',  try_cast(transaction_time as timestamp))    as transaction_hour,

        -- product attributes (denormalised from source)
        {{ clean_string('product_name') }}              as product_name,
        {{ clean_string('category') }}                  as category,

        -- measures
        try_cast(quantity       as integer)             as quantity,
        try_cast(unit_price     as float)               as unit_price,
        try_cast(total_amount   as float)               as total_amount,

        -- descriptors
        {{ clean_string('payment_method') }}            as payment_method

    from source
    where transaction_id is not null

)

select * from renamed
