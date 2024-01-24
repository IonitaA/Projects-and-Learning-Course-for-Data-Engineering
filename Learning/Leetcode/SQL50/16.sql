CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price DECIMAL(10, 2)
);

INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES 
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT
);

INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES 
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);


select Prices.product_id, 
COALESCE(ROUND(sum(Prices.price * UnitsSold.units) /sum(UnitsSold.units),2),0) as average_price 
from Prices 
left join UnitsSold 
ON Prices.product_id = UnitsSold.product_id 
and Prices.start_date <= UnitsSold.purchase_date 
and UnitsSold.purchase_date <= Prices.end_date 
group by Prices.product_id
