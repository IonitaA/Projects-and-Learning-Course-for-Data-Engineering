CREATE TABLE Accounts (
    account_id INT,
    income INT
);

INSERT INTO Accounts (account_id, income)
VALUES 
    (3, 108939),
    (2, 12747),
    (8, 87709),
    (6, 91796);


WITH Categories AS (
    SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
),
Counts AS (
    SELECT 
        (CASE 
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
            ELSE 'High Salary'
        END) AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    GROUP BY category
)
SELECT 
    Categories.category, 
    COALESCE(Counts.accounts_count, 0) AS accounts_count
FROM Categories
LEFT JOIN Counts ON Categories.category = Counts.category;