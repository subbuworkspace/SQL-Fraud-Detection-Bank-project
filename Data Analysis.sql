Use FraudDetection
select*from [dbo].[FraudData]

--Exploratory Data Analysis (EDA)
--Total Transactions and Fraud Distribution

SELECT 
    COUNT(*) AS Total_Transactions,
    SUM(CAST(isFraud AS INT)) AS Total_Fraud,
    (SUM(CAST(isFraud AS INT)) * 100.0 / COUNT(*)) AS Fraud_Percentage
FROM  FraudData;

--Fraud by Transaction Type

SELECT 
    type,
    COUNT(*) AS Total_Transactions,
    SUM(CAST(isFraud AS INT)) AS Fraud_Count,
    (SUM(CAST(isFraud AS INT)) * 100.0 / COUNT(*)) AS Fraud_Rate
FROM FraudData
GROUP BY type
ORDER BY Fraud_Rate DESC;

--Average Amount for Fraud vs. Non-Fraud

SELECT 
    isFraud,
    AVG(amount) AS Avg_Amount,
    MAX(amount) AS Max_Amount,
    MIN(amount) AS Min_Amount
FROM FraudData
GROUP BY isFraud;

-- Fraudulent Transactions by Hour (Step)
SELECT 
    step AS Hour,
    COUNT(*) AS Fraud_Count
FROM Transactions
WHERE isFraud = 1
GROUP BY step
ORDER BY Fraud_Count DESC
LIMIT 10; -- Top 10 hours with most fraud



















