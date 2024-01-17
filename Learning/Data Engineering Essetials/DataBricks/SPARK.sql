-----read data 

df = spark.read.csv('dbfs:/public/retail_db/orders',schema = 'order_id INT, order_date DATE, order_customer_id INT, order_status STRING')

display(
    df.select('order_date', 'order_status'). \
        distinct().\
        orderBy('order_date', 'order_status')
)

display(
df.
select(
'order_id',
'order_date',
cast('int', date_format('order_date', 'yyyyMM')).alias('order_month')
)
)


-----delete add column
display(
    df.drop('drop_customer_id'). \
    withColumn('order_month',cast('int',date_format('order_date','yyyyMM'))))

-----save data frame

df.write.format('delta').save('dbfs:/public/retail_db_delta/orders')

display(
orders_df.
groupBy('order_status').
agg(count('order_id').alias('order_count')).
orderBy(col('order_count').desc())
)


----- date databriks
%fs ls dbfs:/databricks-datasets

------- JOIN

display(
    orders_df.\
        filter("orders_status in ('COMPLETE', 'CLOSED') AND date_format(order_date,'yyyyMM') = 201410").\
            join(order_items_df, orders_df['order_id'] == order_items_df['order_item_order_id']).\
            groupBy('order_id').\
            agg(round(sum('order_item_subtotal'),2).alias('revenue')).\
            orderBy(col('revenue').desc())
)

------rank
from pyspark.sql.functions import dense_rank, col, rank
from pyspark.sql.window import Window

display(
    daily_product_revenue_df.\
        filter("order_date = '2014-01-01'").\
        withColumn('drnk',dense_rank().over(Window.orderBy(col('revenue').desc()))).\
        orderBy('order_date', col('revenue').desc())
)

display(
    daily_product_revenue_df.\
        filter("order_date = '2014-01-01'").\
        withColumn('drnk',dense_rank().over(Window.partitionBy('order_date')orderBy(col('revenue').desc()))).\
        orderBy('order_date', col('revenue').desc())
)

spec = Window.partitionBy('order_date')orderBy(col('revenue').desc())

display(
    daily_product_revenue_df.\
        filter("order_date = '2014-01-01'").\
        withColumn('drnk',dense_rank().over(spec)).\
        orderBy('order_date', col('revenue').desc())
)