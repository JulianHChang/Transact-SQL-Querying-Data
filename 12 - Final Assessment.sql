/*   section 1   */

Select ProductID, ProductName, UnitPrice
from dbo.products
order by UnitsInStock desc
offset 10 ROWS FETCH NEXT 5 rows only;


select FirstName + ' has an EmployeeID of ' + convert(varchar(5),EmployeeID) + ' and was born ' + CONVERT(NVARCHAR(30), BirthDate, 126)
from dbo.employees;


select ShipName + ' is from ' + Coalesce(ShipCity , ShipRegion , ShipCountry)
from dbo.orders;

select ShipName, IsNull(ShipPostalCode, 'unknown')
from dbo.orders;

SELECT CompanyName,
  CASE
    WHEN Fax IS NOT NULL THEN 'outdated'
    ELSE 'modern' 
  END AS Status
FROM Suppliers;


/*   section 2   */
-- Select all the different countries from tables
select distinct Country
from dbo.customers
UNION
select distinct Country
from dbo.Suppliers

-- Select all the countries, including duplicates
select  Country
from dbo.customers
UNION ALL
select  Country
from dbo.Suppliers




/* Section 3   */
select ProductName, UnitPrice
from dbo.Products
where UnitPrice >
(select avg(UnitPrice) from dbo.[Order Details])



Create TABLE #ProductNames (
ProductName VARCHAR(40)
);

Insert Into #ProductNames
Select ProductName from Products;
 
Select * from #ProductNames;

/* Section 4                                     */
Select OrderID, ShippedDate,
    choose (month(ShippedDate), 'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') as ShippedSeason
from dbo.Orders
where month(ShippedDate) is NOT NULL;

select companyname,
    IIF(FAX IS NOT NULL, 'outdated', 'modern') AS Status
from dbo.Suppliers


SELECT Country, ContactTitle, COUNT(ContactTitle) AS Count,
  CASE
    WHEN GROUPING_ID(Country, ContactTitle) = 0 THEN ''
    WHEN GROUPING_ID(Country, ContactTitle) = 1 THEN 'Subtotal for ' + Country
  END AS Legend
FROM Customers
GROUP BY ROLLUP (Country, ContactTitle);



SELECT 'Average Unit Price' AS 'Per Category', 
[1], [2], [3], [4], [5], [6], [7], [8]
from
(SELECT CategoryID, UnitPrice
FROM Products) as SourceTable
Pivot
(
AVG(UnitPrice)
FOR CategoryID in ([1], [2], [3], [4], [5], [6], [7], [8])
) AS PivotTable; 


UPDATE Region
SET RegionDescription = UPPER(RegionDescription);

SELECT *
FROM Region;

/*  #8 needs help  */