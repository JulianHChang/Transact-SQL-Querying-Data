07 - Using Table Expressions


01 - Views


-- Create a view
CREATE VIEW SalesLT.vCustomerAddress
AS
SELECT C.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince 
FROM
SalesLT.Customer C JOIN SalesLT.CustomerAddress CA
ON C.CustomerID=CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID=A.AddressID

-- Query the view
SELECT CustomerID, City
FROM SalesLT.vCustomerAddress

-- Join the view to a table
SELECT c.StateProvince, c.City, ISNULL(SUM(s.TotalDue), 0.00) AS Revenue
FROM SalesLT.vCustomerAddress AS c
LEFT JOIN SalesLT.SalesOrderHeader AS s
ON s.CustomerID = c.CustomerID
GROUP BY c.StateProvince, c.City
ORDER BY c.StateProvince, Revenue DESC;



02 - Temp Tables and Variables


-- Temporary table
CREATE TABLE #Colors
(Color varchar(15));

INSERT INTO #Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM #Colors;

-- Table variable
DECLARE @Colors AS TABLE (Color varchar(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM @Colors;

-- New batch
SELECT * FROM #Colors;

SELECT * FROM @Colors; -- now out of scope


03 - TVFs


CREATE FUNCTION SalesLT.udfCustomersByCity
(@City AS VARCHAR(20))
RETURNS TABLE
AS
RETURN
(SELECT C.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince
 FROM SalesLT.Customer C JOIN SalesLT.CustomerAddress CA
 ON C.CustomerID=CA.CustomerID
 JOIN SalesLT.Address A ON CA.AddressID=A.AddressID
 WHERE City=@City);


SELECT * FROM SalesLT.udfCustomersByCity('Bellevue')



04 - Derived Tables


SELECT Category, COUNT(ProductID) AS Products
FROM
	(SELECT p.ProductID, p.Name AS Product, c.Name AS Category
	 FROM SalesLT.Product AS p
	 JOIN SalesLT.ProductCategory AS c
	 ON p.ProductCategoryID = c.ProductCategoryID) AS ProdCats
GROUP BY Category
ORDER BY Category;



05 -  CTEs


--Using a CTE
WITH ProductsByCategory (ProductID, ProductName, Category)
AS
(
	SELECT p.ProductID, p.Name, c.Name AS Category
	 FROM SalesLT.Product AS p
	 JOIN SalesLT.ProductCategory AS c
	 ON p.ProductCategoryID = c.ProductCategoryID
)

SELECT Category, COUNT(ProductID) AS Products
FROM ProductsByCategory
GROUP BY Category
ORDER BY Category;


-- Recursive CTE
SELECT * FROM SalesLT.Employee

-- Using the CTE to perform recursion
WITH OrgReport (ManagerID, EmployeeID, EmployeeName, Level)
AS
(
	-- Anchor query
	SELECT e.ManagerID, e.EmployeeID, EmployeeName, 0
	FROM SalesLT.Employee AS e
	WHERE ManagerID IS NULL

	UNION ALL

	-- Recursive query
	SELECT e.ManagerID, e.EmployeeID, e.EmployeeName, Level + 1
	FROM SalesLT.Employee AS e
	INNER JOIN OrgReport AS o ON e.ManagerID = o.EmployeeID
)

SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);




DECLARE @Colors AS TABLE (Colors NVARCHAR(15));

INSERT INTO @Colors
SELECT DISTINCT Color
FROM SalesLT.Product;

SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN (SELECT Colors
FROM @Colors);

-- ---
SELECT CompanyContact, sum(SalesAmount) AS Revenue
FROM
  (SELECT concat(c.CompanyName, concat(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
  FROM SalesLT.SalesOrderHeader AS SOH
    JOIN SalesLT.Customer AS c
    ON SOH.CustomerID = c.CustomerID) AS CustomerSales(CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;

/*
Key Points
A derived table is a subquery that generates a multicolumn rowset. You must use the AS clause to define an alias for a derived query.
Common Table Expressions (CTEs) provide a more intuitive syntax or defining rowsets than derived tables, and can be used mulitple times in the same query.
You can use CTEs to define recursive queries.
*/