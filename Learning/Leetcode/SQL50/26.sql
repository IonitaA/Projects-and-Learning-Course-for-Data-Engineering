CREATE TABLE Courses (
    student CHAR(1),
    class VARCHAR(255)
);

INSERT INTO Courses (student, class)
VALUES 
('A', 'Math'),
('B', 'English'),
('C', 'Math'),
('D', 'Biology'),
('E', 'Math'),
('F', 'Computer'),
('G', 'Math'),
('H', 'Math'),
('I', 'Math');

# Write your MySQL query statement below
select class  from Courses 
group by class
having count(student) >= 5
