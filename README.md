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

# Task 05 – Syntax Pitfalls: Cartesian Product & Date Literals
Objective: Understand how small syntax mistakes in SQL can lead to major logical errors, such as unintended Cartesian products or incorrect filtering.
❌ Problematic Query:

```sql
SELECT COUNT(o.orderNumber)
FROM orders o
JOIN customers c
WHERE c.country = 'USA'
  AND o.orderDate >= 2003-01-01;
```

⚠️ Issues:
- Missing ON clause in JOIN: Without specifying how to join orders and customers, the query performs a Cartesian product, pairing every row from one table with every row from the other.
- Unquoted date literal: 2003-01-01 is interpreted as a math expression (2003 - 1 - 1 = 2001), not a date. This leads to incorrect filtering
✅ Corrected Query:
```sql
SELECT COUNT(o.orderNumber)
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
WHERE c.country = 'USA'
  AND o.orderDate >= '2003-01-01';
```

🧾 Explanation:
- The ON clause ensures proper row matching between tables.
- The date is enclosed in quotes to be treated as a valid SQL DATE value.
- This version returns the correct count of orders from U.S. customers placed on or after January 1, 2003.

💡 Lesson learned: Even tiny syntax oversights can drastically affect query results. Always validate joins and literal formats to avoid silent logic errors.

# Task 06 – Aggregating Stock by Vendor
Objective: Use SQL aggregation to calculate total stock per product vendor and sort the results.
📝 My Approach:
At first, I wanted to get a general overview of the data, so I started with this query
```sql
SELECT * FROM products;
```
Then I tried listing vendors and their stock quantities:
```sql
SELECT productVendor,
       quantityInStock
FROM products
ORDER BY quantityInStock DESC;
```

But I quickly realized that some vendors appeared multiple times, since each product has its own row. That meant I wasn’t seeing the total stock per vendor — just individual product entries.
✅ Final Query:
```sql
SELECT productVendor,
       SUM(quantityInStock) AS totalStock
FROM products
GROUP BY productVendor
ORDER BY totalStock DESC;
```
🔍 Explanation:
- SUM(quantityInStock) calculates the total number of items in stock for each vendor.
- GROUP BY productVendor groups the results by vendor name.
- ORDER BY totalStock DESC sorts vendors from the highest to the lowest total stock.
- 
🧠 What I Learned:
- Aggregation is essential when working with repeated values across rows.
- Without GROUP BY, I wouldn’t be able to get a clear summary of stock per vendor.
- Aggregate functions like SUM, AVG, MAX, and COUNT operate over sets of rows — but SQL needs to know how to group those rows before applying the function.
- That’s why GROUP BY is required: it tells SQL to split the data into logical groups (e.g. by vendor), and then apply the aggregation to each group separately.
- If I used SUM(quantityInStock) without GROUP BY productVendor, SQL wouldn’t know whether I want the total stock for all products, or per vendor — and it would either throw an error or give misleading results.
- So in short:
GROUP BY is the bridge between raw data and meaningful summaries.

# Task 07🧮 Counting Employees Who Are Not Reporting to Anyone...
Objective: Find out how many employees are at the top of the organizational hierarchy — i.e., those who don’t report to anyone.
```sql
SELECT COUNT(*) AS top_level_count
FROM employees
WHERE reportsTo IS NULL;
```
🔍 Explanation:
- reportsTo IS NULL filters for employees who don’t have a manager listed — meaning they’re at the top level.
- COUNT(*) counts how many such employees exist.
- The result gives a single number: the total count of top-level individuals in the company.
  
🧠 What I Learned:
- NULL values are useful for identifying missing or undefined relationships in a dataset.
- In organizational structures, NULL in a reportsTo column often indicates leadership roles.
- Using COUNT(*) with a WHERE clause lets me quantify specific subsets of data — in this case, the leadership tier.

# 🧠 Task 08 – Verifying Managerial Structure: Two Managers with Six Direct Reports Each
Objective: Confirm the accuracy of the statement: There are precisely two employees, each of whom is reported to by six subordinates.
✅ Query:
```sql
SELECT reportsTo AS managerNumber,
       COUNT(*) AS direct_reports
FROM employees
WHERE reportsTo IS NOT NULL
GROUP BY reportsTo
HAVING COUNT(*) = 6;
```
🔍 Explanation:
- reportsTo identifies the manager each employee reports to.
- WHERE reportsTo IS NOT NULL excludes top-level employees who don’t report to anyone.
- GROUP BY reportsTo aggregates employees by their manager.
- COUNT(*) calculates how many employees report to each manager.
- HAVING COUNT(*) = 6 filters the result to include only those managers with exactly six direct reports.

🧠 What I Learned:
- This query doesn’t just find managers with six reports — it helps validate a specific organizational claim.
- By running this query and counting the resulting rows, we can confirm whether exactly two managers meet the criteria.
- It’s a great example of using SQL not just for data retrieval, but for truth verification within a business context.

# 🧠 Task 09 – Counting Customers Assigned to a Specific Sales Rep
Objective: Verify how many customers are assigned to the sales representative with the last name Bott.
✅ Query:
```sql
SELECT e.lastName,
       COUNT(c.customerName) AS sum
FROM employees e
JOIN customers c
  ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE e.lastName = 'Bott'
GROUP BY e.lastName;
```

🔍 Explanation:
- JOIN customers ON employeeNumber = salesRepEmployeeNumber links each employee to the customers they manage.
- WHERE lastName = 'Bott' filters the data to focus only on the employee named Bott.
- COUNT(customerName) tallies how many customers are assigned to Bott.
- GROUP BY lastName ensures the count is grouped under Bott’s name.
🧠 What I Learned:
- This query is a great example of combining filtering, joining, and aggregation to answer a specific business question.
- It shows how SQL can be used to audit sales assignments and verify workload distribution.
- The result confirms whether Bott is actively managing customer relationships — and how many.






