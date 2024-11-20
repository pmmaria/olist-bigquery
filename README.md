# E-commerce Sales and Customer Behavior Analysis using the Olist Dataset

## Project Description

This project uses the Olist dataset to analyze sales and customer behavior from a Brazilian e-commerce platform

## Dataset Information

The Olist Dataset is an open source database from a Brazilian e-commerce platform that connects small businesses  with customers from all over the country. It contains data on customer orders, products, sellers, and reviews, offering a complete view of the shopping experience.


### Data Schema

The following image is showing how the different tables are related.

<img src="https://i.imgur.com/HRhd2Y0.png"  width="720" />

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

### **Data Cleaning and Preparation**

In order to facilitate the analysis, the first step is clean and prepare the data to ensure that:
   - The data is consistent and easy to analyze.
   - Only relevant columns are retained for improved performance.
   - Key fields for grouping and analysis are standardized and cleaned.

#### Cleaning process:

1. **Orders Table**:
   - Changed the data type of purchase date columns from `timestamp` to `date`.
   - Added separate columns for **purchase month** and **purchase year** to facilitate time-based analysis.

2. **Order Items Table**:
   - Created a new column for the **total value of each order** (`price + freight_value`).

3. **Products Table**:
   - Created a cleaned version of the table containing:
     - `product_id` and **category names in English**, replacing `NULL` values with valid translations in order to ensure consistency in category names.
   - Excluded irrelevant columns such as `product_name_length`, `product_description_length`, and product dimensions, as they are not pertinent to this analysis. This optimizes the dataset for faster processing.

4. **Customers Table**:
   - Added a new column for the **region of the customer**, based on the state. Simplified analysis by grouping states into the 5 geographical regions of Brazil.

For the full SQL queries used in this process, see [Data Cleaning Queries](sql_queries\data_cleaning.sql)



### **Exploratory Analysis**

The exploratory analysis focuses on understanding the dataset through key metrics and visualizations. The following analyses were conducted:

1. **Total Sales**:
   - Measured by total revenue, total orders, and total items sold.

2. **Average Order Value**:
   - Calculated the average value of each order to understand customer spending patterns.

3. **Total Sales per Month and Year**:
   - Analyzed sales trends over time by breaking down total revenue by month and year.

4. **Customer Distribution**:
   - Explored customer distribution by **region** and **state** to identify geographic trends.

5. **Orders by Payment Type**:
   - Examined the distribution of orders based on the payment method used.

6. **Orders by Status**:
   - Analyzed the count of orders by status, such as delivered, shipped, or canceled.

Each analysis provides insights into customer behavior, sales trends, and operational performance.
