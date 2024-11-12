-- Total Sales: Calculate the total sales value from the cleaned_order_items table. Result should be 15,843,553.24
SELECT
    FORMAT('%0.2f', SUM(order_value_total)) AS total_sales
FROM
    olist.cleaned_order_items;

-- Total Orders: Count the number of unique order_id in the cleaned_orders table. Result should be 99,441 orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM
    olist.cleaned_orders;

-- Average Order Value: Calculate the average value of each order. Result should be 140.64
SELECT
    FORMAT('%0.2f', AVG(order_value_total)) AS avg_order_value
FROM
    olist.cleaned_order_items;

-- Average Order Value per Month and Year
SELECT
    purchase_year,
    purchase_month,
    FORMAT('%0.2f', AVG(order_value_total)) AS avg_order_value
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
    purchase_year,
    purchase_month,
    FORMAT('%0.2f', SUM(order_value_total)) AS total_sales
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
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    olist.customers
GROUP BY
    customer_state
ORDER BY
    total_customers DESC;

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

--Customer Retention: Repeat Customers. Result: none of customers have made more than 1 order
SELECT
    COUNT(DISTINCT customer_id) AS repeat_customers
FROM
    olist.cleaned_orders
GROUP BY
    customer_id
HAVING
    COUNT(DISTINCT order_id) > 1;

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
