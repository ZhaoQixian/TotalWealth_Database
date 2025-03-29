-- 1. Find investors who are making on average a loss across all their portfolios in 2024.
SELECT 
    i.Phone, 
    i.Name, 
    AVG(ul.Amount) as AvgUnrealizedGainLoss
FROM 
    INVESTOR i
JOIN 
    Portfolio1 p ON i.Phone = p.Phone
JOIN 
    UNREALIZED_GAIN_LOSS ul ON p.PID = ul.PID AND p.Phone = ul.Phone
WHERE 
    YEAR(ul.Date) = 2024
GROUP BY 
    i.Phone, i.Name
HAVING 
    AVG(ul.Amount) < 0
ORDER BY 
    AvgUnrealizedGainLoss;