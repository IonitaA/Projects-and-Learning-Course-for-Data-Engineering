CREATE TABLE Insurance (
    pid INT PRIMARY KEY,
    tiv_2015 FLOAT,
    tiv_2016 FLOAT,
    lat FLOAT NOT NULL,
    lon FLOAT NOT NULL
);

INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES 
    (1, 10, 5, 10, 10),
    (2, 20, 20, 20, 20),
    (3, 10, 30, 20, 20),
    (4, 10, 40, 40, 40);


SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM (
    SELECT tiv_2016,
           COUNT(*) OVER (PARTITION BY tiv_2015) AS same_tiv_2015,
           COUNT(*) OVER (PARTITION BY lat, lon) AS same_city
    FROM Insurance
) AS subquery
WHERE same_tiv_2015 > 1 AND same_city = 1;