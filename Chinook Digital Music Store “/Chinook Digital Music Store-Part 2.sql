/**#Q1:Use the Invoice table to determine the countries that have the most invoices. 
Provide a table of BillingCountry and Invoices ordered by the number of invoices for each country.
The country with the most invoices should appear first*/.

SELECT Billingcountry, COUNT(Invoiceid)
FROM Invoice
GROUP BY Billingcountry
ORDER BY COUNT(Invoiceid) DESC


/**#Q2:We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns the 1 city that has the highest sum of invoice totals.
Return both the city name and the sum of all invoice totals.*/

SELECT  C.city AS city,SUM(I.total) AS Invoice_total
FROM Invoice  AS I
JOIN Customer AS C
ON I.CustomerId = C.CustomerId
GROUP BY 1
ORDER BY 2 DESC
Limit 1


/**#Q3:The customer who has spent the most money will be declared the best customer.
Build a query that returns the person who has spent the most money.
I found the solution by linking the following three: Invoice, InvoiceLine, and Customer tables to retrieve this information,
but you can probably do it with fewer!*/


SELECt C.customerid, c.firstname, c.lastname,SUM(I.total) AS total_spent
FROM Customer AS C
JOIN Invoice AS I
ON C.customerid = I.CustomerId
GROUP BY 1
ORDER BY 4 DESC
LIMIT 1


/**#Q4: The team at Chinook would like to identify all the customers who listen to Rock music.
Write a query to return the email, first name, last name, and Genre of all Rock Music listeners.
Return your list ordered alphabetically by email address starting with 'A'.*/


SELECT C.email, c.firstname,c.lastname,G.name
FROM Customer AS C
JOIN Invoice As I
ON C.customerid = I.customerid
JOIN Invoiceline AS IL
ON I.invoiceid = IL.invoiceid
JOIN Track AS T
ON IL.trackid = T.trackid
JOIN Genre AS G
ON T.genreid = G.genreid
Where G.Name = 'Rock'
Group BY 1
ORDER BY C.email


/**#Q5: Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent.
For countries where the top amount spent is shared, provide all customers who spent this amount.*/


WITH T1 as
(SELECT C.customerId AS ID,C.firstname AS firstname, C.lastname AS lastname, C.country AS Country_name, SUM(I.total) AS Total
FROM Customer AS C
JOIN Invoice AS I
ON C.customerId = I.CustomerId
GROUP BY 1,2,3,4),
T2 as
(SELECT Country_name, MAX(Total) AS Total_spent
  FROM T1
GROUP BY 1)

SELECT T1.ID, T1.firstname, T1.lastname, T1.Country_name, T2.Total_spent
FROM T1
JOIN T2
ON T1.Country_name = T2.Country_name AND T1.Total = T2.Total_spent
ORDER BY 4
