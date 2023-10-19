--1. How many pizzas were ordered?
SELECT COUNT(*) AS total_orders FROM customer_orders;

--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders;

--3. How many successful orders were delivered by each runner?
SELECT runner_id,COUNT(*) AS total_delivered FROM runner_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id
ORDER BY runner_id;

--4. How many of each type of pizza was delivered?
SELECT p.pizza_name,COUNT(*) AS total_Delivered FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
JOIN pizza_names p ON c.pizza_id = p.pizza_id
WHERE r.pickup_time IS NOT NULL
GROUP BY p.pizza_name;

--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id,p.pizza_name,COUNT(*) AS num_ordered FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id,p.pizza_name
ORDER BY c.customer_id;

--6. What was the maximum number of pizzas delivered in a single order?
SELECT c.order_id,COUNT(*) AS maximum_delivered 
FROM customer_orders c
JOIN runner_orders r ON c.order_id =r.order_id
WHERE pickup_time IS NOT NULL
GROUP BY c.order_id 
ORDER BY maximum_delivered DESC
LIMIT 1;

-- using correlated Sub queries
SELECT c.order_id,COUNT(*) AS maximum_delivered FROM customer_orders c
WHERE c.order_id IN (SELECT r.order_id FROM runner_orders r WHERE c.order_id = r.order_id 
					AND r.pickup_time IS NOT NULL)
GROUP BY c.order_id
ORDER BY maximum_delivered DESC
LIMIT 1;

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--- data cleaning
UPDATE customer_orders SET exclusions = NULL where exclusions ='';
UPDATE customer_orders SET exclusions = NULL where exclusions ='null';
UPDATE customer_orders SET extras = NULL where extras ='';
UPDATE customer_orders SET extras = NULL where extras ='null';
UPDATE runner_orders   SET pickup_time = NULL WHERE pickup_time = 'null';

--solution
SELECT c.customer_id,
SUM(CASE WHEN((exclusions IS NULL AND extras IS NOT NULL) 
		  OR(exclusions IS NOT NULL AND extras IS NULL)
		  OR (exclusions IS NOT NULL AND extras IS NOT NULL))THEN 1 ELSE 0 END) AS changes,
SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END )AS no_changes

FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE pickup_time is NOT NULL
GROUP BY 1
ORDER BY c.customer_id;
--8. How many pizzas were delivered that had both exclusions and extras?
WITH CTE AS (
	SELECT c.customer_id,
	SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS delivered
	FROM customer_orders c
	JOIN runner_orders r ON c.order_id = r.order_id
	WHERE pickup_time is NOT NULL
	GROUP BY 1
	ORDER BY c.customer_id)
SELECT * FROM CTE 
WHERE delivered > 0;
--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(Hour FROM order_time) AS Hours , COUNT(*) AS orders
FROM customer_orders
GROUP BY Hours
ORDER BY orders DESC;

--10. What was the volume of orders for each day of the week?
SELECT to_char(order_time,'Day') AS Days,COUNT(*) AS orders 
FROM customer_orders
GROUP BY Days
ORDER BY orders DESC;