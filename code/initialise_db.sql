-- Create INVESTOR Table
CREATE TABLE INVESTOR (
    Phone VARCHAR(15) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Gender CHAR(1),
    DoB DATE,
    AnnualIncome DECIMAL(15, 2),
    Company VARCHAR(100)
);

-- Create RISK_TOLERANCE Table
CREATE TABLE RISK_TOLERANCE (
    Phone VARCHAR(15),
    RiskLevel VARCHAR(20),
    Q1A VARCHAR(255),
    Q2A VARCHAR(255),
    Q3A VARCHAR(255),
    Q4A VARCHAR(255),
    Q5A VARCHAR(255),
    PRIMARY KEY (Phone, RiskLevel),
    FOREIGN KEY (Phone) REFERENCES INVESTOR(Phone)
);

-- Create FINANCIAL_GOAL Table
CREATE TABLE FINANCIAL_GOAL (
    Goal VARCHAR(100),
    Phone VARCHAR(15),
    Amount DECIMAL(15, 2),
    Timeline INT,
    PRIMARY KEY (Goal, Phone),
    FOREIGN KEY (Phone) REFERENCES INVESTOR(Phone)
);

-- Create ASSET Table
CREATE TABLE ASSET (
    AssetID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    Price DECIMAL(15, 2)
);

-- Create STOCK Table
CREATE TABLE STOCK (
    AssetID VARCHAR(20) PRIMARY KEY,
    P_ERatio DECIMAL(10, 2),
    EPS DECIMAL(10, 2),
    EBITDA DECIMAL(15, 2),
    FOREIGN KEY (AssetID) REFERENCES ASSET(AssetID)
);

-- Create BOND Table
CREATE TABLE BOND (
    AssetID VARCHAR(20) PRIMARY KEY,
    InterestRate DECIMAL(5, 2),
    MaturityDate DATE,
    FOREIGN KEY (AssetID) REFERENCES ASSET(AssetID)
);

-- Create FUND Table
CREATE TABLE FUND (
    AssetID VARCHAR(20) PRIMARY KEY,
    ExpenseRatio DECIMAL(5, 2),
    DividendYield DECIMAL(5, 2),
    FOREIGN KEY (AssetID) REFERENCES ASSET(AssetID)
);

-- Create PORTFOLIO Table (Decomposed into Portfolio1 and PortfolioFeeStructure)
CREATE TABLE Portfolio1 (
    Phone VARCHAR(15),
    PID VARCHAR(20),
    MarketValue DECIMAL(15, 2),
    InceptionDate DATE,
    AnnualizedReturn DECIMAL(5, 2),
    PRIMARY KEY (PID, Phone), -- Composite primary key (order corrected)
    FOREIGN KEY (Phone) REFERENCES INVESTOR(Phone)
);

CREATE TABLE PortfolioFeeStructure (
    MarketValue DECIMAL(15, 2) PRIMARY KEY,
    Fee DECIMAL(5, 2)
);

-- Create STOCK_IN_PORTFOLIO Table
CREATE TABLE STOCK_IN_PORTFOLIO (
    StockID VARCHAR(20) PRIMARY KEY,
    PID VARCHAR(20),
    Phone VARCHAR(15),
    StartDate DATE,
    AllocationRatio DECIMAL(5, 2),
    PostTradeCO VARCHAR(100),
    FOREIGN KEY (StockID) REFERENCES STOCK(AssetID),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

-- Create BOND_IN_PORTFOLIO Table
CREATE TABLE BOND_IN_PORTFOLIO (
    BondID VARCHAR(20) PRIMARY KEY,
    PID VARCHAR(20),
    Phone VARCHAR(15),
    StartDate DATE,
    AllocationRatio DECIMAL(5, 2),
    PostTradeCO VARCHAR(100),
    FOREIGN KEY (BondID) REFERENCES BOND(AssetID),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

-- Create FUND_IN_PORTFOLIO Table
CREATE TABLE FUND_IN_PORTFOLIO (
    FundID VARCHAR(20) PRIMARY KEY,
    PID VARCHAR(20),
    Phone VARCHAR(15),
    StartDate DATE,
    AllocationRatio DECIMAL(5, 2),
    PostTradeCO VARCHAR(100),
    FOREIGN KEY (FundID) REFERENCES FUND(AssetID),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

-- Create INVESTED_VALUE Table
CREATE TABLE INVESTED_VALUE (
    Phone VARCHAR(15),
    PID VARCHAR(20),
    Date DATE,
    Amount DECIMAL(15, 2),
    PRIMARY KEY (Phone, PID, Date),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

-- Create UNREALIZED_GAIN_LOSS Table
CREATE TABLE UNREALIZED_GAIN_LOSS (
    Phone VARCHAR(15),
    PID VARCHAR(20),
    Date DATE,
    Amount DECIMAL(15, 2),
    PRIMARY KEY (Phone, PID, Date),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

-- Create TRANSACTION Table (Decomposed into Transaction1 and TransactionFees)
CREATE TABLE Transaction1 (
    ID VARCHAR(20),
    Date DATE,
    PID VARCHAR(20),
    Phone VARCHAR(15),
    Type VARCHAR(50),
    PRIMARY KEY (ID, Date),
    FOREIGN KEY (PID, Phone) REFERENCES Portfolio1(PID, Phone) -- References Portfolio1
);

CREATE TABLE TransactionFees (
    Type VARCHAR(50) PRIMARY KEY,
    Fee DECIMAL(5, 2)
);