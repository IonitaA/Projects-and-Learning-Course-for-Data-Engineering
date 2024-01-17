import os
from sqlalchemy import create_engine
import pandas as pd

os.environ['DATABASE_URL'] = 'postgresql://itversity_retail_user:itversity@localhost:5432/itversity_retail_db' 
conn = 'postgresql://itversity_retail_user:itversity@localhost:5432/itversity_retail_db' 

engine = create_engine(os.environ['DATABASE_URL'])
query = "SELECT * FROM orders"

df_engine = pd.read_sql(query, engine)
df_conn = pd.read_sql(query, conn)

print(df_engine)
print("---------------------------------------------------------------------------")

empty_df = df_engine.iloc[0:0]
print(empty_df)

empty_df.to_sql('orders', conn, if_exists='replace',index=False)  # add empty tabble

df_conn = pd.read_sql(query, conn)
print(df_conn)

df_engine.to_sql('orders', conn, if_exists='replace',index=False) # add full table

df_conn = pd.read_sql(query, conn)
print(df_conn)
