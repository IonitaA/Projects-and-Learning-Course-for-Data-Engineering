CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES 
    (1, 2, '2016-06-03'),
    (1, 3, '2016-06-08'),
    (2, 3, '2016-06-08'),
    (3, 4, '2016-06-09');


select id, count(*) as num from 
(select requester_id as id
from RequestAccepted 
union all
select accepter_id  as id
from RequestAccepted) as total_RequestAccepted
group by 1
order by 2 desc 
limit 1