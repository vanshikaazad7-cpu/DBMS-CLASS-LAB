# DBMS Class Lab

This repository contains a complete set of Database Management System (DBMS) lab experiments implemented using MySQL-compatible SQL. The project covers conceptual database design, relational schema creation, normalization-oriented modeling, querying, joins, views, recursive queries, triggers, and stored procedures.

## Repository Structure

- `EXP1/` — ER Diagram for an Indian E-Commerce Platform
- `EXP2/` — E-Commerce Database Schema and Sample Data
- `EXP3/` — Company Database with Employee and Project Data
- `EXP4/` — SQL Joins, Subqueries, and Query Analysis
- `EXP5/` — Views, Hierarchies, and Recursive CTEs
- `EXP6/` — Triggers, Audit Logging, and Stored Procedures

---

## Experiment Overview

### EXP1: ER Diagram for an Indian E-Commerce Platform
This experiment focuses on conceptual database design using an ER diagram for an e-commerce system.

Topics covered:
- Customer, Product, Order, Seller, Category, Payment, Delivery, and Address
- Primary keys
- Composite and multi-valued attributes
- Weak entities
- Product specialization
- Participation constraints
- Real-world e-commerce relationships

Files:
- `ER-1.drawio.png`
- `ER-1.drawio.svg`

---

### EXP2: E-Commerce Database Schema
This experiment implements the e-commerce system as a relational database using SQL.

Database:
- `ecommerce_db`

Tables:
- `Category`
- `Seller`
- `Customer`
- `Address`
- `Product`
- `Electronics`
- `Clothing`
- `Grocery`
- `Order`
- `OrderItem`
- `Payment`
- `Delivery`

Concepts covered:
- Primary keys and foreign keys
- Referential integrity
- `ON DELETE` / `ON UPDATE` actions
- Check constraints
- Auto-increment IDs
- Product type specialization
- Sample transactions and order flow

File:
- `EXP2/exp2.sql`

---

### EXP3: Company Database and SQL Query Practice
This experiment builds a company database and demonstrates SQL query operations.

Database:
- `company_db`

Tables:
- `Department`
- `Employee`
- `Project`
- `Employee_Project`

Concepts covered:
- Table creation and sample data insertion
- Many-to-many relationship handling using a junction table
- Data filtering and sorting
- Grouping and aggregation
- Conditional logic using `CASE`
- Query writing with `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, and `ORDER BY`

File:
- `EXP3/exp3.sql`

---

### EXP4: SQL Joins, Subqueries, and Query Optimization
This experiment introduces advanced SQL features and query analysis.

Concepts covered:
- Inner Join
- Left Join
- Self Join
- Multi-table joins
- Correlated subqueries
- `EXISTS`
- Simulated `INTERSECT`
- Simulated `EXCEPT`
- Execution plan analysis using `EXPLAIN`

File:
- `EXP4/exp4.sql`

---

### EXP5: Views, Hierarchies, and Recursive Queries
This experiment explores employee hierarchy modeling using a self-referencing relationship.

Concepts covered:
- `ManagerID` self-referencing foreign key
- Views
- Aggregate views
- Joined views
- View updatability concepts
- Recursive Common Table Expressions (CTEs)
- Organizational reporting chain traversal

Files:
- `EXP5/exp5.sql`

---

### EXP6: Triggers, Audit Logs, and Stored Procedures
This experiment demonstrates database automation and data integrity enforcement.

Concepts covered:
- `BEFORE UPDATE` trigger for salary validation
- `AFTER UPDATE` trigger for audit logging
- Stored procedures
- Transaction handling
- Error handling using `SIGNAL`
- Employee transfer logic

Tables:
- `EmployeeAuditLog`

Files:
- `EXP6/exp6.sql`

---

## Technologies Used

- MySQL / MariaDB compatible SQL
- SQL scripts for schema creation, inserts, queries, and procedure logic

---

## Learning Outcomes

By completing these experiments, students will be able to:

- Design ER diagrams for real-world systems
- Convert ER models into relational schemas
- Write SQL queries for data retrieval and reporting
- Use joins and subqueries effectively
- Create views and understand view limitations
- Work with recursive data structures and hierarchies
- Implement triggers for validation and auditing
- Use stored procedures and transactions in database applications

---

## How to Use

1. Open MySQL or MariaDB.
2. Create the required database manually if needed.
3. Execute the SQL script for the relevant experiment.
4. Observe the results and understand the underlying database concepts.

Example:
```sql
USE ecommerce_db;
SELECT * FROM Product;