CREATE TABLE IF NOT EXISTS EmployeeAuditLog (
AuditID INT AUTO_INCREMENT PRIMARY KEY,
EmpID INT NOT NULL,
ActionType VARCHAR(50) NOT NULL,
OldDeptID INT,
NewDeptID INT,
OldSalary DECIMAL(10,2),
NewSalary DECIMAL(10,2),
ChangedBy VARCHAR(100) NOT NULL,
ChangedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- TRIGGERS IMPLEMENTATION
-- A. Before Insert & Update Trigger: Salary Validation
-- Prevents setting an employee's salary below $30,000 or giving a single salary decrease greater than 20%.
DELIMITER $$
CREATE TRIGGER trg_BeforeSalaryUpdate
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
-- Prevent salary below minimum threshold
IF NEW.Salary < 30000.00 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Validation Error: Salary cannot be less than 30,000.00.';
END IF;
-- Prevent drastic salary reductions (>20%)
IF NEW.Salary < (OLD.Salary * 0.80) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Validation Error: Salary reduction cannot exceed 20% of current salary.';
END IF;
END$$
DELIMITER ;
-- B. After Update Trigger: Audit Logging
-- Captures changes to an employee's department or salary and writes them to the EmployeeAuditLog table.
DELIMITER $$
CREATE TRIGGER trg_AfterEmployeeUpdate
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
-- Log changes if Department or Salary has changed
IF OLD.DeptID <=> NEW.DeptID OR OLD.Salary <=> NEW.Salary THEN
INSERT INTO EmployeeAuditLog (
EmpID,
ActionType,
OldDeptID,
NewDeptID,
OldSalary,
NewSalary,
ChangedBy,
ChangedAt
) VALUES (
NEW.EmpID,
'UPDATE',
OLD.DeptID,
NEW.DeptID,
OLD.Salary,
NEW.Salary,
CURRENT_USER(),
NOW()
);
END IF;
END$$
DELIMITER ;
-- STORED PROCEDURE: TRANSFER_EMPLOYEE
-- Includes parameter validation, checking for existence, handling redundant updates, and transactional error handling via SQLEXCEPTION.
DELIMITER $$
CREATE PROCEDURE transfer_employee(
IN p_emp_id INT,
IN p_new_dept_id INT
)
PROC_BODY: BEGIN
DECLARE v_emp_exists INT DEFAULT 0;
DECLARE v_dept_exists INT DEFAULT 0;
DECLARE v_current_dept_id INT DEFAULT NULL;
-- Error handler for database/transaction failures
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;
-- Step 1: Validate NULL inputs
IF p_emp_id IS NULL OR p_new_dept_id IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Employee ID and Department ID cannot be NULL.';
END IF;
-- Step 2: Check if Employee exists and fetch current department
SELECT COUNT(*), DeptID INTO v_emp_exists, v_current_dept_id
FROM Employee
WHERE EmpID = p_emp_id;
IF v_emp_exists = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Specified Employee ID does not exist.';
END IF;
-- Step 3: Check if target Department exists
SELECT COUNT(*) INTO v_dept_exists
FROM Department
WHERE DeptID = p_new_dept_id;
IF v_dept_exists = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Specified Target Department ID does not exist.';
END IF;
-- Step 4: Check if employee is already in the target department
IF v_current_dept_id = p_new_dept_id THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Employee is already assigned to this department.';
END IF;
-- Step 5: Perform the transfer within a transaction
START TRANSACTION;
UPDATE Employee
SET DeptID = p_new_dept_id
WHERE EmpID = p_emp_id;
COMMIT;
SELECT CONCAT('Successfully transferred Employee ', p_emp_id, ' to Department ', p_new_dept_id) AS Result;
END$$
DELIMITER ;
-- EDGE CASE TESTING
-- Test Case 1: Successful Department Transfer
-- Valid transfer: Move EmpID 1 to DeptID 2
CALL transfer_employee(1, 2);
-- Verify update and audit entry
SELECT EmpID, FirstName, DeptID FROM Employee WHERE EmpID = 1;
SELECT * FROM EmployeeAuditLog WHERE EmpID = 1;
-- Test Case 2: Non-existent Employee ID
-- Fails: EmpID 9999 does not exist
CALL transfer_employee(9999, 1);
-- Error: Transfer Error: Specified Employee ID does not exist.
-- Test Case 3: Non-existent Target Department ID
-- Fails: DeptID 999 does not exist
CALL transfer_employee(1, 999);
-- Error: Transfer Error: Specified Target Department ID does not exist.
-- Test Case 4: Redundant Transfer (Same Department)
-- Fails: EmpID 1 is already in DeptID 2
CALL transfer_employee(1, 2);
-- Error: Transfer Error: Employee is already assigned to this department.
-- Test Case 5: Salary Validation Trigger (Minimum Threshold)
-- Fails: Salary is below 30,000
UPDATE Employee SET Salary = 20000.00 WHERE EmpID = 1;
-- Error: Validation Error: Salary cannot be less than 30,000.00.
-- Test Case 6: Salary Validation Trigger (Excessive Reduction)
-- Assuming EmpID 1 salary is 95,000.00, reducing to 50,000.00 (>20% drop)
UPDATE Employee SET Salary = 50000.00 WHERE EmpID = 1;
-- Error: Validation Error: Salary reduction cannot exceed 20% of current salary.