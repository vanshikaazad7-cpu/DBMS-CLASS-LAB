CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
-- 1. DEPARTMENT Table
CREATE TABLE Department (
DeptID INT AUTO_INCREMENT PRIMARY KEY,
DeptName VARCHAR(100) NOT NULL UNIQUE,
Location VARCHAR(100) NOT NULL
);
-- 2. EMPLOYEE Table
CREATE TABLE Employee (
EmpID INT AUTO_INCREMENT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
Salary DECIMAL(10,2) NOT NULL,
HireDate DATE NOT NULL,
DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
ON DELETE SET NULL
ON UPDATE CASCADE
);
-- 3. PROJECT Table
CREATE TABLE Project (ProjectID INT AUTO_INCREMENT PRIMARY KEY,
ProjectName VARCHAR(100) NOT NULL UNIQUE,
Budget DECIMAL(12,2) NOT NULL,
DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
ON DELETE SET NULL
ON UPDATE CASCADE
);
-- 4. EMPLOYEE_PROJECT Junction Table (Many-to-Many Relationship)
CREATE TABLE Employee_Project (
EmpID INT,
ProjectID INT,
HoursWorked INT NOT NULL DEFAULT 0,
PRIMARY KEY (EmpID, ProjectID),
FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
ON DELETE CASCADE
ON UPDATE CASCADE
);
INSERT INTO Department (DeptID, DeptName, Location) VALUES
(1, 'Engineering', 'Bengaluru'),
(2, 'Human Resources', 'Mumbai'),
(3, 'Marketing', 'Delhi'),
(4, 'Finance', 'Hyderabad'),
(5, 'Sales', 'Pune');
-- Insert 8 Projects
INSERT INTO Project (ProjectID, ProjectName, Budget, DeptID) VALUES
(1, 'E-Commerce Revamp', 1500000.00, 1),
(2, 'Cloud Migration', 2500000.00, 1),
(3, 'HR Automation System', 500000.00, 2),
(4, 'Q4 Brand Campaign', 800000.00, 3),
(5, 'Financial Audit 2026', 600000.00, 4),
(6, 'CRM Enhancement', 1200000.00, 5),
(7, 'AI Chatbot Integration', 1800000.00, 1),
(8, 'Global Sales Expansion', 2000000.00, 5);
-- Insert 30 Employees
INSERT INTO Employee (EmpID, FirstName, LastName, Email, Salary, HireDate, DeptID) VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@company.com', 95000.00, '2021-03-15', 1),
(2, 'Vihaan', 'Verma', 'vihaan.verma@company.com', 88000.00, '2022-01-10', 1),
(3, 'Ananya', 'Rao', 'ananya.rao@company.com', 105000.00, '2020-06-01', 1),
(4, 'Diya', 'Patel', 'diya.patel@company.com', 72000.00, '2023-04-12', 1),
(5, 'Advait', 'Kulkarni', 'advait.kulkarni@company.com', 65000.00, '2024-02-01', 1),
(6, 'Ishaan', 'Nair', 'ishaan.nair@company.com', 115000.00, '2019-11-20', 1),
(7, 'Priya', 'Singh', 'priya.singh@company.com', 58000.00, '2022-08-15', 2),
(8, 'Kabir', 'Mehta', 'kabir.mehta@company.com', 62000.00, '2021-05-18', 2),
(9, 'Neha', 'Gupta', 'neha.gupta@company.com', 75000.00, '2020-02-11', 2),
(10, 'Rohan', 'Joshi', 'rohan.joshi@company.com', 52000.00, '2023-09-01', 2),
(11, 'Sanya', 'Reddy', 'sanya.reddy@company.com', 68000.00, '2021-07-22', 3),
(12, 'Aditya', 'Kumar', 'aditya.kumar@company.com', 74000.00, '2022-03-30', 3),
(13, 'Kavya', 'Deshmukh', 'kavya.deshmukh@company.com', 81000.00, '2020-10-05', 3),
(14, 'Arjun', 'Chopra', 'arjun.chopra@company.com', 59000.00, '2023-01-15', 3),
(15, 'Tara', 'Bhasin', 'tara.bhasin@company.com', 92000.00, '2019-04-18', 3),
(16, 'Manish', 'Tiwari', 'manish.tiwari@company.com', 110000.00, '2018-08-12', 4),
(17, 'Shreya', 'Iyer', 'shreya.iyer@company.com', 95000.00, '2021-12-01', 4),
(18, 'Karan', 'Saxena', 'karan.saxena@company.com', 87000.00, '2022-05-14', 4),
(19, 'Riya', 'Kapoor', 'riya.kapoor@company.com', 64000.00, '2023-07-19', 4),
(20, 'Varun', 'Bhatt', 'varun.bhatt@company.com', 78000.00, '2020-09-25', 4),
(21, 'Amit', 'Aggarwal', 'amit.aggarwal@company.com', 85000.00, '2021-02-10', 5),
(22, 'Pooja', 'Pillai', 'pooja.pillai@company.com', 69000.00, '2022-11-05', 5),
(23, 'Siddharth', 'Roy', 'siddharth.roy@company.com', 98000.00, '2019-07-01', 5),
(24, 'Sneha', 'Mishra', 'sneha.mishra@company.com', 61000.00, '2023-03-21', 5),
(25, 'Rahul', 'Nambiar', 'rahul.nambiar@company.com', 76000.00, '2021-10-10', 5),
(26, 'Meera', 'Sen', 'meera.sen@company.com', 89000.00, '2020-12-15', 5),
(27, 'Gaurav', 'Pandey', 'gaurav.pandey@company.com', 54000.00, '2024-01-08', 1),
(28, 'Nisha', 'Dube', 'nisha.dube@company.com', 97000.00, '2019-09-09', 4),
(29, 'Vikas', 'Thakur', 'vikas.thakur@company.com', 71000.00, '2022-06-17', 3),
(30, 'Simran', 'Kaur', 'simran.kaur@company.com', 83000.00, '2021-04-04', 2);
-- Assign Employees to Projects in Employee_Project Junction Table
INSERT INTO Employee_Project (EmpID, ProjectID, HoursWorked) VALUES
(1, 1, 120), (1, 2, 80),
(2, 1, 150),
(3, 2, 200), (3, 7, 50),
(4, 1, 100),
(5, 7, 160),
(6, 2, 180), (6, 7, 90),
(7, 3, 140),
(8, 3, 130),
(9, 3, 110),
(10, 3, 90),
(11, 4, 160),
(12, 4, 140),
(13, 4, 170),
(14, 4, 120),
(15, 4, 150),
(16, 5, 210),
(17, 5, 180),
(18, 5, 160),
(19, 5, 130),
(20, 5, 150),
(21, 6, 170), (21, 8, 60),
(22, 6, 140),
(23, 8, 200),
(24, 6, 110),
(25, 8, 150),
(26, 6, 90), (26, 8, 80),
(27, 7, 130),
(28, 5, 190),
(29, 4, 115),
(30, 3, 105);
-- Query 1: Selection & Projection with ORDER BY
-- Selects the names, salary, and hire date of employees in Department 1 (Engineering) with a salary greater than 70,000, ordered by salary descending.
SELECT
FirstName,
LastName,
Salary,
HireDate
FROM Employee
WHERE DeptID = 1 AND Salary > 70000.00
ORDER BY Salary DESC;
-- Query 2: Aggregates, GROUP BY, and HAVING
-- Groups employees by department, calculating the average salary and total workforce count per department, filtering for departments with an average salary exceeding 75,000.
SELECT
d.DeptName,
COUNT(e.EmpID) AS TotalEmployees,
ROUND(AVG(e.Salary), 2) AS AvgSalary,
MAX(e.Salary) AS MaxSalary,
MIN(e.Salary) AS MinSalary
FROM Department d
JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptID, d.DeptName
HAVING AVG(e.Salary) > 75000.00
ORDER BY AvgSalary DESC;

-- Query 3: CASE Expression & Projection
-- Categorizes employee salaries into brackets ('High', 'Medium', 'Low') using a CASE statement and sorts the result by salary.
SELECT
CONCAT(FirstName, ' ', LastName) AS FullName,
Salary,
CASE
WHEN Salary >= 100000.00 THEN 'High Bracket'
WHEN Salary BETWEEN 70000.00 AND 99999.99 THEN 'Medium Bracket'
ELSE 'Low Bracket'
END AS SalaryCategory
FROM Employee
ORDER BY Salary DESC;

-- Query 4: Multi-Table Join with Aggregates, GROUP BY, HAVING, CASE, and ORDER BY
-- Finds projects with more than 2 assigned employees, calculates total hours worked, categorizes project workload using CASE, and sorts by total hours.
SELECT
p.ProjectName,
COUNT(ep.EmpID) AS TotalAssignedEmployees,
SUM(ep.HoursWorked) AS TotalHoursWorked,
CASE
WHEN SUM(ep.HoursWorked) >= 400 THEN 'Heavy Workload'
WHEN SUM(ep.HoursWorked) BETWEEN 200 AND 399 THEN 'Moderate Workload'
ELSE 'Light Workload'
END AS WorkloadStatus
FROM Project p
JOIN Employee_Project ep ON p.ProjectID = ep.ProjectID
GROUP BY p.ProjectID, p.ProjectName
HAVING COUNT(ep.EmpID) > 2
ORDER BY TotalHoursWorked DESC;