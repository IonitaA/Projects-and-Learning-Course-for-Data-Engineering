# export SRC_DIR=/user/`whoami`/randomtextwriter
# export TGT_DIR=/user/`whoami`/word_count

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar randomtextwriter ${SRC_DIR}

hdfs fsck ${SRC_DIR} -files -blocks

hdfs dfs -rm -R -skipTrash ${TGT_DIR}

spark-submit \
    --deploy-mode cluster \
    --conf spark.yarn.appMasterEnv.SRC_DIR=${SRC_DIR} \
    --conf spark.yarn.appMasterEnv.TGT_DIR=${TGT_DIR} \
    --conf spark.dynamicAllocation.enabled=false \
    --conf spark.sql.adaptive.enabled=false \
    /home/ionit/data-engineering-using-spark/Pyspark/word_count.py
hdfs dfs -ls ${TGT_DIR}


