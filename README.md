🛍️ E-Commerce Sales & Customer Analytics (Olist)

📊 Project Overview
This project analyses e-commerce marketplace data to explore revenue trends, customer behaviour, delivery performance, seller performance, and geographic patterns.

Using Python for data cleaning, feature engineering and exploratory analysis, MySQL for structured KPI analysis (CTEs, window functions, RFM/CLV computation), and Power BI for interactive visualisation, the project transforms raw multi-table order data into meaningful business insights.

The analysis enables exploration of revenue drivers, customer segments (RFM & CLV), cohort growth, seller quality, and regional performance — supporting data-driven decisions for a growing online marketplace.

🎯 Business Problem
Marketplace businesses generate large volumes of transactional data spread across orders, payments, products, sellers, reviews and customers — but this data is fragmented and hard to interpret on its own. Businesses need to understand who their most valuable customers are, which sellers and categories drive revenue, how delivery performance affects satisfaction, and where geographic or operational bottlenecks exist.

This project addresses that challenge by building an end-to-end analytics pipeline — from raw multi-table data to cleaned datasets, a relational database, and a Power BI dashboard — that surfaces revenue, retention, delivery, and seller insights in one place.

🗂 Dataset
The dataset is the Olist Brazilian E-Commerce Public Dataset, containing orders, customers, products, sellers, payments, reviews and geolocation data across ~93,000 unique customers and 2 years of transaction history.

📄 Dataset Files: olist_customers_dataset.csv, olist_orders_dataset.csv, olist_order_items_dataset.csv, olist_order_payments_dataset.csv, olist_order_reviews_dataset.csv, olist_products_dataset.csv, olist_sellers_dataset.csv, olist_geolocation_dataset.csv, product_category_name_translation.csv

Key Features
Customer: unique customer ID, city, state
Order: purchase/approval/delivery timestamps, order status, estimated vs actual delivery
Order Items: price, freight value, product, seller
Payments: payment type, installments, payment value
Reviews: review score, comment, response timing
Products: category (English-translated), dimensions, weight
Engineered Features: delivery days (actual/estimated/delay), total item value, freight %, RFM scores & segments, CLV & spend tier, cohort month

🛠 Tools & Technologies
Python — Data cleaning, feature engineering, EDA, RFM/CLV analysis
MySQL — Relational storage, KPI queries using CTEs and window functions
Power BI — Interactive dashboard for revenue, customer, seller and geo insights
Jupyter Notebook — Code development and analysis environment
GitHub — Project documentation and portfolio showcase

🔎 Python Analysis
Data preprocessing, feature engineering and exploratory analysis were performed in Python before loading cleaned data into MySQL.

📄 Notebook: E-Commerce.ipynb

Analysis Included
Data cleaning and preprocessing (date parsing, missing value handling, text standardisation)
Feature engineering: delivery day calculations, total item value, freight percentage, date part extraction
Exploratory data analysis with visualisations (orders over time, revenue trends, category performance, payment types, review scores, order timing, delivery performance, AOV, freight vs price, instalments)
RFM scoring and customer segmentation
Cohort analysis — monthly new-customer acquisition and cumulative growth
Customer Lifetime Value (CLV) segmentation
Seller performance analysis
Geolocation / state-level analysis

🗄 SQL Analysis
KPI queries covering revenue, customer, order/funnel, delivery, seller, review and advanced (CTE + window function) analysis were written in MySQL.

📄 SQL File: E-Commerce.sql

Query Sections
Revenue Analysis — total, monthly trend, by payment type, by category
Customer Analysis — unique customers, by state, repeat vs one-time
Order & Funnel Analysis — status breakdown, day/hour patterns, purchase-to-delivery time
Delivery & Seller Performance — top sellers by revenue, freight cost by state
RFM Pre-Calculation — recency, frequency, monetary base query
Review & Satisfaction Analysis — score distribution, by category, vs delivery performance
Advanced SQL — cumulative revenue (window functions), top categories per state, top customers per state (CTEs + RANK/ROW_NUMBER)

📈 Dashboard Features
📄 Power BI File: E-Commerce.pbix

Visual Analysis
Revenue trend over time
Revenue by category, payment type and state
RFM segment distribution and customer value
CLV segment breakdown and revenue contribution
Cohort growth — cumulative customers over time
Seller performance — top sellers by revenue and review score
Delivery performance — actual vs estimated delivery, delay analysis
Geographic breakdown — revenue, customers and freight by state

💡 Key Insights
- Orders grew consistently from 2016, peaking in November 2017 (Black Friday effect), with 93,358 unique customers acquired over 2 years
- Retention is the biggest challenge — 97% of customers purchased only once, and only 995 of 93,357 customers (1%) qualify as Champions
- 14,585 customers sit in a "Cannot Lose Them" segment — high past spend but gone cold; Premium customers (1,149) contribute 11.8% of revenue
- Credit card is the dominant payment method, with an average of 2.9 installments — higher installment counts correlate with higher spend
- Delivery performance is strong — average actual delivery is 12 days vs. 23 days estimated, with most orders arriving early
- Revenue is heavily concentrated in top product categories, with a long tail of low performers
- The top seller generated R$225,586 in revenue; average seller review score is 4.15/5, though some sellers show delivery outliers as high as 190 days
- São Paulo accounts for the majority of orders and revenue; remote states face higher freight costs and longer delivery times
- Average freight cost is R$20 (~15% of order value), disproportionately higher in remote states

🖼 Dashboard Preview
*(Add Power BI screenshots here, e.g. Overview, Customer Segmentation, Seller & Delivery Performance, Geographic Analysis)*

📚 Data Source & License
The dataset used in this project is the Olist Brazilian E-Commerce Public Dataset, available on Kaggle.


This project is created for educational and portfolio purposes only.

