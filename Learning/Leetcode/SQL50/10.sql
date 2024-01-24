CREATE TABLE Activity (
    machine_id INT,
    process_id INT,
    activity_type VARCHAR(255),
    timestamp FLOAT
);

INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES 
    (0, 0, 'start', 0.712),
    (0, 0, 'end', 1.520),
    (0, 1, 'start', 3.140),
    (0, 1, 'end', 4.120),
    (1, 0, 'start', 0.550),
    (1, 0, 'end', 1.550),
    (1, 1, 'start', 0.430),
    (1, 1, 'end', 1.420),
    (2, 0, 'start', 4.100),
    (2, 0, 'end', 4.512),
    (2, 1, 'start', 2.500),
    (2, 1, 'end', 5.000);

SELECT 
    start.machine_id,
    ROUND(AVG(end.timestamp - start.timestamp), 3) AS processing_time
FROM 
    (SELECT * FROM Activity WHERE activity_type = 'start') start
JOIN 
    (SELECT * FROM Activity WHERE activity_type = 'end') end
ON 
    start.machine_id = end.machine_id AND start.process_id = end.process_id
GROUP BY 
    start.machine_id;


SELECT t1.machine_id, ROUND(AVG(t2.timestamp - t1.timestamp), 3) as processing_time
    FROM 
        Activity AS t1
    INNER JOIN  
        Activity AS t2
            USING (machine_id, process_id)
    WHERE
        t1.activity_type = 'start' AND t2.activity_type='end'
    GROUP BY t1.machine_id