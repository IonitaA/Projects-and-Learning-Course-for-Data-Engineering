CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price DECIMAL(10, 2)
);

INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES 
    (1, 100, 2008, 10, 5000),
    (2, 100, 2009, 12, 5000),
    (7, 200, 2011, 15, 9000);

CREATE TABLE Product (
    product_id INT,
    product_name VARCHAR(255)
);

INSERT INTO Product (product_id, product_name)
VALUES 
    (100, 'Nokia'),
    (200, 'Apple'),
    (300, 'Samsung');


select 
product_id, 
year as first_year, 
quantity, 
price  
from Sales 
where (product_id, year) in (
    SELECT product_id, MIN(year) 
    FROM Sales
    GROUP BY 1
)
