-- 1. How many products can you find in the Production.Product table?

SELECT COUNT(ProductID) AS CountProducts
FROM Production.Product

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

SELECT COUNT (ProductID) AS CountProductsNotNullSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

-- 3.  How many Products reside in each SubCategory? Write a query to display the results with the following titles.

SELECT ProductSubcategoryID, COUNT(ProductID) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID

-- 4.  How many products that do not have a product subcategory.

SELECT COUNT (ProductID) AS CountProductsNullSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.

SELECT SUM (Quantity) AS SumProductQuantity
FROM Production.ProductInventory

-- 6.  Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.

SELECT ProductID, SUM (Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM (Quantity) < 100

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

SELECT Shelf, ProductID, SUM (Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 AND Shelf != 'N/A'
GROUP BY Shelf, ProductID
HAVING SUM (Quantity) < 100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT AVG (Quantity) As AvgVal
FROM Production.ProductInventory
WHERE LocationID = 10

--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

SELECT ProductID, Shelf, AVG (Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

SELECT ProductID, Shelf, AVG (Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY Shelf, ProductID

-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

SELECT Color, Class, COUNT (ProductID) AS TheCount , AVG (ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c
JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c
JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Canada', 'Germany')

-- 14.  List all Products that has been sold at least once in last 27 years.

SELECT p.ProductID, p.ProductName, od.OrderID, o.OrderDate
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
JOIN dbo.Orders o
ON od.OrderID = o.OrderID
WHERE o.OrderDate > DATEADD (YEAR, -27, GETDATE())

-- 15. List top 5 locations (Zip Code) where the products sold most.

SELECT TOP 5 o.ShipPostalCode, COUNT (p.ProductID) AS TheCount
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
JOIN dbo.Orders o
ON od.OrderID = o.OrderID
WHERE o.ShipPostalCode IS NOT NULL 
GROUP BY o.ShipPostalCode
ORDER BY TheCount DESC

-- 16. List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT TOP 5 o.ShipPostalCode, COUNT (p.ProductID) AS TheCount
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
JOIN dbo.Orders o
ON od.OrderID = o.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND o.OrderDate > DATEADD (YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY TheCount DESC

-- 17. List all city names and number of customers in that city

SELECT c.City, COUNT (c.CustomerID) AS CustomerCount
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.City

SELECT c.City, COUNT (c.CustomerID) AS CustomerCount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.City

-- 18. List city names which have more than 2 customers, and number of customers in that city

SELECT c.City, COUNT (c.CustomerID) AS CustomerCountMoreThan2
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.City
HAVING COUNT (c.CustomerID) > 2

-- 19. List the names of customers who placed orders after 1/1/98 with order date.

SELECT DISTINCT c.ContactName
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'

-- 20. List the names of all customers with most recent order dates

SELECT c.ContactName, MAX (o.OrderDate) As MostRecentOrder
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName
ORDER BY MostRecentOrder DESC

SELECT DISTINCT c.ContactName, MAX (o.OrderDate) As MostRecentOrder
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName
ORDER BY MostRecentOrder DESC

-- 21. Display the names of all customers  along with the  count of products they bought

SELECT c.ContactName,  COUNT (od.ProductID)
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP BY c.CustomerID, c.ContactName

-- 22. Display the customer ids who bought more than 100 Products with count of products.

SELECT c.CustomerID,  COUNT (od.ProductID)
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP BY c.CustomerID
HAVING COUNT (od.ProductID) > 100

-- 23. List all of the possible ways that suppliers can ship their products. Display the results as below

SELECT su.CompanyName, sh.CompanyName
FROM Suppliers su
CROSS JOIN Shippers sh

-- 24. Display the products order each day. Show Order date and Product Name.

SELECT o.OrderDate, p.ProductName
FROM Orders o
JOIN [Order Details] od
ON o.OrderID = od.OrderID
JOIN Products p
ON p.ProductID = od.ProductID
ORDER BY o.OrderDate DESC

SELECT DISTINCT o.OrderDate, p.ProductName
FROM Orders o
JOIN [Order Details] od
ON o.OrderID = od.OrderID
JOIN Products p
ON p.ProductID = od.ProductID
ORDER BY o.OrderDate DESC

-- 25. Displays pairs of employees who have the same job title.

SELECT e1.FirstName + ' ' + e1.LastName AS Employee1, e2.FirstName + ' ' + e2.LastName AS Employee2, e1.Title, e2.Title
FROM Employees e1
JOIN Employees e2
ON e1.Title = e2.Title
WHERE e1.EmployeeID != e2.EmployeeID
ORDER By e1.FirstName, e2.FirstName

SELECT e1.FirstName + ' ' + e1.LastName AS Employee1, e2.FirstName + ' ' + e2.LastName AS Employee2, e1.Title, e2.Title
FROM Employees e1
JOIN Employees e2
ON e1.Title = e2.Title
WHERE e1.EmployeeID != e2.EmployeeID AND e1.EmployeeID > e2.EmployeeID
ORDER By e1.FirstName, e2.FirstName

-- 26.  Display all the Managers who have more than 2 employees reporting to them

SELECT mng.FirstName + ' ' + mng.LastName AS Manager, emp.FirstName + ' ' + emp.LastName AS Employee
FROM Employees emp
JOIN Employees mng
ON emp.ReportsTo = mng.EmployeeID
ORDER BY mng.FirstName

SELECT mng.FirstName + ' ' + mng.LastName AS Manager, COUNT (emp.EmployeeID)
FROM Employees emp
JOIN Employees mng
ON emp.ReportsTo = mng.EmployeeID
GROUP BY mng.FirstName, mng.LastName
HAVING COUNT (emp.EmployeeID) > 2

-- 27. Display the customers and suppliers by city. The results should have the following columns

SELECT c.City, c.CompanyName, 'Customer' AS Type
FROM Customers c
UNION 
SELECT s.City, s.CompanyName, 'Supplier' AS Type
FROM Suppliers s

SELECT c.City, c.CompanyName, 'Customer' AS Type
FROM Customers c
UNION ALL
SELECT s.City, s.CompanyName, 'Supplier' AS Type
FROM Suppliers s