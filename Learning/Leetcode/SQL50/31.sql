CREATE TABLE Employee (
    employee_id INT,
    department_id INT,
    primary_flag CHAR(1),
    PRIMARY KEY (employee_id, department_id)
);

INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES
    (1, 1, 'N'),
    (2, 1, 'Y'),
    (2, 2, 'N'),
    (3, 3, 'N'),
    (4, 2, 'N'),
    (4, 3, 'Y'),
    (4, 4, 'N');

select employee_id, department_id
from Employee
where primary_flag = 'Y' or employee_id in 
    (select employee_id from Employee group by employee_id having count(*) = 1)