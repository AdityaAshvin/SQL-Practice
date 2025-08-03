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

SELECT DISTINCT c.City
FROM Customers c
LEFT JOIN Employees e
ON e.City = c.City

-- 3. List all products and their total order quantities throughout all orders.

SELECT p.ProductName, SUM(od.Quantity) AS TotalOrderQuantity
FROM Products p
JOIN [Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, ProductName
ORDER BY p.ProductName

SELECT p.ProductName, ( SELECT SUM(od.Quantity) AS TotalOrderQuantity
						FROM [Order Details] od
						WHERE p.ProductID = od.ProductID
						) AS TotalOrderQuantity
FROM Products p
ORDER BY p.ProductName

-- 4. List all Customer Cities and total products ordered by that city.

SELECT c.City, SUM (od.Quantity) AS TotalProducts
FROM [Order Details] od
JOIN Orders o
ON od.OrderID = o.OrderID
JOIN Customers c
ON c.CustomerID = o.CustomerID
GROUP BY c.City
ORDER BY c.City

SELECT c.City, (SELECT SUM (od.Quantity)
				FROM [Order Details] od
				JOIN Orders o
				ON o.OrderID = od.OrderID
				JOIN Customers c1
				ON c1.CustomerID = o.CustomerID
				WHERE c1.City = c.City
				) AS TotalProducts
FROM Customers c
ORDER BY c.City

-- 5.  List all Customer Cities that have at least two customers.

SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2

-- 6. List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City, COUNT (DISTINCT od.ProductID) AS ProductCount
FROM Customers c
JOIN Orders o
ON o.CustomerID = c.CustomerID
JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP By c.City
HAVING COUNT (DISTINCT od.ProductID) >= 2
ORDER BY c.City

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT c.ContactName, c.City, o.ShipCity
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

--a. find the top 5 most popular products and their avg price

WITH TopProducts AS (
	SELECT TOP 5 p.ProductID, p.ProductName, SUM (od.Quantity) AS ProductCount, AVG (od.UnitPrice) AS AvgPrice
	FROM Products p
	JOIN [Order Details] od
	ON p.ProductID = od.ProductID
	GROUP BY p.ProductID, p.ProductName
	ORDER BY SUM (od.Quantity) DESC
	),

--b. customer city that ordered most quantity of it

CustomerCity AS (
	SELECT c.City, p.ProductID, p.ProductName, SUM (od.Quantity) AS MostQuantity, 
	DENSE_RANK() OVER(PARTITION BY p.ProductID ORDER BY SUM(od.Quantity) DESC) AS rnk
	FROM Customers c
	JOIN Orders o
	ON o.CustomerID = c.CustomerID
	JOIN [Order Details] od
	ON od.OrderID = o.OrderID
	JOIN Products P
	ON od.ProductID = p.ProductID
	GROUP BY c.City, p.ProductID, p.ProductName
	)

SELECT tp.ProductName, tp.AvgPrice, cc.City
FROM TopProducts tp
JOIN CustomerCity cc
ON tp.ProductID = cc.ProductID
WHERE cc.rnk = 1

-- 9. List all cities that have never ordered something but we have employees there.

-- a. Use sub-query

SELECT e.City
FROM Employees e
WHERE e.City NOT IN (
	SELECT c.City
	FROM Customers c
	INNER JOIN Orders o
	ON o.CustomerID = c.CustomerID
	)

-- b. Do not use sub-query

SELECT e.City
FROM Employees e
LEFT JOIN Customers c
ON e.City = c.City
LEFT JOIN Orders o
ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL

-- 10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

WITH CityMostOrders AS (
	SELECT TOP 1 e.EmployeeID, e.City, e.FirstName + ' ' + e.LastName AS Employee, COUNT (od.orderID) AS OrderCount
	FROM Employees e
	JOIN Orders o
	ON o.EmployeeID = e.EmployeeID
	JOIN [Order Details] od
	ON od.OrderID = o.OrderID
	GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.City
	ORDER BY COUNT (od.orderID) DESC
),
CityMostQuantity AS (
	SELECT TOP 1 e.EmployeeID, e.City, e.FirstName + ' ' + e.LastName AS Employee, SUM (od.Quantity) AS QuantitySold
	FROM Employees e
	JOIN Orders o
	ON o.EmployeeID = e.EmployeeID
	JOIN [Order Details] od
	ON od.OrderID = o.OrderID
	GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.City
	ORDER BY SUM (od.Quantity) DESC
)

SELECT cmo.City
FROM CityMostOrders cmo
JOIN CityMostQuantity cmq
ON cmo.City = cmq.City

-- 11. How do you remove the duplicates record of a table?

-- 1 ROW_NUMBER then DELETE
-- 2. Temp Table
-- 3. GROUP BY
-- 4. DELETE in Subquery