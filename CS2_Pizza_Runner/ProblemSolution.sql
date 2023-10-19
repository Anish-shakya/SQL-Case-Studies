--1. How many pizzas were ordered?
SELECT COUNT(*) AS total_orders FROM customer_orders;
--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders;
--3. How many successful orders were delivered by each runner?
SELECT runner_id,COUNT(*) AS total_delivered FROM runner_orders
WHERE pickup_time <> 'null'
GROUP BY runner_id
ORDER BY runner_id;

--4. How many of each type of pizza was delivered?
SELECT p.pizza_name,COUNT(*) AS total_Delivered FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
JOIN pizza_names p ON c.pizza_id = p.pizza_id
WHERE r.pickup_time <> 'null'
GROUP BY p.pizza_name;
--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id,p.pizza_name,COUNT(*) AS num_ordered FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id,p.pizza_name
ORDER BY c.customer_id;

--6. What was the maximum number of pizzas delivered in a single order?

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--8. How many pizzas were delivered that had both exclusions and extras?
--9. What was the total volume of pizzas ordered for each hour of the day?
--10. What was the volume of orders for each day of the week?
