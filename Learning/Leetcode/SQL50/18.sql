CREATE TABLE Users (
    user_id INT,
    user_name VARCHAR(255)
);

INSERT INTO Users (user_id, user_name)
VALUES 
    (6, 'Alice'),
    (2, 'Bob'),
    (7, 'Alex');

CREATE TABLE Register (
    contest_id INT,
    user_id INT
);

INSERT INTO Register (contest_id, user_id)
VALUES 
    (215, 6),
    (209, 2),
    (208, 2),
    (210, 6),
    (208, 6),
    (209, 7),
    (209, 6),
    (215, 7),
    (208, 7),
    (210, 2),
    (207, 2),
    (210, 7);


select 
contest_id, 
round(count(distinct user_id) * 100 /(select count(user_id) from Users) ,2) as percentage
from  Register
group by contest_id
order by percentage desc,contest_id