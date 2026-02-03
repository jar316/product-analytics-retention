

CREATE OR REPLACE TABLE fct_customer_features AS
WITH orders AS (
  SELECT
    customer_id,
    invoice_no,
    MIN(invoice_ts) AS order_ts,
    SUM(revenue)    AS order_revenue,
    SUM(quantity)   AS items
  FROM stg_retail
  GROUP BY 1,2
),
customer_rollup AS (
  SELECT
    customer_id,
    MIN(order_ts) AS first_order_ts,
    MAX(order_ts) AS last_order_ts,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(order_revenue) AS lifetime_revenue,
    AVG(order_revenue) AS avg_order_value,
    SUM(items) AS lifetime_items
  FROM orders
  GROUP BY 1
),
asof_dat AS (
  SELECT MAX(invoice_ts) AS asof_ts FROM stg_retail
)
SELECT
  cr.*,
  DATE_DIFF('day', cr.last_order_ts, a.asof_ts) AS days_since_last_order,
  CASE
    WHEN cr.total_orders = 1 THEN 'one_time'
    WHEN cr.total_orders BETWEEN 2 AND 3 THEN 'repeat_2_3'
    WHEN cr.total_orders BETWEEN 4 AND 9 THEN 'repeat_4_9'
    ELSE 'power_10_plus'
  END AS order_frequency_segment,
  CASE
    WHEN cr.lifetime_revenue < 100 THEN 'low'
    WHEN cr.lifetime_revenue < 500 THEN 'mid'
    ELSE 'high'
  END AS value_segment
FROM customer_rollup cr
CROSS JOIN asof_dat a;