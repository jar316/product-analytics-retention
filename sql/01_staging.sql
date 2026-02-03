-- sql/01_staging.sql
-- Purpose: create a clean staging layer from retail_clean

CREATE OR REPLACE TABLE stg_retail AS
SELECT
  CAST(InvoiceNo AS VARCHAR)         AS invoice_no,
  CAST(StockCode AS VARCHAR)         AS stock_code,
  TRIM(CAST(Description AS VARCHAR)) AS product_description,
  CAST(Quantity AS INTEGER)          AS quantity,
  CAST(InvoiceDate AS TIMESTAMP)     AS invoice_ts,
  CAST(UnitPrice AS DOUBLE)          AS unit_price,
  CAST(CustomerID AS BIGINT)         AS customer_id,
  CAST(Country AS VARCHAR)           AS country,
  (CAST(Quantity AS DOUBLE) * CAST(UnitPrice AS DOUBLE)) AS revenue
FROM retail_clean
WHERE
  CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo IS NOT NULL
  AND InvoiceDate IS NOT NULL;