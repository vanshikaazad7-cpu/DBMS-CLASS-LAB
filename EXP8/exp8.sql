-- 1. Setup
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    balance DECIMAL(10,2) CHECK (balance >= 0)
);

INSERT INTO Accounts VALUES (101, 'Alice', 5000.00);
INSERT INTO Accounts VALUES (102, 'Bob', 3000.00);
INSERT INTO Accounts VALUES (103, 'Charlie', 2000.00);

-- 2. Transaction with Savepoint and Rollback
START TRANSACTION;

-- Deduct 1000 from Alice
UPDATE Accounts SET balance = balance - 1000 WHERE account_id = 101;

-- Set a savepoint
SAVEPOINT SP1;

-- Attempt to credit an invalid account (simulating failure)
UPDATE Accounts SET balance = balance + 1000 WHERE account_id = 999;

-- Realize the mistake, rollback to savepoint
ROLLBACK TO SP1;

-- Correctly credit Bob instead
UPDATE Accounts SET balance = balance + 1000 WHERE account_id = 102;

-- Commit the transaction
COMMIT;

-- Verify final state
SELECT * FROM Accounts;
-- SESSION 1
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Accounts SET balance = balance - 2000 WHERE account_id = 101;
-- Do NOT commit yet.

-- SESSION 2 (In a new window)
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- This will read the updated balance of Alice (3000 - 2000 = 1000) even though
-- Session 1 hasn't committed. (DIRTY READ)
SELECT balance FROM Accounts WHERE account_id = 101;

-- SESSION 1
ROLLBACK; -- Session 1 cancels the transaction

-- SESSION 2
-- This will read the original balance of Alice (3000) because Session 1 rolled
-- back.
SELECT balance FROM Accounts WHERE account_id = 101;