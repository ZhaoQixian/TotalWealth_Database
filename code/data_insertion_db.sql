-- Switch to the correct database
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

-- PART 2: INSERT DATA RESPECTING SINGLE PRIMARY KEY CONSTRAINTS
-- ==========================================
-- INVESTOR
-- ==========================================
INSERT INTO INVESTOR VALUES 
('91234567', 'Guo Yichen', 'F', '1995-08-15', 85000.00, 'DBS'),
('98765432', 'Mahi Pandey', 'M', '1987-03-22', 120000.00, 'OCBC'),
('90001111', 'Mehta Rishika', 'F', '1980-11-02', 125000.00, 'UOB'),
('95554444', 'Zhao Qixian', 'M', '1990-06-17', 60000.00, 'Grab'),
('93332222', 'Evelyn Ong', 'F', '1962-02-23', 95000.00, 'GovTech'),
('96669999', 'Faisal Rahman', 'M', '2000-05-18', 110000.00, 'Shopee');

-- ==========================================
-- RISK_TOLERANCE
-- ==========================================
INSERT INTO RISK_TOLERANCE VALUES
('91234567', 'Aggressive', 'A', 'B', 'C', 'A', 'D'),
('98765432', 'Moderate', 'C', 'B', 'C', 'D', 'A'),
('90001111', 'Moderate', 'A', 'B', 'C', 'D', 'C'),
('95554444', 'Aggressive', 'D', 'B', 'A', 'B', 'C'),
('93332222', 'Conservative', 'C', 'C', 'B', 'D', 'A'),
('96669999', 'Aggressive', 'A', 'C', 'D', 'B', 'A');

-- ==========================================
-- FINANCIAL_GOAL
-- ==========================================
INSERT INTO FINANCIAL_GOAL VALUES
('Retirement', '91234567', 1000000.00, 30),
('Children Education', '90001111', 300000.00, 10),
('Buy Property', '98765432', 800000.00, 15),
('Holiday Fund', '95554444', 50000.00, 3),
('Medical Emergency', '93332222', 200000.00, 2),
('Start Business', '96669999', 450000.00, 5);

-- ==========================================
-- ASSET
-- ==========================================
INSERT INTO ASSET VALUES 
('STK001', 'Tesla', 900.00),
('STK002', 'Apple', 180.00),
('BND001', 'SG Bond 2035', 100.00),
('BND002', 'US Treasury 2030', 98.50),
('FND001', 'Vanguard S&P 500', 55.25),
('FND002', 'Asia Growth Fund', 45.00);

-- ==========================================
-- STOCK
-- ==========================================
INSERT INTO STOCK VALUES 
('STK001', 25.6, 12.5, 30000000.00),
('STK002', 30.0, 15.2, 50000000.00);

-- ==========================================
-- BOND
-- ==========================================
INSERT INTO BOND VALUES 
('BND001', 3.5, '2035-12-31'),
('BND002', 2.8, '2030-06-30');

-- ==========================================
-- FUND
-- ==========================================
INSERT INTO FUND VALUES 
('FND001', 1.2, 2.8),
('FND002', 1.5, 3.1);

-- ==========================================
-- Portfolio1
-- ==========================================
INSERT INTO Portfolio1 VALUES
('91234567', 'P1001', 500000.00, '2021-01-01', 8.75),
('98765432', 'P1002', 450000.00, '2022-05-10', 11.20),
('90001111', 'P1003', 350000.00, '2023-03-15', 6.40),
('95554444', 'P1004', 300000.00, '2023-01-05', 5.20),
('93332222', 'P1005', 700000.00, '2020-07-01', -2.50),
('96669999', 'P1006', 850000.00, '2021-10-12', 12.00);

-- ==========================================
-- PortfolioFeeStructure
-- ==========================================
INSERT INTO PortfolioFeeStructure VALUES
(500000.00, 0.88),
(450000.00, 0.88),
(350000.00, 0.88),
(300000.00, 0.88),
(700000.00, 0.88),
(850000.00, 0.88);

-- ==========================================
-- For tables with single primary keys, we need to be careful 
-- to not assign the same asset to multiple portfolios
-- ==========================================

-- ==========================================
-- STOCK_IN_PORTFOLIO (respecting single primary key)
-- ==========================================
INSERT INTO STOCK_IN_PORTFOLIO VALUES
('STK001', 'P1001', '91234567', '2021-01-01', 0.4, 'Saxo'),
('STK002', 'P1002', '98765432', '2022-05-10', 0.5, 'Clearstream');

-- ==========================================
-- BOND_IN_PORTFOLIO (respecting single primary key)
-- ==========================================
INSERT INTO BOND_IN_PORTFOLIO VALUES
('BND001', 'P1001', '91234567', '2021-01-01', 0.3, 'Clearstream'),
('BND002', 'P1002', '98765432', '2022-05-10', 0.2, 'Saxo');

-- ==========================================
-- FUND_IN_PORTFOLIO (respecting single primary key)
-- ==========================================
INSERT INTO FUND_IN_PORTFOLIO VALUES
('FND001', 'P1001', '91234567', '2021-01-01', 0.3, 'Interactive Broker'),
('FND002', 'P1002', '98765432', '2022-05-10', 0.3, 'Clearstream');

-- ==========================================
-- INVESTED_VALUE (2024 focus)
-- ==========================================
INSERT INTO INVESTED_VALUE VALUES
('91234567', 'P1001', '2024-01-01', 500000.00),
('98765432', 'P1002', '2024-01-01', 450000.00),
('90001111', 'P1003', '2024-01-01', 350000.00),
('95554444', 'P1004', '2024-01-01', 300000.00),
('93332222', 'P1005', '2024-01-01', 700000.00),
('96669999', 'P1006', '2024-01-01', 850000.00);

-- Add March 2024 data
INSERT INTO INVESTED_VALUE VALUES
('91234567', 'P1001', '2024-03-31', 480000.00),
('98765432', 'P1002', '2024-03-31', 420000.00),
('90001111', 'P1003', '2024-03-31', 360000.00),
('95554444', 'P1004', '2024-03-31', 290000.00),
('93332222', 'P1005', '2024-03-31', 650000.00),
('96669999', 'P1006', '2024-03-31', 880000.00);

-- ==========================================
-- UNREALIZED_GAIN_LOSS (2024 trends) with losses
-- ==========================================
INSERT INTO UNREALIZED_GAIN_LOSS VALUES
('91234567', 'P1001', '2024-01-01', -25000.00), -- Loss for Alice
('98765432', 'P1002', '2024-01-01', -30000.00), -- Loss for Bob
('90001111', 'P1003', '2024-01-01', 10000.00),  -- Gain for Clara
('95554444', 'P1004', '2024-01-01', -15000.00), -- Loss for Daniel
('93332222', 'P1005', '2024-01-01', -40000.00), -- Loss for Evelyn
('96669999', 'P1006', '2024-01-01', 30000.00);  -- Gain for Faisal

-- Add March 2024 values to establish a trend
INSERT INTO UNREALIZED_GAIN_LOSS VALUES
('91234567', 'P1001', '2024-03-31', -32000.00),
('98765432', 'P1002', '2024-03-31', -38000.00),
('90001111', 'P1003', '2024-03-31', 15000.00),
('95554444', 'P1004', '2024-03-31', -20000.00),
('93332222', 'P1005', '2024-03-31', -50000.00),
('96669999', 'P1006', '2024-03-31', 40000.00);

-- ==========================================
-- Transaction1
-- ==========================================
INSERT INTO Transaction1 VALUES
('T001', '2024-01-01', 'P1001', '91234567', 'BUY'),
('T002', '2024-01-05', 'P1002', '98765432', 'REBALANCE'),
('T003', '2024-02-01', 'P1003', '90001111', 'TOPUP'),
('T004', '2024-03-01', 'P1004', '95554444', 'TOPUP'),
('T005', '2024-04-01', 'P1005', '93332222', 'SELL'),
('T006', '2024-05-01', 'P1006', '96669999', 'BUY');

-- ==========================================
-- TransactionFees
-- ==========================================
INSERT INTO TransactionFees VALUES
('BUY', 0.5),
('SELL', 0.7),
('REBALANCE', 0.4),
('TOPUP', 0.2);