CREATE TABLE QueryResults (
    query_name VARCHAR(255),
    result VARCHAR(255),
    position INT,
    rating INT
);

INSERT INTO QueryResults (query_name, result, position, rating)
VALUES 
    ('Dog', 'Golden Retriever', 1, 5),
    ('Dog', 'German Shepherd', 2, 5),
    ('Dog', 'Mule', 200, 1),
    ('Cat', 'Shirazi', 5, 2),
    ('Cat', 'Siamese', 3, 3),
    ('Cat', 'Sphynx', 7, 4);

Select  query_name,
Round(sum(rating/position) / count(*),2) as quality, 
Round(sum(case when rating < 3 then 1 else 0 end) * 100 / count(*),2) as poor_query_percentage 
from Queries where query_name  is not NULL
group by 1