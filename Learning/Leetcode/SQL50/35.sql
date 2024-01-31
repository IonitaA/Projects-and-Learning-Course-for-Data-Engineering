CREATE TABLE Queue (
    person_id INT,
    person_name VARCHAR(255),
    weight INT,
    turn INT
);

INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES 
    (5, 'Alice', 250, 1),
    (4, 'Bob', 175, 5),
    (3, 'Alex', 350, 2),
    (6, 'John Cena', 400, 3),
    (1, 'Winston', 500, 6),
    (2, 'Marie', 200, 4);

SELECT person_name
FROM (
    SELECT person_name, SUM(weight) OVER (ORDER BY turn) AS cumulative_weight
    FROM Queue
) AS subquery
WHERE cumulative_weight <= 1000
ORDER BY cumulative_weight DESC
LIMIT 1
