DROP TABLE IF EXISTS public.superstore;

CREATE TABLE public.superstore (
    row_id            INTEGER NOT NULL PRIMARY KEY,
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
    quantity          INTEGER NOT NULL,
    discount          DECIMAL(10,4) NOT NULL,
    profit            DECIMAL(18,4) NOT NULL,
    order_year        INTEGER NOT NULL,
    order_month       INTEGER NOT NULL,
    order_month_name  VARCHAR(20) NOT NULL,
    order_quarter     INTEGER NOT NULL,
    shipping_days     INTEGER NOT NULL
)
ENCODE AUTO;