/* ============================================================
   05 - WINDOW FUNCTIONS & ADVANCED PATTERNS
   ROW_NUMBER, RANK, LAG, running totals, EXISTS / NOT EXISTS
   ============================================================ */

-- 1. Number each customer's payments in order
SELECT payment_id,
       customer_id,
       amount,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_id) AS payment_number
FROM payment;

-- 2. Most recent payment for every customer
WITH ranked_payments AS (
    SELECT payment_id,
           customer_id,
           amount,
           payment_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS rn
    FROM payment
)
SELECT *
FROM ranked_payments
WHERE rn = 1;

-- 3. Rank customers by total spending
SELECT customer_id,
       total_spending,
       RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
) AS customer_spending;

-- 4. Top 3 customers by spending
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id,
           total_spending,
           RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
    FROM customer_spending
)
SELECT *
FROM ranked_customers
WHERE spending_rank <= 3;

-- 5. Each payment alongside the customer's total spending
SELECT payment_id,
       customer_id,
       amount,
       SUM(amount) OVER (PARTITION BY customer_id) AS customer_total
FROM payment;

-- 6. Running total of payments per customer, ordered by date
SELECT customer_id,
       payment_date,
       amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS running_total
FROM payment;

-- 7. Compare each payment with the customer's previous payment
SELECT customer_id,
       payment_date,
       amount,
       LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS previous_payment,
       amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS difference
FROM payment;

-- 8. Payments greater than the customer's own average payment
SELECT p.payment_id,
       p.customer_id,
       p.amount
FROM payment AS p
WHERE p.amount > (
    SELECT AVG(p2.amount)
    FROM payment AS p2
    WHERE p2.customer_id = p.customer_id
);

-- 9. Customers who have made a payment over $8
SELECT c.customer_id,
       c.first_name,
       c.last_name
FROM customer AS c
WHERE EXISTS (
    SELECT 1
    FROM payment AS p
    WHERE p.customer_id = c.customer_id
      AND p.amount > 8
);

-- 10. Customers who have never made a payment
SELECT c.customer_id,
       c.first_name,
       c.last_name
FROM customer AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM payment AS p
    WHERE p.customer_id = c.customer_id
);

-- 11. Customers with total spending greater than $100
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id,
       total_spending
FROM customer_spending
WHERE total_spending > 100;

-- 12. Customer spending with names attached
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name,
       c.last_name,
       cs.total_spending
FROM customer AS c
JOIN customer_spending AS cs
    ON c.customer_id = cs.customer_id
ORDER BY cs.total_spending DESC;

-- 13. Top 5 customers by spending, with names and rank
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id,
           total_spending,
           RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
    FROM customer_spending
)
SELECT c.first_name,
       c.last_name,
       r.spending_rank,
       r.total_spending
FROM ranked_customers AS r
JOIN customer AS c
    ON r.customer_id = c.customer_id
WHERE r.spending_rank <= 5
ORDER BY r.spending_rank;

-- 14. Number of payments and spending rank per customer
WITH customer_stats AS (
    SELECT customer_id,
           SUM(amount) AS total_spending,
           COUNT(*) AS number_of_payments
    FROM payment
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id,
           total_spending,
           number_of_payments,
           RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
    FROM customer_stats
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       r.total_spending,
       r.spending_rank,
       r.number_of_payments
FROM ranked_customers AS r
JOIN customer AS c
    ON c.customer_id = r.customer_id
ORDER BY r.spending_rank;

-- 15. Monthly revenue and the previous month's revenue
WITH monthly_revenue AS (
    SELECT EXTRACT(MONTH FROM payment_date) AS month,
           SUM(amount) AS revenue
    FROM payment
    GROUP BY EXTRACT(MONTH FROM payment_date)
)
SELECT month,
       revenue,
       LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
FROM monthly_revenue
ORDER BY month;

-- 16. Month-over-month revenue change
WITH monthly_revenue AS (
    SELECT EXTRACT(MONTH FROM payment_date) AS month,
           SUM(amount) AS revenue
    FROM payment
    GROUP BY EXTRACT(MONTH FROM payment_date)
)
SELECT month,
       revenue,
       LAG(revenue) OVER (ORDER BY month) AS previous_month,
       revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM monthly_revenue
ORDER BY month;

-- 17. Each customer's spending vs. the average customer's spending
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id,
       total_spending,
       (SELECT AVG(total_spending) FROM customer_spending) AS avg_customer_spending
FROM customer_spending
WHERE total_spending > (SELECT AVG(total_spending) FROM customer_spending);

-- 18. Each customer's percentage of total revenue
WITH customer_spending AS (
    SELECT customer_id,
           SUM(amount) AS total_spending
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id,
       total_spending,
       ROUND(100 * total_spending / SUM(total_spending) OVER (), 2) AS pct_of_revenue
FROM customer_spending
ORDER BY total_spending DESC;

-- 19. Top 3 customers by spending, within each store
WITH customer_spending AS (
    SELECT p.customer_id,
           c.store_id,
           SUM(p.amount) AS total_spending
    FROM payment AS p
    JOIN customer AS c
        ON c.customer_id = p.customer_id
    GROUP BY p.customer_id, c.store_id
),
ranked_customers AS (
    SELECT store_id,
           customer_id,
           total_spending,
           RANK() OVER (PARTITION BY store_id ORDER BY total_spending DESC) AS spending_rank
    FROM customer_spending
)
SELECT *
FROM ranked_customers
WHERE spending_rank <= 3
ORDER BY store_id, spending_rank;

-- 20. Full customer profile: latest payment, total spending, payment count, rank
WITH customer_stats AS (
    SELECT customer_id,
           SUM(amount) AS total_spending,
           COUNT(*) AS number_of_payments
    FROM payment
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id,
           number_of_payments,
           total_spending,
           RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
    FROM customer_stats
),
ranked_payments AS (
    SELECT customer_id,
           payment_id,
           amount,
           payment_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS rn
    FROM payment
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       r.total_spending,
       r.number_of_payments,
       r.spending_rank,
       p.payment_id   AS latest_payment_id,
       p.amount       AS latest_payment_amount,
       p.payment_date AS latest_payment_date
FROM customer AS c
JOIN ranked_customers AS r
    ON c.customer_id = r.customer_id
JOIN ranked_payments AS p
    ON c.customer_id = p.customer_id
   AND p.rn = 1
ORDER BY r.spending_rank;
