-- 4. What is the top three most popular first financial goals for investors in 2024?
SELECT TOP 3
    Goal,
    COUNT(*) AS NumberOfInvestors
FROM 
    FINANCIAL_GOAL
GROUP BY 
    Goal
ORDER BY 
    NumberOfInvestors DESC;