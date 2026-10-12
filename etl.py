import pandas as pd 
from sqlalchemy import create_engine
engine = create_engine('postgresql+psycopg://etl_user:YOUR_PASSSWORD@localhost:5432/pagila_practice')
customers = pd.read_sql('select * from customer', engine)
print(customers.head()) 