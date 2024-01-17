pyspark --conf spark.sql.warehouse.dir=/user/$USER/spark/warehouse          #set warehouse

spark.conf.get('spark.sql.warehouse.dir')

spark.sql('show databases').show()