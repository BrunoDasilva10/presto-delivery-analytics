/*
===============================================================================
PRESTO DELIVERY ANALYTICS & ELT PLATFORM
End-to-End BigQuery SQL Pipeline and Business Analysis

Project: Presto Delivery Analytics
Warehouse: Google BigQuery
===============================================================================
*/


/*
===============================================================================
1. BRONZE LAYER
===============================================================================

Raw source data is ingested into:

bruno-delivery-analytics.presto_bronze.bronze_orders_raw

The Bronze layer preserves the source data for traceability and downstream
transformation.

*/


/*
===============================================================================
2. SILVER LAYER
===============================================================================

The Silver layer contains the cleaned and feature-engineered dataset:

bruno-delivery-analytics.presto_silver.silver_orders_clean

Key transformations include data cleaning, validation, derived delivery
metrics, delivery delay calculations, late-delivery flags, and business
feature engineering.

*/


/*
===============================================================================
3. GOLD LAYER
DIMENSIONAL DATA MODEL
===============================================================================
*/


/*-----------------------------------------------------------------------------
3.1 DIM_CITY
-----------------------------------------------------------------------------*/

CREATE OR REPLACE TABLE
`bruno-delivery-analytics.presto_gold.dim_city` AS

SELECT
    DENSE_RANK() OVER (ORDER BY city_tier) AS city_key,
    city_tier

FROM (
    SELECT DISTINCT
        city_tier

    FROM
    `bruno-delivery-analytics.presto_silver.silver_orders_clean`
);


/*-----------------------------------------------------------------------------
3.2 DIM_TIME
-----------------------------------------------------------------------------*/

CREATE OR REPLACE TABLE
`bruno-delivery-analytics.presto_gold.dim_time` AS

SELECT
    DENSE_RANK() OVER (
        ORDER BY
            order_month,
            order_day_of_week,
            order_hour,
            festival_or_weekend_flag
    ) AS time_key,

    order_month,
    order_day_of_week,
    order_hour,
    festival_or_weekend_flag

FROM (
    SELECT DISTINCT
        order_month,
        order_day_of_week,
        order_hour,
        festival_or_weekend_flag

    FROM
    `bruno-delivery-analytics.presto_silver.silver_orders_clean`
);


/*-----------------------------------------------------------------------------
3.3 DIM_CUSTOMER_SEGMENT
-----------------------------------------------------------------------------*/

CREATE OR REPLACE TABLE
`bruno-delivery-analytics.presto_gold.dim_customer_segment` AS

SELECT
    DENSE_RANK() OVER (
        ORDER BY
            age_group,
            loyalty_tier,
            premium_customer_flag
    ) AS customer_segment_key,

    age_group,
    loyalty_tier,
    premium_customer_flag

FROM (

    SELECT DISTINCT

        CASE
            WHEN customer_age BETWEEN 18 AND 25
                THEN 'Young Adult'
            WHEN customer_age BETWEEN 26 AND 35
                THEN 'Adult'
            WHEN customer_age BETWEEN 36 AND 50
                THEN 'Middle Age'
            ELSE 'Senior'
        END AS age_group,

        CASE
            WHEN customer_loyalty_score < 33
                THEN 'Low Loyalty'
            WHEN customer_loyalty_score < 67
                THEN 'Medium Loyalty'
            ELSE 'High Loyalty'
        END AS loyalty_tier,

        premium_customer_flag

    FROM
    `bruno-delivery-analytics.presto_silver.silver_orders_clean`
);


/*-----------------------------------------------------------------------------
3.4 FACT_ORDERS
-----------------------------------------------------------------------------*/

CREATE OR REPLACE TABLE
`bruno-delivery-analytics.presto_gold.fact_orders` AS

SELECT

    -- Business Key
    s.order_id,

    -- Foreign Keys
    c.city_key,
    t.time_key,
    cs.customer_segment_key,

    -- Financial Measures
    ROUND(s.order_value, 2) AS order_value,
    ROUND(s.delivery_fee, 2) AS delivery_fee,
    ROUND(s.discount_amount, 2) AS discount_amount,
    ROUND(s.tip_amount, 2) AS tip_amount,
    ROUND(s.final_amount_paid, 2) AS final_amount_paid,

    -- Order Measures
    s.number_of_items,

    -- Delivery Measures
    s.preparation_time_minutes,
    s.delivery_time_minutes,
    s.estimated_delivery_time,
    ROUND(s.delivery_delay_minutes, 2) AS delivery_delay_minutes,

    -- Delivery Performance Flag
    s.is_late_delivery

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean` AS s

LEFT JOIN
`bruno-delivery-analytics.presto_gold.dim_city` AS c

    ON s.city_tier = c.city_tier

LEFT JOIN
`bruno-delivery-analytics.presto_gold.dim_time` AS t

    ON s.order_month = t.order_month
    AND s.order_day_of_week = t.order_day_of_week
    AND s.order_hour = t.order_hour
    AND s.festival_or_weekend_flag = t.festival_or_weekend_flag

LEFT JOIN
`bruno-delivery-analytics.presto_gold.dim_customer_segment` AS cs

    ON

    CASE
        WHEN s.customer_age BETWEEN 18 AND 25
            THEN 'Young Adult'
        WHEN s.customer_age BETWEEN 26 AND 35
            THEN 'Adult'
        WHEN s.customer_age BETWEEN 36 AND 50
            THEN 'Middle Age'
        ELSE 'Senior'
    END = cs.age_group

    AND

    CASE
        WHEN s.customer_loyalty_score < 33
            THEN 'Low Loyalty'
        WHEN s.customer_loyalty_score < 67
            THEN 'Medium Loyalty'
        ELSE 'High Loyalty'
    END = cs.loyalty_tier

    AND s.premium_customer_flag = cs.premium_customer_flag;


/*
===============================================================================
4. BUSINESS ANALYSIS
===============================================================================
*/


/*-----------------------------------------------------------------------------
4.1 EXECUTIVE KPI ANALYSIS
-----------------------------------------------------------------------------*/

SELECT

    COUNT(order_id) AS total_orders,

    ROUND(SUM(final_amount_paid), 2) AS total_revenue,

    ROUND(AVG(final_amount_paid), 2) AS average_order_value,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate,

    ROUND(SUM(discount_amount), 2)
        AS total_discounts_given,

    ROUND(SUM(tip_amount), 2)
        AS total_tips_received,

    COUNT(DISTINCT customer_segment_key)
        AS active_customer_segments

FROM
`bruno-delivery-analytics.presto_gold.fact_orders`;


/*-----------------------------------------------------------------------------
4.2 CITY PERFORMANCE
-----------------------------------------------------------------------------*/

SELECT

    c.city_tier,

    COUNT(f.order_id) AS total_orders,

    ROUND(SUM(f.final_amount_paid), 2)
        AS total_revenue,

    ROUND(AVG(f.delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(f.delivery_delay_minutes), 2)
        AS average_delivery_delay,

    ROUND(
        100 * COUNTIF(f.is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM
`bruno-delivery-analytics.presto_gold.fact_orders` AS f

JOIN
`bruno-delivery-analytics.presto_gold.dim_city` AS c

    ON f.city_key = c.city_key

GROUP BY
    c.city_tier

ORDER BY
    late_delivery_rate DESC;


/*-----------------------------------------------------------------------------
4.3 DELIVERY PARTNER EXPERIENCE
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN delivery_partner_experience_years < 2
            THEN '0–2 Years'
        WHEN delivery_partner_experience_years < 5
            THEN '2–5 Years'
        ELSE '5+ Years'
    END AS experience_group,

    CASE
        WHEN delivery_partner_experience_years < 2 THEN 1
        WHEN delivery_partner_experience_years < 5 THEN 2
        ELSE 3
    END AS experience_order,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    experience_group,
    experience_order

ORDER BY
    experience_order;


/*-----------------------------------------------------------------------------
4.4 TRAFFIC IMPACT
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN traffic_level_score < 4 THEN 'Low'
        WHEN traffic_level_score < 7 THEN 'Medium'
        ELSE 'High'
    END AS traffic_group,

    CASE
        WHEN traffic_level_score < 4 THEN 1
        WHEN traffic_level_score < 7 THEN 2
        ELSE 3
    END AS traffic_order,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    traffic_group,
    traffic_order

ORDER BY
    traffic_order;


/*-----------------------------------------------------------------------------
4.5 PREPARATION TIME IMPACT
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN preparation_time_minutes < 20
            THEN 'Fast'
        WHEN preparation_time_minutes < 40
            THEN 'Moderate'
        ELSE 'Slow'
    END AS preparation_group,

    CASE
        WHEN preparation_time_minutes < 20 THEN 1
        WHEN preparation_time_minutes < 40 THEN 2
        ELSE 3
    END AS preparation_order,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    preparation_group,
    preparation_order

ORDER BY
    preparation_order;


/*-----------------------------------------------------------------------------
4.6 COMBINED OPERATIONAL CONDITIONS
Traffic + Preparation + Weather
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN traffic_level_score < 4 THEN 'Low'
        WHEN traffic_level_score < 7 THEN 'Medium'
        ELSE 'High'
    END AS traffic_group,

    CASE
        WHEN preparation_time_minutes < 20 THEN 'Fast'
        WHEN preparation_time_minutes <= 40 THEN 'Moderate'
        ELSE 'Slow'
    END AS preparation_group,

    CASE
        WHEN weather_severity_score < 4 THEN 'Mild'
        WHEN weather_severity_score < 7 THEN 'Moderate'
        ELSE 'Severe'
    END AS weather_group,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    traffic_group,
    preparation_group,
    weather_group

ORDER BY
    late_delivery_rate DESC;


/*-----------------------------------------------------------------------------
4.7 CUSTOMER LOYALTY
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN customer_loyalty_score < 33
            THEN 'Low Loyalty'
        WHEN customer_loyalty_score < 67
            THEN 'Medium Loyalty'
        ELSE 'High Loyalty'
    END AS loyalty_segment,

    CASE
        WHEN customer_loyalty_score < 33 THEN 1
        WHEN customer_loyalty_score < 67 THEN 2
        ELSE 3
    END AS loyalty_order,

    COUNT(*) AS total_orders,

    ROUND(SUM(final_amount_paid), 2)
        AS total_revenue,

    ROUND(AVG(final_amount_paid), 2)
        AS average_order_value,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    loyalty_segment,
    loyalty_order

ORDER BY
    loyalty_order;


/*-----------------------------------------------------------------------------
4.8 PREMIUM CUSTOMER PERFORMANCE
-----------------------------------------------------------------------------*/

SELECT

    premium_customer_flag,

    COUNT(*) AS total_orders,

    ROUND(SUM(final_amount_paid), 2)
        AS total_revenue,

    ROUND(AVG(final_amount_paid), 2)
        AS average_order_value,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    premium_customer_flag;


/*-----------------------------------------------------------------------------
4.9 PROMOTIONAL ACTIVITY
-----------------------------------------------------------------------------*/

SELECT

    promo_code_used,

    COUNT(*) AS total_orders,

    ROUND(SUM(final_amount_paid), 2)
        AS total_revenue,

    ROUND(AVG(final_amount_paid), 2)
        AS average_order_value,

    ROUND(AVG(discount_amount), 2)
        AS average_discount,

    ROUND(AVG(number_of_items), 2)
        AS average_items,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    promo_code_used;


/*-----------------------------------------------------------------------------
4.10 REFUND ANALYSIS
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN traffic_level_score < 4 THEN 'Low'
        WHEN traffic_level_score < 7 THEN 'Medium'
        ELSE 'High'
    END AS traffic_group,

    CASE
        WHEN preparation_time_minutes < 20 THEN 'Fast'
        WHEN preparation_time_minutes <= 40 THEN 'Moderate'
        ELSE 'Slow'
    END AS preparation_group,

    CASE
        WHEN weather_severity_score < 4 THEN 'Mild'
        WHEN weather_severity_score < 7 THEN 'Moderate'
        ELSE 'Severe'
    END AS weather_group,

    COUNT(*) AS total_orders,

    ROUND(
        100 * COUNTIF(refund_flag) / COUNT(*),
        2
    ) AS refund_rate,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    traffic_group,
    preparation_group,
    weather_group

ORDER BY
    refund_rate DESC;


/*-----------------------------------------------------------------------------
4.11 CANCELLATION ANALYSIS
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN traffic_level_score < 4 THEN 'Low'
        WHEN traffic_level_score < 7 THEN 'Medium'
        ELSE 'High'
    END AS traffic_group,

    CASE
        WHEN preparation_time_minutes < 20 THEN 'Fast'
        WHEN preparation_time_minutes <= 40 THEN 'Moderate'
        ELSE 'Slow'
    END AS preparation_group,

    CASE
        WHEN weather_severity_score < 4 THEN 'Mild'
        WHEN weather_severity_score < 7 THEN 'Moderate'
        ELSE 'Severe'
    END AS weather_group,

    COUNT(*) AS total_orders,

    ROUND(
        100 * COUNTIF(cancellation_flag) / COUNT(*),
        2
    ) AS cancellation_rate,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    traffic_group,
    preparation_group,
    weather_group

ORDER BY
    cancellation_rate DESC;


/*-----------------------------------------------------------------------------
4.12 CUSTOMER SATISFACTION
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN customer_rating < 3
            THEN 'Low Rating'
        WHEN customer_rating < 4
            THEN 'Average Rating'
        ELSE 'High Rating'
    END AS customer_satisfaction,

    CASE
        WHEN customer_rating < 3 THEN 1
        WHEN customer_rating < 4 THEN 2
        ELSE 3
    END AS satisfaction_order,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay,

    ROUND(AVG(preparation_time_minutes), 2)
        AS average_preparation_time,

    ROUND(AVG(traffic_level_score), 2)
        AS average_traffic_level_score,

    ROUND(AVG(weather_severity_score), 2)
        AS average_weather_severity_score,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating,

    ROUND(
        100 * COUNTIF(cancellation_flag) / COUNT(*),
        2
    ) AS cancellation_rate,

    ROUND(
        100 * COUNTIF(refund_flag) / COUNT(*),
        2
    ) AS refund_rate

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    customer_satisfaction,
    satisfaction_order

ORDER BY
    satisfaction_order;


/*-----------------------------------------------------------------------------
4.13 FESTIVAL AND WEEKEND PERFORMANCE
-----------------------------------------------------------------------------*/

SELECT

    festival_or_weekend_flag,

    COUNT(*) AS total_orders,

    ROUND(SUM(final_amount_paid), 2)
        AS total_revenue,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating,

    ROUND(AVG(order_value), 2)
        AS average_order_value,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    festival_or_weekend_flag

ORDER BY
    festival_or_weekend_flag DESC;


/*-----------------------------------------------------------------------------
4.14 DELIVERY EFFICIENCY SCORE
-----------------------------------------------------------------------------*/

SELECT

    CASE
        WHEN delivery_efficiency_score < 40
            THEN 'Low Efficiency'
        WHEN delivery_efficiency_score < 70
            THEN 'Medium Efficiency'
        ELSE 'High Efficiency'
    END AS efficiency_group,

    CASE
        WHEN delivery_efficiency_score < 40 THEN 1
        WHEN delivery_efficiency_score < 70 THEN 2
        ELSE 3
    END AS efficiency_order,

    COUNT(*) AS total_orders,

    ROUND(AVG(delivery_time_minutes), 2)
        AS average_delivery_time,

    ROUND(AVG(delivery_delay_minutes), 2)
        AS average_delivery_delay,

    ROUND(AVG(customer_rating), 2)
        AS average_customer_rating,

    ROUND(
        100 * COUNTIF(is_late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM
`bruno-delivery-analytics.presto_silver.silver_orders_clean`

GROUP BY
    efficiency_group,
    efficiency_order

ORDER BY
    efficiency_order;
