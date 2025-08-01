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
GROUP BY Color, Class
HAVING Color IS NOT NULL AND Class IS NOT NULL

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

-- 17. 