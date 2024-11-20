create or replace table olist.consolidated_table as
select
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_region,
    oi.product_id,
    p.product_category,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    oi.order_value_total,
    op.payment_type,
    op.payment_value,
    o.order_status,
    o.order_purchase_date,
    o.purchase_year,
    o.purchase_month,
    o.order_delivered_date,
    o.order_estimated_date,
    r.review_score,
    s.seller_city,
    s.seller_state
from
    olist.cleaned_orders o
    join olist.cleaned_order_items oi using (order_id)
    join olist.cleaned_products p using (product_id)
    join olist.order_payments op using (order_id)
    join olist.customers c using (customer_id)
    join olist.sellers s using (seller_id)
    left join olist.order_reviews r using (order_id);
