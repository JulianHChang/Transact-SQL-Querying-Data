11 - Error Handling and Transactions


01 - Raising Errors


-- View a system error
INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
VALUES
(100000, 1, 680, 1431.50, 0.00);





-- Raise an error with RAISERROR
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	RAISERROR('The product was not found - no products have been updated', 16, 0);





-- Raise an error with THROW
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	THROW 50001, 'The product was not found - no products have been updated', 0;


02 - Handling Errors


-- catch an error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:';
	PRINT ERROR_MESSAGE();
END CATCH;

-- Catch and rethrow
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:';
	PRINT ERROR_MESSAGE();
	THROW;
END CATCH;

-- Catch, log, and throw a custom error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	DECLARE @ErrorLogID as int, @ErrorMsg AS varchar(250);
	EXECUTE dbo.uspLogError @ErrorLogID OUTPUT;
	SET @ErrorMsg = 'The update failed because of an error. View error #'
	                 + CAST(@ErrorLogID AS varchar)
					 + ' in the error log for details.';
	THROW 50001, @ErrorMsg, 0;
END CATCH;

-- View the error log
SELECT * FROM dbo.ErrorLog;


03 - Transactions


-- No transaction
BEGIN TRY
	INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

	DECLARE @SalesOrderID int = SCOPE_IDENTITY();

	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 1431.50, 0.00);
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

-- View orphaned orders
SELECT h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON d.SalesOrderID = h.SalesOrderID
WHERE D.SalesOrderDetailID IS NULL;

-- Manually delete orphaned record
DELETE FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = SCOPE_IDENTITY();

-- Use a transaction
BEGIN TRY
  BEGIN TRANSACTION
	INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

	DECLARE @SalesOrderID int = SCOPE_IDENTITY();

	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 1431.50, 0.00);
  COMMIT TRANSACTION
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
  BEGIN
    PRINT XACT_STATE();
	ROLLBACK TRANSACTION;
  END
  PRINT ERROR_MESSAGE();
  THROW 50001,'An insert failed. The transaction was cancelled.', 0;
END CATCH;

-- Check for orphaned orders
SELECT h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON d.SalesOrderID = h.SalesOrderID
WHERE D.SalesOrderDetailID IS NULL

-- Use XACT_ABORT
SET XACT_ABORT ON;
BEGIN TRY
  BEGIN TRANSACTION
	INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

	DECLARE @SalesOrderID int = SCOPE_IDENTITY();

	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 1431.50, 0.00);
  COMMIT TRANSACTION
END TRY
BEGIN CATCH
  PRINT ERROR_MESSAGE();
  THROW 50001,'An insert failed. The transaction was cancelled.', 0;
END CATCH;
SET XACT_ABORT OFF;

-- Check for orphaned orders
SELECT h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS h
LEFT JOIN SalesLT.SalesOrderDetail AS d
ON d.SalesOrderID = h.SalesOrderID
WHERE D.SalesOrderDetailID IS NULL


DECLARE @OrderID int = 0

-- Declare a custom error if the specified order doesn't exist
declare @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

IF NOT exists (SELECT *
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = @OrderID)
BEGIN
THROW 50001, @error, 0;
END
ELSE
BEGIN
  SELECT *
  FROM SalesLT.SalesOrderDetail
  WHERE  SalesOrderID = @OrderID
  DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
end


DECLARE @OrderID int = 71774
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

-- Wrap IF ELSE in a TRY block
Begin try
  IF NOT EXISTS (SELECT *
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
  DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
  DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
END
end
try
-- Add a CATCH block to print out the error
Begin catch
PRINT ERROR_MESSAGE();
end catch


DECLARE @OrderID int = 0
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

BEGIN TRY
  IF NOT EXISTS (SELECT *
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
  BEGIN TRANSACTION
  DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;
  DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID;
  COMMIT TRANSACTION
END
END
TRY
BEGIN CATCH


/*
Key Points
Transactions are used to protect data integrity by ensuring that all data changes within a transaction succeed or fail as a unit.
Individual Transact-SQL statements are inherently treated as transactions, and you can define explicit transactions that encompass mulitple statements.
Use the BEGIN TRANSACTION, COMMIT TRANSACTION, and ROLLBACK TRANSACTION statements to manage transactions.
Enable the XACT_ABORT option to automatically rollback all transactions if an exception occurs.
Use the @@TRANCOUNT system variable and XACT_STATE system function to determine transaction status.
*/