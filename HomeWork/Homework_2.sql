USE AdventureWorks2022;

-- Question 1 --

SELECT TOP 500
    CONCAT(p.FirstName, ' ', ISNULL(p.MiddleName, ''), ' ', p.LastName) AS FullName,
    ea.EmailAddress AS Email,
    CONCAT(a.AddressLine1, ', ', ISNULL(a.AddressLine2, ''), ', ', a.City, ', ', sp.Name, ', ', a.PostalCode) AS Address
FROM Sales.Customer AS c
JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
JOIN Person.Address AS a
    ON c.PersonID = a.AddressID
JOIN Person.StateProvince AS sp
    ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.EmailAddress AS ea
    ON p.BusinessEntityID = ea.BusinessEntityID
WHERE 
    p.FirstName LIKE '[A-C]%'   -- First name starts with A, B, or C
    AND EmailPromotion > 0   -- Opted in for email promotions
ORDER BY 
    FullName ASC; -- Sort alphabetically by Full Name

-- Question 2 --
SELECT DISTINCT
    p.ProductID,
    p.Name,
    sum(so.OrderQty) AS TotalUnitsSold,
    sum(so.OrderQty * so.UnitPrice) AS SalesRevenue
FROM sales.SalesOrderDetail as so
JOIN Production.Product as p
    ON so.ProductID = p.ProductID
join sales.SalesOrderHeader as sh
    ON so.SalesOrderID = sh.SalesOrderID
WHERE p.Style = 'w' OR p.Style = 'W'
    AND sh.OrderDate >= '2013-01-01'
GROUP BY p.ProductID, p.Name


-- Question 3 --
-- Section a --
IF OBJECT_ID('Production.ProductWarranty', 'U') IS NOT NULL
    DROP TABLE Production.ProductWarranty;
GO

CREATE TABLE Production.ProductWarranty
(
    WarrantyID   INT            IDENTITY(1,1) NOT NULL,
    ProductID    INT            NOT NULL,
    WarrantyType VARCHAR(20)    NOT NULL,           -- Standard | Extended | Premium
    Duration     TINYINT        NOT NULL,           -- 12 | 24 | 36
    Cost         MONEY          NOT NULL,           -- >= 0 (POC)

    CONSTRAINT PK_ProductWarranty
        PRIMARY KEY CLUSTERED (WarrantyID),

    CONSTRAINT FK_ProductWarranty_Product
        FOREIGN KEY (ProductID)
        REFERENCES Production.Product(ProductID),

    -- Makes sure the type and duration match
    CONSTRAINT CK_ProductWarranty_TypeDuration
        CHECK (
            (WarrantyType = 'Standard' AND Duration = 12) OR
            (WarrantyType = 'Extended' AND Duration = 24) OR
            (WarrantyType = 'Premium'  AND Duration = 36)
        ),

    -- Non negative cost
    CONSTRAINT CK_ProductWarranty_Cost
        CHECK (Cost >= 0),

    -- No dupplicates of a product
    CONSTRAINT UQ_ProductWarranty_Product_Type
        UNIQUE (ProductID, WarrantyType)
);

-- Section b --
INSERT INTO Production.ProductWarranty (ProductID, WarrantyType, Duration, Cost)
VALUES
(707, 'Standard', 12, 50),
(708, 'Standard', 12, 62),
(709, 'Extended', 24, 95),
(710, 'Extended', 24, 110),
(712, 'Extended', 24, 137),
(714, 'Premium',  36, 200),
(716, 'Standard', 12, 75),
(720, 'Extended', 24, 105),
(721, 'Premium',  36, 190),
(725, 'Premium',  24, 210);

-- There will be an error on line 94 
-- The INSERT statement conflicted with the CHECK constraint "CK_ProductWarranty_TypeDuration".
-- This is due to violation of the unique constraint. The premium warranty is of a durantion of 36 not 24


-- Section c --
SELECT 
    p.Name AS [Product Name],
    pc.Name AS [Category Name],
    psc.Name AS [Subcategory Name],
    pw.WarrantyType,
    pw.Duration,
    pw.Cost
FROM Production.ProductWarranty AS pw
INNER JOIN Production.Product AS p
    ON pw.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Clothing'
ORDER BY pw.Cost DESC;

-- section d --
IF OBJECT_ID('Production.ProductWarranty', 'U') IS NOT NULL
BEGIN
    DROP TABLE Production.ProductWarranty;
    PRINT 'Table Production.ProductWarranty has been deleted successfully.';
END