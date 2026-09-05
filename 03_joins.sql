/* ============================================================
   03 - JOINS
   INNER / LEFT JOIN across the Pagila schema
   ============================================================ */

-- 1. Each customer's first name, last name, and address
SELECT c.first_name,
       c.last_name,
       a.address
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id;

-- 2. Every rental with the customer's first name, last name, and rental date
SELECT c.first_name,
       c.last_name,
       r.rental_date
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id;

-- 3. Total amount paid by each customer, highest spender first
SELECT c.first_name,
       c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_paid DESC;

-- 4. Top 10 customers by number of rentals
SELECT c.first_name,
       c.last_name,
       COUNT(*) AS num_rentals
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY num_rentals DESC
LIMIT 10;

-- 5. Film title and category name for every film
SELECT f.title,
       cat.name AS category_name
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS cat
    ON fc.category_id = cat.category_id
ORDER BY f.title;

-- 6. Every film together with the actor(s) who appear in it
SELECT f.title,
       a.first_name,
       a.last_name
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
JOIN actor AS a
    ON fa.actor_id = a.actor_id
ORDER BY f.title;

-- 7. Customer first name, last name, film title, and rental date
SELECT c.first_name,
       c.last_name,
       f.title,
       r.rental_date
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
ORDER BY r.rental_date;

-- 8. Top 10 customers by total payments
SELECT c.first_name,
       c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_paid DESC
LIMIT 10;

-- 9. Customer's first name, last name, and city
SELECT c.first_name,
       c.last_name,
       ci.city
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id;

-- 10. Every customer with every film title they've rented
SELECT c.first_name,
       c.last_name,
       f.title
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
ORDER BY c.last_name;
