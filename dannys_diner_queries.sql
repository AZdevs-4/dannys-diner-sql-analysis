use dannys_diner;

-- ---------------# QUERIES #---------------------------------------
-- Q1: What is the total amount each customer spent at the Resturant?
Select 
	s.customer_id,
    sum(n.price)
From sales as s
join menu as n
on s.product_id = n.product_id
Group by 
	s.customer_id;
-- -------------------------------------------------------------------------

-- Q2: How many days does each customer has visited the Restaurant?
Select 
	customer_id,
    count(order_date) as Visit_times
From sales
group by customer_id
Order By visit_times Desc;
-- -------------------------------------------------------------------------

-- Q3: what was the first item purchased by the each customer?
Select
	customer_id,
    product_name,
    order_date
From sales as s
left join menu as m
on s.product_id = m.product_id
where s.order_date = 
				(Select min(order_date)
                from sales
                where s.product_id = m.product_id)
;
-- -------------------------------------------------------------------------

-- Q4: What is the most purchases item on the menu and how much times was it purchased by all customers?

SELECT
    m.product_name,
    COUNT(s.product_id) AS purchase_times
FROM sales as s
JOIN menu  as m
ON s.product_id = m.product_id
GROUP BY
    s.product_id,
    m.product_name
ORDER BY purchase_times DESC
LIMIT 1;
-- -------------------------------------------------------------------------

-- Q5: Which item is popular for all customers?
Select 
	customer_id,
    product_name as item,
    ordered_times
from (
		Select 
			s.customer_id,
            m.product_name,
            count(s.product_id) as ordered_times
        from sales as s
        join menu as m
        on s.product_id = m.product_id
        group by m.product_name, s.customer_id
) as t
where t.ordered_times = (
							Select max(c.ordered_times)
                            from 
									(Select 
										s.customer_id,
										m.product_name,
										count(s.product_id) as ordered_times
									from sales as s
									join menu as m
									on s.product_id = m.product_id
									group by m.product_name, s.customer_id
									) as c
                                    where t.customer_id = c.customer_id
)
order by t.ordered_times desc;
-- -------------------------------------------------------------------------

-- Q6: What item was Purchased First by the customer after they became a member?
Select 
	s.customer_id,
    men.product_name,
    s.order_date
from members as m
join sales as s
on m.customer_id = s.customer_id
join menu as men
on men.product_id = s.product_id

where s.order_date = (
						select min(order_date)
                        from sales
                        where customer_id = s.customer_id and order_date >= join_date
)
order by s.order_date;
-- -------------------------------------------------------------------------

-- Q7: Which item was purchased just before the customer became a member?

Select 
	s.customer_id,
    men.product_name,
    s.order_date
from members as m
join sales as s
on m.customer_id = s.customer_id
join menu as men
on men.product_id = s.product_id

where s.order_date = (
						select min(order_date)
                        from sales
                        where customer_id = s.customer_id and order_date < join_date and order_date != join_date
)
order by s.order_date;
-- -------------------------------------------------------------------------

-- Q8: What is the total items and amount spent for each member before they became a member?
with t as(
	Select
		s.customer_id,
		n.product_name,
		n.price,
        s.order_date,
		m.join_date
        
    From members as m
    join sales as s
    on m.customer_id = s.customer_id
    join menu as n
    on s.product_id = n.product_id
)
select 
		t.customer_id,
        sum(price) as total_amount_spent,
        count(t.product_name) as total_orders
from t
where order_date < join_date
Group by t.customer_id;
-- -------------------------------------------------------------------------

