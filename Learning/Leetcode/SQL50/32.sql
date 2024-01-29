CREATE TABLE Triangle (
    x INT,
    y INT,
    z INT
);

INSERT INTO Triangle (x, y, z) VALUES
    (13, 15, 30),
    (10, 20, 15);

select 
*,
(case when ((x + z ) > y) and ((x + y ) > z) and ((y + z ) > x) then "Yes" else "No" end)  as triangle 
from
Triangle 

select
x,y,z,
(case
when greatest(x,y,z) < (1/2*(x+y+z)) then 'Yes'
else 'No'
end) as triangle
from triangle
