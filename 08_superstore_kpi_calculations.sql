-- Superstore KPI Queries

-- 1. Overall KPI Summary
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS avg_order_value,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM public.superstore;


-- 2. Yearly KPIs With YoY Growth
WITH yearly AS (
    SELECT
        order_year,
        SUM(sales) AS sales,
        SUM(profit) AS profit,
        COUNT(DISTINCT order_id) AS orders
    FROM public.superstore
    GROUP BY order_year
),
yearly_with_previous AS (
    SELECT
        order_year,
        sales,
        profit,
        orders,
        LAG(sales) OVER (
            ORDER BY order_year
        ) AS previous_sales,
        LAG(profit) OVER (
            ORDER BY order_year
        ) AS previous_profit
    FROM yearly
)
SELECT
    order_year,
    ROUND(sales, 2) AS total_sales,
    ROUND(profit, 2) AS total_profit,
    ROUND(
        profit / NULLIF(sales, 0) * 100,
        2
    ) AS profit_margin_pct,
    orders AS total_orders,
    ROUND(
        (sales - previous_sales)
        / NULLIF(previous_sales, 0) * 100,
        2
    ) AS sales_yoy_pct,
    ROUND(
        (profit - previous_profit)
        / NULLIF(ABS(previous_profit), 0) * 100,
        2
    ) AS profit_yoy_pct
FROM yearly_with_previous
ORDER BY order_year;


-- 3. Monthly Trend
SELECT
    order_year,
    order_month,
    order_month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.superstore
GROUP BY
    order_year,
    order_month,
    order_month_name
ORDER BY
    order_year,
    order_month;


-- 4. KPIs by Category
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    SUM(quantity) AS total_quantity
FROM public.superstore
GROUP BY category
ORDER BY total_sales DESC;


-- 5. KPIs by Region
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.superstore
GROUP BY region
ORDER BY total_sales DESC;


-- 6. KPIs by Customer Segment
SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS avg_order_value
FROM public.superstore
GROUP BY segment
ORDER BY total_sales DESC;


-- 7. Sub-Category Performance
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore
GROUP BY
    category,
    sub_category
ORDER BY total_profit DESC;


-- 8. Top 10 Customers by Sales
SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- 9. Discount Impact on Profit
SELECT
    CASE
        WHEN discount = 0 THEN '0% (No discount)'
        WHEN discount <= 0.2 THEN '1-20%'
        WHEN discount <= 0.4 THEN '21-40%'
        ELSE '41%+'
    END AS discount_bucket,
    COUNT(*) AS line_items,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore
GROUP BY 1
ORDER BY MIN(discount);


-- 10. Shipping Performance by Ship Mode
SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM public.superstore
GROUP BY ship_mode
ORDER BY avg_shipping_days;