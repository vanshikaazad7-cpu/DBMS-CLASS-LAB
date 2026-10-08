-- A. INNER JOIN
-- Retrieves all employees along with their assigned department details.
SELECT
e.EmpID,
e.FirstName,
e.LastName,
d.DeptName,
d.Location
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID;
-- B. LEFT JOIN
-- Retrieves all departments and their assigned employees, including departments that currently have no employees.
SELECT
d.DeptID,
Name : Vanshika Azad
UID: 25LBCS3242
d.DeptName,
e.EmpID,
e.FirstName,
e.LastName
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID;
-- C. Self-Join
-- Finds pairs of employees who work in the same department (excluding self-matches).
SELECT
e1.DeptID,
CONCAT(e1.FirstName, ' ', e1.LastName) AS Employee_1,
CONCAT(e2.FirstName, ' ', e2.LastName) AS Employee_2
FROM Employee e1
INNER JOIN Employee e2 ON e1.DeptID = e2.DeptID AND e1.EmpID < e2.EmpID
ORDER BY e1.DeptID;
-- D. 3-Way Join
-- Retrieves employee names, their project titles, and total hours worked by joining Employee, Employee_Project, and Project.
SELECT
CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
p.ProjectName,
ep.HoursWorked
FROM Employee e
INNER JOIN Employee_Project ep ON e.EmpID = ep.EmpID
INNER JOIN Project p ON ep.ProjectID = p.ProjectID;
-- E. Correlated Subquery
-- Finds employees whose salary is strictly greater than the average salary of their respective department.
SELECT
e.EmpID,
e.FirstName,
e.LastName,
e.Salary,
e.DeptID
FROM Employee e
WHERE e.Salary > (
SELECT AVG(e2.Salary)
FROM Employee e2
WHERE e2.DeptID = e.DeptID
);
-- F. EXISTS Operator
-- Retrieves employees who are actively assigned to at least one project.
SELECT
e.EmpID,
e.FirstName,
e.LastName
FROM Employee e
WHERE EXISTS (
SELECT 1
FROM Employee_Project ep
WHERE ep.EmpID = e.EmpID
);
-- G. Simulated INTERSECT
-- Finds employee IDs that belong to Department 1 AND are assigned to Project 1 (simulating INTERSECT using INNER JOIN / Subquery for MySQL versions/compatibility).
-- Simulated INTERSECT via INNER JOIN on Subqueries
SELECT t1.EmpID
FROM (
SELECT EmpID FROM Employee WHERE DeptID = 1
) t1
INNER JOIN (
SELECT EmpID FROM Employee_Project WHERE ProjectID = 1
) t2 ON t1.EmpID = t2.EmpID;
-- H. Simulated EXCEPT
-- Finds employees in Department 1 who are NOT assigned to Project 1 (simulating EXCEPT / MINUS using LEFT JOIN where IS NULL).
-- Simulated EXCEPT via LEFT JOIN
SELECT e.EmpID, e.FirstName, e.LastName
FROM Employee e
LEFT JOIN Employee_Project ep
ON e.EmpID = ep.EmpID AND ep.ProjectID = 1
WHERE e.DeptID = 1 AND ep.EmpID IS NULL;
-- EXECUTION PLAN ANALYSIS (EXPLAIN)
-- To analyze query performance in MySQL, place EXPLAIN before any query:
EXPLAIN SELECT e.EmpID, e.FirstName, e.LastName, e.Salary, e.DeptID
FROM Employee e
WHERE e.Salary > (
SELECT AVG(e2.Salary)
FROM Employee e2
WHERE e2.DeptID = e.DeptID
);