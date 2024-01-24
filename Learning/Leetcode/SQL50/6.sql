CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Employees (id, name) VALUES 
(1, 'Alice'),
(7, 'Bob'),
(11, 'Meir'),
(90, 'Winston'),
(3, 'Jonathan');

CREATE TABLE EmployeeUNI (
    id INT,
    unique_id INT
);

INSERT INTO EmployeeUNI (id, unique_id) VALUES 
(3, 1),
(11, 2),
(90, 3);


select EmployeeUNI.unique_id, Employees.name 
from Employees 
left join EmployeeUNI 
on Employees.id = EmployeeUNI.id