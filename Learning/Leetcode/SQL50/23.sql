CREATE TABLE Teachers (
    teacher_id INT,
    subject_id INT,
    dept_id INT
);

INSERT INTO Teachers (teacher_id, subject_id, dept_id)
VALUES 
    (1, 2, 3),
    (1, 2, 4),
    (1, 3, 3),
    (2, 1, 1),
    (2, 2, 1),
    (2, 3, 1),
    (2, 4, 1);

select 
teacher_id, 
count(distinct subject_id ) as cnt 
from Teacher 
group by 1