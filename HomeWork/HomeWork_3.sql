/*		TECH 20712A -- Database creation and operation
 *		
 *		HEC MontrÃ©al
 *		Homework 3
 *		Instructor : Monalisa Mahapatra (A01)
 *		
 *		ANSWERS TO HOMEWORK 3
 */
 
use AdventureWorks2022

/*
	Question #1 : 
		The Sales Director is interested in the details of AdventureWorks' largest sale recorded in the first quarter of 2014, based on the 
		total due. He needs the following details:

			- the invoice number
			- the total due, including taxes, shipping, etc., displayed in currency format
			- the date of sale (excluding hours, minutes, etc.)
			- the sales person's ID
			- the full name (including title, middle name, suffix, etc.) of the sales person who made the sale, all in a single cell; the full
				name must be perfectly formatted, eliminating any unnecessary spaces.
			- the number of products included in the sale.

		He takes the trouble to mention that he only wants the details of this sale (the largest recorded by AdventureWorks in the first quarter of 2014).
		He therefore expects you to give him a single line of result.
*/

SELECT TOP 1
	soh.SalesOrderNumber AS 'Invoice Number',
	soh.TotalDue 'Total Due',
	CAST(soh.OrderDate AS DATE) AS 'Date of Sale',
	soh.SalesPersonID AS 'Sales Person ID',
	TRIM(CONCAT(' ',
		ISNULL(sp.Title, ''),
        ' ',
		sp.FirstName,
        ' ',
		ISNULL(sp.MiddleName,''),
        ' ',
		sp.LastName,
        ' ',
		ISNULL(sp.Suffix,'')
	)) AS 'Full Name',
	COUNT(sod.SalesOrderDetailID) AS 'Number of Products'
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Sales.SalesPerson sp_rel ON soh.SalesPersonID = sp_rel.BusinessEntityID
INNER JOIN Person.Person sp ON sp_rel.BusinessEntityID = sp.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2014
	AND MONTH(soh.OrderDate) IN (1, 2, 3)
GROUP BY 
	soh.SalesOrderNumber,
	soh.TotalDue,
	soh.OrderDate,
	soh.SalesPersonID,
	sp.Title,
	sp.FirstName,
	sp.MiddleName,
	sp.LastName,
	sp.Suffix
ORDER BY soh.TotalDue DESC;

GO

/*
	Question #2 :
		The Sales Director would also like to know which stores have a sum subtotal sales in the first quarter of 2014 that is higher than 
		the average subtotal sales of all stores in the last quarter of 2013.

		Obviously, this only refers to sales made in stores.

		He specifies that he needs the report to display only the store ID and name, sorted from smallest to largest store ID.
*/

WITH AvgQ4_2013 AS (
	SELECT AVG(soh.SubTotal) AS AvgSubTotal
	FROM Sales.SalesOrderHeader soh
	WHERE soh.CustomerID IN (SELECT CustomerID FROM Sales.Customer WHERE StoreID IS NOT NULL)
		AND YEAR(soh.OrderDate) = 2013
		AND MONTH(soh.OrderDate) IN (10, 11, 12)
),
Q1_2014_Stores AS (
	SELECT 
		c.StoreID,
		s.Name,
		SUM(soh.SubTotal) AS TotalSubTotal
	FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	INNER JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
	WHERE YEAR(soh.OrderDate) = 2014
		AND MONTH(soh.OrderDate) IN (1, 2, 3)
		AND c.StoreID IS NOT NULL
	GROUP BY c.StoreID, s.Name
)
SELECT 
	q1.StoreID,
	q1.Name
FROM Q1_2014_Stores q1
CROSS JOIN AvgQ4_2013 avg
WHERE q1.TotalSubTotal > avg.AvgSubTotal
ORDER BY q1.StoreID;

GO

/*
	Question #3 :
		The person in charge of manufacturing invites you to lunch! But, as there's never a free meal, it turns out she needs a report on the manufacturing delays 
		AdventureWorks has experienced... You should have bought your own sandwich!

		More specifically, she would like to know how many work orders were delayed by a given number of days. Her report should have two columns.

		The first column, titled "Delays (in days)", would show the different numbers of days of delay. Instead of displaying 0 for work orders without delays,
		it would show "On time". The second column, titled "Number of work orders", would show the number of work orders associated with the different delays.
		Something like the following:
		
		Delays (in days)	| Number of work orders
		On time				| 49801
		1					| 2656
		3					| 2736
		...					| ...

		All sorted by Delays (in days) (ascending order).
*/

WITH DelayCalculation AS (
	SELECT 
		CASE 
			WHEN DATEDIFF(DAY, wh.ScheduledEndDate, wh.ActualEndDate) <= 0 THEN 'On time'
			ELSE CAST(DATEDIFF(DAY, wh.ScheduledEndDate, wh.ActualEndDate) AS VARCHAR(10))
		END AS DelayValue,
		DATEDIFF(DAY, wh.ScheduledEndDate, wh.ActualEndDate) AS DelaySortValue
	FROM Production.WorkOrder wo
	INNER JOIN Production.WorkOrderRouting wh ON wo.WorkOrderID = wh.WorkOrderID
	WHERE wh.ActualEndDate IS NOT NULL
)
SELECT 
	DelayValue AS 'Delays (in days)',
	COUNT(*) AS 'Number of work orders'
FROM DelayCalculation
GROUP BY DelayValue, DelaySortValue
ORDER BY CASE WHEN DelaySortValue <= 0 THEN 0 ELSE DelaySortValue END;

GO

/*
	Question #4 :
		It's late Friday afternoon and your friend, the Sales Director, has one last request for the week!! (At least, that's what you hope...)

		Essentially, he would like a report on discounted products and some details regarding the payment method. More specifically, the following data:

			- the product number sold at a reduced price
			- the invoice number
			- the invoice number transformed by keeping the first two characters, followed by the "_" and ending with the rest of the digits
			- the ID of the discount
			- the discount description
			- the discount percentage (in % format)
			- the type of discount
			- a text indicator (Yes/No) indicating whether the product was paid for by credit card or not.

		He wants the report to be sorted by the percentage of the discount in descending order.
*/

SELECT 
	p.ProductNumber AS 'Product Number',
	soh.SalesOrderNumber AS 'Invoice Number',
	SUBSTRING(soh.SalesOrderNumber, 1, 2) + '_' + SUBSTRING(soh.SalesOrderNumber, 3, LEN(soh.SalesOrderNumber)) AS 'Transformed Invoice Number',
	sd.SpecialOfferID AS 'Discount ID',
	so.Description AS 'Discount Description',
	FORMAT(so.DiscountPct, 'P') AS 'Discount Percentage',
	so.Type AS 'Type of Discount',
	CASE 
		WHEN soh.CreditCardID IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END AS 'Credit Card Payment'
FROM Sales.SalesOrderDetail sd
INNER JOIN Sales.SalesOrderHeader soh ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product p ON sd.ProductID = p.ProductID
INNER JOIN Sales.SpecialOffer so ON sd.SpecialOfferID = so.SpecialOfferID
WHERE sd.SpecialOfferID != 1 -- Exclude No Discount
ORDER BY so.DiscountPct DESC;
