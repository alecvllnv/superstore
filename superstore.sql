-- Create schema
CREATE SCHEMA IF NOT EXISTS superstore_db;

-- Use schema
USE superstore_db;

-- Remove existing table
DROP TABLE IF EXISTS superstore;

-- Create table
CREATE TABLE superstore (
    row_id            INT NOT NULL PRIMARY KEY,
    order_id          VARCHAR(20) NOT NULL,
    order_date        DATE NOT NULL,
    ship_date         DATE NOT NULL,
    ship_mode         VARCHAR(30) NOT NULL,
    customer_id       VARCHAR(20) NOT NULL,
    customer_name     VARCHAR(100) NOT NULL,
    segment           VARCHAR(30) NOT NULL,
    country_region    VARCHAR(100) NOT NULL,
    city              VARCHAR(100) NOT NULL,
    state_province    VARCHAR(100) NOT NULL,
    postal_code       VARCHAR(20),
    region            VARCHAR(30) NOT NULL,
    product_id        VARCHAR(30) NOT NULL,
    category          VARCHAR(50) NOT NULL,
    sub_category      VARCHAR(50) NOT NULL,
    product_name      VARCHAR(255) NOT NULL,
    sales             DECIMAL(18,4) NOT NULL,
    quantity          INT NOT NULL,
    discount          DECIMAL(10,4) NOT NULL,
    profit            DECIMAL(18,4) NOT NULL,
    order_year        INT NOT NULL,
    order_month       INT NOT NULL,
    order_month_name  VARCHAR(20) NOT NULL,
    order_quarter     INT NOT NULL,
    shipping_days     INT NOT NULL
);

-- Check table
SHOW TABLES;

-- Check structure
DESCRIBE superstore;

-- Load CSV
LOAD DATA LOCAL INFILE '/Users/adotvillanueva/Downloads/superstore_cleaned.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country_region,
    city,
    state_province,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    order_year,
    order_month,
    order_month_name,
    order_quarter,
    shipping_days
);

-- Check imported row count
SELECT COUNT(*) AS row_count
FROM superstore;

-- Check imported data
SELECT *
FROM superstore
LIMIT 10;