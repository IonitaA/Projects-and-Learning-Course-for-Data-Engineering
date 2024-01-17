USERNAME=${1}
spark-sql \
    --conf spark.sql.warehouse.dir=/user/'whoami'/spark/warehouse \
    --packages io.delta:delta-core_2.12:2.1.0 \
    --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
    -f /home/ionit/data-engineering-using-spark/shell_scripts/nyse_converter.sql \
    -d username = ${USERNAME} \
    --verbose \
    2>/dev/null

    hdfs dfs -rm -R -skipTrash /user/${USERNAME}/data/nyse/*