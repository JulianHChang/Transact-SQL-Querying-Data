06 - Using Subqueries and APPLY


01 -  Scalar Subquery


--Display a list of products whose list price is higher than the highest unit price of items that have sold

SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail

SELECT * from SalesLT.Product
WHERE ListPrice >


SELECT * from SalesLT.Product
WHERE ListPrice >
(SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail)



02 -  Multi-Valued Subquery


--List products that have an order quantity greater than 20

SELECT Name FROM SalesLT.Product
WHERE ProductID IN
(SELECT ProductID from SalesLT.SalesOrderDetail
WHERE OrderQty>20)

SELECT Name 
FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail SOD
ON P.ProductID=SOD.ProductID
WHERE OrderQty>20



03 -  Correlated Subquery


--For each customer list all sales on the last day that they made a sale

SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
ORDER BY CustomerID,OrderDate

SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE orderdate =
(SELECT MAX(orderdate)
FROM SalesLT.SalesOrderHeader)


SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE orderdate =
(SELECT MAX(orderdate)
FROM SalesLT.SalesOrderHeader AS SO2
WHERE SO2.CustomerID = SO1.CustomerID)
ORDER BY CustomerID



04 -  CROSS APPLY


-- Setup
CREATE FUNCTION SalesLT.udfMaxUnitPrice (@SalesOrderID int)
RETURNS TABLE
AS
RETURN
SELECT SalesOrderID,Max(UnitPrice) as MaxUnitPrice FROM 
SalesLT.SalesOrderDetail
WHERE SalesOrderID=@SalesOrderID
GROUP BY SalesOrderID;

--Display the sales order details for items that are equal to
-- the maximum unit price for that sales order
SELECT * FROM SalesLT.SalesOrderDetail AS SOH
CROSS APPLY SalesLT.udfMaxUnitPrice(SOH.SalesOrderID) AS MUP
WHERE SOH.UnitPrice=MUP.MaxUnitPrice
ORDER BY SOH.SalesOrderID;



-- select the ProductID, Name, and ListPrice columns
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
-- filter based on ListPrice
WHERE ListPrice >
-- get the average UnitPrice
(SELECT avg(UnitPrice)
FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;


SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductID IN
  -- select ProductID from the appropriate table
  (SELECT ProductID
  FROM SalesLT.SalesOrderDetail
  WHERE UnitPrice < 100)
  AND ListPrice >= 100
ORDER BY ProductID;


SELECT ProductID, Name, StandardCost, ListPrice,
  -- get the average UnitPrice
  (SELECT avg(UnitPrice)
  -- from the appropriate table, aliased as SOD
  FROM SalesLT.SalesOrderDetail AS SOD
  -- filter when the appropriate ProductIDs are equal
  WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
ORDER BY P.ProductID;

SELECT ProductID, Name, StandardCost, ListPrice,
  (SELECT AVG(UnitPrice)
  FROM SalesLT.SalesOrderDetail AS SOD
  WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
-- filter based on StandardCost
WHERE StandardCost >
-- get the average UnitPrice
(SELECT avg(UnitPrice)
-- from the appropriate table aliased as SOD
FROM SalesLT.SalesOrderDetail AS SOD
-- filter when the appropriate ProductIDs are equal
WHERE P.ProductID = SOD.ProductID)
ORDER BY P.ProductID;


-- select SalesOrderID, CustomerID, FirstName, LastName, TotalDue from the appropriate tables
SELECT SOH.SalesOrderID, SOH.CustomerID, CI.FirstName, CI.LastName, SOH.TotalDue
FROM SalesLT.SalesOrderHeader AS SOH
-- cross apply as per the instructions
cross apply dbo.ufnGetCustomerInformation(SOH.CustomerID) AS CI
-- finish the clause
ORDER by SOH.SalesOrderID;




-- select the CustomerID, FirstName, LastName, Addressline1, and City columns from the appropriate tables
SELECT CA.CustomerID, FirstName, LastName, A.Addressline1, A.City
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
  -- join based on AddressID
  ON A.AddressID = CA.AddressID
-- cross apply as per instructions
cross apply dbo.ufnGetCustomerInformation(CA.CustomerID) AS CI
ORDER BY CA.CustomerID;


/*
Key Points
The APPLY operator enables you to execute a table-valued function for each row in a rowset returned by a SELECT statement. Conceptually, this approach is similar to a correlated subquery.
CROSS APPLY returns matching rows, similar to an inner join. OUTER APPLY returns all rows in the original SELECT query results with NULL values for rows where no match was found.
*/