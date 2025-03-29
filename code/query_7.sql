-- 7. Are male investors in their 20s making more money from their investments than their female counterparts in 2024?
WITH InvestorAge AS (
    SELECT 
        i.Phone,
        i.Name,
        i.Gender,
        DATEDIFF(YEAR, i.DoB, '2025-03-29') AS Age,
        i.AnnualIncome
    FROM 
        INVESTOR i
    WHERE 
        DATEDIFF(YEAR, i.DoB, '2025-03-29') BETWEEN 20 AND 29
),
InvestmentPerformance AS (
    SELECT
        ia.Phone,
        ia.Name,
        ia.Gender,
        ia.Age,
        COALESCE(ugl.Amount, 0) AS UnrealizedGainLoss,
        p.AnnualizedReturn
    FROM
        InvestorAge ia
    JOIN
        Portfolio1 p ON ia.Phone = p.Phone
    LEFT JOIN
        UNREALIZED_GAIN_LOSS ugl ON ia.Phone = ugl.Phone 
                                AND p.PID = ugl.PID 
                                AND ugl.Date = '2024-03-31'  -- Most recent data point
)
SELECT 
    Gender,
    COUNT(*) AS InvestorCount,
    AVG(UnrealizedGainLoss) AS AvgUnrealizedGainLoss,
    AVG(AnnualizedReturn) AS AvgAnnualizedReturn
FROM 
    InvestmentPerformance
GROUP BY 
    Gender
ORDER BY 
    AvgUnrealizedGainLoss DESC;