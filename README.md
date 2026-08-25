# Olist E-Commerce Analysis | Power BI

An end-to-end e-commerce data analysis project using PostgreSQL, DBeaver, Power BI, Power Query, and DAX to explore sales performance, delivery efficiency, and geographic patterns in the Brazilian Olist marketplace.

## Project Overview
This project analyzes the Brazilian Olist e-commerce dataset to evaluate sales performance, delivery efficiency, and geographic distribution.
The analysis combines SQL-based data preparation in PostgreSQL with data modeling, DAX calculations, and interactive reporting in Power BI. The final Power BI report consists of an executive overview and three focused analytical pages:

- **Executive Summary** — High-level overview of key business KPIs and trends
- **Sales & Revenue** — Sales performance, revenue trends, and product/category analysis
- **Delivery & Logistics** — Delivery efficiency, delays, and fulfillment performance
- **Geospatial Analysis** — Customer/seller distribution and geographic fulfillment patterns

## Tools and Technologies

- **PostgreSQL** — Database management, data storage, and SQL-based transformations
- **DBeaver** — SQL client used to query and manage the PostgreSQL database
- **Python (Pandas)** — Used to handle and prepare datasets that required additional processing during data import
- **Jupyter Notebook** — Environment used for Python-based data preparation and troubleshooting
- **Power BI** — Data modeling, analysis, and interactive dashboard development
- **Power Query** — Data transformation and preparation
- **DAX** — Measures, KPIs, and time-intelligence calculations

## Business Questions
The analysis was designed to answer the following business questions across four report pages.

### Executive Summary

- Is revenue growing over time?
- Are order volumes increasing?
- How satisfied are customers?
- Is delivery performance improving?
- Which regions and product categories are driving revenue?

### Sales & Revenue

- How is revenue changing over time?
- Which product categories generate the most revenue?
- Are high-revenue categories driven by higher-value purchases or greater sales volume?
- How concentrated is revenue across product categories?

### Delivery & Logistics

- How is average delivery time changing compared with the previous year?
- How efficiently and reliably are orders being fulfilled?
- How severe are delays when orders arrive late?
- How does late delivery relate to customer review scores?
- How many orders fail to result in a successful delivery?

### Geospatial Analysis

- Which Brazilian states contribute the most to revenue?
- How are customers and sellers distributed across states?
- Does the geographic distribution of Olist's seller network align with customer demand?
- What proportion of orders are fulfilled within the customer's state versus across state boundaries?
- How does cross-state fulfillment relate to delivery time, on-time performance, and delay severity?


## Data Source & Preparation

The project uses the Brazilian E-Commerce Public Dataset by Olist, which contains information about orders, customers, sellers, products, payments, reviews, and geographic locations.

### Data Ingestion

The main CSV datasets were imported into a PostgreSQL database and managed and queried through DBeaver.

The customer reviews dataset required a different ingestion approach because its text fields contained multiline content and special characters that caused issues with the standard CSV import process.

To handle this dataset, Python was used to load the CSV into a Pandas DataFrame and SQLAlchemy was used to establish a connection to PostgreSQL and write the resulting table directly to the database.

### Geolocation Data Preparation

The raw geolocation dataset contains latitude and longitude information associated with Brazilian ZIP code prefixes. However, `geolocation_zip_code_prefix` is not unique in the source data, with multiple geolocation records existing for some ZIP code prefixes.

To create a suitable lookup for geographic enrichment, a PostgreSQL view was created containing one record per ZIP code prefix.

The resulting view was then imported into Power BI and used in Power Query to enrich both the customer and seller tables with geographic attributes, including latitude and longitude.

The workflow was:

Raw Geolocation Table  
↓  
PostgreSQL View with Unique ZIP Code Prefixes  
↓  
Power BI / Power Query  
↓  
Merge with Customers and Sellers  
↓  
Latitude & Longitude added to Customer and Seller tables

After the required geographic attributes were merged into the customer and seller tables, load was disabled for the intermediate geolocation query because it was no longer required as a separate table in the Power BI data model.

### Product Category Preparation

Product categories were standardized before analysis. Portuguese category names were mapped to their English equivalents using the provided category translation table. Missing category values were labeled as **"Not Specified"**.












