# Pagila SQL Analysis and Python ETL :

A set of SQL exercises solved against the [Pagila](https://github.com/devrimgunduz/pagila) sample database (PostgreSQL's version of Sakila — a fictional DVD rental store). This repo is a personal practice log, organized from basic queries to window functions.

## Database :

**Pagila** models a DVD rental business: `customer`, `film`, `actor`, `category`, `inventory`, `rental`, `payment`, `store`, `staff`, `address`, `city`, `country`, and bridge tables like `film_actor` and `film_category`.

- Schema + data: https://github.com/devrimgunduz/pagila
- Engine: PostgreSQL

## Contents :

| File | Topics covered |
|---|---|
| [`sql/01_basic_queries.sql`](sql/01_basic_queries.sql) | `SELECT`, `WHERE`, `LIKE`, `BETWEEN`, `IN`, `ORDER BY`, `LIMIT` |
| [`sql/02_aggregation_grouping.sql`](sql/02_aggregation_grouping.sql) | `GROUP BY`, `HAVING`, aggregate functions |
| [`sql/03_joins.sql`](sql/03_joins.sql) | `INNER JOIN` across customer / rental / payment / film / actor / category |
| [`sql/04_subqueries_ctes.sql`](sql/04_subqueries_ctes.sql) | Subqueries, CTEs, `CASE` expressions, date functions, `LEFT JOIN` anti-patterns |
| [`sql/05_window_functions.sql`](sql/05_window_functions.sql) | `ROW_NUMBER`, `RANK`, `LAG`, running totals, `EXISTS` / `NOT EXISTS` |

Each file is self-contained, numbered, and commented with the original question above every query.

 ## Python ETL pipeline

After the SQL practice, I built a small ETL pipeline in Python (`etl.py`):

1. **Extract:** reads `customer` and `payment` from PostgreSQL with pandas.
2. **Transform:** checks for nulls and duplicates, lowercases emails, and calculates total spent, number of payments, and average payment per customer.
3. **Load:** writes the result into a new table, `customer_summary`.

**Tools:** Python, pandas, SQLAlchemy, psycopg, PostgreSQL

**How to run:**
1. `pip install -r requirements.txt`
2. Copy `config_example.py` to `config.py` and fill in your database details
3. `python etl.py`
4. Check the result: `select * from customer_summary limit 5;`

**What I learned:** connecting Python to PostgreSQL, pandas `groupby` and `merge` (the equivalents of `GROUP BY` and `JOIN`), and structuring a pipeline into extract, transform, and load functions.
