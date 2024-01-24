CREATE TABLE Project (
    project_id INT,
    employee_id INT
);

INSERT INTO Project (project_id, employee_id)
VALUES 
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4);

CREATE TABLE Employee (
    employee_id INT,
    name VARCHAR(255),
    experience_years INT
);

INSERT INTO Employee (employee_id, name, experience_years)
VALUES 
    (1, 'Khaled', 3),
    (2, 'Ali', 2),
    (3, 'John', 1),
    (4, 'Doe', 2);

SELECT Project.project_id , round(avg(Employee.experience_years),2) as average_years 
from Project 
left join Employee 
on Project.employee_id  = Employee.employee_id 
group by Project.project_id 
