CREATE TABLE Cinema (
    id INT,
    movie VARCHAR(255),
    description VARCHAR(255),
    rating FLOAT
);

INSERT INTO Cinema (id, movie, description, rating)
VALUES 
    (1, 'War', 'great 3D', 8.9),
    (2, 'Science', 'fiction', 8.5),
    (3, 'irish', 'boring', 6.2),
    (4, 'Ice song', 'Fantacy', 8.6),
    (5, 'House card', 'Interesting', 9.1);

select * 
from Cinema  
where id % 2 = 1 and description != 'boring' 
order by 4 desc
