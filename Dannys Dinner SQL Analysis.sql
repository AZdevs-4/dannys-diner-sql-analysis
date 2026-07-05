Select * from members;
Select * from menu;
Select * from sales;

-- Q1: What is the total amount each customer spent at the Resturant?

Select 
	s.customer_id,
    sum(n.price)
From sales as s
join menu as n
on s.product_id = n.product_id
Group by 
	s.customer_id;
