#creare mediu
spark-sql \
    --conf spark.sql.warehouse.dir=/user/$USER/spark/warehouse \                                    # set warehouse
    --packages io.delta:delta-core_2.12:2.1.0 \                                                     # add pack for delta         
    --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    -f /home/ionit/data-engineering-using-spark/shell_scripts/nyse_converter.sql \                  # run script
    -d username = $USER \                                                                           # create variable
    --verbose \
    2>/dev/null


hdfs dfs -ls /user/ionit/data/nyse
hdfs dfs -mkdir -p /user/ionit/data/nyse
hdfs dfs -put /home/ionit/data-engineering-using-spark/data/nyse_all/nyse_data /user/ionit/data/nyse

hdfs dfs -put /home/ionit/data-engineering-using-spark/data/nyse_all/nyse_data/NYSE_1997.txt.gz /user/ionit/data/nyse

!hdfs dfs -rm -R -skipTrash /user/ionit/data/nyse/*
; # '!' because linux comand in spark

!hdfs dfs -ls /user/whoami/spark/warehouse/nyse_db.db/nyse_daily

spark-sql -e "DROP DATABASE nyse_db cascade"  #run spark comnd in terminal without create medd

chmod u+x nyse_converter.sh                   # add proprietis to execute script

 ./nyse_converter.sh ionit

 hdfs dfs -ls -R /user