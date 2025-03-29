-- 2. Find investors who are seeing an annualized return of more than 10% from their portfolios in 2024.
SELECT 
    i.Name AS InvestorName,
    i.Phone,
    p.PID AS PortfolioID,
    p.AnnualizedReturn
FROM 
    INVESTOR i
INNER JOIN 
    Portfolio1 p ON i.Phone = p.Phone
WHERE 
    p.AnnualizedReturn > 10.0
ORDER BY 
    p.AnnualizedReturn DESC;