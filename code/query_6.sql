-- 6. Find the most popular financial goals for investors working in the same company and whose age is between 30 to 40 years old.
WITH InvestorAge AS (
    SELECT 
        i.Phone,
        i.Name,
        i.Company,
        i.DoB,
        DATEDIFF(YEAR, i.DoB, GETDATE()) AS Age
    FROM 
        INVESTOR i
),
AgeFiltered AS (
    SELECT 
        ia.Phone,
        ia.Name,
        ia.Company,
        ia.Age
    FROM 
        InvestorAge ia
    WHERE 
        ia.Age BETWEEN 30 AND 40
)
SELECT 
    af.Company,
    fg.Goal,
    COUNT(*) AS NumberOfInvestors
FROM 
    AgeFiltered af
JOIN 
    FINANCIAL_GOAL fg ON af.Phone = fg.Phone
GROUP BY 
    af.Company,
    fg.Goal
ORDER BY 
    af.Company,
    NumberOfInvestors DESC;