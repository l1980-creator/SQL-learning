use exam;
select * from products
order by quantityInStock desc;

select productCode,
    count(productCode) from products
group by productCode;

select count(*) from products;

select c.contactFirstName,
       c. contactLastName,
COUNT(o.orderNumber) as orders_count
from customers c
JOIN
    orders o
USING(customerNumber)
where orderNumber>10
group by c.contactFirstName, c. contactLastName
order by orders_count desc ;

SELECT
    CASE
        WHEN (100.0 * SUM(CASE WHEN status = 'On Hold' THEN 1 ELSE 0 END) / COUNT(*)) > 5
        THEN 'Over 5 %'
        ELSE 'Under 5 %'
    END AS Order_status
FROM orders;

select
    COUNT(o.orderNumber)
    from orders o
JOIN
    customers c
    on o.customerNumber = c.customerNumber
where
    c.country='USA'
and
 o.orderdate>='2003-01-01';

select * from products;
select productVendor,
       quantityInStock
from products
order by(quantityInStock)DESC ;

SELECT productVendor,
       SUM(quantityInStock) AS totalStock
FROM products
GROUP BY productVendor
ORDER BY totalStock DESC;

SELECT COUNT(*) AS top_level_count
FROM employees
WHERE reportsTo IS NULL;

SELECT reportsTo AS managerNumber, COUNT(*) AS direct_reports
FROM employees
WHERE reportsTo IS NOT NULL
GROUP BY reportsTo
HAVING COUNT(*) = 6;

select * from customers;
select
e.lastName,
count(c.customerName) as sum
from employees e

JOIN
    customers c
on e.employeeNumber = c.salesRepEmployeeNumber
where
    lastName='Bott'
GROUP By e.lastName;


