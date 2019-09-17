05 - Using Functions and Aggregating Data


01 - Functions


-- Scalar functions
SELECT YEAR(SellStartDate) SellStartYear, ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear;

SELECT YEAR(SellStartDate) SellStartYear, DATENAME(mm,SellStartDate) SellStartMonth,
       DAY(SellStartDate) SellStartDay, DATENAME(dw, SellStartDate) SellStartWeekday,
	   ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear;

SELECT DATEDIFF(yy,SellStartDate, GETDATE()) YearsSold, ProductID, Name
FROM SalesLT.Product
ORDER BY ProductID;

SELECT UPPER(Name) AS ProductName
FROM SalesLT.Product;

SELECT CONCAT(FirstName + ' ', LastName) AS FullName
FROM SalesLT.Customer;

SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType,
                            SUBSTRING(ProductNumber,CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode,
							SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode
FROM SalesLT.Product;


-- Logical functions
SELECT Name, Size AS NumericSize
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;

SELECT Name, IIF(ProductCategoryID IN (5,6,7), 'Bike', 'Other') ProductType
FROM SalesLT.Product;

SELECT Name, IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Non-Numeric') SizeType
FROM SalesLT.Product;

SELECT prd.Name AS ProductName, cat.Name AS Category,
      CHOOSE (cat.ParentProductCategoryID, 'Bikes','Components','Clothing','Accessories') AS ProductType
FROM SalesLT.Product AS prd
JOIN SalesLT.ProductCategory AS cat
ON prd.ProductCategoryID = cat.ProductCategoryID;


-- Window functions
SELECT TOP(100) ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
ORDER BY RankByPrice;

SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK() OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductcategoryID
ORDER BY Category, RankByPrice;


-- Aggregate Functions
SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, AVG(ListPrice) AS AveragePrice
FROM SalesLT.Product;

SELECT COUNT(p.ProductID) BikeModels, AVG(p.ListPrice) AveragePrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name LIKE '%Bikes';


02 - Group By


SELECT Salesperson, COUNT(CustomerID) Customers
FROM SalesLT.Customer
GROUP BY Salesperson
ORDER BY Salesperson;

SELECT c.Name AS Category, COUNT(p.ProductID) AS Products
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
GROUP BY c.Name
ORDER BY Category;

SELECT c.Salesperson, SUM(oh.SubTotal) SalesRevenue
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.Salesperson
ORDER BY SalesRevenue DESC;

SELECT c.Salesperson, ISNULL(SUM(oh.SubTotal), 0.00) SalesRevenue
FROM SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.Salesperson
ORDER BY SalesRevenue DESC;

SELECT c.Salesperson, CONCAT(c.FirstName +' ', c.LastName) AS Customer, ISNULL(SUM(oh.SubTotal), 0.00) SalesRevenue
FROM SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.Salesperson, CONCAT(c.FirstName +' ', c.LastName)
ORDER BY SalesRevenue DESC, Customer;


03 - Having


-- Try to find salespeople with over 150 customers (fails with error)
SELECT Salesperson, COUNT(CustomerID) Customers
FROM SalesLT.Customer
WHERE COUNT(CustomerID) > 100
GROUP BY Salesperson
ORDER BY Salesperson;

--Need to use HAVING clause to filter based on aggregate
SELECT Salesperson, COUNT(CustomerID) Customers
FROM SalesLT.Customer
GROUP BY Salesperson
HAVING COUNT(CustomerID) > 100
ORDER BY Salesperson;


round
year
datename
upper, left, right
ISNUMERIC

-- The sales manager would like a list of customers ranked by sales.
-- select CompanyName and TotalDue columns
SELECT c.CompanyName, SOH.TotalDue AS Revenue,
  -- get ranking and order by appropriate column
  Rank() OVER (ORDER BY soh.TotalDue DESC) AS RankByRevenue
FROM SalesLT.SalesOrderHeader AS SOH
  -- use appropriate join on appropriate table
  join SalesLT.Customer AS C
  ON SOH.CustomerID = C.CustomerID;

sum, avg, min, max


/*
Key Points
You can use GROUP BY with aggregate functions to return aggregations grouped by one or more columns or expressions.
All columns in the SELECT clause that are not aggregate function expressions must be included in a GROUP BY clause.
The order in which columns or expressions are listed in the GROUP BY clause determines the grouping hierarchy.
You can filter the groups that are included in the query results by specifying a HAVING clause.
*/
