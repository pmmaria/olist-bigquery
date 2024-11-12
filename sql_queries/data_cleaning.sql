-- Creating new tables to clean data


/* 
Create a new table for orders:
    - Change data type from timestamp to date
    - Make two separate columns for month and year of purchase to facilitate analysis.
*/

create table olist.cleaned_orders as 
select
    order_id, 
    customer_id,
    order_status, 
    cast(order_purchase_timestamp as date) as order_purchase_date,
    extract(year from order_purchase_timestamp) as purchase_year,
    extract(month from order_purchase_timestamp) as purchase_month,
    cast (order_delivered_customer_date as date) as order_delivered_date,
    cast(order_estimated_delivery_date as date) as order_estimated_date
from olist.orders;

/* 
Create a new table for order_items with a column for total value of each order (price + freight_value)
*/
create table olist.cleaned_order_items as
select 
    order_id, 
    order_item_id,
    product_id, 
    seller_id, 
    cast(shipping_limit_date as date) as shipping_limit, 
    price,
    freight_value,
    (price + freight_value) as order_value_total
from olist.order_items;


/*
Create a new table for products, to keep only relevant information and also get the name of categories in English in the same table
*/

-- First identify null values for the categories
select 
    distinct p.product_category_name, 
    e.product_category_name_english
from olist.products as p 
left join olist.product_category_name_translation as e 
    on p.product_category_name = e.product_category_name
order by 2;
/* 
- We have 3 categories Null. One of them corresponds with a null value in the products table. The other two are missing the translation


- Create new table cleaned_products with the information about product_id and the category names in English, replacing the null values for a valid english translation. Data about product name length, product description length and the dimensions of the product are not relevant for this analysis. 
*/
create or replace table olist.cleaned_products as (
with category_translation as (
    select 
        distinct coalesce(p.product_category_name, 'unknown') as category_name_portuguese,
        coalesce ( e.product_category_name_english,
            case
                when p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos'  then 'portable_kitchen_food_preparation_device'
                when p.product_category_name like 'pc_gamer' then 'pc_gamer'
                else 'unknown'
            end 
        ) as category_name_english
    from olist.products as p 
    left join olist.product_category_name_translation as e 
        on p.product_category_name = e.product_category_name
)

select
    p.product_id,
    ct.category_name_english as product_category
from category_translation as ct 
join olist.products as p 
    on p.product_category_name = ct.category_name_portuguese
);
