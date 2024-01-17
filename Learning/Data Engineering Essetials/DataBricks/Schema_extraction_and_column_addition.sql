------pyspark in terminal------------------------------------------------

import json

-------Retrieving all data from JSON--------------------------------------------------------
schemas_text = spark.read.text('dbfs:/public/retail_db/schemas.json/', wholetext = True).first().value

-------The data for the 'orders' table has been retrieved -----------------------------------------------
column_details = json.loads(schemas_text)['orders']

------The column names have been retrieved and sorted------------------------------------
columns = [col['column_name'] for col in sorted(column_details, key = lambda col: col['column_position'])]

------Reading the table and adding headers------------------------------------------
orders = spark.read.csv('dbfs:/public/retail_db/orders',inferSchema = True).toDF(*columns)
spark.read.csv('dbfs:/public/retail_db/orders',schema = 'order_id INT, order_date DATE, order_customer_id INT, order_status STRING')


-------Creating a query ----------------------------------------------------------
from pyspark.sql.functions import count, col
orders.\
    groupBy('order_status').\
    agg(count('*').alias('order_count')).\
    orderBy(col('order_count').desc() ).\
    show()

------Creating a table and adding the location. --------------------------------------------
orders.\
    write.\
    mode('overwrite').\
    parquet('dbfs:/public/retail_db_parquet/orders')

------Function that extracts column names from the schema for the respective table----------------------
import json
def get_columns(schemas_file,ds_name):
    schemas_text = spark.read.text(schemas_file, wholetext = True).first().value
    schemas = json.loads(schemas_text)
    column_details = schemas[ds_name]
    columns = [col['column_name'] for col in sorted(column_details, key = lambda col: col['column_position'])]
    return columns


ds_list = list(json.loads(schemas_text).keys())
base_dir= 'dbfs:/public/retail_db'
tgt_base_dir= 'dbfs:/public/retail_db_parquet'

---------For all tables in the schema, we extract the headers, read the tables with added headers, and create the tables in the database in Parquet format at another location
for ds in ds_list:
    print(f'Proccesing {ds} data')
    columns = get_columns(f'{base_dir}/schemas.json',ds)
    df = spark.\
        read.csv(f'{base_dir}/{ds}',inferSchema = True).\
        toDF(*columns)
    df.\
        write.\
        mode('overwrite').\
        parquet(f'{tgt_base_dir}/{ds}')

