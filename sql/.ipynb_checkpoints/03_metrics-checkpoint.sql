-- sql/03_metrics.sql
-- Purpose: cohort retention table based on first purchase month

CREATE OR REPLACE TABLE mart_cohort_retention AS
WITH orders AS (
  SELECT
    customer_id,
    invoice_no,
    DATE_TRUNC('month', MIN(invoice_ts)) AS order_month
  FROM stg_retail
  GROUP BY 1,2
),
first_month AS (
  SELECT
    customer_id,
    MIN(order_month) AS cohort_month
  FROM orders
  GROUP BY 1
),
cohort_orders AS (
  SELECT
    o.customer_id,
    f.cohort_month,
    o.order_month,
    DATE_DIFF('month', f.cohort_month, o.order_month) AS months_since_cohort
  FROM orders o
  JOIN first_month f USING (customer_id)
),
cohort_sizes AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size
  FROM cohort_orders
  WHERE months_since_cohort = 0
  GROUP BY 1
),
retained AS (
  SELECT
    cohort_month,
    months_since_cohort,
    COUNT(DISTINCT customer_id) AS retained_customers
  FROM cohort_orders
  GROUP BY 1,2
)
SELECT
  r.cohort_month,
  r.months_since_cohort,
  s.cohort_size,
  r.retained_customers,
  (r.retained_customers * 1.0 / s.cohort_size) AS retention_rate
FROM retained r
JOIN cohort_sizes s USING (cohort_month)
ORDER BY 1,2;