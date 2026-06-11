CREATE database ecommerce;
USE ecommerce;

-- Check number of rows in orders table
SELECT COUNT(*) AS order_count FROM orders;

-- Check number of rows in customers table
SELECT COUNT(*) AS customer_count FROM customers;

-- Check number of rows in order_items table
SELECT COUNT(*) AS order_items_count FROM order_items;

-- Check number of rows in order_payments table
SELECT COUNT(*) AS order_payments_count FROM order_payments;

-- Check number of rows in order_reviews table
SELECT COUNT(*) AS order_reviews_count FROM order_reviews;

-- Check number of rows in products table
SELECT COUNT(*) AS products_count FROM products;

-- Check number of rows in sellers table
SELECT COUNT(*) AS sellers_count FROM sellers;

-- Section 1: REVENUE ANALYSIS

-- 1.1 Total Overall Revenue
SELECT ROUND(SUM(payment_value), 2) AS total_revenue,
COUNT(DISTINCT order_id) AS total_orders,
ROUND(AVG(payment_value), 2) AS avg_order_value
FROM order_payments;

-- 1.2 Monthly Revenue Trend
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(op.payment_value), 2) AS total_revenue,
ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY ym;

-- 1.3 Revenue by Payment Type
SELECT payment_type,
COUNT(DISTINCT order_id) AS total_orders,
ROUND(SUM(payment_value), 2) AS total_revenue,
ROUND(AVG(payment_value), 2) AS avg_order_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- 1.4 Revenue by Product Category
SELECT p.product_category_name_english AS category,
COUNT(DISTINCT oi.order_id) AS total_orders,
ROUND(SUM(oi.price), 2) AS total_revenue,
ROUND(AVG(oi.price), 2) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- Section 2: CUSTOMER ANALYSIS

-- Total Unique Customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers,
COUNT(DISTINCT customer_id) AS total_customer_ids,
COUNT(DISTINCT customer_state) AS total_states
FROM customers;

-- Customers by State
SELECT customer_state AS state,
COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC
LIMIT 10;

-- Repeat vs One Time Customers
SELECT 
CASE 
	WHEN order_count = 1 THEN 'One Time Customer'
	WHEN order_count = 2 THEN 'Repeat Customer'
	ELSE 'Loyal Customer'
END AS customer_type,
COUNT(*) AS total_customers
FROM (SELECT c.customer_unique_id,
	COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;

-- Section 3: ORDER & FUNNEL ANALYSIS

-- 3.1 Order Status Breakdown
SELECT order_status,
COUNT(*) AS total_orders,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 3.2 Orders by Day of Week
SELECT DAYNAME(order_purchase_timestamp) AS day_of_week,
COUNT(*) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC;

-- 3.3 Orders by Hour of Day
SELECT HOUR(order_purchase_timestamp) AS hour_of_day,
COUNT(*) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 3.4 Average Time from Purchase to Delivery
SELECT 
ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
	order_purchase_timestamp)), 1) AS avg_delivery_days,
ROUND(AVG(DATEDIFF(order_estimated_delivery_date, 
	order_purchase_timestamp)), 1) AS avg_estimated_days,
ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
	order_estimated_delivery_date)), 1) AS avg_delay_days,
COUNT(CASE WHEN order_delivered_customer_date > 
	order_estimated_delivery_date 
	THEN 1 END) AS late_orders,
COUNT(*) AS total_delivered
FROM orders
WHERE order_status = 'delivered';

-- Section 4: DELIVERY & SELLER PERFORMANCE
-- 4.1 Top 10 Sellers by Revenue
SELECT oi.seller_id, s.seller_city, s.seller_state,
COUNT(DISTINCT oi.order_id)     AS total_orders,
ROUND(SUM(oi.price), 2)         AS total_revenue,
ROUND(AVG(oi.price), 2)         AS avg_price
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 4.2 Freight Cost Analysis by State
SELECT c.customer_state AS state,
ROUND(AVG(oi.freight_value), 2) AS avg_freight,
ROUND(AVG(oi.price), 2) AS avg_price,
ROUND(AVG(oi.freight_value / oi.price * 100), 2) AS freight_pct_of_price
FROM order_items oi
JOIN orders o  ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY state
ORDER BY avg_freight DESC
LIMIT 10;

-- Section 5: RFM PRE-CALCULATION
-- 5.1 RFM Base Query
-- Recency = days since last purchase
-- Frequency = number of orders
-- Monetary = total spend
SELECT c.customer_unique_id                                        AS customer_id,
DATEDIFF('2018-10-01', MAX(o.order_purchase_timestamp)) AS recency,
COUNT(DISTINCT o.order_id) AS frequency,
ROUND(SUM(op.payment_value), 2) AS monetary
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY monetary DESC;

-- Section 6: REVIEW & SATISFACTION ANALYSIS
-- 6.1 Overall Review Score Distribution
SELECT review_score,
COUNT(*) AS total_reviews,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- 6.2 Average Review Score by Product Category
SELECT p.product_category_name_english AS category,
ROUND(AVG(r.review_score), 2) AS avg_review_score,
COUNT(r.review_id) AS total_reviews
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY category
ORDER BY avg_review_score DESC
LIMIT 10;

-- 6.3 Review Score vs Delivery Performance
SELECT r.review_score,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
	o.order_purchase_timestamp)), 1) AS avg_delivery_days,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
	o.order_estimated_delivery_date)), 1) AS avg_delay_days,
COUNT(*) AS total_orders
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY r.review_score
ORDER BY r.review_score;

-- Section 7: ADVANCED SQL - CTEs & WINDOW FUNCTIONS
-- 7.1 Cumulative Revenue Growth by Month (Window Function)
-- Shows how revenue has grown cumulatively over time
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    ROUND(SUM(op.payment_value), 2) AS monthly_revenue,
    ROUND(SUM(SUM(op.payment_value)) OVER (ORDER BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
    ), 2) AS cumulative_revenue
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY ym;

-- 7.2 Top 3 Product Categories per State (CTE + Window Function)
-- Identifies which product categories are most popular in each state
WITH ranked_categories AS (SELECT c.customer_state AS state,
        p.product_category_name_english AS category,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY c.customer_state 
            ORDER BY SUM(oi.price) DESC) AS category_rank
FROM order_items oi
JOIN orders o    ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state, p.product_category_name_english)
SELECT state, category, total_orders, total_revenue, category_rank
FROM ranked_categories
WHERE category_rank <= 3
ORDER BY state, category_rank;

-- 7.3 Top 5 Customers per State by Spend (CTE + RANK)
-- Identifies highest value customers in each state
WITH customer_spend AS (SELECT c.customer_state AS state, c.customer_unique_id AS customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(op.payment_value), 2) AS total_spend,
        RANK() OVER (PARTITION BY c.customer_state ORDER BY SUM(op.payment_value) DESC)                                               AS spend_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, c.customer_unique_id)
SELECT state, customer_id, total_orders, total_spend, spend_rank
FROM customer_spend
WHERE spend_rank <= 5
ORDER BY state, spend_rank;


SELECT * FROM clv_segments LIMIT 5;