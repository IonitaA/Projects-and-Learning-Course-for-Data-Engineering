# Import necessary libraries and modules
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from py4j.java_gateway import java_import
import datetime
import subprocess
import os
import calendar
import sys
import pandas as pd

# Create a Spark session
spark = SparkSession. \
    builder. \
    appName('Process data from BVB API').\
    master('yarn'). \
    getOrCreate()

# Import Java classes for Hadoop file system operations
java_import(spark._jvm, 'org.apache.hadoop.fs.FileSystem')
java_import(spark._jvm, 'org.apache.hadoop.fs.Path')

# Get Hadoop file system object
fs = spark._jvm.org.apache.hadoop.fs.FileSystem.get(spark._jsc.hadoopConfiguration())

# Define paths and directories
DataLake_dir = "/user/ionit/DataStock/DataLake"
DataLake_path = spark._jvm.org.apache.hadoop.fs.Path(DataLake_dir)

# Create DataLake directory if it does not exist
if not fs.exists(DataLake_path):
    fs.mkdirs(DataLake_path)

# Define API URL for historical trading data
API_url = "https://m.bvb.ro/TradingAndStatistics/Trading/HistoricalTradingInfo.ashx?day="

# Get years from environment variable
years = os.environ.get('Years').split(',')

# Create an empty DataFrame for storing data
df_WareHouse = spark.createDataFrame([], schema="Symbol string, Name string, Market string, Trades string, Volume string, Value string, Open string, Low string, High string, Avg string, Close string, RefPrice string, VarPercent string, Data string")

# Iterate through each year
for year in years:
    # Check if the year is valid
    if not year.isdigit() or int(year) < 1990 or int(year) > 2024:
        print(f"The year {year} is not valid. Please provide a year between 1990 and 2024.")
        continue

    # Convert year to integer
    year = int(year)
    
    # Set the start date for the year
    start_date = datetime.datetime(year, 1, 1)

    # Determine the number of days in the year
    if calendar.isleap(year):
        days = 366
    else:
        days = 365

    # Iterate through each day in the year
    for i in range(days):
        # Calculate the current date
        current_date = start_date + datetime.timedelta(days=i)
        
        # Construct the API URL for the current date
        url = f"{API_url}{current_date.strftime('%Y%m%d')}"
        
        # Generate a unique file name for the current date
        API_file_name = f"BVB_Historical_trading_info_{current_date.strftime('%Y%m%d')}.csv"
        
        # Specify the HDFS path for storing the data
        DataLake_path = spark._jvm.org.apache.hadoop.fs.Path(os.path.join(DataLake_dir, str(current_date.year), str(current_date.month)))
        
        # Create the directory structure if it does not exist
        if not fs.exists(DataLake_path):
            fs.mkdirs(DataLake_path)
        
        # Specify the HDFS path for the current file
        DataLake_hdfs_path = spark._jvm.org.apache.hadoop.fs.Path(f"{DataLake_path}/{API_file_name}")
        
        # Check if the file already exists in HDFS
        if not fs.exists(DataLake_hdfs_path):
            # Use subprocess to download the file using wget
            result = subprocess.run(["wget", "-O", API_file_name, url])
            
            # Check if the downloaded file is not empty
            if os.path.getsize(API_file_name) > 0:
                # Copy the local file to HDFS
                fs.copyFromLocalFile(spark._jvm.org.apache.hadoop.fs.Path(API_file_name), DataLake_hdfs_path)
                
                # Remove the local file
                os.remove(API_file_name)

            # Continue to the next iteration if the download was not successful
            if result.returncode != 0:
                continue

        # Read the data from the CSV file in HDFS into a Spark DataFrame
        if fs.exists(DataLake_hdfs_path):
            df = spark.read.option("delimiter", ",").csv(str(DataLake_hdfs_path), header=True)
            
            # Add a 'Data' column with the current date to the DataFrame
            df = df.withColumn('Data', F.lit(current_date.strftime('%Y-%m-%d')))
            
            # Append the current DataFrame to the main DataFrame
            df_WareHouse = df_WareHouse.union(df)

# Define the HDFS path for storing the final DataFrame
warehouse_path = spark._jvm.org.apache.hadoop.fs.Path('/user/ionit/DataStock/DataWareHouse')

# Create the directory structure if it does not exist
if not fs.exists(warehouse_path):
    fs.mkdirs(warehouse_path)

# Write the final DataFrame to HDFS in CSV format
df_WareHouse.write.mode('overwrite').csv(str(warehouse_path), header=True)
