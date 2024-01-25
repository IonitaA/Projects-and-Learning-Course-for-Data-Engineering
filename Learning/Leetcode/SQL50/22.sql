CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES 
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-03-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

SELECT 
    ROUND(
        (
            SELECT COUNT(DISTINCT player_id) 
            FROM Activity a1 
            WHERE EXISTS (
                SELECT 1 
                FROM Activity a2 
                WHERE a1.player_id = a2.player_id 
                AND DATE(a1.event_date) = DATE_ADD(DATE(a2.event_date), INTERVAL 1 DAY)
            )
        ) / COUNT(DISTINCT player_id), 
        2
    ) AS fraction
FROM 
    Activity;

SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  )