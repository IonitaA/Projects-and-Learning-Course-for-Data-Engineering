CREATE TABLE MyNumbers (
    num INT
);

INSERT INTO MyNumbers (num)
VALUES 
(8),
(8),
(3),
(3),
(1),
(4),
(5),
(6);

SELECT MAX(num) as num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) as unique_nums;
