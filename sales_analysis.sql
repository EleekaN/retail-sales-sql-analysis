-- ============================================================
-- Project 3: SQL Analysis of Retail Sales
-- Tables: orders, customers, products (imported the cleaned_sales_data.csv file)
-- Business goal: understand sales, profit, customers and discounts
-- ============================================================

-- Q1. Overall business summary

SELECT count(*) as totat_orders,
	round(sum(sales),0) as total_sales,
	round(sum(profit),0) as total_profit,
	round(sum(profit)*100 / sum(sales),1)	as profit_margin
FROM orders;

-- Q2. Sales and profit by category (JOIN orders + products)

SELECT p.category as category,
	round(sum(o.sales),0) as total_sales,
	round(sum(o.profit),0) as total_profit,
	round(sum(o.profit)*100 / sum(o.sales), 1) as profit_margin
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP By category
order by profit_margin DESC;

-- q2 answers which product category has the maximum sales and maximum profit.
--  Also, it explains maximum sale doesn't necessarily bring higher profit margins.

-- Q3. Sales by region and customer segment (JOIN orders + customers)
SELECT c.region, c.segment,
	round(sum(o.sales),0) as total_sales,
	count(distinct o.customer_id) as active_customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region, c.segment
Order by c.region, total_sales DESC;

-- Q4. Monthly sales trend
SELECT strftime('%Y-%m', order_date) as month,
	round(sum(sales),0) as total_sales,
	count(*) as total_order
FROM orders
GROUP BY month;

-- Note: The result shows a trend of higher sales around Oct to Dec every year. 


-- Q5. Top 10 customers by sales 
SELECT c.customer_id, c.customer_name, c.city,
	round(sum(o.sales),0) as total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER by total_sales DESC
LIMit 10;

-- Q6. Customers who never placed an order (LEFT JOIN + NULL check)

SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id is NULL;

-- Q7. Does discount reduce profit margin? (CASE WHEN)
SELECT 
	Case 
	when discount = 0 THEN 'No Discout'
	when discount <= 0.10 THEN 'Low - upto 10%'
	ELSE 'High >10%' END as discount_band,
	count(*) as orders,
	round(sum(profit)*100/sum(sales), 1) as profit_margin	
FROM orders
GROUP BY discount_band
order by profit_margin DESC;

-- The result clearly indicates that higher discounts affects the profit margin. 

-- Q8. Sub-categories with sales above the average sub-category (HAVING + subquery)

WIth category as 
(
SELECT p.sub_category, sum(o.sales) as sub_total
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.sub_category
)
SELECT avg(sub_total) as average_sub_total
FROM category;

SELECT p.sub_category, sum(o.sales) as total_sales
FROM orders o
JOIN products p on o.product_id = p.product_id
GROUP BY p.sub_category
HAVING total_sales > (
	SELECT avg(sub_total) FROM 
	(SELECT p.sub_category, sum(o.sales) as sub_total
		FROM orders o
		JOIN products p ON o.product_id = p.product_id
		GROUP BY p.sub_category))
ORDER BY total_sales DESC;

-- Q9. Average customer spend by segment (CTE)

WIth customer_sales as 
( SELECT customer_id, sum(sales) as total_spend
FROM orders
GROUP BY customer_id
)
SELECT c.segment, 
		count(*) as customers,
		round(avg(cs.total_spend),2) as avg_customer_spend
FROM customer_sales cs
JOIN customers c ON cs.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY avg_customer_spend DESC;

-- Q10. Top 3 products by profit within each category (window function)

SELECT * 
FROM
(SELECT p.category, p.product_name, round(sum(o.profit),0) as total_profit,
	rank() OVER (PARTITION BY p.category ORDER by sum(o.profit) DESC) as rnk
FROM orders o
JOIN Products p ON p.product_id = o.product_id
GROUP BY p.category, p.product_name
) WHERE rnk <=3
ORDER BY category, rnk;
