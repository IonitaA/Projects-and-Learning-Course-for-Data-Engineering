CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    low_fats BOOLEAN,
    recyclable BOOLEAN
);

INSERT INTO Products (product_id, low_fats, recyclable)
VALUES
    (0, 1, 0),
    (1, 1, 1),
    (2, 0, 1),
    (3, 1, 1),
    (4, 0, 0);

SELECT product_id  from Products where (low_fats, recyclable)  = (1,1)