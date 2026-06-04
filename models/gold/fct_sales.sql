{{ config(materialized='table') }}

/*
    Fact table — one row per completed transaction.
    Built directly from stg_transactions since source data is denormalised.
    Foreign keys link to derived dimension tables.
*/

with transactions as (

    select * from {{ ref('stg_transactions') }}

),

final as (

    select
        -- surrogate key
        {{ dbt_utils.generate_surrogate_key(['transaction_id']) }}  as sales_key,

        -- natural keys
        transaction_id,
        store_id,
        product_id,
        customer_id,

        -- time
        transaction_timestamp,
        transaction_date,
        transaction_year,
        transaction_month,
        transaction_hour,

        -- measures
        quantity,
        unit_price,
        total_amount,
        quantity * unit_price                   as calculated_amount,

        -- descriptors
        payment_method,
        category,
        product_name

    from transactions

)

select * from final
