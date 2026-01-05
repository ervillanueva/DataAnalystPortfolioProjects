# Florida Shop Sales Analysis

## Table of Contents
- [Overview](#overview)
- [Data Sources and Tools](#data-sources-and-tools)
- [Key Questions Answered](#key-questions-answered)
- [Visual Overview](#visual-overview)
- [Business Impact](#business-impact)
- [Technical Workflow Summary](#technical-workflow-summary)
- [Files Included](#files-included)

---

## Overview
This project analyzes two years of retail sales and customer survey data for a Florida-based shop.  
The objective is to identify trends in revenue, customer behavior, discount effectiveness, and product performance, and to communicate insights through an interactive Power BI dashboard.

The project simulates a real-world data analyst workflow by combining SQL-based data preparation with business intelligence visualization.

---

## Data Sources and Tools

### Data Sources
- **sales_2yrs.csv**  
  Transaction-level sales data including products, pricing, discounts, units sold, and dates.

- **survey_2yrs.csv**  
  Customer survey data capturing customer type, demographics, and feedback attributes.

- **weather_2yrs.csv**
  Weather data recording the humidity percentage, average temperature in fareinheit 

### Tools Used
- **DataGrip** – SQL querying, joins, and data preparation  
- **SQL Database (MySQL / SQL Server)** – Data storage and transformation  
- **Power BI** – Data modeling, visualization, and dashboard development  

---

## Key Questions Answered
- How strongy does temperature and rainfall affect daily sales?
- Which shop performs best and why?
- Who are our customers - family vs single, male vs female, and how does that change over time?
- Are there predictable seasonal patterns in sales?

---

## Visual Overview
The Power BI dashboard includes:
- Revenue trends by month and year
- Number of customers
- Total sales
- Customer type distribution
- Interactive filters for date, product, and customer segment
- Average sales per customer by shop

These visuals allow stakeholders to explore the data dynamically and quickly identify key business drivers.

---

## Business Impact
This analysis converts raw transactional and survey data into actionable business insights that support data-driven decision making.

Key business value delivered includes:
- **Revenue optimization:** Evaluated how discounts affect revenue to inform promotional strategies.
- **Product performance insights:** Identified top-performing shops to support inventory and merchandising decisions.
- **Customer segmentation:** Analyzed purchasing behavior by customer type to guide targeted marketing efforts.
- **Seasonality awareness:** Revealed time-based sales patterns useful for forecasting and planning.
- **Executive-ready reporting:** Delivered insights through an interactive Power BI dashboard designed for non-technical users.

---

## Technical Workflow Summary
1. **Data Ingestion**
   - Imported raw CSV files into a SQL database.

2. **Data Preparation (DataGrip)**
   - Cleaned and joined sales and survey datasets.
   - Created calculated fields for revenue and discount-adjusted revenue.
   - Extracted date-based features (month and year).

3. **Data Modeling (Power BI)**
   - Imported SQL query results.
   - Defined relationships and field categorization.
   - Optimized data types for analysis and visualization.

4. **Visualization**
   - Built interactive charts, tables, and slicers.
   - Designed a clean, business-focused dashboard layout.

---

## Files Included
- **Florida Shop Sales.pbix** – Power BI dashboard file  
- **sales_2yrs.csv** – Two years of sales transaction data  
- **survey_2yrs.csv** – Two years of customer survey data
- **weather_2yrs.csv** - Two years of weather data
- **README.md** – Project documentation  
