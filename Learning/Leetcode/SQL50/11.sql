CREATE TABLE Employee (
    empId INT,
    name VARCHAR(255),
    supervisor INT,
    salary INT
);

INSERT INTO Employee (empId, name, supervisor, salary)
VALUES 
    (3, 'Brad', NULL, 4000),
    (1, 'John', 3, 1000),
    (2, 'Dan', 3, 2000),
    (4, 'Thomas', 3, 4000);

CREATE TABLE Bonus (
    empId INT,
    bonus INT
);

INSERT INTO Bonus (empId, bonus)
VALUES 
    (2, 500),
    (4, 2000);

select e.name, b.bonus 
from Employee as e
left join Bonus as b 
on e.empId = b.empId
where b.bonus < 1000 or b.bonus is Null