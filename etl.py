import pandas as pd
from sqlalchemy import create_engine
from config import DB_URL


def extract(engine):
    customers = pd.read_sql('select * from customer', engine)
    payments = pd.read_sql('select customer_id, amount, payment_date from payment', engine)
    print('Extracted', len(customers), 'customers and', len(payments), 'payments')
    return customers, payments


def transform(customers, payments):
    print('Missing values:', customers.isna().sum().sum())
    print('Duplicate rows:', customers.duplicated().sum())
    customers['email'] = customers['email'].str.lower()

    summary = payments.groupby('customer_id').agg(
        total_spent=('amount', 'sum'),
        num_payments=('amount', 'count'),
        avg_payment=('amount', 'mean')
    ).reset_index()

    summary = summary.merge(
        customers[['customer_id', 'first_name', 'last_name']],
        on='customer_id'
    )
    return summary


def load(summary, engine):
    summary.to_sql('customer_summary', engine, if_exists='replace', index=False)
    print('Loaded', len(summary), 'rows into customer_summary')


def main():
    engine = create_engine(DB_URL)
    customers, payments = extract(engine)
    summary = transform(customers, payments)
    load(summary, engine)
    print('Done')


if __name__ == '__main__':
    main()