/* Business Problem 3:
Managers need to track invoices that are overdue and the most commonly used
payment methods. This helps them identify which payment methods are the most
associated with payment risks and therefore can help reduce risk ofunpaid fees.
Here's a query that displays the number of invoices and the total overdue amount
grouped by payment method.
We show only the payment methods with at least one overdue invoice.
*/

SELECT pm.Method
COUNT(i.InvoiceID) AS OverdueInvoices,
SUM(i.TotalAmount) AS TotalOverdueAmount
FROM Invoice i
JOIN PaymentAccount pa ON i.PaymentAccountID = pa.PaymentAccountID
JOIN PaymentMethod pm ON pa.PaymentAccountID = pm.PaymentAccountID
WHERE i.Deadline < GETDATE()
GROUP BY pm.Method
HAVING COUNT(i.InvoiceID) > 0
ORDER BY TotalOverdueAmount DESC;

/* Interpretation:
This result identifies which payment methods are most associated with overdue invoices.
Managers can focus on reducing risk by tightening policies or offering safer alternatives for
those methods.
*/