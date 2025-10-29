USE AdventureWorks2022;

SELECT TOP 500
    CONCAT(p.FirstName, ' ', ISNULL(p.MiddleName, ''), ' ', p.LastName) AS FullName,
    ea.EmailAddress AS Email,
    CONCAT(a.AddressLine1, ', ', ISNULL(a.AddressLine2, ''), ', ', a.City, ', ', sp.Name, ', ', a.PostalCode) AS Address,
    p.EmailPromotion
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
    p.FirstName LIKE '[A-C]%' -- First name starts with A, B, or C
    AND EmailPromotion > 0 -- Opted in for email promotions
ORDER BY 
    FullName ASC; -- Sort alphabetically by Full Name