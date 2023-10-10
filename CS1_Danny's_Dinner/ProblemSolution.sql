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
With CTE AS (
	SELECT s.customer_id, s.order_date,m.product_name,
	DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
	FROM sales AS s
	JOIN menu AS m
	ON s.product_id = m.product_id
	GROUP BY 1,2,3
)
SELECT customer_id,product_name
FROM CTE
WHERE rank = 1;
-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name,COUNT(*)
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY  m.product_name
ORDER BY 2 DESC
LIMIT 1


-- Which item was the most popular for each customer?
--Which item was purchased first by the customer after they became a member?
-- Which item was purchased just before the customer became a member?
-- What is the total items and amount spent for each member before they became a member?
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
---- how many points would each customer have?
-- In the first week after a customer joins the program (including their join date) 
----they earn 2x points on all items, not just sushi - how many points do customer A and B 
-----have at the end of January?