-- CREATE DATABASE OnlineBookstore;
CREATE TABLE Books (
	BOOK_ID SERIAL PRIMARY KEY,
	TITLE VARCHAR(80) NOT NULL,
	AUTHOR VARCHAR(50) NOT NULL,
	GENRE VARCHAR(25) NOT NULL,
	PUBLISHED_YEAR INT NOT NULL,
	PRICE NUMERIC(5, 2) NOT NULL,
	STOCK INT NOT NULL
);

SELECT * FROM Books;

COPY 
Books(Book_id,title,author,genre,published_year,price,stock)
FROM 'C:\Users\Aman Sagar\Downloads\All Excel Practice Files\Books.csv'
DELIMITER ','
HEADER CSV;


CREATE TABLE Customers(

Customer_ID	SERIAL	PRIMARY KEY,
Name	VARCHAR(50)	NOT NULL,
Email	VARCHAR(60)	NOT NULL,
Phone	INT	NOT NULL,
City	VARCHAR(30)	NOT NULL,
Country	VARCHAR(100)	NOT NULL

);

SELECT * FROM Customers;
-- DROP TABLE Orders;
CREATE TABLE Orders (
	Order_ID	SERIAL	PRIMARY KEY,
Customer_ID	INT	REFERENCES Customers(Customer_id),
Book_ID	INT	REFERENCES Books(Book_id),
Order_Date	DATE	NOT NULL,
Quantity	INT	NOT  NULL,
Total_Amount	NUMERIC(10,2)	NOT  NULL

);

SELECT * FROM Orders;


--fiction genre
SELECT * FROM Books WHERE genre = 'Fiction';

--books published after 1950
SELECT * FROM Books WHERE published_year > 1950;

--customers from canada
SELECT  * FROM Customers WHERE country IN('Canada');

--orders placed in november2003
SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--total stocks
SELECT SUM(stock) as sum_ FROM Books;

--details of most expensive book
SELECT * FROM Books
ORDER BY PRICE desc
LIMIT 1;

--min quantity 1
SELECT * FROM Orders WHERE quantity>1;

SELECT c.name,c.customer_id,o.quantity
FROM orders o
JOIN Customers c 
ON c.customer_id =  o.customer_id
WHERE quantity>1;

--order amount > 20
SELECT * FROM Orders WHERE total_amount>20;

--all genres in the book
SELECT DISTINCT(genre) as unique FROM Books;

-- book with the lowest stock:
SELECT * FROM Books
ORDER BY stock asc
LIMIT 1;

--totol revenue generated from all orders
SELECT SUM(total_amount) as total FROM Orders;


-----------------------------------advance----------------------------------------------------
SELECT * FROM Books;
SELECT * FROM Orders;
SELECT * FROM Customers;



-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre , SUM(o.quantity) 
FROM Books b 
JOIN Orders o 
ON b.book_id = o.book_id
GROUP BY genre;



-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) FROM Books 
WHERE genre = 'Fantasy';



-- 3) List customers who have placed at least 2 orders:
SELECT c.name, Count(o.order_id)
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(order_id)>2;



-- 4) Find the most frequently ordered book:
SELECT b.book_id , b.title , Count(o.order_id) as order_count
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.book_id,b.title 
ORDER BY order_count DESC LIMIT 1;



-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY Price desc
LIMIT 3;



-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author , SUM(o.quantity) as total_quantity
FROM Books b 
JOIN Orders o 
ON b.book_id=o.book_id
GROUP BY b.author


-- 7) List the cities where customers who spent over $30 are located:
SELECT c.city 
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.city,c.customer_id
HAVING SUM(total_amount)>30;

-- SELECT DISTINCT c.city, total_amount
-- FROM orders o
-- JOIN customers c 
-- ON o.customer_id=c.customer_id
-- WHERE o.total_amount > 30;

SELECT DISTINCT  city FROM Customers;

-- 8) Find the customer who spent the most on orders:
SELECT c.name , SUM(o.total_amount) as total_amount
FROM Customers c
JOIN Orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC LIMIT 1;


-- SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
-- FROM orders o
-- JOIN customers c ON o.customer_id=c.customer_id
-- GROUP BY c.customer_id, c.name
-- ORDER BY Total_spent Desc LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title , COALESCE(SUM(o.quantity),0) AS Order_quantity
,b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM Books b 
LEFT JOIN Orders o
ON b.booK_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;

 

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity, 
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o 
ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;


