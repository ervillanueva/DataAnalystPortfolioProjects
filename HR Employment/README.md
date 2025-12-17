# HR Analytics Dashboard

This project presents an end-to-end HR analytics workflow using SQL for data cleaning and Power BI for visualization. It analyzes over 22,000 employee records from 2000 to 2020, revealing trends in demographics, tenure, hiring, turnover, and departmental structure.

---

## Table of Contents

1. [Overview](#overview)  
2. [Data Sources and Tools](#data-sources-and-tools)  
3. [Key Questions Answered](#key-questions-answered)  
4. [Visual Overview](#visual-overview)  
5. [Technical Workflow Summary](#technical-workflow-summary)  
6. [Files Included](#files-included)

---

## Overview

- Total records: 22,000+ employee entries  
- Time span: 2000–2020  
- Data types: demographics, job roles, departments, locations, hire dates, termination dates  

The dashboard provides insights into workforce changes, demographic representation, hiring and termination trends, and overall employment structure.

A reference copy of the dashboard is included in this repository as a PDF export from Power BI.

---

## Data Sources and Tools

### Data

- HR dataset containing 22,000+ rows covering 20 years of employee activity.

### Data Cleaning and Preparation

- Tool: MySQL Workbench  
- Main steps:
  - Standardized inconsistent date formats.  
  - Normalized categorical values (e.g., gender, race, department names).  
  - Created calculated fields for age, age groups, tenure, and termination metrics.  
  - Removed incomplete or invalid records.  

### Data Visualization

- Tool: Power BI Desktop  
- Visual elements:
  - Line charts to show change in employee count over time.  
  - Clustered and stacked bar charts for demographic and departmental comparisons.  
  - Tables summarizing turnover rates by department.  
  - Maps or bar charts for geographic employee distribution.  

---

## Key Questions Answered

### Employee Demographics

1. What is the gender breakdown of employees in the company?  
2. What is the race/ethnicity breakdown of employees in the company?  
3. What is the age distribution of employees in the company?

### Employment Structure and Location

4. How many employees work at headquarters versus remote locations?  
5. What is the distribution of employees across U.S. states?

### Tenure, Hiring, and Termination

6. What is the average length of employment for employees who have been terminated?  
7. How has the company's employee count changed over time based on hire and term dates?  
8. What is the tenure distribution for each department?

### Organizational and Departmental Trends

9. How does the gender distribution vary across departments and job titles?  
10. What is the distribution of job titles across the company?  
11. Which department has the highest turnover rate?

---

## Visual Overview

The Power BI report includes the following key visuals:

- Gender distribution.  
- Race and ethnicity distribution.  
- Age group distribution.  
- Age distribution by gender.  
- Headquarters vs. remote employment split.  
- Employee count change from 2000–2020.  
- State-level employee distribution.  
- Termination rate by department.  
- Gender distribution by department.  

These visuals work together to provide a high-level and detailed view of the company’s workforce composition and trends.

---

## Technical Workflow Summary

1. Imported the raw HR dataset into MySQL.  
2. Cleaned and standardized demographic and employment fields.  
3. Wrote SQL queries to:
   - Calculate age and group employees into age brackets.  
   - Calculate tenure based on hire and termination dates.  
   - Aggregate data by department, job title, race, gender, and state.  
4. Exported cleaned and aggregated data from MySQL.  
5. Loaded the processed dataset into Power BI Desktop.  
6. Built interactive visuals and filters to explore the data.  
7. Published the final HR dashboard for presentation and analysis.
