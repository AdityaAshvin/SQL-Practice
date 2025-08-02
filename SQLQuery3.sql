-- 1.  List all cities that have both Employees and Customers.

SELECT DISTINCT city
FROM Employees
WHERE City IN (SELECT city
		FROM Customers)

SELECT DISTINCT e.City
FROM Employees e
JOIN Customers c
ON e.City = c.City

-- 2.  List all cities that have Customers but no Employee.

-- a. Using Subquery

SELECT DISTINCT city
FROM Customers
WHERE NOT City IN (SELECT city
		FROM Employees)

-- b. Without using Subquery

SELECT DISTINCT e.City
FROM Customers c
LEFT JOIN Employees e
ON e.City = c.City
