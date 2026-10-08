-- To support employee reporting chains and hierarchy, we add a self-referencing ManagerID foreign key to the Employee table.
-- Add ManagerID column to Employee table
ALTER TABLE Employee
ADD COLUMN ManagerID INT NULL,
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
ON DELETE SET NULL
ON UPDATE CASCADE;
-- Assign managers to employees to create a reporting hierarchy
UPDATE Employee SET ManagerID = NULL WHERE EmpID IN (6, 16); -- Top Executives/Department Heads
UPDATE Employee SET ManagerID = 6 WHERE EmpID IN (1, 2, 3, 27); -- Report to Ishaan (EmpID 6)
UPDATE Employee SET ManagerID = 1 WHERE EmpID IN (4, 5); -- Report to Aarav (EmpID 1)
UPDATE Employee SET ManagerID = 16 WHERE EmpID IN (17, 18, 28); -- Report to Manish (EmpID 16)
UPDATE Employee SET ManagerID = 17 WHERE EmpID IN (19, 20); -- Report to Shreya (EmpID 17)

-- View 1: Department Salary Summary (Aggregate View)
-- Provides aggregated metrics (total employees, total salary, average salary, max, min) for each department.
CREATE OR REPLACE VIEW vw_DepartmentSalarySummary AS
SELECT
d.DeptID,
d.DeptName,
COUNT(e.EmpID) AS TotalEmployees,
COALESCE(SUM(e.Salary), 0.00) AS TotalSalary,
ROUND(COALESCE(AVG(e.Salary), 0.00), 2) AS AvgSalary,
COALESCE(MAX(e.Salary), 0.00) AS MaxSalary,
COALESCE(MIN(e.Salary), 0.00) AS MinSalary
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptID, d.DeptName;
-- View 2: Employee Hierarchy View (Simple/Joined View)
-- Displays basic employee information alongside their direct manager's name.
CREATE OR REPLACE VIEW vw_EmployeeHierarchy AS
SELECT
e.EmpID,
CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
e.Email,
e.Salary,
e.DeptID,
e.ManagerID,
CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM Employee e
LEFT JOIN Employee m ON e.ManagerID = m.EmpID;
-- TESTING UPDATABILITY OF VIEWS
-- In relational database management systems (RDBMS) like MySQL, a view is updatable only if it is built on a single base table without aggregate functions, GROUP BY, HAVING, UNION, or DISTINCT.
-- Test Case A: Updating an Aggregate View (vw_DepartmentSalarySummary)
-- Attempting to update a row in the aggregate view
UPDATE vw_DepartmentSalarySummary
SET DeptName = 'Software Engineering'
WHERE DeptID = 1;
-- Test Case B: Updating a Simple Updatable View (vw_EmployeeHierarchy)
-- Updating an employee's salary through the view
UPDATE Employee
SET Salary = 98000.00
WHERE EmpID = 1;
-- Verify update on both View and Base Table
SELECT EmpID, EmployeeName, Salary FROM vw_EmployeeHierarchy WHERE EmpID = 1;
SELECT EmpID, FirstName, Salary FROM Employee WHERE EmpID = 1;

-- RECURSIVE CTE FOR DISPLAYING REPORTING CHAINS
-- A Recursive Common Table Expression (CTE) traverses the employee-manager hierarchy to display the full management chain and reporting level for every employee.
WITH RECURSIVE ReportingChain AS (
-- Anchor Member: Top-level managers (Employees with no Manager)
SELECT
EmpID,
FirstName,
LastName,
ManagerID,
1 AS HierarchyLevel,
CAST(CONCAT(FirstName, ' ', LastName) AS CHAR(500)) AS ReportingPath
FROM Employee
WHERE ManagerID IS NULL
UNION ALL
-- Recursive Member: Join employees to their managers in the CTE
SELECT
e.EmpID,
e.FirstName,
e.LastName,
e.ManagerID,
rc.HierarchyLevel + 1 AS HierarchyLevel,
CAST(CONCAT(rc.ReportingPath, ' -> ', e.FirstName, ' ', e.LastName) AS CHAR(500)) AS ReportingPath
FROM Employee e
INNER JOIN ReportingChain rc ON e.ManagerID = rc.EmpID
)
SELECT
EmpID,
CONCAT(FirstName, ' ', LastName) AS EmployeeName,
ManagerID,
HierarchyLevel,
ReportingPath
FROM ReportingChain
ORDER BY HierarchyLevel, EmpID;