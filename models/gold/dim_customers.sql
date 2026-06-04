{{ config(materialized='table') }}

/*
    Customer dimension derived from transaction data.
    One row per customer_id.
    No customer profile data in source — behavioural attributes only.
*/

with transactions as (

    select * from {{ ref('stg_transactions') }}

),

customers as (

    select
        customer_id,
        min(transaction_date)                               as first_purchase_date,
        max(transaction_date)                               as last_purchase_date,
        count(distinct transaction_id)                      as total_transactions,
        count(distinct store_id)                            as stores_visited,
        count(distinct product_id)                         as unique_products_bought,
        sum(total_amount)                                   as lifetime_value,
        round(avg(total_amount), 2)                         as avg_order_value,

        -- most frequent payment method
        mode(payment_method)                                as preferred_payment_method,

        -- recency
        datediff('day', max(transaction_date), current_date()) as days_since_last_purchase

    from transactions
    group by customer_id

),

final as (

    select
        customer_id,
        first_purchase_date,
        last_purchase_date,
        days_since_last_purchase,
        total_transactions,
        stores_visited,
        unique_products_bought,
        lifetime_value,
        avg_order_value,
        preferred_payment_method,

        -- RFM banding
        case
            when days_since_last_purchase <= 30  then 'Active'
            when days_since_last_purchase <= 90  then 'At Risk'
            when days_since_last_purchase <= 180 then 'Lapsing'
            else 'Churned'
        end                                                 as recency_band,

        case
            when total_transactions >= 20 then 'High'
            when total_transactions >= 5  then 'Medium'
            else 'Low'
        end                                                 as frequency_band,

        case
            when lifetime_value >= 500  then 'High Value'
            when lifetime_value >= 100  then 'Mid Value'
            else 'Low Value'
        end                                                 as monetary_band

    from customers

)

select * from final
