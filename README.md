# 🍜 Case Study #1 - Danny's Diner

📊 Business Task
Danny wants to use data to answer a few simple questions about his customers—specifically about their visiting patterns, how much money they’ve spent, and which menu items are their favorites. This documentation contains the exact SQL solutions developed to extract these insights.

🛠️ Tech Stack
Database Management System: MySQL

SQL Concepts Used: Aggregate Functions (SUM, COUNT), Joins (JOIN, LEFT JOIN), Grouping & Ordering, Subqueries, and Common Table Expressions (CTEs).

🚀 Case Study Questions & Solutions
Q1: What is the total amount each customer spent at the Restaurant?
Logic: Joins transaction records from sales with the menu pricing table, aggregating the sum of prices per customer.

SQL
SELECT 
    s.customer_id,
    SUM(n.price)
FROM sales AS s
JOIN menu AS n
    ON s.product_id = n.product_id
GROUP BY 
    s.customer_id;
Q2: How many days does each customer has visited the Restaurant?
Logic: Counts the frequency of order dates per customer, sorted from the most frequent visitor to the least.

SQL
SELECT 
    customer_id,
    COUNT(order_date) AS Visit_times
FROM sales
GROUP BY customer_id
ORDER BY visit_times DESC;
Q3: What was the first item purchased by the each customer?
Logic: Employs a correlated subquery to isolate the absolute minimum (earliest) order date for each customer's products.

SQL
SELECT
    customer_id,
    product_name,
    order_date
FROM sales AS s
LEFT JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date = 
                (SELECT MIN(order_date)
                FROM sales
                WHERE s.product_id = m.product_id)
;
Q4: What is the most purchases item on the menu and how much times was it purchased by all customers?
Logic: Groups orders by product name, counts the occurrences, and uses LIMIT 1 to return the single highest volume item.

SQL
SELECT
    m.product_name,
    COUNT(s.product_id) AS purchase_times
FROM sales AS s
JOIN menu AS m
    ON s.product_id = m.product_id
GROUP BY
    s.product_id,
    m.product_name
ORDER BY purchase_times DESC
LIMIT 1;
Q5: Which item is popular for all customers?
Logic: Employs nested subqueries to first build count aggregates per customer/item combination, and then filters for items matching the maximum ordered count.

SQL
SELECT 
    customer_id,
    product_name AS item,
    ordered_times
FROM (
        SELECT 
            s.customer_id,
            m.product_name,
            COUNT(s.product_id) AS ordered_times
        FROM sales AS s
        JOIN menu AS m
            ON s.product_id = m.product_id
        GROUP BY m.product_name, s.customer_id
) AS t
WHERE t.ordered_times = (
                            SELECT MAX(c.ordered_times)
                            FROM 
                                    (SELECT 
                                        s.customer_id,
                                        m.product_name,
                                        COUNT(s.product_id) AS ordered_times
                                    FROM sales AS s
                                    JOIN menu AS m
                                    ON s.product_id = m.product_id
                                    GROUP BY m.product_name, s.customer_id
                                    ) AS c
                                    WHERE t.customer_id = c.customer_id
)
ORDER BY t.ordered_times DESC;
Q6: What item was Purchased First by the customer after they became a member?
Logic: Joins members, sales, and menu tables, applying a subquery filter to locate the earliest order date that sits on or after the official membership join_date.

SQL
SELECT 
    s.customer_id,
    men.product_name,
    s.order_date
FROM members AS m
JOIN sales AS s
    ON m.customer_id = s.customer_id
JOIN menu AS men
    ON men.product_id = s.product_id
WHERE s.order_date = (
                        SELECT MIN(order_date)
                        FROM sales
                        WHERE customer_id = s.customer_id AND order_date >= join_date
)
ORDER BY s.order_date;
Q7: Which item was purchased just before the customer became a member?
Logic: Filters transactional history exclusively for records prior to the membership join_date, targeting the baseline historical items.

SQL
SELECT 
    s.customer_id,
    men.product_name,
    s.order_date
FROM members AS m
JOIN sales AS s
    ON m.customer_id = s.customer_id
JOIN menu AS men
    ON men.product_id = s.product_id
WHERE s.order_date = (
                        SELECT MIN(order_date)
                        FROM sales
                        WHERE customer_id = s.customer_id AND order_date < join_date AND order_date != join_date
)
ORDER BY s.order_date;
Q8: What is the total items and amount spent for each member before they became a member?
Logic: Implements a Common Table Expression (CTE) named t to isolate prior order details, then runs a final aggregation calculating the total spend and overall volume of orders before membership activation.

SQL
WITH t AS(
    SELECT
        s.customer_id,
        n.product_name,
        n.price,
        s.order_date,
        m.join_date
    FROM members AS m
    JOIN sales AS s
        ON m.customer_id = s.customer_id
    JOIN menu AS n
        ON s.product_id = n.product_id
)
SELECT 
        t.customer_id,
        SUM(price) AS total_amount_spent,
        COUNT(t.product_name) AS total_orders
FROM t
WHERE order_date < join_date
GROUP BY t.customer_id;
