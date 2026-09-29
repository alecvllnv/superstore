-- ============================================================
-- Superstore KPI Queries (Amazon Redshift)
-- Table: superstore_db.superstore
-- ============================================================

-- ------------------------------------------------------------
-- 1. OVERALL KPI SUMMARY (headline scorecards)
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(sales), 2)                                        AS total_sales,
    ROUND(SUM(profit), 2)                                       AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2)         AS profit_margin_pct,
    COUNT(DISTINCT order_id)                                    AS total_orders,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2)  AS avg_order_value,
    SUM(quantity)                                               AS total_quantity,
    COUNT(DISTINCT customer_id)                                 AS unique_customers,
    ROUND(AVG(discount) * 100, 2)                               AS avg_discount_pct,
    ROUND(AVG(shipping_days), 2)                                AS avg_shipping_days
FROM superstore_db.superstore;


-- ------------------------------------------------------------
-- 2. YEARLY KPIs WITH YoY GROWTH
-- ------------------------------------------------------------
WITH yearly AS (
    SELECT
        order_year,
        SUM(sales)                  AS sales,
        SUM(profit)                 AS profit,
        COUNT(DISTINCT order_id)    AS orders
    FROM superstore_db.superstore
    GROUP BY order_year
)
SELECT
    order_year,
    ROUND(sales, 2)  AS total_sales,
    ROUND(profit, 2) AS total_profit,
    ROUND(profit / NULLIF(sales, 0) * 100, 2) AS profit_margin_pct,
    orders           AS total_orders,
    ROUND((sales - LAG(sales) OVER (ORDER BY order_year))
          / NULLIF(LAG(sales) OVER (ORDER BY order_year), 0) * 100, 2)   AS sales_yoy_pct,
    ROUND((profit - LAG(profit) OVER (ORDER BY order_year))
          / NULLIF(ABS(LAG(profit) OVER (ORDER BY order_year)), 0) * 100, 2) AS profit_yoy_pct
FROM yearly
ORDER BY order_year;


-- ------------------------------------------------------------
-- 3. MONTHLY TREND (line chart)
-- ------------------------------------------------------------
SELECT
    order_year,
    order_month,
    order_month_name,
    ROUND(SUM(sales), 2)   AS total_sales,
    ROUND(SUM(profit), 2)  AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_db.superstore
GROUP BY order_year, order_month, order_month_name
ORDER BY order_year, order_month;


-- ------------------------------------------------------------
-- 4. KPIs BY CATEGORY
-- ------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    SUM(quantity)         AS total_quantity
FROM superstore_db.superstore
GROUP BY category
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- 5. KPIs BY REGION
-- ------------------------------------------------------------
SELECT
    region,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore_db.superstore
GROUP BY region
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- 6. KPIs BY CUSTOMER SEGMENT
-- ------------------------------------------------------------
SELECT
    segment,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS avg_order_value
FROM superstore_db.superstore
GROUP BY segment
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- 7. SUB-CATEGORY PERFORMANCE (find loss-makers)
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore_db.superstore
GROUP BY category, sub_category
ORDER BY total_profit DESC;


-- ------------------------------------------------------------
-- 8. TOP 10 CUSTOMERS BY SALES
-- ------------------------------------------------------------
SELECT
    customer_name,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_db.superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 9. DISCOUNT IMPACT ON PROFIT
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN discount = 0    THEN '0% (No discount)'
        WHEN discount <= 0.2 THEN '1-20%'
        WHEN discount <= 0.4 THEN '21-40%'
        ELSE '41%+'
    END AS discount_bucket,
    COUNT(*)              AS line_items,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore_db.superstore
GROUP BY 1
ORDER BY MIN(discount);


-- ------------------------------------------------------------
-- 10. SHIPPING PERFORMANCE BY SHIP MODE
-- ------------------------------------------------------------
SELECT
    ship_mode,
    COUNT(DISTINCT order_id)         AS total_orders,
    ROUND(AVG(shipping_days), 2)     AS avg_shipping_days
FROM superstore_db.superstore
GROUP BY ship_mode
ORDER BY avg_shipping_days;
