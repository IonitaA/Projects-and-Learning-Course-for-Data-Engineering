CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    customer_id INT
);

INSERT INTO Visits (visit_id, customer_id) VALUES 
(1, 23),
(2, 9),
(4, 30),
(5, 54),
(6, 96),
(7, 54),
(8, 54);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY, 
    visit_id INT,
    amount INT
);

INSERT INTO Transactions (transaction_id, visit_id, amount) VALUES 
(2, 5, 310),
(3, 5, 300),
(9, 7, 400);


select Visits.customer_id , count(*) as count_no_trans 
from Visits
left join Transactions
on Visits.visit_id = Transactions.visit_id
where Transactions.transaction_id is NULL
Group by Visits.customer_id


SELECT customer_id, COUNT(visit_id) as count_no_trans 
FROM Visits v
WHERE NOT EXISTS (
	SELECT visit_id FROM Transactions t 
	WHERE t.visit_id = v.visit_id
	)
GROUP BY customer_id