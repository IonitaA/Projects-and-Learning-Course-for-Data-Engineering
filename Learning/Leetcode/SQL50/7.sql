CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL
);

INSERT INTO Product (product_id, product_name) VALUES 
(100, 'Nokia'),
(200, 'Apple'),
(300, 'Samsung');

CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price INT,
    PRIMARY KEY (sale_id, year),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Sales (sale_id, product_id, year, quantity, price) VALUES 
(1, 100, 2008, 10, 5000),
(2, 100, 2009, 12, 5000),
(7, 200, 2011, 15, 9000);

select Product.product_name, Sales.year, Sales.price 
from Sales 
join Product 
on Sales.product_id = Product.product_id 