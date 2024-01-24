CREATE TABLE Students (
    student_id INT,
    student_name VARCHAR(255)
);

INSERT INTO Students (student_id, student_name)
VALUES 
    (1, 'Alice'),
    (2, 'Bob'),
    (13, 'John'),
    (6, 'Alex');

CREATE TABLE Subjects (
    subject_name VARCHAR(255)
);

INSERT INTO Subjects (subject_name)
VALUES 
    ('Math'),
    ('Physics'),
    ('Programming');

CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(255)
);

INSERT INTO Examinations (student_id, subject_name)
VALUES 
    (1, 'Math'),
    (1, 'Physics'),
    (1, 'Programming'),
    (2, 'Programming'),
    (1, 'Physics'),
    (1, 'Math'),
    (13, 'Math'),
    (13, 'Programming'),
    (13, 'Physics'),
    (2, 'Math'),
    (1, 'Math');

select 
    Students.student_id,
    Students.student_name, 
    Subjects.subject_name, 
    COUNT(Examinations.subject_name) as attended_exams 
from Students 
CROSS JOIN Subjects
left join Examinations
on Students.student_id = Examinations.student_id
 and 
Subjects.subject_name  = Examinations.subject_name
group by 1,3
order by 1,3

SELECT s.student_id, s.student_name, sj.subject_name, count(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sj
LEFT JOIN Examinations e
ON s.student_id = e.student_id and sj.subject_name = e.subject_name
GROUP BY s.student_id,s.student_name, sj.subject_name
ORDER BY s.student_id, sj.subject_name;
