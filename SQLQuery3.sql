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
				ON c.CustomerID = o.CustomerID
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
HAVING COUNT (od.ProductID) >= 2
ORDER BY c.City

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT c.ContactName, c.City, o.ShipCity
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT p.ProductName, COUNT (p.productID) AS OrderCount, AVG (od.UnitPrice * od.Quantity) AS AvgPrice, c.City
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
ON od.OrderID = o.OrderID
JOIN Products p
ON p.ProductID = od.ProductID
GROUP By c.City, p.ProductID, p.ProductName
ORDER BY COUNT (p.productID) DESC

-- 9. 