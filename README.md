# SQL Final Exam – Practice Repository

Welcome to my SQL Final Exam repository. This project contains a collection of SQL exercises and solutions based on exam-style questions. Each task is designed to test and reinforce key concepts in relational databases, including:

- SELECT statements  
- JOIN operations  
- GROUP BY and aggregation  
- Filtering and sorting  
- Subqueries and nested logic

The goal of this repository is to demonstrate practical SQL skills using real-world scenarios and sample datasets. Each exercise includes a brief description, the SQL query, and a short explanation of the logic behind the solution.

Feel free to explore the tasks, learn from the examples, and use this as a reference for your own SQL practice.
## Database Selection

Before running any queries, we need to make sure we're working inside the correct database.  
The following command sets the active database to `exam`:

```sql
USE exam;

```

# Task 01 – Find a product with the highest stock quantity

Assignment:
Write an SQL query that retrieves all products from the database and sorts them by the quantity in stock, from highest to lowest.
Solution:
Use the statement SELECT * FROM products ORDER BY quantityInStock DESC;, which selects all columns from the products table and orders the results by the quantityInStock column in descending order. This gives you a clear overview of the most stocked products.


```sql
select * from products
order by quantityInStock desc;
```
Explanation:
This query is useful for inventory analysis, identifying overstocked items, or planning sales. It helps quickly determine which products are currently most available.
# Task 02: Count the Number of Records in the Products Table
Objective:
Determine how many rows (records) are stored in the Products table.
SQL Query:

```sql
SELECT COUNT(*) 
FROM products;
```
Explanation:
This query returns a single number representing the total count of entries in the products table. It's useful for understanding the size of the dataset or verifying that data has been correctly imported.


# Task 03: Which customer  has more than 10 orders? 
Objective: On the basis of two tables - orders and customers, find the customer who has over 10 orders(columns contactFirstName and contactLastName)
```sql
select c.contactFirstName,
       c. contactLastName,
COUNT(o.orderNumber) as orders_count
from customers c
JOIN
    orders o
USING(customerNumber)
where orderNumber>10
group by c.contactFirstName, c. contactLastName
order by orders_count desc;
```
Explanation: 
This SQL query lists customer contact names along with the number of their orders.
- Joins customers and orders using customerNumber
- Filters orders with orderNumber > 10
- Groups by customer name
- Counts orders per customer
- Sorts results by order count in descending order

🔗 Join condition:
- Uses a USING(customerNumber) clause to match customers with their orders.

📈 Output:
A ranked list of customer names with the number of qualifying orders they’ve made, starting from the most active.

# Task 04: Do orders marked "On Hold" exceed 5% of the total? 
```sql
SELECT
    CASE
        WHEN (100.0 * SUM(CASE WHEN status = 'On Hold' THEN 1 ELSE 0 END) / COUNT(*)) > 5
        THEN 'Over 5 %'
        ELSE 'Under 5 %'
    END AS Order_status
FROM orders;
```
Explanation: 
This SQL query calculates the percentage of orders with the status 'On Hold' and classifies the result into two categories: 'Over 5 %' or 'Under 5 %'.
Purpose of CASE ... WHEN
The CASE ... WHEN construct is used here to:
- Count conditionally: It allows counting only those rows where status = 'On Hold' by returning 1 for matching rows and 0 otherwise.
- Enable classification: The outer CASE evaluates whether the calculated percentage exceeds 5%, and returns a label accordingly.
Logic Summary
- SUM(CASE WHEN status = 'On Hold' THEN 1 ELSE 0 END) counts how many orders are on hold.
- COUNT(*) gives the total number of orders.
- The percentage is calculated as (on_hold_count / total_count) * 100.
- The result is labeled as 'Over 5 %' or 'Under 5 %' based on the threshold.
This approach makes the query flexible and readable, especially when applying conditional logic directly within aggregate functions.



