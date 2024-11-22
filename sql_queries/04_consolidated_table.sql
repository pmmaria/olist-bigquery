-- Create a consolidated table with all the information needed for the analysis in Looker Studio.
CREATE OR REPLACE TABLE olist.consolidated_table AS
SELECT
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
  ap.payment_types,
  ap.total_payment_value,
  o.order_status,
  o.order_purchase_date,
  o.purchase_year,
  o.purchase_month,
  o.order_delivered_date,
  o.order_estimated_date,
  COALESCE(r.review_score, -1) AS review_score,
  s.seller_city,
  s.seller_state
FROM
  olist.cleaned_orders o
  JOIN olist.cleaned_order_items oi USING (order_id)
  JOIN olist.cleaned_products p USING (product_id)
  JOIN olist.customers c USING (customer_id)
  JOIN olist.sellers s USING (seller_id)
  LEFT JOIN (
    WITH
      aggregated_payments AS (
        SELECT
          order_id,
          CASE
            WHEN COUNT(DISTINCT payment_type) > 1 THEN 'combined_payment'
            ELSE MAX(payment_type)
          END AS payment_types,
          SUM(payment_value) AS total_payment_value
        FROM
          olist.order_payments
        GROUP BY
          order_id
      )
    SELECT
      *
    FROM
      aggregated_payments
  ) ap ON o.order_id = ap.order_id
  LEFT JOIN (
    SELECT
      order_id,
      ROUND(AVG(review_score), 0) AS review_score
    FROM
      olist.order_reviews
    GROUP BY
      order_id
  ) r ON o.order_id = r.order_id;
