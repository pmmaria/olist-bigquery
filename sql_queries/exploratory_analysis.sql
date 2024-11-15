-- Total Sales by Revenue, Orders and Items Sold
SELECT
    ROUND(SUM(order_value_total), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(product_id) AS total_items_sold
FROM
    olist.cleaned_order_items;

-- Average Order Value: Calculate the average value of each order. Result should be 140.64
SELECT
    FORMAT('%0.2f', AVG(order_value_total)) AS avg_order_value
FROM
    olist.cleaned_order_items;

-- Average Order Value per Month and Year
SELECT
    purchase_year,
    purchase_month,
    ROUND(AVG(order_value_total), 2) AS avg_order_value
FROM
    olist.cleaned_orders
    JOIN olist.cleaned_order_items USING (order_id)
GROUP BY
    purchase_year,
    purchase_month
ORDER BY
    purchase_year,
    purchase_month;

-- Total Sales per Month and Year
SELECT
    extract(
        year
        FROM
            order_purchase_date
    ) AS purchase_year,
    extract(
        month
        FROM
            order_purchase_date
    ) as purchase_month,
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

-- Customer Distribution by State
SELECT
    customer_state,
    customer_zip_code_prefix,
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    olist.customers
GROUP BY
    customer_state,
    customer_zip_code_prefix
ORDER BY
    total_customers DESC;

-- Customer Distribution by lat and lng
WITH
    avg_lat_lng AS (
        SELECT
            geolocation_zip_code_prefix,
            AVG(geolocation_lat) AS avg_lat,
            AVG(geolocation_lng) AS avg_lng
        FROM
            olist.geolocation
        GROUP BY
            geolocation_zip_code_prefix
    )
SELECT
    customer_id,
    customer_city,
    customer_state,
    customer_zip_code_prefix,
    avg_lat,
    avg_lng
FROM
    olist.customers AS c
    JOIN avg_lat_lng AS a ON c.customer_zip_code_prefix = a.geolocation_zip_code_prefix
ORDER BY
    customer_id;

-- Customer Distribution by City
SELECT
    customer_city,
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    olist.customers
GROUP BY
    customer_city
ORDER BY
    total_customers DESC;

-- Top 10 Customers by Total Spending
SELECT
    customer_id,
    customer_city,
    customer_state,
    FORMAT('%0.2f', SUM(order_value_total)) AS total_spent
FROM
    olist.cleaned_orders
    JOIN olist.cleaned_order_items USING (order_id)
    JOIN olist.customers USING (customer_id)
GROUP BY
    customer_id,
    customer_city,
    customer_state
ORDER BY
    total_spent DESC
LIMIT
    10;

-- Top 10 Categories by Total Sales (sales includes freight value)
SELECT
    product_category,
    FORMAT('%0.2f', SUM(order_value_total)) AS total_sales
FROM
    olist.cleaned_order_items
    JOIN olist.cleaned_products USING (product_id)
GROUP BY
    product_category
ORDER BY
    total_sales DESC
LIMIT
    10;

-- Top 10 Categories by Total Orders
SELECT
    product_category,
    COUNT(order_id) AS total_orders
FROM
    olist.cleaned_order_items
    JOIN olist.cleaned_products USING (product_id)
GROUP BY
    product_category
ORDER BY
    total_orders DESC
LIMIT
    10;

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

--Customer Retention: Repeat Customers
with
    repeat_customer_unique_ids as (
        select
            a.customer_unique_id
        FROM
            olist.customers a
            JOIN olist.orders USING (customer_id)
        GROUP BY
            a.customer_unique_id
        HAVING
            COUNT(order_id) > 1
    ),
    repeat_customers as (
        select
            a.customer_unique_id,
            b.customer_id
        from
            repeat_customer_unique_ids a
            inner join olist.customers b using (customer_unique_id)
    )
SELECT
    *
from
    repeat_customers
order by
    customer_unique_id;

-- Average Delivery Time by Order Status 
SELECT
    order_status,
    ROUND(
        AVG(
            DATE_DIFF(
                IFNULL(order_delivered_date, order_estimated_date),
                order_purchase_date,
                DAY
            )
        ),
        2
    ) AS avg_delivery_time,
    COUNTIF(order_delivered_date IS NULL) AS estimated_deliveries,
    ROUND(
        AVG(
            CASE
                WHEN order_delivered_date IS NULL THEN DATE_DIFF(order_estimated_date, order_purchase_date, DAY)
                ELSE NULL
            END
        ),
        2
    ) AS avg_estimated_delivery_time
FROM
    olist.cleaned_orders
GROUP BY
    order_status;

SELECT
    purchase_month,
    FORMAT('%0.2f', SUM(order_value_total)) AS total_sales
FROM
    olist.cleaned_orders
    JOIN olist.cleaned_order_items USING (order_id)
GROUP BY
    purchase_month
ORDER BY
    purchase_month;
