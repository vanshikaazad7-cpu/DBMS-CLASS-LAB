-- 1. Create Table
CREATE TABLE Railway_Booking (
    pnr BIGINT PRIMARY KEY,
    train_no INT,
    passenger_name VARCHAR(50),
    journey_date DATE,
    source VARCHAR(50),
    destination VARCHAR(50),
    status VARCHAR(20)
);

-- 2. Insert 5000 records (MySQL 8.0+ syntax using Recursive CTE)
INSERT INTO Railway_Booking (pnr, train_no, passenger_name, journey_date, source,
destination, status)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 5000
)
SELECT
    1000000000 + n,
    12000 + (n % 50), -- Generates 50 different train numbers
    CONCAT('Passenger_', n),
    DATE_ADD('2024-01-01', INTERVAL (n % 30) DAY), -- Spreads across 30 days
    'Station_A',
    'Station_B',
    IF(n % 5 = 0, 'WL', 'CNF')
FROM cte;

-- 3. Benchmark Before Index (Analyze Execution Plan)
EXPLAIN SELECT * FROM Railway_Booking
WHERE train_no = 12015 AND journey_date = '2024-01-16';

-- 4. Create Single Index
CREATE INDEX idx_train ON Railway_Booking(train_no);

-- Benchmark After Single Index
EXPLAIN SELECT * FROM Railway_Booking
WHERE train_no = 12015 AND journey_date = '2024-01-16';

-- 5. Create Composite Index
CREATE INDEX idx_train_date ON Railway_Booking(train_no, journey_date);

-- Benchmark After Composite Index
EXPLAIN SELECT * FROM Railway_Booking
WHERE train_no = 12015 AND journey_date = '2024-01-16';
