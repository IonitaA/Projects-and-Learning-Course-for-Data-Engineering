# Grant execute permission to the WorkFlow.sh script
# chmod u+x WorkFlow.sh

# Execute the WorkFlow.sh script
# sh WorkFlow.sh

# Set the environment variable 'Years' to the value "2024"
export Years="2024"

# Submit a Spark job to process data from API to HDFS
spark-submit \
    --deploy-mode cluster \
    --conf spark.yarn.appMasterEnv.Years=${Years} \
    /home/ionit/StockProject/Procces_data_API_to_HDFS.py

# Merge the files in the HDFS DataWareHouse directory into a single file on the local file system
hadoop fs -getmerge /user/ionit/DataStock/DataWareHouse /home/ionit/StockProject/HDFS_BVB_Dataset.csv

# Run the Python script for modeling the merged dataset
python Modeling_the_merged_dataset.py

# Copy the resulting BVB_Dataset.csv file to a Google Cloud Storage bucket
gsutil cp BVB_Dataset.csv gs://stock_market_data_processing

# Check if the BigQuery dataset 'stockdata' exists; if not, create it
if ! bq ls -n 1 'stock-market-project-413114:stockdata' | grep -q 'BVB_Dataset'; then
    bq mk -t 'stock-market-project-413114:stockdata.BVB_Dataset'
fi

# Load the data from the local CSV file into the BigQuery table 'BVB_Dataset'
bq load --autodetect --source_format=CSV 'stock-market-project-413114:stockdata.BVB_Dataset' ./BVB_Dataset.csv
