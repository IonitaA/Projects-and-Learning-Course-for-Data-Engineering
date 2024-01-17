----------------IN CMD---------------------------------------------

----------------Connecting to Databricks with a profile and token --------------------
databricks configure --host https://8063617419628354.4.gcp.databricks.com --token --profile analytiqsgcp
Token: dapia83e1d66e1b095bde47383b83c85a16a

databricks fs ls --profile analytiqsgcp

----------------Adding data from the environment to Databricks-----------------------------------
databricks fs cp data dbfs:/public/retail_db --recursive --profile analytiqsgcp

---------------- Displaying the files located in a specific location--------------------
%fs ls dbfs:/public/retail_db/

databricks clusters list --profile analytiqsgcp
databricks clusters start --cluster-id 1202-102257-cdx9t5s4 --profile analytiqsgcp


-----------------IN DATABRICKS------------------------------------------------------------
spark.sql('SELECT current_date').show()

%sql
SELECT current_date


%fs ls dbfs:/public/retail_db

%sql
SELECT * FROM TEXT.'/public/retail_db/order_items/'
SELECT * FROM CSV.`/public/retail_db/order_items/`
SELECT * FROM PARQUET.`/public/retail_db/daily_product_revenue/`
