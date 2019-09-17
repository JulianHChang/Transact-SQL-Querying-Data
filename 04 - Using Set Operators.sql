04
- Using
Set Operators


01
-  Union


-- Setup
CREATE VIEW [SalesLT].[Customers]
as
    select distinct firstname, lastname
    from saleslt.customer
    where lastname >='m'
        or customerid=3;
GO
CREATE VIEW [SalesLT].[Employees]
as
    select distinct firstname, lastname
    from saleslt.customer
    where lastname <='m'
        or customerid=3;
GO

-- Union example
    SELECT FirstName, LastName
    FROM SalesLT.Employees
UNION
    SELECT FirstName, LastName
    FROM SalesLT.Customers
ORDER BY LastName
;





02 -  Intersect


    SELECT FirstName, LastName
    FROM SalesLT.Customers
INTERSECT
    SELECT FirstName, LastName
    FROM SalesLT.Employees
;



03 -  Except


    SELECT FirstName, LastName
    FROM SalesLT.Customers
EXCEPT
    SELECT FirstName, LastName
    FROM SalesLT.Employees;





    SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
    FROM SalesLT.Customer AS c
        JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
        JOIN SalesLT.Address AS a
        ON ca.AddressID = a.AddressID
    WHERE ca.AddressType = 'Main Office'
UNION ALL
    SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
    FROM SalesLT.Customer AS c
        JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
        JOIN SalesLT.Address AS a
        ON ca.AddressID = a.AddressID
    WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;




    SELECT c.CompanyName
    FROM SalesLT.Customer AS c
        -- join the CustomerAddress table
        JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
        JOIN SalesLT.Address AS a
        -- join based on AddressID
        ON ca.AddressID = a.AddressID
    WHERE ca.AddressType = 'Main Office'
EXCEPT
    SELECT c.CompanyName
    FROM SalesLT.Customer AS c
        -- use the appropriate join to join the CustomerAddress table
        join SalesLT.CustomerAddress AS ca
        -- join based on CustomerID
        ON c.CustomerID = ca.CustomerID
        -- use the appropriate join to join the Address table
        join SalesLT.Address AS a
        ON ca.AddressID = a.AddressID


-- select the CompanyName column
    Select c.CompanyName
    -- from the appropriate table
    FROM SalesLT.Customer AS c
        -- use the appropriate join with the appropriate table
        join SalesLT.CustomerAddress AS ca
        -- join based on CustomerID
        ON c.CustomerID = ca.CustomerID
        -- use the appropriate join with the appropriate table
        JOIN SalesLT.Address AS a
        -- join based on AddressID
        ON ca.AddressID = a.AddressID
    -- filter based on AddressType
    where ca.AddressType = 'Main Office'
INTERSECT
    -- select the CompanyName column
    SELECT c.CompanyName
    FROM SalesLT.Customer AS c
        -- use the appropriate join with the appropriate table
        JOIN SalesLT.CustomerAddress AS ca
        ON c.CustomerID = ca.CustomerID
        JOIN SalesLT.Address AS a
        -- join based on AddressID
        ON ca.AddressID = a.AddressID
    -- filter based on AddressType
    Where ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;

/*
Key Points
Use INTERSECT to return only rows that are returned by both queries.
Use EXCEPT to return rows from the first query that are not returned by the second query.
*/