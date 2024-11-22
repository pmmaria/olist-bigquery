-- Total Sales by Revenue, Orders and Items Sold.
SELECT
  ROUND(SUM(order_value_total), 2) AS total_sales,
  COUNT(DISTINCT order_id) total_orders,
  COUNT(product_id) AS total_items_sold
FROM
  olist.cleaned_order_items;

-- Average Order Value: Calculate the average value of each order.
SELECT
  ROUND(AVG(order_value_total), 2) AS avg_order_value
FROM
  olist.cleaned_order_items;

-- Total Sales per Month and Year
SELECT
  purchase_year,
  purchase_month,
  ROUND(SUM(order_value_total), 2) AS total_sales
FROM
  olist.cleaned_orders
  JOIN olist.cleaned_order_items USING (order_id)
GROUP BY
  purchase_year,
  purchase_month
ORDER BY
  purchase_year,
  purchase_month;

-- Customer Distribution by Region/State
SELECT
  customer_region,
  customer_state,
  COUNT(DISTINCT customer_id) AS total_customers
FROM
  olist.customers
GROUP BY
  customer_region,
  customer_state
ORDER BY
  total_customers DESC;

-- Orders by Payment Type
SELECT
  payment_type,
  COUNT(order_id) AS total_orders
FROM
  olist.order_payments
GROUP BY
  payment_type
ORDER BY
  total_orders DESC;

-- Orders by Status (delivered, shipped, etc)
SELECT
  order_status,
  COUNT(order_id) AS total_orders
FROM
  olist.cleaned_orders
GROUP BY
  order_status
ORDER BY
  total_orders DESC;