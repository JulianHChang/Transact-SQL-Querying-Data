08 - Grouping Sets and Pivoting Data


01 - Grouping Sets


SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, count(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories as cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductcategoryID
GROUP BY cat.ParentProductCategoryName, cat.ProductCategoryName
--GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
--GROUP BY ROLLUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
--GROUP BY CUBE (cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;



02 - Pivot


SELECT * FROM
(SELECT P.ProductID, PC.Name,ISNULL(P.Color, 'Uncolored') AS Color
 FROM saleslt.productcategory AS PC
 JOIN SalesLT.Product AS P
 ON PC.ProductCategoryID=P.ProductCategoryID
 ) AS PPC
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as pvt
ORDER BY Name;

-- Unpivot
CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int , multi int, uncolored int);

INSERT INTO #ProductColorPivot
SELECT * FROM
(SELECT P.ProductID, PC.Name,ISNULL(P.Color, 'Uncolored') AS Color
 FROM saleslt.productcategory AS PC
 JOIN SalesLT.Product AS P
 ON PC.ProductCategoryID=P.ProductCategoryID
 ) AS PPC
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as pvt
ORDER BY Name;

SELECT Name, Color, ProductCount
FROM
(SELECT Name,
[Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored]
FROM #ProductColorPivot) pcp
UNPIVOT
(ProductCount FOR Color IN ([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])
) AS ProductCounts







-- Unpivot
CREATE TABLE #SalesByQuarter
(ProductID int,
 Q1 money,
 Q2 money,
 Q3 money,
 Q4 money);

INSERT INTO #SalesByQuarter
VALUES
(1, 19999.00, 21567.00, 23340.00, 25876.00),
(2, 10997.00, 12465.00, 13367.00, 14365.00),
(3, 21900.00, 21999.00, 23376.00, 23676.00);

SELECT * FROM #SalesByQuarter;

SELECT ProductID, Period, Revenue
FROM
(SELECT ProductID,
Q1, Q2, Q3, Q4
FROM #SalesByQuarter) sbq
UNPIVOT
(Revenue FOR Period IN (Q1, Q2, Q3, Q4)
) AS RevenueReport


SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
  JOIN SalesLT.CustomerAddress AS ca
  ON a.AddressID = ca.AddressID
  JOIN SalesLT.Customer AS c
  ON ca.CustomerID = c.CustomerID
  JOIN SalesLT.SalesOrderHeader as soh
  ON c.CustomerID = soh.CustomerID
-- Modify GROUP BY to use ROLLUP
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;


SELECT a.CountryRegion, a.StateProvince,
  IIF(GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1, 'Total', IIF(GROUPING_ID(a.StateProvince) = 1, a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal')) AS Level,
  SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
  JOIN SalesLT.CustomerAddress AS ca
  ON a.AddressID = ca.AddressID
  JOIN SalesLT.Customer AS c
  ON ca.CustomerID = c.CustomerID
  JOIN SalesLT.SalesOrderHeader as soh
  ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;


SELECT a.CountryRegion, a.StateProvince, a.City,
  CHOOSE (1 + GROUPING_ID(a.CountryRegion) + GROUPING_ID(a.StateProvince) + GROUPING_ID(a.City),
        a.City + ' Subtotal', a.StateProvince + ' Subtotal',
        a.CountryRegion + ' Subtotal', 'Total') AS Level,
  SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
  JOIN SalesLT.CustomerAddress AS ca
  ON a.AddressID = ca.AddressID
  JOIN SalesLT.Customer AS c
  ON ca.CustomerID = c.CustomerID
  JOIN SalesLT.SalesOrderHeader as soh
  ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;



SELECT *
FROM
  (SELECT cat.ParentProductCategoryName, cust.CompanyName, sod.LineTotal
  FROM SalesLT.SalesOrderDetail AS sod
    JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN SalesLT.Customer AS cust ON soh.CustomerID = cust.CustomerID
    JOIN SalesLT.Product AS prod ON sod.ProductID = prod.ProductID
    JOIN SalesLT.vGetAllCategories AS cat ON prod.ProductcategoryID = cat.ProductCategoryID) AS catsales
PIVOT (SUM(LineTotal) FOR ParentProductCategoryName
IN ([Accessories], [Bikes], [Clothing], [Components])) AS pivotedsales
ORDER BY CompanyName;

/*
Key Points
Use PIVOT to re-orient a rowset by generating mulitple columns from values in a single column.
Use UNPIVOT to re-orient mulitple columns in a an existing rowset into a single column.
*/