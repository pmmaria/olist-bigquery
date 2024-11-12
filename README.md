# E-commerce Sales and Customer Behavior Analysis using the Olist Dataset

## Project Description

This project uses the Olist dataset to analyze sales and customer behavior from a Brazilian e-commerce platform

## Dataset Information

The Olist Dataset is an open source database from a Brazilian e-commerce platform that connects small businesses  with customers from all over the country. It contains data on customer orders, products, sellers, and reviews, offering a complete view of the shopping experience.


### Data Schema

The following image is showing how the different tables are related.

![Data Schema](https://i.imgur.com/HRhd2Y0.png)

### Dataset key tables and columns

1. **Orders**: Information about each order, including:
    
    - `order_id`: Unique identifier for each order.
    - `order_purchase_timestamp`: The date and time when the order was placed.
    - `order_delivered_customer_date`: Delivery date of the order.

2. **Order Items**: Details on the products within each order:

    - `order_id`: Order identifier linking to the Orders table
    - `product_id:` Product identifier
    - `price`: Price of each product within the order
    - `freight_value`: Cost of freight for each product

3. **Customers**: Customer demographic information:

    - `customer_id`: Unique customer identifier
    - `customer_city`: City of the customer
    - `customer_state`: State of the customer

4. **Products**: Product details:

    - `product_id`: Unique identifier for each product
    - `product_category_name`: Category of the product

5. **Reviews**: Customer feedback on orders:

    - `order_id`: Order identifier linking to the Orders table
    - `review_score`: Rating given by the customer (1-5)

6. **Sellers**: Information about the sellers on the platform:

    - `seller_id`: Unique identifier for each seller
    - `seller_city`, seller_state: Seller location data

### Dataset Link:
The Olist dataset can be accessed on Kaggle [here](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Analysis of Data using SQL

### Data cleaning and preparation




