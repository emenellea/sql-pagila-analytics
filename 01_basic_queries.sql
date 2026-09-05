/* ============================================================
   01 - BASIC QUERIES
   Fundamentals: SELECT, WHERE, LIKE, BETWEEN, IN, ORDER BY, LIMIT
   ============================================================ */

-- 1. Display all columns for the first 10 customers
SELECT *
FROM customer
LIMIT 10;

-- 2. First name, last name, and email for every customer
SELECT first_name,
       last_name,
       email
FROM customer;

-- 3. All customers whose first name is MARY
SELECT *
FROM customer
WHERE first_name = 'MARY';

-- 4. All films with a rental rate greater than 4
SELECT *
FROM film
WHERE rental_rate > 4;

-- 5. All films whose title starts with the letter A
SELECT *
FROM film
WHERE title LIKE 'A%';

-- 6. All customers whose first name contains "AN" anywhere
SELECT *
FROM customer
WHERE first_name LIKE '%AN%';

-- 7. Films with a rental duration between 5 and 7 days (inclusive)
SELECT *
FROM film
WHERE rental_duration BETWEEN 5 AND 7;

-- 8. Films rated PG or PG-13
SELECT *
FROM film
WHERE rating IN ('PG', 'PG-13');

-- 9. The 10 longest films (title, length)
SELECT title,
       length
FROM film
ORDER BY length DESC
LIMIT 10;

-- 10. The 5 cheapest films to rent (title, rental_rate)
SELECT title,
       rental_rate
FROM film
ORDER BY rental_rate ASC
LIMIT 5;

-- 11. The 10 customers whose last names come first alphabetically
SELECT first_name,
       last_name
FROM customer
ORDER BY last_name ASC
LIMIT 10;

-- 12. How many customers are in the database?
SELECT COUNT(*) AS total_customers
FROM customer;

-- 13. How many films are in the database?
SELECT COUNT(*) AS total_films
FROM film;

-- 14. Average, minimum, and maximum rental rate
SELECT AVG(rental_rate) AS avg_rate,
       MIN(rental_rate) AS min_rate,
       MAX(rental_rate) AS max_rate
FROM film;

-- 15. Total amount of money recorded in the payment table
SELECT SUM(amount) AS total_revenue
FROM payment;

-- 16. Average length of all films
SELECT AVG(length) AS avg_length
FROM film;
