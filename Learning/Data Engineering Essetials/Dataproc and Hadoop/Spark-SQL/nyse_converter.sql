create database if not exists nyse_db;

use nyse_db;

CREATE TABLE IF NOT EXISTS nyse_stg (
  ticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  volume BIGINT
)
USING CSV
OPTIONS (
  path = '/user/${username}/data/nyse'
);

CREATE TABLE IF NOT EXISTS nyse_daily (
  ticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  volume BIGINT
) USING delta
PARTITIONED by (trademonth INT);

refresh table nyse_stg;

INSERT INTO TABLE nyse_daily PARTITION (trademonth)
SELECT ns.*, substr(tradedate, 1, 6) as trademonth from nyse_stg as ns ;

select count(*) from nyse_stg;
select count(*) from nyse_daily;

select substr(trademonth,1,4) as tradeyear, count(*) as tradecount
from nyse_daily
group by tradeyear
order by tradeyear;
