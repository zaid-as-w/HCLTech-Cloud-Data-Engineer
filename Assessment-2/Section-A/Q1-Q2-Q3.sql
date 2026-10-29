-- question 1 --
CREATE DATABASE EnterpriseDB;

USE EnterpriseDB;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    JoiningDate DATE NOT NULL,
    ManagerID INT,
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ManagerID)
        REFERENCES Employees(EmployeeID)
);

INSERT INTO Departments VALUES
(1, 'IT', 'Bangalore'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Chennai'),
(4, 'Marketing', 'Delhi'),
(5, 'Operations', 'Hyderabad');

INSERT INTO Employees VALUES
(101, 'Amit', 1, 90000, '2020-01-15', NULL),
(102, 'Priya', 2, 80000, '2019-03-10', NULL),
(103, 'Rahul', 3, 85000, '2018-06-20', NULL),
(104, 'Sneha', 4, 75000, '2021-02-01', NULL);

INSERT INTO Employees VALUES
(105, 'Vikram', 1, 70000, '2022-04-12', 101),
(106, 'Anjali', 1, 70000, '2023-01-05', 101),
(107, 'Kiran', 1, 60000, '2023-07-18', 101),
(108, 'Meera', 2, 50000, '2022-08-22', 102),
(109, 'Arjun', 2, 45000, '2023-09-11', 102),
(110, 'Divya', 3, 65000, '2021-11-30', 103),
(111, 'Rohit', 3, 55000, '2022-05-14', 103),
(112, 'Pooja', 3, 55000, '2024-01-10', 103),
(113, 'Neha', 4, 60000, '2022-12-01', 104),
(114, 'Suresh', 4, 50000, '2023-06-15', 104),
(115, 'Kavya', 1, 40000, '2024-03-20', 101);

-- Tasks --
-- Task a --
SELECT e.EmployeeName,
       d.DepartmentName,
       m.EmployeeName AS ManagerName
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;

-- Task b --
SELECT EmployeeName, DepartmentID, Salary
FROM Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);

-- Task c --
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees
);

-- Task d --
WITH RankedEmployees AS (
    SELECT EmployeeName,
           DepartmentID,
           Salary,
           DENSE_RANK() OVER (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC
           ) AS SalaryRank
    FROM Employees
)
SELECT EmployeeName, DepartmentID, Salary, SalaryRank
FROM RankedEmployees
WHERE SalaryRank <= 3
ORDER BY DepartmentID, Salary DESC;

-- question 2 --
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    SaleDate DATE,
    ProductName VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10, 2)
);

INSERT INTO Sales
    (SaleID, CustomerID, SaleDate, ProductName, Quantity, UnitPrice)
VALUES
    (1, 101, '2025-01-10', 'Laptop', 2, 50000.00),
    (2, 102, '2025-01-15', 'Mobile', 3, 20000.00),
    (3, 103, '2025-01-20', 'Headphones', 5, 1500.00),
    (4, 101, '2025-02-05', 'Laptop', 1, 50000.00),
    (5, 104, '2025-02-12', 'Mobile', 2, 20000.00),
    (6, 105, '2025-02-18', 'Keyboard', 4, 2500.00),
    (7, 102, '2025-03-03', 'Laptop', 1, 50000.00),
    (8, 103, '2025-03-11', 'Headphones', 3, 1500.00),
    (9, 104, '2025-03-20', 'Mobile', 1, 20000.00),
    (10, 105, '2025-04-02', 'Keyboard', 2, 2500.00),
    (11, 101, '2025-04-14', 'Laptop', 2, 50000.00),
    (12, 102, '2025-04-21', 'Mobile', 4, 20000.00),
    (13, 103, '2025-05-06', 'Headphones', 6, 1500.00),
    (14, 104, '2025-05-15', 'Keyboard', 3, 2500.00),
    (15, 105, '2025-05-25', 'Laptop', 1, 50000.00);

-- revenue of each product --
SELECT
    ProductName,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY ProductName
ORDER BY TotalRevenue DESC;

-- monthly revenue and changing --
WITH MonthlySales AS (
    SELECT
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(Quantity * UnitPrice) AS MonthlyRevenue
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT
    SaleYear,
    SaleMonth,
    MonthlyRevenue,
    LAG(MonthlyRevenue) OVER (
        ORDER BY SaleYear, SaleMonth
    ) AS PreviousMonthRevenue,
    MonthlyRevenue - LAG(MonthlyRevenue) OVER (
        ORDER BY SaleYear, SaleMonth
    ) AS RevenueChange
FROM MonthlySales
ORDER BY SaleYear, SaleMonth;

-- original query --
SELECT * 
FROM Employees 
WHERE YEAR(JoiningDate) = 2025;

-- optimized query --
SELECT *
FROM Employees
WHERE JoiningDate >= '2025-01-01'
  AND JoiningDate < '2026-01-01';

-- duplicate email addresses --
SELECT EmailID
FROM Employees
GROUP BY EmailID
HAVING COUNT(EmailID) > 1;


