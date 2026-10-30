CREATE TABLE Sales_UNF (
    OrderID INT,
    CustomerID INT,
    CustomerName VARCHAR(50),
    ProductID INT,
    ProductName VARCHAR(50),
    SalesRep VARCHAR(50),
    RepDepartment VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO Sales_UNF VALUES
(101, 1, 'Alice', 201, 'Laptop', 'John', 'Electronics', 2),
(102, 2, 'Alice', 202, 'Mouse', 'Sarah', 'Accessories', 1),
(102, 2, 'Alice', 201, 'Laptop', 'John', 'Electronics', 1);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL
);

CREATE TABLE Departments (
    SalesRep VARCHAR(50) PRIMARY KEY,
    RepDepartment VARCHAR(50) NOT NULL
);

CREATE TABLE Rep_Products (
    SalesRep VARCHAR(50),
    ProductID INT,
    PRIMARY KEY (SalesRep, ProductID),
    FOREIGN KEY (SalesRep) REFERENCES Departments(SalesRep),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Order_Reps (
    OrderID INT,
    ProductID INT,
    SalesRep VARCHAR(50),
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (SalesRep, ProductID) REFERENCES Rep_Products(SalesRep, ProductID)
);

INSERT INTO Customers (CustomerID, CustomerName)
SELECT DISTINCT CustomerID, CustomerName
FROM Sales_UNF;

INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT OrderID, CustomerID
FROM Sales_UNF;

INSERT INTO Products (ProductID, ProductName)
SELECT DISTINCT ProductID, ProductName
FROM Sales_UNF;

INSERT INTO Departments (SalesRep, RepDepartment)
SELECT DISTINCT SalesRep, RepDepartment
FROM Sales_UNF;

INSERT INTO Rep_Products (SalesRep, ProductID)
SELECT DISTINCT SalesRep, ProductID
FROM Sales_UNF;

INSERT INTO Order_Reps (OrderID, ProductID, SalesRep, Quantity)
SELECT OrderID, ProductID, SalesRep, Quantity
FROM Sales_UNF;

SELECT
    o.OrderID,
    c.CustomerID,
    c.CustomerName,
    p.ProductID,
    p.ProductName,
    or_rep.SalesRep,
    d.RepDepartment,
    or_rep.Quantity
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
JOIN Order_Reps or_rep
    ON o.OrderID = or_rep.OrderID
JOIN Products p
    ON or_rep.ProductID = p.ProductID
JOIN Departments d
    ON or_rep.SalesRep = d.SalesRep;
