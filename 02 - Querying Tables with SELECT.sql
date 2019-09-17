02 - Querying Tables with SELECT


01 -  Eliminating Duplicates and Sorting Results


--Display a list of product colors
SELECT Color FROM SalesLT.Product;

--Display a list of product colors with the word 'None' if the value is null
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM SalesLT.Product;

--Display a list of product colors with the word 'None' if the value is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM SalesLT.Product ORDER BY Color;

--Display a list of product colors with the word 'None' if the value is null and a dash if the size is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color, ISNULL(Size, '-') AS Size FROM SalesLT.Product ORDER BY Color;


--Display the top 100 products by list price
SELECT TOP 100 Name, ListPrice FROM SalesLT.Product ORDER BY ListPrice DESC;

--Display the first ten products by product number
SELECT Name, ListPrice FROM SalesLT.Product ORDER BY ProductNumber OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; 

--Display the next ten products by product number
SELECT Name, ListPrice FROM SalesLT.Product ORDER BY ProductNumber OFFSET 10 ROWS FETCH FIRST 10 ROW ONLY;


02 -  Filtering with Predicates


--List information about product model 6
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID = 6;

--List information about products that have a product number beginning FR
SELECT productnumber,Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'FR%';

--Filter the previous query to ensure that the product number contains two sets of two didgets
SELECT Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

--Find products that have no sell end date
SELECT Name FROM SalesLT.Product WHERE SellEndDate IS NOT NULL;

--Find products that have a sell end date in 2006
SELECT Name FROM SalesLT.Product WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

--Find products that have a category ID of 5, 6, or 7.
SELECT ProductCategoryID, Name, ListPrice FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7);

--Find products that have a category ID of 5, 6, or 7 and have a sell end date
SELECT ProductCategoryID, Name, ListPrice, SellEndDate FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7) AND SellEndDate IS NULL;

--Select products that have a category ID of 5, 6, or 7 and a product number that begins FR
SELECT Name, ProductCategoryID, ProductNumber FROM SalesLT.Product WHERE ProductNumber LIKE 'FR%' OR ProductCategoryID IN (5,6,7);


SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
-- offset 10 rows and get the next 100
OFFSET 10 rows fetch NEXT 100 rows ONLY;


-- select the ProductNumber and Name columns
SELECT ProductNumber, Name
FROM SalesLT.Product
-- check that Color is one of 'Black', 'Red' or 'White'
-- check that Size is one of 'S' or 'M'
WHERE Color IN ('Black', 'Red' , 'White') AND Size IN ('S' , 'M');


-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for product numbers beginning with BK- using LIKE
WHERE ProductNumber like 'BK-%';

-- Remember:
-- to match any string of zero or more characters, use %
-- to match characters that are not R, use [^R]

to match a numeral,
use [0-9]
-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for ProductNumbers
WHERE ProductNumber LIKE 'BK-[^R]%%%-[0-9][0-9]';



/*
Key Points
Use the WHERE clause to filter the results returned by a SELECT query based on a search condition.
A search condition is composed of one or more predicates.
Predicates include conditional operators (such as =, >, and <), IN, LIKE, and NOT.
You can use AND and OR to combine predicates based on Boolean logic.
*/