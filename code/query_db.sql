-- This code removes all data but preserves the table structures
USE TotalWealthDB;
GO

-- PART 1: CLEAN ALL DATA FROM TABLES
-- Disable all constraints first
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

-- Delete all data from tables in reverse order of dependencies
DELETE FROM TransactionFees;
DELETE FROM Transaction1;
DELETE FROM UNREALIZED_GAIN_LOSS;
DELETE FROM INVESTED_VALUE;
DELETE FROM FUND_IN_PORTFOLIO;
DELETE FROM BOND_IN_PORTFOLIO;
DELETE FROM STOCK_IN_PORTFOLIO;
DELETE FROM PortfolioFeeStructure;
DELETE FROM Portfolio1;
DELETE FROM FUND;
DELETE FROM BOND;
DELETE FROM STOCK;
DELETE FROM ASSET;
DELETE FROM FINANCIAL_GOAL;
DELETE FROM RISK_TOLERANCE;
DELETE FROM INVESTOR;

-- Re-enable all constraints
EXEC sp_MSforeachtable "ALTER TABLE ? CHECK CONSTRAINT ALL";



--Queries
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