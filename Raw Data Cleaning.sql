-- Cleaning the data for null values is critical to ensure accuracy before starting analysis or visualization. Below is a step-by-step guide to prepare the dataset for the SQL Fraud Detection project:


Use FraudDetection
select*from [dbo].[FraudData]

--Check for Null Values

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END) AS Null_steps,
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS Null_type,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS Null_amount,
    SUM(CASE WHEN nameOrig IS NULL THEN 1 ELSE 0 END) AS Null_nameOrig,
    SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS Null_oldbalanceOrg,
    SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS Null_newbalanceOrig,
    SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END) AS Null_nameDest,
    SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS Null_oldbalanceDest,
    SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END) AS Null_newbalanceDest,
    SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END) AS Null_isFraud,
    SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END) AS Null_isFlaggedFraud
FROM FraudData;

--Handle Missing Values

--Critical Columns (Non-Negotiable Fields)
DELETE FROM FraudData
WHERE 
    type IS NULL 
    OR amount IS NULL 
    OR nameOrig IS NULL 
    OR nameDest IS NULL 
    OR isFraud IS NULL;
--Balance Columns
UPDATE FraudData
SET 
    oldbalanceOrg = COALESCE(oldbalanceOrg, 0),
    newbalanceOrig = COALESCE(newbalanceOrig, 0),
    oldbalanceDest = COALESCE(oldbalanceDest, 0),
    newbalanceDest = COALESCE(newbalanceDest, 0);
--step (Time Step)
UPDATE FraudData
SET step = (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY step) Over () FROM Transactions)
WHERE step IS NULL;
--isFlaggedFraud
UPDATE FraudData
SET isFlaggedFraud = 0
WHERE isFlaggedFraud IS NULL;

--Validate Cleaned Data

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END) AS Null_steps,
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS Null_type,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS Null_amount,
    SUM(CASE WHEN nameOrig IS NULL THEN 1 ELSE 0 END) AS Null_nameOrig,
    SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS Null_oldbalanceOrg,
    SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS Null_newbalanceOrig,
    SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END) AS Null_nameDest,
    SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS Null_oldbalanceDest,
    SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END) AS Null_newbalanceDest,
    SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END) AS Null_isFraud,
    SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END) AS Null_isFlaggedFraud
FROM FraudData;

--Export Clean Data for Power BI

CREATE VIEW Cleaned_Transactions AS
SELECT *
FROM FraudData
WHERE 
    type IS NOT NULL 
    AND amount IS NOT NULL 
    AND nameOrig IS NOT NULL 
    AND nameDest IS NOT NULL 
    AND isFraud IS NOT NULL;

select*from [dbo].[Cleaned_Transactions]

--Final Checks (Ensure no duplicate rows exist:)

SELECT step, type, amount, nameOrig, nameDest, COUNT(*)
FROM FraudData
GROUP BY step, type, amount, nameOrig, nameDest
HAVING COUNT(*) > 1;

--Now your data is ready for analysis!

select*from [dbo].[FraudData]















