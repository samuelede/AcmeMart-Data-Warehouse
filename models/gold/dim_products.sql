{{ config(materialized='table') }}

/*
    Product dimension derived from transaction data.
    Takes the latest known product_name and category per product_id.
    One row per product.
*/

with transactions as (

    select * from {{ ref('stg_transactions') }}

),

products as (

    select distinct
        product_id,
        product_name,
        category,

        -- price range observed across transactions
        min(unit_price)     as min_unit_price,
        max(unit_price)     as max_unit_price,
        avg(unit_price)     as avg_unit_price

    from transactions
    group by product_id, product_name, category

),

final as (

    select
        product_id,
        product_name,
        category,
        min_unit_price,
        max_unit_price,
        round(avg_unit_price, 2)    as avg_unit_price
    from products

)

select * from final
