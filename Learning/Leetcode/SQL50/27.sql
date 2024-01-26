CREATE TABLE Followers (
    user_id INT,
    follower_id INT
);

INSERT INTO Followers (user_id, follower_id)
VALUES 
(0, 1),
(1, 0),
(2, 0),
(2, 1);

select user_id, count(*) as followers_count from Followers  
group by user_id 
order by 1 asc