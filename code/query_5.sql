-- 5. Find investors who consistently top up their investment at the beginning of every month (dollar-cost averaging) in 2024 for at least one of their portfolios.
WITH MonthlyTopups AS (
    SELECT 
        t.Phone,
        t.PID,
        MONTH(t.Date) AS MonthNumber,
        COUNT(*) AS TopupCount
    FROM 
        Transaction1 t
    WHERE 
        t.Type = 'TOPUP'
        AND YEAR(t.Date) = 2024
        AND DAY(t.Date) <= 5  -- Assuming "beginning of month" means within first 5 days
    GROUP BY 
        t.Phone,
        t.PID,
        MONTH(t.Date)
)
SELECT 
    i.Name AS InvestorName,
    i.Phone,
    COUNT(DISTINCT m.MonthNumber) AS MonthsWithTopups
FROM 
    INVESTOR i
JOIN 
    MonthlyTopups m ON i.Phone = m.Phone
GROUP BY 
    i.Name,
    i.Phone
HAVING 
    COUNT(DISTINCT m.MonthNumber) > 0
ORDER BY 
    MonthsWithTopups DESC;