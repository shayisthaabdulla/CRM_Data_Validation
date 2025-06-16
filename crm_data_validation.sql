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

-- 1. Data Cleaning & Valudation Queries--

-- Find leads with missing email or phone--

select *
from crm_leads

select *
from crm_accounts

select *
from crm_orders

SELECT *
FROM crm_leads
WHERE email IS NULL OR email=''
OR phone IS NULL OR phone='';

--Find leads with missing or null status---

SELECT *
FROM crm_leads
WHERE status IS NULL OR status='';

--Check if all leads in crm_accounts exist in crm_leads---

SELECT a.lead_id
FROM crm_accounts AS a
LEFT JOIN crm_leads as l 
ON a.lead_id =l.lead_id
WHERE l.lead_id IS NULL;

--Find accounts missing industry info---

SELECT *
FROM crm_accounts
WHERE industry IS NULL or industry='';

--Detect orders with NULL order value--

SELECT *
FROM crm_orders
WHERE order_value IS NULL;

--Find orders with missing status--

SELECT * 
FROM crm_orders
WHERE order_status IS NULL OR order_status = '';

--Check for accounts without orders--

SELECT a.account_id,a.account_name
FROM crm_accounts as a
LEFT JOIN crm_orders as o
ON a.account_id=o.account_id
WHERE o.account_id IS NULL;

-- Check for leads without accounts--

SELECT l.lead_id,l.first_name, l.last_name
FROM crm_leads AS l
LEFT JOIN crm_accounts AS a
ON l.lead_id=a.lead_id
WHERE a.lead_id IS NULL;


--Validate duplicate emails in leads---
SELECT email, COUNT(*)
FROM crm_leads
WHERE email IS NOT NULL AND email != ''
GROUP BY email
HAVING COUNT(*) > 1;

--2. DATA EXPLORATION QUERIES--

-- count of leads per source--

SELECT source, COUNT (*) as lead_count
FROM crm_leads
GROUP BY source;

--Number of leads per status--

SELECT status, COUNT (*) as status_count
FROM crm_leads
GROUP BY status;

--Active vs inactive account breakdown--

SELECT is_active, COUNT (*) 
FROM crm_accounts
GROUP BY is_active;


SELECT *
FROM crm_orders

--Total order value per account---

SELECT a.account_name, SUM (o.order_value) AS total_order_value
FROM crm_accounts AS a 
JOIN crm_orders AS o
ON a.account_id=o.account_id
GROUP BY a.account_name;

--Leads converted to accounts with at least one order--

SELECT DISTINCT l.lead_id, l.first_name, l.last_name
FROM crm_leads AS l
JOIN crm_accounts AS a 
ON l.lead_id = a.lead_id
JOIN crm_orders AS o 
ON a.account_id = o.account_id;


--Average order value by status where the order status or order value is not null--

SELECT order_status, AVG(order_value) AS avg_order_value
FROM crm_orders
WHERE order_value IS NOT NULL AND order_status IS NOT NULL
GROUP BY order_status;





