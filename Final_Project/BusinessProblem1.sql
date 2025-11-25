/* 
Business Problem 1:  
Managers need to know which properties have been listed for a long time  
but haven't sold yet. Properties that remain unsold for too long create holding costs  
and reduce profitability.  
Here's a query that displays all properties that have been listed for more than 90 days  
without any payment transaction recorded.  
We show the property ID, street, city, listing date, and the number of days on the market. 
*/ 

SELECT p.PropertyID, a.Street, a.City, ps.ListingDate,  
DATEDIFF(DAY, ps.ListingDate, GETDATE()) AS DaysOnMarket 
FROM PropertySale as ps 
JOIN Property p ON ps.PropertyID = p.PropertyID 
JOIN Address a ON p.AddressID = a.AddressID 
LEFT JOIN ClientPropertySale cps ON ps.PropertySaleID = cps.PropertySaleID 
LEFT JOIN PaymentTransaction pt ON pt.InvoiceID IN ( 
SELECT InvoiceID FROM Invoice WHERE PaymentAccountID IN ( 
SELECT PaymentAccountID FROM PaymentAccount WHERE ClientID = 
cps.ClientID 
) 
) 
WHERE pt.PaymentTransactionID IS NULL 
AND DATEDIFF(DAY, ps.ListingDate, GETDATE()) > 90; 

/* Interpretation:  
This result shows managers which properties are stuck on the market too long. It helps them 
decide whether to adjust pricing, marketing, or strategy to reduce holding costs and improve 
profitability.  
*/