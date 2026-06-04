-- Custom singular test: assert no transactions have zero or negative amounts.
-- This test will FAIL (and surface the offending rows) if any are found.

select
    transaction_id,
    store_id,
    product_id,
    quantity,
    unit_price,
    total_amount
from {{ ref('fct_sales') }}
where
    total_amount <= 0
    or unit_price <= 0
    or quantity   <= 0
