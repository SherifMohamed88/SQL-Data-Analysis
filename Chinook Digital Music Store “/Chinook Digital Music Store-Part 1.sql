/** Q1:#The Chinook team decided to run a marketing campaign in Brazil, Canada, india, and Sweden.
Using the customer table, write a query that returns the first name, last name, and country for all customers from the 4 countries.*/

SELECT firstname, lastname, country
FROM Customer
Where Country IN ('Brazil', 'Canada', 'India', 'Sweden');

/** Q2: #The Chinook database contains all invoices from the beginning of 2009 till the end of 2013.
The employees at Chinook store are interested in seeing all invoices that happened in 2013 only.
Using the Invoice table, write a query that returns all the info of the invoices in 2013.*/

SELECT * FROM Invoice
Where InvoiceDate Between '2013-01-01' AND '2013-12-31'
ORDER BY InvoiceDate DESC;

/** Q3: #Using the Track and Album tables, write a query that returns all the songs that start with the letter 'A' and the composer field is not empty.
Your query should return the name of the song, the name of the composer, and the title of the album.*/

SELECT T.Name, T.Composer, A.title
From Track AS T
Join Album AS A
ON A.Albumid = T.Albumid
Where T.Composer IS NOT NULL AND T,Name ILIKE 'A%'
