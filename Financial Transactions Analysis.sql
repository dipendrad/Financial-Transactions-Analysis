-- Step 1: Create Database
CREATE DATABASE financial_data;

-- Step 2: Use the new Database
USE financial_data;

-- Step 3: Create Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    datetime DATETIME,
    amount DECIMAL(10, 2),
    account_id INT,
    transaction_type VARCHAR(50),
    category VARCHAR(50),
    transaction_platform VARCHAR(50)
);


LOAD DATA LOCAL INFILE 'C:\New folder\fin.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transaction_id, datetime, amount, account_id, transaction_type, category, transaction_platform);

-- Total number of transactions
SELECT COUNT(*) AS total_transactions FROM transactions;

-- Total credit and debit amounts
SELECT 
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_credits,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_debits
FROM transactions;

-- Number of transactions per category
SELECT category, COUNT(*) AS num_transactions
FROM transactions
GROUP BY category;

-- Number of transactions per platform
SELECT transaction_platform, COUNT(*) AS num_transactions
FROM transactions
GROUP BY transaction_platform;

-- Total transactions per month
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    COUNT(*) AS num_transactions, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- Average transaction amount per month
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- Transactions by category and platform
SELECT 
    category, 
    transaction_platform, 
    COUNT(*) AS num_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY category, transaction_platform
ORDER BY category, transaction_platform;


-- Monthly trends by transaction type
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    transaction_type, 
    COUNT(*) AS num_transactions, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY month, transaction_type
ORDER BY month, transaction_type;

-- Transaction patterns for each category
SELECT 
    category, 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    COUNT(*) AS num_transactions, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY category, month
ORDER BY category, month;

-- Average transaction amount by platform
SELECT 
    transaction_platform, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY transaction_platform
ORDER BY avg_amount DESC;

-- Transaction volume heatmap
SELECT 
    DATE_FORMAT(datetime, '%Y-%m-%d') AS day, 
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY day
ORDER BY day;

-- Transaction value heatmap
SELECT 
    DATE_FORMAT(datetime, '%Y-%m-%d') AS day, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY day
ORDER BY day;





