CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    departmentId INT
);

INSERT INTO Employee (id, name, salary, departmentId)
VALUES 
    (1, 'Joe', 85000, 1),
    (2, 'Henry', 80000, 2),
    (3, 'Sam', 60000, 2),
    (4, 'Max', 90000, 1),
    (5, 'Janet', 69000, 1),
    (6, 'Randy', 85000, 1),
    (7, 'Will', 70000, 1);

CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Department (id, name)
VALUES 
    (1, 'IT'),
    (2, 'Sales');




SELECT D.name AS 'Department', E.name AS 'Employee', E.salary
FROM (
    SELECT departmentId, salary,
           DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) as salary_rank
    FROM Employee
) AS ER
JOIN Employee E ON ER.departmentId = E.departmentId AND ER.salary = E.salary
JOIN Department D ON E.departmentId = D.id
WHERE ER.salary_rank <= 3
GROUP BY D.name, E.name, E.salary;
