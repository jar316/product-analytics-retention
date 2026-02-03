# Product Analytics: Customer Retention & Cohort Analysis

## Overview
This project analyzes customer purchasing behavior using transaction-level data to understand early retention patterns and identify high-performing acquisition cohorts.

The workflow mirrors a real analytics setup:
- Data quality validation and cleaning (Python)
- SQL-based staging and feature engineering (DuckDB)
- Cohort retention metrics and visualization
- Business interpretation and recommendations

---

## Business Questions
- How quickly do customers drop off after their first purchase?
- Are certain acquisition months associated with higher early retention?
- Where should product and lifecycle teams focus to improve retention?

---

## Dataset
Public online retail transaction dataset (2010–2011)
- ~400K transactions
- ~4.3K customers

---

## Metric Definitions
- **Cohort**: Month of first purchase
- **Retention**: A customer makes at least one purchase in a subsequent calendar month after acquisition
- **Month 0**: First purchase month
- **Month 1+**: Subsequent calendar months

---

## Approach

### 1) Data Preparation (Python)
- Removed canceled transactions
- Filtered invalid quantities/prices
- Dropped records without customer identifiers
- Saved a clean dataset to Parquet for reproducibility

### 2) SQL Modeling (DuckDB)
- `sql/01_staging.sql`: typed staging layer (`stg_retail`)
- `sql/02_features.sql`: customer feature table (`fct_customer_features`)
- `sql/03_metrics.sql`: cohort retention mart (`mart_cohort_retention`)

### 3) Analysis
- Cohort retention table and retention curves
- Comparison of Month-1 retention across cohorts

---

## Key Findings
- Retention drops sharply after the first purchase (early lifecycle gap).
- December cohorts show higher Month-1 retention than most other acquisition months.
- Retention becomes noisier after Month-2, consistent with non-subscription retail behavior.

---

## Interpretation
Higher Month-1 retention for December cohorts reflects sustained early engagement rather than same-month repeat purchases. This can be consistent with post-holiday behaviors such as returns/exchanges and gift-recipient follow-up purchases.

---

## Recommendations
- Focus on improving first-to-second purchase conversion.
- Run post-purchase lifecycle experiments within the first 30 days.
- Segment early retention by customer value tier to prioritize impact.

---

## Tech Stack
- Python: pandas, matplotlib
- SQL: DuckDB
- JupyterLab

---

## Project Structure
