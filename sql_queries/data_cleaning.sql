-- Creating new tables to clean data
/* 
Create a new table for orders:
- Change data type from timestamp to date
- Make two separate columns for month and year of purchase to facilitate analysis.
*/
CREATE OR REPLACE TABLE olist.cleaned_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    CAST(order_purchase_timestamp AS DATE) AS order_purchase_date,
    EXTRACT(
        YEAR
        FROM
            order_purchase_timestamp
    ) AS purchase_year,
    EXTRACT(
        MONTH
        FROM
            order_purchase_timestamp
    ) AS purchase_month,
    CAST(order_delivered_customer_date AS DATE) AS order_delivered_date,
    CAST(order_estimated_delivery_date AS DATE) AS order_estimated_date
FROM
    olist.orders;

/* 
Create a table for order_items with a column for total value of each order (price + freight_value)
*/
CREATE TABLE olist.cleaned_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS DATE) AS shipping_limit,
    price,
    freight_value,
    (price + freight_value) AS order_value_total
FROM
    olist.order_items;

/*
Create a new table for products, to keep only relevant information and also get the name of categories in English in the same table
*/
-- First identify null values for the categories
SELECT DISTINCT
    p.product_category_name,
    e.product_category_name_english
FROM
    olist.products AS p
    LEFT JOIN olist.product_category_name_translation AS e ON p.product_category_name = e.product_category_name
ORDER BY
    2;

/* 
- We have 3 categories Null. One of them corresponds with a null value in the products table. The other two are missing the translation


- Create new table cleaned_products with the information about product_id and the category names in English, replacing the null values for a valid english translation. Data about product name length, product description length and the dimensions of the product are not relevant for this analysis. 
*/
CREATE OR REPLACE TABLE olist.cleaned_products AS (
    WITH
        category_translation AS (
            SELECT DISTINCT
                COALESCE(p.product_category_name, 'unknown') AS category_name_portuguese,
                COALESCE(
                    e.product_category_name_english,
                    CASE
                        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'portable_kitchen_food_preparation_device'
                        WHEN p.product_category_name LIKE 'pc_gamer' THEN 'pc_gamer'
                        ELSE 'unknown'
                    END
                ) AS category_name_english
            FROM
                olist.products AS p
                LEFT JOIN olist.product_category_name_translation AS e ON p.product_category_name = e.product_category_name
        )
    SELECT
        p.product_id,
        ct.category_name_english AS product_category
    FROM
        category_translation AS ct
        JOIN olist.products AS p ON p.product_category_name = ct.category_name_portuguese
);

-- Add a new column to the customers table with the region of the customer based on the state.
CREATE OR REPLACE TABLE olist.customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    (
        CASE
            WHEN customer_state in ('RO', 'AC', 'AM', 'RR', 'AP', 'PA', 'TO') THEN 'north'
            WHEN customer_state in (
                'MA',
                'PI',
                'CE',
                'RN',
                'PB',
                'PE',
                'AL',
                'SE',
                'BA'
            ) THEN 'northeast'
            WHEN customer_state in ('MT', 'MS', 'GO', 'DF') THEN 'midwest'
            WHEN customer_state in ('PR', 'SC', 'RS') THEN 'south'
            WHEN customer_state in ('SP', 'RJ', 'ES', 'MG') THEN 'southeast'
            ELSE 'unknown'
        END
    ) as customer_region,
    'brazil' as customer_country
from
    olist.customers;
