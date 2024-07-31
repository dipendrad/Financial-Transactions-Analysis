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


-- Daily Transaction Averages
SELECT 
    DATE_FORMAT(datetime, '%Y-%m-%d') AS day, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY day
ORDER BY day;

-- Peak Transaction Hours
SELECT 
    HOUR(datetime) AS hour, 
    COUNT(*) AS num_transactions, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY hour
ORDER BY num_transactions DESC, total_amount DESC;

-- Largest Transactions
SELECT 
    * 
FROM transactions
ORDER BY ABS(amount) DESC
LIMIT 10;

-- Smallest Transactions
SELECT 
    * 
FROM transactions
ORDER BY ABS(amount)
LIMIT 10;

-- Monthly Transaction Averages
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- Average Transaction Amount by Category
SELECT 
    category, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY category
ORDER BY avg_amount DESC;

-- Transaction Distribution by Amount Range
SELECT 
    CASE
        WHEN amount < 100 THEN 'Below 100'
        WHEN amount BETWEEN 100 AND 499.99 THEN '100-499.99'
        WHEN amount BETWEEN 500 AND 999.99 THEN '500-999.99'
        ELSE '1000 and above'
    END AS amount_range,
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY amount_range
ORDER BY amount_range;

-- Transaction Count by Weekday
SELECT 
    DAYNAME(datetime) AS weekday, 
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY weekday
ORDER BY FIELD(weekday, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- Total Transaction Amount by Weekday
SELECT 
    DAYNAME(datetime) AS weekday, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY weekday
ORDER BY FIELD(weekday, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- Average Transaction Amount by Weekday
SELECT 
    DAYNAME(datetime) AS weekday, 
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY weekday
ORDER BY FIELD(weekday, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- Transactions by Account ID
SELECT 
    account_id, 
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY account_id
ORDER BY num_transactions DESC;

-- Total Amount by Account ID
SELECT 
    account_id, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id
ORDER BY total_amount DESC;

-- Transactions by Date and Time
SELECT 
    DATE_FORMAT(datetime, '%Y-%m-%d %H:%i:%s') AS transaction_datetime, 
    COUNT(*) AS num_transactions, 
    SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_datetime
ORDER BY transaction_datetime;

-- Summary Statistics
SELECT 
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount,
    SUM(amount) AS total_amount,
    COUNT(*) AS num_transactions
FROM transactions;

-- Month-over-Month Growth Rate
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS month, 
    SUM(amount) AS total_amount,
    LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(datetime, '%Y-%m')) AS previous_month_amount,
    (SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(datetime, '%Y-%m'))) / LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(datetime, '%Y-%m')) * 100 AS month_over_month_growth
FROM transactions
GROUP BY month
ORDER BY month;




