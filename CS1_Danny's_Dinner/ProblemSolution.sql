-- What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(price) AS total_amount_spend 
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY 2 DESC;

-- How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) AS days_visited 
FROM sales
GROUP BY customer_id
ORDER BY 1

-- What was the first item from the menu purchased by each customer?
WITH CTE AS (SELECT s.customer_id,m.product_name,s.order_date,
DENSE_RANK() OVER(PARTITION BY s.customer_id order by s.order_date) AS ranks
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY 1,2,3)
SELECT customer_id,product_name
FROM CTE
WHERE ranks=1

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name,COUNT(*)
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY  m.product_name
ORDER BY 2 DESC
LIMIT 1


-- Which item was the most popular for each customer?
WITH CTE AS (
SELECT customer_id,product_name,item_count,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY item_count DESC) AS ranks
FROM(
	SELECT s.customer_id,s.product_id,m.product_name,COUNT(*) AS item_count
	FROM sales s
	JOIN menu m
	ON s.product_id= m.product_id
	GROUP by s.product_id,s.customer_id,m.product_name
	ORDER by s.customer_id,item_count DESC) AS popular_items)
SELECT customer_id,product_name as popular_product
FROM CTE
WHERE ranks = 1


--Which item was purchased first by the customer after they became a member?
WITH CTE AS (
	SELECT m.customer_id,m.join_date,s.product_id,s.order_date,
	DENSE_RANK() OVER(PARTITION BY m.customer_id ORDER BY s.order_date) as ranks
	FROM members m
	JOIN sales s
	ON m.customer_id  = s.customer_id 
	WHERE s.order_date >= m.join_date -- filtering member and non member customer
	GROUP BY 1,2,3,4
)
SELECT customer_id,m.product_name FROM CTE c
JOIN menu m
ON c.product_id = m.product_id
WHERE ranks = 1

-- Which item was purchased just before the customer became a member?
-- What is the total items and amount spent for each member before they became a member?
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
---- how many points would each customer have?
-- In the first week after a customer joins the program (including their join date) 
----they earn 2x points on all items, not just sushi - how many points do customer A and B 
-----have at the end of January?