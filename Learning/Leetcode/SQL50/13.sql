CREATE TABLE Employee (
    id INT,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

INSERT INTO Employee (id, name, department, managerId)
VALUES 
    (101, 'John', 'A', NULL),
    (102, 'Dan', 'A', 101),
    (103, 'James', 'A', 101),
    (104, 'Amy', 'A', 101),
    (105, 'Anne', 'A', 101),
    (106, 'Ron', 'B', 101);

select name 
from Employee 
where id in (
    select managerId 
    from Employee  
    group by 1 
    having  count(*) >= 5
)