CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    reports_to INT,
    age INT,
);

INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES
    (9, 'Hercy', NULL, 43),
    (6, 'Alice', 9, 41),
    (4, 'Bob', 9, 36),
    (2, 'Winston', NULL, 37);


Select 
reports_to as employee_id,  
(select  
    name 
    from Employees w2 
    where w1.reports_to = w2.employee_id) as name,
count(*) as reports_count, 
round(avg(age))  as average_age 
from Employees w1
where reports_to  is not null
group by reports_to 
order by 1 