-----------Setting up the path where we will place the databases-----------
%sql
SET spark.sql.warehouse.dir 

---------Their path-------------------------
%fs ls dbfs:/user/hive/warehouse

%sql
create database itveristy_retail_db

%sql
describe database itveristy_retail_db

%sql
DROP DATABASE if EXISTS itveristy_retail_db cascade

---------Using a database----------------
%sql
use itveristy_retail_db

-----------Visualizing the used database --------------
%sql
select current_database()

----------"Creating a managed table in the database."--------------- 
%sql
create table itveristy_retail_db.orders(
  order_id INT,
  order_date TIMESTAMP,
  order_customer_id INT,
  order_status STRING
)using DELTA

--------Ionformations about table ---------------
%sql
describe formatted orders

%sql
show create table orders

-------add data from phisical folder to a table in DB ----------
%sql
copy into orders
from 'dbfs:/public/retail_db_parquet/orders/'
FILEFORMAT = PARQUET

--------CREATE EXTERNAL TABLE ------------------------------------
%sql
CREATE EXTERNAL TABLE order_items (
  order_item_id LONG,
  order_item_order_id LONG,
  order_item_product_id LONG,
  order_item_quantity LONG,
  order_item_subtotal DOUBLE,
  order_item_product_price DOUBLE
)USING DELTA
options(
  path='dbfs:/public/hive/warehouse/itveristy_retail_db.db/order_items'
)

--------delete data from table--------
drop TABLE IF EXISTS order_items

--------Deleting the folder.-----------
%fs rm -r dbfs:/public/hive/warehouse/itveristy_retail_db.db/order_items

--------Adding data to a table based on the schema ------------------
%sql
copy into order_items
from 'dbfs:/public/retail_db_parquet/order_items/'
FILEFORMAT = PARQUET

------------Adding data to a table without enforcing schema constraints -----------
%sql
INSERT INTO order_items
SELECT order_item_id,
order_item_order_id,
order_item_product_id,
order_item_quantity,
order_item_subtotal,
order_item_product_price 
FROM PARQUET.`dbfs:/public/retail_db_parquet/order_items/`


-------------update - insert new data -----------------------
MERGE INTO crud_demo AS cd 
USING crud_demo_stg AS cdg 
ON cd.user_id = cdg.user_id 
WHEN MATCHED THEN UPDATE SET
  cd.user_fname = cdg.user_fname,
  cd.user_lname = cdg.user_lname,
  cd.user_email = cdg.user_email
WHEN NOT MATCHED THEN INSERT
  (cd.user_id, cd.user_fname, cd.user_lname, cd.user_email)
VALUES 
  (cdg.user_id, cdg.user_fname, cdg.user_lname, cdg.user_email)