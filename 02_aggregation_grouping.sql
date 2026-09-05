/* ============================================================
   02 - AGGREGATION & GROUPING
   GROUP BY, HAVING, aggregate functions
   ============================================================ */

-- 1. Number of customers per store
SELECT store_id,
       COUNT(*) AS num_customers
FROM customer
GROUP BY store_id;

-- 2. Number of films per rating
SELECT rating,
       COUNT(*) AS num_films
FROM film
GROUP BY rating;

-- 3. Total amount paid by each customer
SELECT customer_id,
       SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;

-- 4. Customers who made more than 30 payments
SELECT customer_id,
       COUNT(*) AS num_payments
FROM payment
GROUP BY customer_id
HAVING COUNT(*) > 30;

-- 5. Film ratings where the average rental rate is greater than 3
SELECT rating,
       AVG(rental_rate) AS avg_rate
FROM film
GROUP BY rating
HAVING AVG(rental_rate) > 3;
