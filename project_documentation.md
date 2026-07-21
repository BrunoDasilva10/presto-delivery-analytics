# Presto Delivery Analytics & ELT Platform
### End-to-End Data Warehouse, SQL Analytics & Business Intelligence Solution

## Executive Summary

Presto is a food delivery company operating across multiple cities, processing thousands of customer orders every month. As the business expanded, operational data became increasingly fragmented across order processing, delivery operations, customer experience, and payment activities, making it difficult for stakeholders to monitor performance consistently and identify opportunities for operational improvement.

To address this challenge, an end-to-end analytics platform was designed using Google BigQuery and Power BI. The solution implements a layered ELT architecture that transforms raw transactional data into a structured analytical warehouse through Bronze, Silver, and Gold data layers. Business-ready dimensional models were then developed to support executive reporting and operational analysis.

The platform enables stakeholders to monitor key performance indicators, investigate delivery bottlenecks, evaluate customer behaviour, measure operational efficiency, and support strategic decision-making through a single, trusted source of analytical data.

## Business Problem

Presto's operational teams relied on raw transactional records to monitor business performance. While the available data contained valuable information about customer orders, delivery operations, rider performance, promotional campaigns, and payments, it lacked a structured analytical model capable of supporting consistent reporting across departments.

Without standardized business metrics and a centralized reporting layer, stakeholders faced several operational challenges:

- Delivery performance could not be consistently monitored across different cities.
- Operational bottlenecks causing delivery delays were difficult to identify.
- Customer behaviour and loyalty trends were not clearly understood.
- Marketing initiatives such as promotions and premium memberships could not be properly evaluated.
- Executive reporting required repetitive manual analysis instead of reusable business models.

To improve operational visibility and support data-driven decision-making, the business required a scalable analytics platform capable of transforming raw operational data into reliable business intelligence.

## Project Objectives

The project was designed to achieve the following objectives:

- Design a modern ELT data warehouse using Bronze, Silver, and Gold layers.
- Clean, validate, and standardize operational delivery data.
- Build a dimensional star schema optimized for analytical reporting.
- Engineer business-focused features to improve operational analysis.
- Develop reusable SQL models capable of answering strategic business questions.
- Produce interactive Power BI dashboards for executive and operational reporting.
- Deliver actionable business recommendations based on analytical findings.

## Technology Stack
Data Warehouse;  Google BigQuery 
SQL; GoogleSQL 
Data Modelling; Star Schema 
ETL / ELT; BigQuery SQL 
Data Visualisation; Power BI 
Version Control; Git & GitHub 


## Dataset Overview

The analytical dataset contains 15,000 food delivery orders and captures information across multiple areas of the delivery operation, including customer behaviour, order economics, delivery performance, operational conditions, rider experience, and customer outcomes.

The dataset contains 30 operational and transactional attributes covering:

- Order and transaction information
- Customer loyalty and premium membership
- Delivery and preparation times
- Traffic and weather conditions
- Restaurant and delivery partner ratings
- Discounts, delivery fees, and tips
- Cancellations and refunds
- Delivery efficiency
- Promotional activity

## Data Architecture

The platform follows a layered ELT architecture designed to progressively transform raw operational data into trusted, business-ready analytical models.

The architecture consists of three primary layers:

1. Bronze Layer — Raw data ingestion
2. Silver Layer — Data cleaning, validation, and feature engineering
3. Gold Layer — Dimensional modelling and business-ready analytics

## Bronze Layer — Raw Data Ingestion

The Bronze layer serves as the initial landing zone for the source data.

The raw delivery dataset was ingested into Google BigQuery without applying business transformations. This layer preserves the original source structure and provides a reliable foundation for downstream processing.

The Bronze layer acts as the source of truth for the transformation pipeline and allows downstream models to be rebuilt if required.

## Silver Layer — Data Cleaning & Feature Engineering

The Silver layer transforms raw operational data into a clean, validated, and analysis-ready dataset.

Key transformations included:

- Standardizing data types.
- Validating column ranges and values.
- Investigating missing values.
- Checking for duplicate records.
- Validating Boolean fields.
- Creating business-focused calculated features.
- Applying data quality checks to newly engineered fields.

### Engineered Features
#### Delivery Delay

`delivery_delay_minutes`

Measures the difference between the actual delivery time and the estimated delivery time.

This feature provides a direct measure of whether an order was delivered ahead of or behind its expected delivery time.

#### Late Delivery Indicator

`is_late_delivery`

A Boolean field derived from delivery delay that identifies whether an order exceeded its estimated delivery time.

This feature enables standardized calculation of the late delivery rate across different operational dimensions.

## Data Quality & Validation

Data quality checks were performed throughout the transformation process to ensure that the analytical models were suitable for business reporting.

Validation activities included:

- Row count reconciliation between source and transformed datasets.
- Duplicate record checks.
- Missing value analysis.
- Data type validation.
- Range validation for numerical fields.
- Boolean field validation.
- Validation of engineered features.
- Inspection of unexpected relationships between related fields.

### Data Quality Finding: Promotional Data Inconsistency

An inconsistency was identified between the `promo_code_used` and discount fields.

Orders where `promo_code_used = FALSE` still contained discount amounts, indicating that the promotional flag did not fully explain all discounts applied to orders.

This finding highlights the importance of validating relationships between related fields rather than assuming that individual columns are always logically consistent.

## Gold Layer — Business-Ready Data Models

The Gold layer contains curated analytical models designed to support business reporting and analytical workloads.

The layer follows a dimensional modelling approach using a star schema consisting of:

- `fact_orders`
- `dim_city`
- `dim_time`
- `dim_customer_segment`

The dimensional model separates measurable business events from descriptive attributes, enabling consistent and efficient analysis across multiple business dimensions.
## Data Warehouse Design

The analytical warehouse follows a star schema design.

The central `fact_orders` table stores measurable order-level business events, while dimension tables provide descriptive context for analysis.

### Fact Table

#### `fact_orders`

Contains one record per order and stores the primary measurable business metrics associated with each delivery.

Examples include:

- Order value
- Final amount paid
- Delivery time
- Delivery delay
- Delivery fees
- Discounts
- Tips
- Customer ratings
- Refund and cancellation indicators
### Dimension Tables

#### `dim_city`

Provides city-level context for analyzing operational and financial performance across different city tiers.

#### `dim_time`

Provides time-related attributes that support analysis by:

- Order hour
- Day of the week
- Month
- Weekend and festival periods

#### `dim_customer_segment`

Provides customer segmentation attributes for analyzing customer behaviour and value.

### Why a Star Schema?

The star schema was selected to provide a clear separation between business events and descriptive attributes.

This design offers several advantages:

- Simplifies analytical queries.
- Reduces repeated descriptive data.
- Provides consistent business dimensions.
- Supports reusable reporting models.
- Makes the data model easier for analysts and business users to understand.
- Provides a scalable foundation for future dashboards and analytical workloads.

## Business Questions

The analytical layer was used to investigate key questions across operations, customer behaviour, financial performance, and service quality.

### Executive Performance

- How many orders were processed?
- What was the total revenue generated?
- What was the average order value?
- What was the average delivery time?
- What percentage of orders were delivered late?
- How much was spent on discounts?
- How much revenue was generated through tips?

### Delivery Operations

- Which city tiers generate the most orders and revenue?
- Does delivery partner experience influence delivery performance?
- How does traffic affect delivery time and late delivery rates?
- How does food preparation time influence delivery performance?
- How do traffic, preparation time, and weather interact to affect delivery outcomes?
- Which operational conditions produce the highest cancellation rates?
- Which operational conditions produce the highest refund rates?
### Customer Experience

- How does customer satisfaction relate to delivery and operational performance?
- Which customer groups generate the most revenue?
- Do premium customers have higher average order values?
- What factors are associated with refunds and cancellations?

### Marketing & Customer Behaviour

- How does promotional code usage relate to order value and customer behaviour?
- Do festival and weekend periods influence order value and delivery performance?
- How does customer loyalty relate to revenue and purchasing behaviour?

### Operational Efficiency

- Does the delivery efficiency score accurately reflect delivery performance?
- How do efficiency levels relate to delivery time and late delivery rates?

## Executive KPI Overview

KPI - Result 
Total Orders: 15,000 
Total Revenue: 1,786,255.57 
Average Order Value: 119.08 
Average Delivery Time: 94.14 minutes
Late Delivery Rate: 47.77% 
Total Discounts Given:  223,988.80 
Total Tips Received: 186,660.82 
The executive overview indicates that Presto processed 15,000 orders and generated approximately 1.79 million in revenue. However, the 47.77% late delivery rate represents a significant operational challenge and became a key focus of the subsequent analysis.

### City Performance

Tier 3 cities accounted for the largest share of order volume, processing 7,520 orders and generating approximately 896,563 in revenue.

Tier 1 cities recorded the lowest order volume, with 3,723 orders, and generated approximately 443,957 in revenue.

Although Tier 3 cities recorded the highest overall operational volume, differences in average delivery performance across city tiers were relatively limited. This suggests that order volume alone does not fully explain the elevated late delivery rate.

Further analysis was therefore conducted to investigate additional operational factors, including delivery partner experience, traffic conditions, preparation time, and weather severity.

### Delivery Partner Experience

Delivery partners with more than five years of experience handled the largest volume of orders and recorded the highest late delivery rate.

Despite this, the group maintained a strong average customer rating.

The combination of relatively strong customer ratings and elevated delivery delays suggests that delivery partner experience alone may not be the primary cause of late deliveries.

This prompted further investigation into external operational factors such as traffic conditions, preparation times, and weather severity.

### Traffic Impact

Traffic conditions demonstrated a clear relationship with delivery time.

Traffic Group - Average Delivery Time 

Low: 88.62 minutes 
Medium:  94.66 minutes 
High: 100.79 minutes 

Orders affected by high traffic recorded the longest average delivery times.

Although the late delivery rate remained relatively similar across traffic groups, the consistent increase in average delivery time indicates that traffic is a significant contributor to overall delivery duration.


### Preparation Time and Delivery Performance

Food preparation time demonstrated a clear relationship with total delivery duration.

| Preparation Group | Average Delivery Time | Late Delivery Rate |
| Fast | 77.18 minutes | 47.77% |
| Moderate | 91.58 minutes | 47.16% |
| Slow | 108.34 minutes | 48.34% |

Orders requiring more than 40 minutes of preparation recorded the highest average delivery time.

The difference in late delivery rates between preparation groups was comparatively small. However, the substantial increase in total delivery time indicates that longer preparation times directly contribute to the overall customer waiting experience.

This suggests that operational improvements should not focus exclusively on the delivery stage. Restaurant preparation time represents an important component of the end-to-end delivery process.

### Combined Operational Conditions

To investigate how multiple operational factors interact, traffic conditions, preparation time, and weather severity were analyzed together.

The analysis showed that the highest average delivery times generally occurred when multiple operational conditions were unfavorable simultaneously.

For example, combinations involving:

- High traffic
- Slow food preparation
- Severe weather

produced some of the longest delivery times observed in the dataset.

Conversely, combinations involving:

- Low traffic
- Fast preparation
- Mild weather

produced significantly shorter delivery times.

The analysis demonstrates that delivery performance is influenced by the combined effect of multiple operational factors rather than a single isolated variable.

### Refund Analysis

Refund rates varied across different combinations of operational conditions.

Interestingly, the combination with the most extreme operational conditions did not produce the highest refund rate.

Instead, the highest refund rate occurred under a moderate traffic, moderate preparation, and moderate weather combination.

This suggests that refund behaviour may not be driven solely by the objective severity of operational conditions.

Customer expectations, perceived service quality, and the difference between expected and actual delivery performance may also influence refund behaviour.

However, additional customer-level data would be required to confirm these behavioural explanations.

### Cancellation Analysis

Cancellation rates demonstrated a stronger relationship with severe operating conditions than refund rates.

The highest cancellation rate was observed under a combination of:

- High traffic
- Moderate preparation time
- Severe weather

This combination produced a cancellation rate of 21.2%.

The result suggests that customers may be more likely to cancel orders when severe external conditions combine with operational delays.

This reinforces the importance of proactive operational communication during periods of significant disruption.

### Customer Satisfaction

Customer satisfaction was analyzed using three rating segments:

- Low Rating: below 3
- Average Rating: 3 to below 4
- High Rating: 4 and above

Customers providing low ratings experienced similar average delivery times to other customer groups.

However, the low-rating segment recorded a significantly higher refund rate.

| Satisfaction Segment | Average Rating | Refund Rate |
| Low Rating | 2.73 | 11.14% |
| Average Rating | 3.58 | 4.03% |
| High Rating | 4.39 | 3.83% |

The results indicate a strong association between low customer satisfaction and refund activity.

However, the available data does not establish whether refunds caused lower ratings or whether poor experiences caused both low ratings and refund requests.

### Customer Loyalty

Customer loyalty scores were segmented based on the observed distribution of the loyalty score, which ranged from approximately 0 to 100.

The distribution produced relatively balanced customer groups across low, medium, and high loyalty segments.

Revenue and order volume were also relatively evenly distributed across the three groups. This indicates that loyalty score alone did not create a strong separation in customer value within the available dataset.

Further customer-level behavioural features would be required to develop a more comprehensive customer value model.

### Premium Customer Performance

Premium customers represented a smaller portion of total order volume but demonstrated higher average order values.

| Customer Type | Orders | Average Order Value |
| Non-Premium | 10,779 | 115.28 |
| Premium | 4,221 | 128.80 |

Premium customers generated a higher average order value while experiencing similar delivery times and customer ratings compared with non-premium customers.

This suggests that premium membership is associated with higher customer spend, although additional analysis would be required to determine whether premium membership directly drives higher spending.

### Promotional Activity

Orders were analyzed based on whether a promotional code was recorded as being used.

| Promo Code Used | Orders | Revenue |
| No | 8,653 | 1,030,928.43 |
| Yes | 6,347 | 755,326.85 |

The analysis identified an inconsistency between the `promo_code_used` field and discount amounts.

Orders where `promo_code_used = FALSE` still contained discount values. Additionally, the discount fields did not provide a consistent distinction between promotional and non-promotional discounts.

As a result, the `promo_code_used` field cannot independently be used to determine the true effectiveness of promotional campaigns without additional clarification regarding the underlying discount logic.

This finding highlights the importance of validating relationships between related business fields before using them for strategic decision-making.

### Festival and Weekend Performance

Orders occurring during festival or weekend periods were compared with regular orders.

| Order Period | Average Order Value | Average Delivery Time | Late Delivery Rate |
| Festival / Weekend | 121.71 | 93.18 | 46.06% |
| Regular Period | 111.94 | 94.39 | 48.21% |

Festival and weekend periods recorded higher average order values and slightly better delivery performance than regular periods.

This suggests that these periods may represent valuable revenue opportunities for Presto.

However, the data does not establish whether the improved delivery performance is caused by the festival/weekend period itself or by other operational factors occurring during those periods.

### Delivery Efficiency Score

The Delivery Efficiency Score demonstrated a strong relationship with operational performance.

| Efficiency Group | Average Delivery Time | Late Delivery Rate |
| Low Efficiency | 136.63 minutes | 60.63% |
| Medium Efficiency | 99.87 minutes | 48.52% |
| High Efficiency | 60.63 minutes | 39.58% |

Orders with higher efficiency scores consistently recorded shorter delivery times and lower late delivery rates.

This indicates that the Delivery Efficiency Score is a useful operational KPI for monitoring delivery performance.

The score could potentially be used to:

- Identify operational bottlenecks.
- Monitor performance across cities.
- Evaluate delivery operations over time.
- Support targeted operational interventions.

## Key Findings

The analysis identified several important operational and customer-related insights across the Presto delivery ecosystem.

### 1. Delivery delays are influenced by multiple operational factors

Traffic conditions and food preparation time demonstrated clear relationships with total delivery duration.

High traffic conditions increased average delivery time, while slow food preparation created a significant increase in total customer waiting time.

The combined analysis also showed that multiple unfavorable conditions occurring simultaneously can significantly affect delivery performance.

This suggests that delivery delays should be addressed as a broader operational challenge rather than being attributed to a single factor.

### 2. Delivery partner experience alone does not explain late deliveries

More experienced delivery partners handled the highest order volumes and recorded the highest late delivery rate.

However, they also maintained strong customer ratings.

This suggests that delivery partner experience alone may not be the primary driver of late deliveries. External operational conditions such as traffic, preparation time, and weather may have a stronger influence on delivery outcomes.

### 3. Customer satisfaction is strongly associated with refund activity

Customers providing low ratings recorded a significantly higher refund rate than customers providing average or high ratings.

This indicates that poor customer experiences are associated with increased refund activity and should be investigated as part of customer retention and service quality initiatives.

### 4. Premium customers generate higher average order values

Premium customers recorded higher average order values than non-premium customers while experiencing similar delivery times and customer ratings.

This indicates that premium customers represent a valuable customer segment and may warrant targeted retention and engagement strategies.

### 5. Delivery efficiency is a strong operational performance indicator

The Delivery Efficiency Score demonstrated a clear relationship with delivery outcomes.

Higher efficiency scores were associated with:

- Shorter average delivery times.
- Lower average delivery delays.
- Lower late delivery rates.

This suggests that the Delivery Efficiency Score can serve as a useful KPI for monitoring delivery operations and identifying potential performance issues.

### 6. Data quality issues can affect business conclusions

The analysis identified inconsistencies between promotional code usage and discount amounts.

This demonstrates that data quality validation is essential before using related fields for strategic decision-making.

Business conclusions should only be made after confirming that the underlying data accurately represents the business processes being analyzed.

## Business Recommendations

Based on the analytical findings, the following actions are recommended.

### 1. Prioritize high-traffic operating environments

High traffic was associated with longer average delivery times.

Presto should investigate operational strategies for high-traffic environments, including:

- Improved delivery route planning.
- Dynamic rider allocation.
- Operational monitoring during peak traffic periods.

### 2. Investigate restaurant preparation bottlenecks

Slow preparation times substantially increased total delivery duration.

Restaurants with consistently long preparation times should be evaluated to identify:

- Kitchen capacity constraints.
- Peak-period bottlenecks.
- Menu items requiring excessive preparation time.

### 3. Monitor delivery efficiency as a core operational KPI

The Delivery Efficiency Score showed a strong relationship with delivery performance.

Presto should use the score to:

- Monitor operational performance.
- Identify underperforming areas.
- Compare performance across cities.
- Track operational improvement over time.

### 4. Investigate low-rated orders and refund activity

Low-rated orders had substantially higher refund rates.

Further investigation should focus on:

- The most common reasons for low ratings.
- The relationship between delivery delays and refunds.
- Restaurant-level and city-level customer satisfaction patterns.

### 5. Improve promotional data tracking

The inconsistency between promotional code usage and discount amounts indicates that the promotional data model requires further validation.

The business should ensure that:

- Promotional discounts are clearly separated from other discounts.
- Promotion identifiers are consistently recorded.
- Campaign performance can be accurately measured.

### 6. Improve communication during severe operating conditions

Severe weather and challenging operating conditions can increase delivery uncertainty.

Providing customers with more accurate delivery estimates and proactive notifications may help manage expectations and reduce cancellations.

## Conclusion

This project developed an end-to-end delivery analytics platform for Presto using a layered ELT architecture.

Raw delivery data was transformed through Bronze, Silver, and Gold layers, with data cleaning, validation, feature engineering, dimensional modelling, and business analysis applied throughout the process.

The resulting analytical platform provides visibility into:

- Delivery performance.
- Operational efficiency.
- Customer satisfaction.
- Refunds and cancellations.
- Customer value.
- Revenue performance.

The analysis identified several factors associated with delivery performance, particularly traffic conditions, preparation time, and overall operational efficiency.

The Delivery Efficiency Score demonstrated the strongest relationship with delivery outcomes and provides a potentially valuable KPI for operational monitoring.

Beyond the analytical findings, the project also demonstrated the importance of data quality validation. Inconsistencies in promotional data highlighted how unreliable source data can affect business conclusions if not investigated before analysis.

The completed platform provides a foundation for Presto to make more informed operational decisions and demonstrates how raw operational data can be transformed into actionable business intelligence.
