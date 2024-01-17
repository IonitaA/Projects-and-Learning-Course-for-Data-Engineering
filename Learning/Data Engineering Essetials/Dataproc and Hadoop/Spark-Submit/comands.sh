#CREATEA ENVIORMENT VARIABLE
export SRC_BASE_DIR=/user/ionit
export TGT_BASE_DIR=/user/ionit/retail_db

#VIEW ENVIORMENT VARIABLE
echo $SRC_BASE_DIR
echo $TGT_BASE_DIR

# run on client 
spark-submit \ /home/ionit/data-engineering-using-spark/Pyspark/aplication.py

spark-submit 
--deploy-mode client \
    /home/ionit/data-engineering-using-spark/Pyspark/aplication.py

#run on cluster
spark-submit \ 
    --deploy-mode cluster \
    --packages io.delta:delta-core_2.12:2.1.0 \                                 #package for delta
    --conf spark.yarn.appMasterEnv.SRC_BASE_DIR=${SRC_BASE_DIR} \                   #CREATEA ENVIORMENT VARIABLE
    --conf spark.yarn.appMasterEnv.TGT_BASE_DIR=${TGT_BASE_DIR} \         #CREATEA ENVIORMENT VARIABLE
    /home/ionit/data-engineering-using-spark/Pyspark/aplication.py


# we can use folders for packages
cd /tmp
mkdir jars
cd /jars
wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.1.0/delta-core_2.12-2.1.0.jar        # one package

spark-submit --jars /tmp/jars/delta-core_2.12-2.1.0.jar, ...
