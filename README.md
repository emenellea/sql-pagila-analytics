# Pagila SQL Practice :

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

## Notes :
- Next up in this series: a Python/pandas + NumPy version of the same kinds of analysis, for comparison between SQL and DataFrame-based approaches.

## About :

Practice project for learning SQL fundamentals through advanced window functions, using a realistic relational schema.
