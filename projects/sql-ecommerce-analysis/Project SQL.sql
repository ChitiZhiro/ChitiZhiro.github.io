create database Project
use project

select * from sales
select * from customers
select * from products


#QUESTIONS

#1.  Find all products in the 'Electronics' category whose selling price is greater than 50,000.

SELECT * FROM PRODUCTS 
WHERE CATEGORY = 'ELECTRONICS' 
AND SELLING_PRICE > 50000


#2.  Retrieve all sales orders where the quantity ordered is greater than or equal to 2 and the payment mode is 'UPI'.

SELECT * FROM SALES 
WHERE QUANTITY >= 2 
AND PAYMENT_MODE = 'UPI'


#3.  Retrieve customers whose email addresses end with '@gmail.com'.

SELECT * FROM CUSTOMERS 
WHERE EMAIL 
LIKE '%@GMAIL.COM'


#4. Find all products whose name contains the word 'Laptop' using the LIKE operator.

SELECT * FROM PRODUCTS 
WHERE PRODUCT_NAME 
LIKE '%LAPTOP%'


#5. List the top 5 most expensive products based on their Original_Price.

SELECT * FROM PRODUCTS 
ORDER BY ORIGINAL_PRICE DESC LIMIT 5


#6. Retrieve the 10 most recent orders based on Order_Date and Order_Time.

SELECT * FROM SALES 
ORDER BY ORDER_DATE DESC , 
ORDER_TIME DESC LIMIT 10


#7. Calculate the average selling price and total stock quantity for each product category.

SELECT CATEGORY , AVG(SELLING_PRICE) AS AVG_SELL_PRICE , 
SUM(STOCK_QUANTITY) AS TOTAL_STOCK_QUANTITY 
FROM PRODUCTS GROUP BY CATEGORY


#8. Find the total sales revenue generated and the total number of orders for each payment mode.

SELECT PAYMENT_MODE, SUM(TOTAL_AMOUNT) AS TOTAL_SALES_REVENUE, 
COUNT(*) AS TOTAL_NUMBER_OF_ORDERS 
FROM SALES GROUP BY PAYMENT_MODE


#9. Find product categories where the average discount percentage is greater than 28%.

SELECT 	CATEGORY , AVG(DISCOUNT_PERCENT) 
FROM PRODUCTS GROUP BY CATEGORY 
HAVING AVG(DISCOUNT_PERCENT) > 28


#10. List cities where the total sales amount exceeds 100,000.

SELECT CITY , SUM(TOTAL_AMOUNT) 
FROM SALES GROUP BY CITY 
HAVING SUM(TOTAL_AMOUNT) > 100000


#11. Retrieve order details along with the corresponding customer's name and customer tier.

SELECT C.CUSTOMER_ID, S.ORDER_ID, 
C.CUSTOMER_NAME, C.CUSTOMER_TIER, S.ORDER_DATE, 
S.ORDER_TIME, S.ORDER_VALUE, S.ORDER_STATUS 
FROM CUSTOMERS AS C
JOIN SALES AS S ON C.CUSTOMER_ID = S.CUSTOMER_ID



#12. Get a list of orders showing the Order ID, Product Name, Category, and Quantity purchased.

SELECT S.ORDER_ID, P.PRODUCT_NAME, 
P.CATEGORY, S.QUANTITY FROM SALES AS S
JOIN PRODUCTS AS P ON P.PRODUCT_ID = S.PRODUCT_ID


#13. Generate a complete report showing Customer Name, Product Name, Category, Order Date, and Total Amount for every transaction.

select * from sales
select * from customers
select * from products

SELECT C.CUSTOMER_NAME, P.PRODUCT_NAME, 
P.CATEGORY, S.ORDER_DATE, S.TOTAL_AMOUNT
FROM SALES AS S 
JOIN CUSTOMERS AS C 
ON S.CUSTOMER_ID = C.CUSTOMER_ID
JOIN PRODUCTS AS P 
ON P.PRODUCT_ID = S.PRODUCT_ID



#14. Find customers who have never placed any orders (Total_Orders = 0 or missing in sales).

SELECT DISTINCT ORDER_STATUS FROM SALES


SELECT * FROM CUSTOMERS AS C
JOIN SALES AS S
ON C.CUSTOMER_ID = S.CUSTOMER_ID
WHERE C.TOTAL_ORDERS = 0



SELECT C.* 
FROM CUSTOMERS AS C
LEFT JOIN SALES AS S ON C.CUSTOMER_ID = S.CUSTOMER_ID
WHERE S.CUSTOMER_ID IS NULL;

SELECT * FROM CUSTOMERS
WHERE TOTAL_ORDERS = 0


SELECT * 
FROM Customers 
WHERE Total_Orders = 0 
   OR Customer_ID NOT IN (SELECT DISTINCT Customer_ID FROM Sales)
   
   
SELECT DISTINCT Customer_ID FROM Sales WHERE Customer_ID IS NOT NULL


#15. Find all products whose selling price is higher than the overall average selling price of all products.

SELECT AVG(SELLING_PRICE) 
FROM PRODUCTS

SELECT * FROM PRODUCTS 
WHERE SELLING_PRICE > (SELECT AVG(SELLING_PRICE) FROM PRODUCTS)


#16. Retrieve customers whose total amount spent is greater than the average total spent across all customers.

SELECT AVG(TOTAL_SPENT) FROM CUSTOMERS

SELECT * FROM CUSTOMERS 
WHERE TOTAL_SPENT > (SELECT AVG(TOTAL_SPENT) FROM CUSTOMERS)

SELECT *
FROM CUSTOMERS AS C1
WHERE C1.TOTAL_SPENT > (
    SELECT AVG(x.total_spent)
    FROM (
        SELECT CUSTOMER_NAME, SUM(TOTAL_SPENT) AS total_spent
        FROM CUSTOMERS
        GROUP BY CUSTOMER_NAME
    ) AS x
);

#17. List product details for products that appear in the sales table using a subquery with IN.

select * from sales
select * from customers
select * from products

SELECT * FROM PRODUCTS 
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM SALES)


#18. Find the maximum total spent for each customer tier using a grouped subquery approach.

SELECT CUSTOMER_TIER, MAX(TOTAL_SPENT) 
FROM CUSTOMERS GROUP BY CUSTOMER_TIER



SELECT MAX(TOTAL_SPENT) FROM CUSTOMERS


#19. Calculate total revenue generated per product category by joining sales and products, sorted from highest to lowest revenue.

select * from products
select * from sales
select * from customers

SELECT P.CATEGORY, SUM(S.TOTAL_AMOUNT) AS TOTAL_REVENUE FROM PRODUCTS AS P
JOIN SALES AS S ON P.PRODUCT_ID = S.PRODUCT_ID
GROUP BY P.CATEGORY ORDER BY TOTAL_REVENUE DESC


#20. Find cities where the total number of orders placed is greater than the average number of orders per city.

select * from customers

SELECT CITY, COUNT(CUSTOMER_ID) AS TOTAL_NOS_ORDERS 
FROM CUSTOMERS GROUP BY CITY
HAVING COUNT(CUSTOMER_ID) > (SELECT COUNT(CITY) * 1 / COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMERS)


SELECT DISTINCT CITY FROM CUSTOMERS


select * from sales

SELECT CITY, COUNT(ORDER_ID) AS TOTAL_NO_OF_ORDERS 
FROM SALES GROUP BY CITY
HAVING COUNT(ORDER_ID)> (SELECT COUNT(CITY) * 1 / COUNT(DISTINCT ORDER_ID) FROM SALES)




SELECT COUNT(ORDER_ID) FROM SALES GROUP BY CITY

SELECT CITY, COUNT(ORDER_ID) AS TOTAL_NO_OF_ORDERS FROM SALES GROUP BY CITY
HAVING COUNT(ORDER_ID) > (SELECT AVG(C) FROM (SELECT COUNT(ORDER_ID) AS C FROM SALES GROUP BY CITY) AS CITYORDERS); 



SELECT CITY, COUNT(CUSTOMER_ID) FROM CUSTOMERS GROUP BY CITY

SELECT CITY, COUNT(CITY) FROM CUSTOMERS GROUP BY CITY


SELECT CITY, COUNT(TOTAL_ORDERS) AS TOTAL_NOS_ORDERS FROM CUSTOMERS 
GROUP BY CITY 
HAVING COUNT(TOTAL_ORDERS) > (SELECT AVG(T) FROM (SELECT COUNT(TOTAL_ORDERS) AS T FROM CUSTOMERS GROUP BY CITY) AS ORDERS);




#NEW QUERIES

use project

select * from sales
select * from customers
select * from products

#How much revenue did the business generate each month?

SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
SUM(total_amount) AS revenue
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

#How much revenue does an average order generate?

SELECT ROUND(
SUM(total_amount) / NULLIF(COUNT(DISTINCT order_id), 0),
2
) AS average_order_value
FROM sales;

#Which payment methods account for the most sales?

SELECT payment_mode,
COUNT(DISTINCT order_id) AS order_count,
SUM(total_amount) AS revenue
FROM sales
GROUP BY payment_mode
ORDER BY revenue DESC;

#Which registered customers have never purchased?

SELECT c.customer_id, c.customer_name
FROM customers as c
LEFT JOIN sales as o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

#What percentage of purchasing customers placed more than one order?

WITH customer_orders AS (
SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
FROM sales
GROUP BY customer_id
)
SELECT COUNT(*) AS purchasing_customers,
SUM(order_count > 1) AS repeat_customers,
ROUND(100.0 * SUM(order_count > 1) /
NULLIF(COUNT(*), 0), 2) AS repeat_rate_pct
FROM customer_orders;







#Did revenue rise or fall compared with the previous month?

WITH monthly_sales AS (SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
SUM(total_amount) AS revenue FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')),
comparisons AS (SELECT sales_month, revenue,
LAG(revenue) OVER (ORDER BY sales_month) AS prior_revenue
FROM monthly_sales)
SELECT sales_month, revenue, prior_revenue,
ROUND(100.0 * (revenue - prior_revenue) /
NULLIF(prior_revenue, 0), 2) AS mom_growth_pct
FROM comparisons ORDER BY sales_month;

#How much revenue has accumulated over time?

WITH daily_sales AS (
SELECT DATE(order_date) AS sales_date,
SUM(total_amount) AS revenue FROM sales
GROUP BY DATE(order_date)
)
SELECT sales_date, revenue,
SUM(revenue) OVER (
ORDER BY sales_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS cumulative_revenue
FROM daily_sales ORDER BY sales_date;

#Which products lead their own category?

WITH PRODUCT_SALES AS (SELECT P.PRODUCT_ID, 
P.PRODUCT_NAME, P.CATEGORY, SUM(S.ORDER_VALUE) as REVENUE
FROM SALES AS S JOIN PRODUCTS AS P ON P.PRODUCT_ID = S.PRODUCT_ID
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME, P.CATEGORY),
RANKED AS ( SELECT PRODUCT_SALES.*,
DENSE_RANK() OVER (PARTITION BY CATEGORY ORDER BY REVENUE DESC)
AS PRODUCT_RANK FROM PRODUCT_SALES)
SELECT * FROM RANKED 
WHERE PRODUCT_RANK <= 3
ORDER BY CATEGORY, PRODUCT_RANK;


#What was each customer's most recent purchase?

SELECT customer_id, order_id, order_date, total_amount
FROM (
SELECT o.*,
ROW_NUMBER() OVER (
PARTITION BY customer_id
ORDER BY order_date DESC, order_id DESC
) AS rn
FROM sales o
) ranked_orders
WHERE rn = 1;

#Which customers spend more than the average customer?

WITH customer_spending AS (
SELECT customer_id, SUM(total_amount) AS total_spent
FROM sales
GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_spending
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spending)
ORDER BY total_spent DESC;

