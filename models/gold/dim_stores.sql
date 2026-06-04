{{ config(materialized='table') }}

/*
    Store dimension derived from transaction data.
    One row per store_id.
*/

with transactions as (

    select * from {{ ref('stg_transactions') }}

),

stores as (

    select
        store_id,
        min(transaction_date)                       as first_transaction_date,
        max(transaction_date)                       as last_transaction_date,
        count(distinct transaction_date)            as active_days,
        count(distinct transaction_id)              as total_transactions,
        count(distinct customer_id)                 as unique_customers
    from transactions
    group by store_id

),

final as (

    select
        store_id,
        first_transaction_date,
        last_transaction_date,
        active_days,
        total_transactions,
        unique_customers
    from stores

)

select * from final
