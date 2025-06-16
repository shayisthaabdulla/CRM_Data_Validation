# CRM Data Validation (SQL Project)

## Project Overview

**Project Title**: CRM Data Validation
**Level**: Beginner  
**Database**: `CRM_Data_Validation`

This project simulates a CRM (Customer Relationship Management) system inspired by Dynamics 365, designed to showcase SQL skills commonly used by Business Analysts. It focuses on data validation, cleaning, and insight generation from core CRM entities. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a CRM database**: Create and populate a CRM database with sample data for leads, accounts, and orders.
2. **Data Cleaning**: Identify and handle missing values, nulls, duplicates, and mismatched relationships.
3. **Exploratory Data Analysis (EDA)**: Use SQL to explore trends in lead sources, account activity, and order performance.
4. **Business Insights**:  Answer real-world business questions related to lead conversion, inactive accounts, and revenue trends.
   
## Project Structure

### 1. Database Setup

- **Database Creation**: The project begins by setting up a PostgreSQL environment with a database named 'crm_data_validation' that mimics a basic CRM system.
- **Table Creation**: Three core tables are created to simulate lead generation, account management, and order tracking within a CRM platform:
- **crm_leads**: Stores initial lead information, including name, contact details, source, status, and created date.
- **crm_accounts**: Represents customer accounts converted from leads, capturing industry, activity status, and account creation date.
- **crm_orders**: Tracks orders placed by accounts, storing order status, value, and creation date.
- **Sample Data Insertion**: Each table is populated with realistic sample data, including intentional anomalies (e.g., null values, missing links) to reflect common CRM data issues.

```sql
CREATE DATABASE crm_data_validation;

CREATE TABLE crm_leads (
    lead_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    source VARCHAR(50),
    status VARCHAR(20),
    created_date DATE
);

INSERT INTO crm_leads (first_name, last_name, email, phone, source, status, created_date) VALUES
('Aisha', 'Khan', 'aisha.khan@example.com', '123-456-7890', 'Web Form', 'New', '2024-10-01'),
('John', 'Doe', 'john.doe@example.com', NULL, 'Referral', 'Contacted', '2024-10-05'),
('Fatima', 'Ali', '', '321-654-0987', 'Campaign', 'Qualified', '2024-10-10'),
('Raj', 'Patel', 'raj.patel@example.com', '999-999-9999', 'Web Form', NULL, '2024-10-15');

CREATE TABLE crm_accounts (
    account_id SERIAL PRIMARY KEY,
    lead_id INT,
    account_name VARCHAR(100),
    industry VARCHAR(50),
    is_active BOOLEAN,
    account_created DATE
);

INSERT INTO crm_accounts (lead_id, account_name, industry, is_active, account_created) VALUES
(1, 'Khan Tech', 'IT Services', TRUE, '2024-10-20'),
(2, 'Doe Logistics', 'Transportation', FALSE, '2024-10-22'),
(4, 'Patel Media', NULL, TRUE, '2024-10-25');


CREATE TABLE crm_orders (
    order_id SERIAL PRIMARY KEY,
    account_id INT,
    order_status VARCHAR(30),
    order_value DECIMAL(10,2),
    created_on DATE
);


INSERT INTO crm_orders (account_id, order_status, order_value, created_on) 
VALUES
(1, 'Pending', 1200.00, '2024-11-01'),
(1, 'Completed', 800.00, '2024-11-15'),
(2, 'Cancelled', NULL, '2024-11-20'),
(3, NULL, 1500.00, '2024-11-25');
```

### 2. Data Cleaning & Validation Queries: This section outlines the key SQL queries used to validate and clean data across the CRM system to ensure reliability and consistency.

- **Lead Completeness Check**: Identify leads with missing email, phone number, or status to flag incomplete records.
- **Account-Link Consistency**: Detect crm_accounts entries linked to nonexistent lead_ids in the crm_leads table to ensure foreign key integrity.
- **Industry Missing Check**: Flag customer accounts where the industry field is not recorded.
- **Null Order Value Check**: Detect orders in crm_orders with a NULL order value for financial completeness.
- **Missing Order Status Check**: Identify orders missing a valid order_status value.
- **Orphan Accounts Check**: Find accounts in crm_accounts that have no associated orders, indicating low activity or potential data issues.
- **Unlinked Leads Check**: Identify leads from crm_leads that have not been converted into accounts.
- **Duplicate Lead Detection**: Search for duplicate email addresses in the leads table to avoid contact redundancies.
  
```sql
1. Write a SQL query to find leads with missing email or phone:

SELECT *
FROM crm_leads
WHERE email IS NULL OR email=''
OR phone IS NULL OR phone='';

2. Write a SQL query to find leads with missing or null status:

SELECT *
FROM crm_leads
WHERE status IS NULL OR status='';

3. Write a SQL query to check if all leads in crm_accounts exist in crm_leads:

SELECT a.lead_id
FROM crm_accounts AS a
LEFT JOIN crm_leads as l 
ON a.lead_id =l.lead_id
WHERE l.lead_id IS NULL;

4. Write a SQL query to find accounts missing industry info:

SELECT *
FROM crm_accounts
WHERE industry IS NULL or industry='';

5. Write a SQL query to detect orders with NULL order value:

SELECT *
FROM crm_orders
WHERE order_value IS NULL;

6. Write a SQL query to find orders with missing status:

SELECT * 
FROM crm_orders
WHERE order_status IS NULL OR order_status = '';

7. Write a SQL query to check for accounts without orders:

SELECT a.account_id,a.account_name
FROM crm_accounts as a
LEFT JOIN crm_orders as o
ON a.account_id=o.account_id
WHERE o.account_id IS NULL;

8. Write a SQL query to check for leads without accounts:

SELECT l.lead_id,l.first_name, l.last_name
FROM crm_leads AS l
LEFT JOIN crm_accounts AS a
ON l.lead_id=a.lead_id
WHERE a.lead_id IS NULL;


9. Write a SQL query to validate duplicate emails in leads:

SELECT email, COUNT(*)
FROM crm_leads
WHERE email IS NOT NULL AND email != ''
GROUP BY email
HAVING COUNT(*) > 1;

```

### 3. Data Exploration Queries

The following SQL queries were developed to answer specific business questions:

```sql

1. Write a SQL query to count leads per source:

SELECT source, COUNT (*) as lead_count
FROM crm_leads
GROUP BY source;

2. Write a SQL query to find the number of leads per status:

SELECT status, COUNT (*) as status_count
FROM crm_leads
GROUP BY status;

3. Write a SQL query to find active vs inactive account breakdown:

SELECT is_active, COUNT (*) 
FROM crm_accounts
GROUP BY is_active;

4. Write a SQL query to find the total order value per account:

SELECT a.account_name, SUM (o.order_value) AS total_order_value
FROM crm_accounts AS a 
JOIN crm_orders AS o
ON a.account_id=o.account_id
GROUP BY a.account_name;

5. Write a SQL query to find the Leads converted to accounts with at least one order--

SELECT DISTINCT l.lead_id, l.first_name, l.last_name
FROM crm_leads AS l
JOIN crm_accounts AS a 
ON l.lead_id = a.lead_id
JOIN crm_orders AS o 
ON a.account_id = o.account_id;


6. Write a SQL query to find the average order value by status where the order status or order value is not null:

SELECT order_status, AVG(order_value) AS avg_order_value
FROM crm_orders
WHERE order_value IS NOT NULL AND order_status IS NOT NULL
GROUP BY order_status;

```

## Findings

- **Incomplete Lead Records**: Some leads are missing key information such as email, phone number, or status, which can hinder effective follow-ups.
- **Missing Industry and Order Details**: Certain accounts lack industry data, and some orders are missing values or statuses, pointing to potential data entry issues.
- **Unlinked CRM Entities**: A few leads haven't been converted to accounts, and some accounts have no related orders, revealing breaks in the sales funnel.
- **Lead Source & Status Distribution**: Most leads came from web forms, and the highest volume of leads are in the "Qualified" or "Contacted" status.
- **Account Engagement Patterns**: Active accounts tend to have higher order activity, while inactive ones either lack engagement or require review for reactivation.

## Reports

- **Lead Quality Report**: Summary of leads with missing contact details or status to flag incomplete or low-quality entries.
- **Account Coverage Report**: Insights into how many leads were successfully converted into accounts and how many accounts are orphaned without orders.
- **Order Summary Report**: Overview of total and average order values per account and per order status (e.g., Pending, Completed).
- **Activity Breakdown**: Breakdown of active vs. inactive accounts and their associated sales activity, helping identify engagement gaps.
- **Conversion Funnel**: Visualization of lead-to-account-to-order conversion path, highlighting potential drop-off points or CRM inefficiencies.

## Conclusion

This project demonstrates how SQL can be used effectively to:

- Validate CRM data by identifying inconsistencies, null values, and relational mismatches.
- Perform exploratory queries to extract business insights such as lead conversion trends and customer engagement.
- Highlight critical areas for data quality improvement — a key requirement for accurate reporting, automation, and CRM optimization.

These capabilities are vital for business analysts working with customer databases in CRM platforms like Dynamics 365, Salesforce, or HubSpot.


## Author - Shayistha

This project is part of my business analyst portfolio and highlights my hands-on experience with SQL for CRM data validation and reporting. It reflects key skills in data quality analysis, troubleshooting relational inconsistencies, and extracting business insights using PostgreSQL.
Feel free to reach out if you'd like to collaborate or provide feedback!
https://www.linkedin.com/in/shayisthaa/

Thank you for your support, and I look forward to connecting with you!

