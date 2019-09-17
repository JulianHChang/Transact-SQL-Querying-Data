10 - Programming with Transact-SQL


00 -  Setup


IF OBJECT_ID('SalesLT.DemoTable') IS NOT NULL
	BEGIN
	DROP TABLE SalesLT.DemoTable
	END
GO


CREATE TABLE SalesLT.DemoTable
(ID INT IDENTITY(1,1),
Description Varchar(20),
CONSTRAINT [PK_DemoTable] PRIMARY KEY CLUSTERED(ID) 
)
GO



01 -  Variables


--Search by city using a variable
DECLARE @City VARCHAR(20)='Toronto'
Set @City='Bellevue'



Select FirstName +' '+LastName as [Name],AddressLine1 as Address,City
FROM SalesLT.Customer as C
JOIN SalesLT.CustomerAddress as CA
ON C.CustomerID=CA.CustomerID
JOIN SalesLT.Address as A
ON CA.AddressID=A.AddressID
WHERE City=@City

--Use a variable as an output
DECLARE @Result money
SELECT @Result=MAX(TotalDue)
FROM SalesLT.SalesOrderHeader

PRINT @Result


02 -  If Else


--Simple logical test
If 'Yes'='Yes'
Print 'True'

--Change code based on a condition
UPDATE SalesLT.Product
SET DiscontinuedDate=getdate()
WHERE ProductID=1;

IF @@ROWCOUNT<1
BEGIN
	PRINT 'Product was not found'
END
ELSE
BEGIN
	PRINT 'Product Updated'
END



03 -  While


DECLARE @Counter int=1

WHILE @Counter <=5

BEGIN
	INSERT SalesLT.DemoTable(Description)
	VALUES ('ROW '+CONVERT(varchar(5),@Counter))
	SET @Counter=@Counter+1
END

SELECT Description FROM SalesLT.DemoTable


--Testing for existing values
DECLARE @Counter int=1

DECLARE @Description int
SELECT @Description=MAX(ID)
FROM SalesLT.DemoTable

WHILE @Counter <5
BEGIN
	INSERT SalesLT.DemoTable(Description)
	VALUES ('ROW '+CONVERT(varchar(5),@Description))
	SET @Description=@Description+1
	SET @Counter=@Counter+1
END

SELECT Description FROM SalesLT.DemoTable



04 - Stored Procedure


-- Create a stored procedure
CREATE PROCEDURE SalesLT.GetProductsByCategory (@CategoryID INT = NULL)
AS
IF @CategoryID IS NULL
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product
ELSE
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product
	WHERE ProductCategoryID = @CategoryID;


-- Execute the procedure without a parameter
EXEC SalesLT.GetProductsByCategory

-- Execute the procedure with a parameter
EXEC SalesLT.GetProductsByCategory 6



DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;

INSERT INTO SalesLT.SalesOrderHeader
  (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES
  (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

PRINT SCOPE_IDENTITY();



-- Code from previous exercise
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
INSERT INTO SalesLT.SalesOrderHeader
  (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES
  (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');
DECLARE @OrderID int = SCOPE_IDENTITY();

-- Additional script to complete
DECLARE @ProductID int = 760;
DECLARE @Quantity int = 1;
DECLARE @UnitPrice money = 782.99;

IF exists (SELECT *
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = @OrderID)
BEGIN
  INSERT INTO SalesLT.SalesOrderDetail
    (SalesOrderID, OrderQty, ProductID, UnitPrice)
  VALUES
    (@OrderID, @Quantity, @ProductID, @UnitPrice)
END
ELSE

/*
need help
*/


/*
Key Points
Use stored procedures to encapsulate Transact-SQL code in a reusable database objects.
You can define parameters for a stored procedure, and use them as variables in the Transact-SQL code it contains.
Stored procedures can return rowsets (usually the results of a SELECT statement). They can also return output parameters, and they always return a return value, which is used to indicate status.
*/