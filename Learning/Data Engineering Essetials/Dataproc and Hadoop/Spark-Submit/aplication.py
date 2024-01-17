from pyspark.sql import SparkSession
from pyspark.sql.functions import sum, r
import os



src_base_dir = os.environ.get('SRC_BASE_DIR')
tgt_base_dir = os.environ.get('TGT_BASE_DIR')

spark = SparkSession. \
    builder. \
    appName('Compute Daily Revene').\
    master('yarn'). \
    getOrCreate()



orders = spark. \
    read. \
    csv(
        f'{src_base_dir}/orders',
        schema = '''
            order_id INT, order_data STRING,
            order_customer_id INT, order_status STRING
        '''
    )
order_items = spark. \
    read. \
    csv(
        f'{src_base_dir}/orders_items',
        schema = '''
            order_item_id INT, order_item_order_id INT ,
            order_item_product_id INT, order_item_quantity INT ,
            order_item_subtotal FLOAT, order_item_product_price FLOAT
        '''
    )

daily_revenue = orders. \
    filter("order_status IN ('COMPLETE', 'CLOSED')"). \
    join(order_items, orders['order_id'] == order_items['order_item_order_id']). \
    groupBy('order_date'). \
    agg(round(sum('order_item_subtotal'),2).alias('revenue')). \
    orderBy('order_date')

daily_revenue. \
    write. \
    mode('overwrite'). \
    format('delta'). \
    save( f'{tgt_base_dir}/daily_revenue', header=True)

df = spark.read.format('delta').load(f'{tgt_base_dir}/daily_revenue')