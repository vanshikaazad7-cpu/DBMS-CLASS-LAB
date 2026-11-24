-- 1. Setup & Data Generation (10,000 rows)
CREATE TABLE Sales_Data (
    txn_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    amount DECIMAL(10,2),
    category VARCHAR(50),
    txn_date DATE
);

INSERT INTO Sales_Data (customer_id, amount, category, txn_date)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 10000
)
SELECT
    (n % 100) + 1,
    RAND() * 1000,
    CASE WHEN n%3=0 THEN 'Electronics' WHEN n%3=1 THEN 'Clothing' ELSE 'Groceries'
END,
    DATE_ADD('2023-01-01', INTERVAL (n % 365) DAY)
FROM cte;

-- Add basic index for later testing
CREATE INDEX idx_cust ON Sales_Data(customer_id);
CREATE INDEX idx_cat ON Sales_Data(category);
CREATE INDEX idx_date ON Sales_Data(txn_date);

-- ==========================================================
-- SLOW QUERY 1: Leading Wildcard
-- ==========================================================
EXPLAIN SELECT * FROM Sales_Data WHERE category LIKE '%tronics%';
-- OPTIMIZATION: Avoid leading wildcard, use exact prefix if possible.
EXPLAIN SELECT * FROM Sales_Data WHERE category LIKE 'Electro%';

-- ==========================================================
-- SLOW QUERY 2: Subquery with IN
-- ==========================================================
EXPLAIN SELECT * FROM Sales_Data
WHERE customer_id IN (SELECT customer_id FROM Sales_Data WHERE amount > 900);
-- OPTIMIZATION: Use INNER JOIN
EXPLAIN SELECT s1.* FROM Sales_Data s1
INNER JOIN (SELECT customer_id FROM Sales_Data WHERE amount > 900) s2
ON s1.customer_id = s2.customer_id;

-- ==========================================================
-- SLOW QUERY 3: Function on Indexed Column
-- ==========================================================
-- (Bypasses the idx_date index because of the YEAR() function)
EXPLAIN SELECT * FROM Sales_Data WHERE YEAR(txn_date) = 2023;
-- OPTIMIZATION: Rewrite to range query to utilize idx_date
EXPLAIN SELECT * FROM Sales_Data
WHERE txn_date >= '2023-01-01' AND txn_date <= '2023-12-31';

-- ==========================================================
-- SLOW QUERY 4: OR condition on different columns
-- ==========================================================
EXPLAIN SELECT * FROM Sales_Data WHERE category = 'Clothing' OR customer_id = 50;
-- OPTIMIZATION: Use UNION to utilize both idx_cat and idx_cust individually
EXPLAIN
SELECT * FROM Sales_Data WHERE category = 'Clothing'
UNION ALL
SELECT * FROM Sales_Data WHERE customer_id = 50 AND category != 'Clothing';

-- ==========================================================
-- SLOW QUERY 5: Unindexed Grouping and Sorting
-- ==========================================================
EXPLAIN SELECT category, SUM(amount) FROM Sales_Data GROUP BY category ORDER BY
SUM(amount) DESC;
-- OPTIMIZATION: Create an index covering category and amount.
CREATE INDEX idx_cat_amt ON Sales_Data(category, amount);
-- Re-run EXPLAIN to see removal of 'Using temporary; Using filesort' (depending
-- on RDBMS engine optimizations).
EXPLAIN SELECT category, SUM(amount) FROM Sales_Data GROUP BY category ORDER BY
SUM(amount) DESC;