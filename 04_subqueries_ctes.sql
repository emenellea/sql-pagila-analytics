/* ============================================================
   04 - SUBQUERIES, CTEs, CASE & DATE LOGIC
   ============================================================ */

-- 1. Classify films by length: Short (<90), Medium (90-120), Long (>120)
SELECT title,
       length,
       CASE
           WHEN length > 120 THEN 'Long'
           WHEN length BETWEEN 90 AND 120 THEN 'Medium'
           ELSE 'Short'
       END AS length_category
FROM film
ORDER BY length DESC;

-- 2. Classify each customer's total spending:
--    High (>150), Medium (75-150), Low (<75)
WITH customer_totals AS (
    SELECT customer_id,
           SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id,
       total_spent,
       CASE
           WHEN total_spent > 150 THEN 'High spender'
           WHEN total_spent BETWEEN 75 AND 150 THEN 'Medium spender'
           ELSE 'Low spender'
       END AS spending_tier
FROM customer_totals
ORDER BY total_spent DESC;

-- 3. Films whose rental rate is higher than the average rental rate
SELECT title,
       rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;

-- 4. Customers whose total payments exceed the average customer's total payments
WITH customer_totals AS (
    SELECT customer_id,
           SUM(amount) AS total_payment
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id,
       total_payment
FROM customer_totals
WHERE total_payment > (SELECT AVG(total_payment) FROM customer_totals)
ORDER BY total_payment DESC;

-- 5. All customers who rented the film "ACADEMY DINOSAUR"
SELECT DISTINCT c.first_name,
       c.last_name
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON f.film_id = i.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 6. The customer who spent the most money overall
WITH customer_totals AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           SUM(p.amount) AS total_spent
    FROM customer AS c
    JOIN payment AS p
        ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM customer_totals
ORDER BY total_spent DESC
LIMIT 1;

-- 7. Number of rentals per month
SELECT EXTRACT(MONTH FROM rental_date) AS month,
       COUNT(*) AS rental_count
FROM rental
GROUP BY EXTRACT(MONTH FROM rental_date)
ORDER BY month;

-- 8. Number of rentals per year and month
SELECT EXTRACT(YEAR FROM rental_date)  AS year,
       EXTRACT(MONTH FROM rental_date) AS month,
       COUNT(*) AS rental_count
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date)
ORDER BY year, month;

-- 9. All rentals that occurred during the year 2005
SELECT *
FROM rental
WHERE rental_date >= '2005-01-01'
  AND rental_date <  '2006-01-01';

-- 10. Customers who have never made a rental
SELECT c.customer_id,
       c.first_name,
       c.last_name
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

-- 11. Films that have never been rented
SELECT f.film_id,
       f.title
FROM film AS f
LEFT JOIN inventory AS i
    ON f.film_id = i.film_id
LEFT JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 12. Customers whose total spending is greater than the average
--     (fully qualified, avoids ambiguous alias reuse)
WITH customer_totals AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           SUM(p.amount) AS total_spending
    FROM customer AS c
    JOIN payment AS p
        ON p.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id,
       first_name,
       last_name,
       total_spending
FROM customer_totals
WHERE total_spending > (SELECT AVG(total_spending) FROM customer_totals)
ORDER BY total_spending DESC;
