-- 3. Find the monthly average unrealized gain/loss of portfolios for each month in 2024.
SELECT 
    FORMAT(Date, 'yyyy-MM') AS YearMonth,
    MONTH(Date) AS MonthNumber,
    DATENAME(MONTH, Date) AS MonthName,
    AVG(Amount) AS AverageUnrealizedGainLoss
FROM 
    UNREALIZED_GAIN_LOSS
WHERE 
    YEAR(Date) = 2024
GROUP BY 
    FORMAT(Date, 'yyyy-MM'),
    MONTH(Date),
    DATENAME(MONTH, Date)
ORDER BY 
    MonthNumber;