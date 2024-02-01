CREATE TABLE Movies (
    movie_id INT,
    title VARCHAR(255)
);

INSERT INTO Movies (movie_id, title)
VALUES 
    (1, 'Avengers'),
    (2, 'Frozen 2'),
    (3, 'Joker');

CREATE TABLE Users (
    user_id INT,
    name VARCHAR(255)
);

INSERT INTO Users (user_id, name)
VALUES 
    (1, 'Daniel'),
    (2, 'Monica'),
    (3, 'Maria'),
    (4, 'James');

CREATE TABLE MovieRating (
    movie_id INT,
    user_id INT,
    rating INT,
    created_at DATE
);

INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES 
    (1, 1, 3, '2020-01-12'),
    (1, 2, 4, '2020-02-11'),
    (1, 3, 2, '2020-02-12'),
    (1, 4, 1, '2020-01-01'),
    (2, 1, 5, '2020-02-17'),
    (2, 2, 2, '2020-02-01'),
    (2, 3, 2, '2020-03-01'),
    (3, 1, 3, '2020-02-22'),
    (3, 2, 4, '2020-02-25');



(Select 
u.name as results
from MovieRating as mr
left join Users as u
on mr.user_id = u.user_id
group by mr.user_id
order by count(*) desc, u.name asc
limit 1)
union all
(Select 
m.title as results
from MovieRating as mr
left join Movies as m
on mr.movie_id = m.movie_id
WHERE 
    YEAR(mr.created_at) = 2020 AND MONTH(mr.created_at) = 2
group by mr.movie_id
order by avg(rating) desc, m.title asc
limit 1)


