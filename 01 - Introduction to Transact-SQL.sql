01 - Introduction to Transact-SQL


01 - Select

SELECT Name, StandardCost, ListPrice
FROM SalesLT.Product;


SELECT Name, ListPrice - StandardCost
FROM SalesLT.Product;


SELECT Name, ListPrice - StandardCost AS Markup
FROM SalesLT.Product;


SELECT ProductNumber, Color, Size, Color + ', ' + Size AS ProductDetails
FROM SalesLT.Product; 


SELECT ProductID + ': ' + Name
FROM SalesLT.Product; 




02 - Converting Data Types


SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName
FROM SalesLT.Product;

SELECT CONVERT(varchar(5), ProductID) + ': ' + Name AS ProductName
FROM SalesLT.Product;

SELECT SellStartDate,
       CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
	   CONVERT(nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate
FROM SalesLT.Product;

SELECT Name, CAST (Size AS Integer) AS NumericSize
FROM SalesLT.Product; --(note error - some sizes are incompatible)

SELECT Name, TRY_CAST (Size AS Integer) AS NumericSize
FROM SalesLT.Product; --(note incompatible sizes are returned as NULL)



03 - NULLs and Expressions


SELECT Name, ISNULL(TRY_CAST(Size AS Integer),0) AS NumericSize
FROM SalesLT.Product;

SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;

SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;

SELECT Name, COALESCE(DiscontinuedDate, SellEndDate, SellStartDate) AS FirstNonNullDate
FROM SalesLT.Product;

--Searched case
SELECT Name,
		CASE
			WHEN SellEndDate IS NULL THEN 'On Sale'
			ELSE 'Discontinued'
		END AS SalesStatus
FROM SalesLT.Product;

--Simple case
SELECT Name,
		CASE Size
			WHEN 'S' THEN 'Small'
			WHEN 'M' THEN 'Medium'
			WHEN 'L' THEN 'Large'
			WHEN 'XL' THEN 'Extra-Large'
			ELSE ISNULL(Size, 'n/a')
		END AS ProductSize
FROM SalesLT.Product;


---------
-- to build a string with an integer
-- cast the CustomerID column to a VARCHAR and concatenate with the CompanyName column
SELECT CAST(customerid AS varchar) + ': ' + companyname AS CustomerCompany
FROM SalesLT.Customer;

-- OrderDate: 2004-06-01 00:00:00	
-- The order date converted to ANSI standard format yyyy.mm.dd (e.g. 2015.01.31).
-- finish the query
SELECT salesordernumber + ' (' + STR(revisionnumber, 1) + ')' AS OrderRevision,
  CONVERT(NVARCHAR(30), orderdate, 102) AS OrderDate
FROM SalesLT.SalesOrderHeader;

-- The list should consist of a single field in the format:
-- <first name> <last name> (e.g. Keith Harris) if the middle name is unknown,
-- <first name> <middle name> <last name> (e.g. Jane M. Gates) if a middle name is stored in the database.
-- use ISNULL to check for middle names and concatenate with FirstName and LastName
SELECT firstname + ' ' + coalesce(middlename + ' ', '') + lastname
AS CustomerName
FROM SalesLT.Customer;



-- select the CustomerID, and use COALESCE with EmailAddress and Phone columns
SELECT customerid, coalesce(emailaddress, phone) AS PrimaryContact
FROM SalesLT.Customer;


-- You have been asked to create a query that returns a list of sales order IDs and order dates 
-- with a column named ShippingStatus that contains the text "Shipped" for orders with a 
-- known ship date, and "Awaiting Shipment" for orders with no ship date.

SELECT SalesOrderID, OrderDate,
  CASE
  WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
    ELSE 'Shipped'
  END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;

/*
distinct
top N

Key Points
NULL is used to indicate an unknown or missing value. NULL is not equivalent to zero or an empty string.
Arithmetic or string concatenation operations involving one or more NULL operands return NULL. For example, 12 + NULL = NULL.
If you need to compare a value to NULL, use the IS operator instead of the = operator. 
The ISNULL function returns a specified alternative value for NULL columns and variables.
The NULLIF function returns NULL when a column or variable contains a specified value.
The COALESCE function returns the first non-NULL value in a specified list of columns or variables).

*/