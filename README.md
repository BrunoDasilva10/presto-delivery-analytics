# Presto Delivery Analytics & ELT Platform

## Executive Summary

Presto is a food delivery company operating across multiple cities. This project delivers an end-to-end analytics platform that transforms raw delivery data into trusted, business-ready insights.

The solution implements a layered ELT architecture in Google BigQuery, progressing from raw data ingestion through data cleaning, validation, feature engineering, dimensional modelling, and business analysis.

The resulting analytical platform enables Presto to monitor delivery performance, operational efficiency, customer behaviour, financial performance, cancellations, refunds, and promotional activity.

---

## Business Problem

Presto lacked a centralized analytical platform for understanding the factors affecting delivery performance and customer outcomes.

This project was designed to answer key business questions, including:

* What factors are contributing to late deliveries?
* How do traffic, food preparation time, and weather affect delivery performance?
* Which customer segments generate the most value?
* What operational conditions are associated with cancellations and refunds?
* Can delivery efficiency be used as a reliable operational KPI?

---

## Solution Architecture

The platform follows a layered ELT architecture:

```text
Raw CSV Data
      ↓
Bronze Layer
Raw Data Ingestion
      ↓
Silver Layer
Cleaning • Validation • Feature Engineering
      ↓
Gold Layer
Dimensional Data Warehouse
      ↓
Business Analysis
      ↓
Power BI Reporting
```

The Gold layer follows a star schema consisting of:

* `fact_orders`
* `dim_city`
* `dim_time`
* `dim_customer_segment`

---

## Technology Stack

* **Google BigQuery** — Data warehouse and ELT processing
* **SQL** — Data transformation and analytical querying
* **Power BI** — Business intelligence and reporting
* **Git & GitHub** — Version control and project documentation

---

## Key Performance Indicators

| KPI                   |        Result |
| --------------------- | ------------: |
| Total Orders          |        15,000 |
| Total Revenue         |  1,786,255.57 |
| Average Order Value   |        119.08 |
| Average Delivery Time | 94.14 minutes |
| Late Delivery Rate    |        47.77% |
| Total Discounts Given |    223,988.80 |
| Total Tips Received   |    186,660.82 |

---

## Key Findings

### Operational Performance

* High traffic conditions were associated with longer delivery times, averaging **100.79 minutes** compared with **88.62 minutes** under low traffic.
* Slow food preparation increased average delivery time to **108.34 minutes**, compared with **77.18 minutes** for fast preparation.
* Delivery performance deteriorated when multiple unfavorable operational conditions occurred simultaneously.

### Customer Experience

* Orders receiving low customer ratings had an **11.14% refund rate**, compared with approximately **4%** for higher-rated orders.
* Premium customers recorded a higher average order value of **128.80**, compared with **115.28** for non-premium customers.
* Customer loyalty scores did not create a significant separation in revenue or order volume across the observed customer segments.

### Operational Efficiency

The Delivery Efficiency Score demonstrated a strong relationship with delivery performance:

| Efficiency Group  | Average Delivery Time | Late Delivery Rate |
| ----------------- | --------------------: | -----------------: |
| Low Efficiency    |            136.63 min |             60.63% |
| Medium Efficiency |             99.87 min |             48.52% |
| High Efficiency   |             60.63 min |             39.58% |

This suggests that the Delivery Efficiency Score can serve as a useful operational KPI for monitoring delivery performance.

### Data Quality

An inconsistency was identified between the `promo_code_used` field and discount amounts. Orders marked as not using a promotional code still contained discount values.

This highlights the importance of validating relationships between related business fields before using them for strategic decision-making.

---

## Business Recommendations

Based on the analysis, the following actions are recommended:

1. **Prioritize operational improvements in high-traffic environments**, where delivery times are consistently longer.
2. **Investigate restaurant preparation bottlenecks**, particularly for orders requiring extended preparation times.
3. **Adopt the Delivery Efficiency Score as an operational monitoring KPI.**
4. **Investigate low-rated orders and refund activity** to identify recurring customer experience issues.
5. **Review the promotional data model** to ensure discounts can be accurately attributed to promotional campaigns.
6. **Improve customer communication during severe operating conditions** to set more accurate delivery expectations.

---

## Dashboard

---

## Detailed Documentation

For the complete technical implementation, data quality investigation, transformation logic, analytical methodology, and business analysis: project_documentation.md

---

## Project Outcome

The project transformed raw delivery data into a structured analytical platform capable of supporting operational monitoring and business decision-making.

The resulting solution provides Presto with a foundation for understanding delivery performance, identifying operational bottlenecks, evaluating customer behaviour, and prioritizing areas for improvement.
