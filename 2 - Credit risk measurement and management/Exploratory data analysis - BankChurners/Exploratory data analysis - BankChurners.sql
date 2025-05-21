# Churn Rate by gender
SELECT Gender,
	COUNT(*) AS total_customers,
    SUM(Attrition_Flag = 'Attrited Customer') AS churned, 
    ROUND(SUM(Attrition_Flag = 'Attrited Customer')* 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM bankchurners
GROUP BY Gender;

# Churn rate by Education level
SELECT Education_Level,
	COUNT(*) AS total_customers,
	SUM(Attrition_flag = 'Attrited Customer') AS churned,
    ROUND(SUM(Attrition_Flag = 'Attrited Customer') * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bankchurners
GROUP BY Education_Level
ORDER BY  churn_rate_pct DESC;

# Churn rate by income cateogry
SELECT Income_Category,
	COUNT(*) AS total_customerS,
	SUM(Attrition_flag = 'Attrited Customer') AS churned,
   ROUND(SUM(Attrition_Flag = 'Attrited Customer') * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bankchurners
GROUP BY Income_Category
ORDER BY churn_rate_pct DESC;

# Average credit limit by education
SELECT Education_Level,
	ROUND(AVG(Credit_limit),2) AS avg_credit_limit
FROM bankchurners
GROUP BY Education_Level
ORDER BY avg_credit_limit DESC;

# Churn rate by age group
SELECT
	CASE
		WHEN Customer_Age < 30 THEN 'Under 30'
        WHEN Customer_Age BETWEEN 30 AND 49 THEN '30-39'
        WHEN Customer_Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Customer_Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE  '60 and above'
	END AS age_group,
    COUNT(*) AS total_customers,
    SUM(Attrition_Flag = 'Attrited Customer') AS churned_customers,
    ROUND(SUM(Attrition_Flag = 'Attrited Customer') * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM bankchurners
GROUP BY age_group
ORDER by churn_rate_pct;

# Relationship between credit limit and churn
SELECT
	CASE
		WHEN Credit_Limit < 1000 THEN '<1k'
        WHEN Credit_Limit BETWEEN 1000 AND 4999 THEN '1K-5K'
        WHEN Credit_Limit BETWEEN 5000 AND 9999 THEN '5K-10K'
        WHEN Credit_Limit BETWEEN 10000 AND 19999 THEN '10K-20K'
        ELSE '20K+'
	END AS credit_bracket,
    COUNT(*) AS total,
    SUM(Attrition_Flag = 'Attrited Customer') AS churned,
    ROUND(SUM(Attrition_Flag = 'Attrited Customer') * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bankchurners
GROUP BY credit_bracket
ORDER BY churn_rate_pct DESC;

# Utilization Ratio vs Churn
SELECT
	CASE 
		WHEN Avg_Utilization_Ratio < 0.2 THEN 'Under 20%'
        WHEN Avg_Utilization_Ratio < 0.5 THEN '20-50%'
        WHEN Avg_Utilization_Ratio < 0.8 THEN '50-80%'
        ELSE '80%+'
	END AS utilization_band,
    COUNT(*) AS total_customers,
    SUM(Attrition_Flag = 'Attrited Customer') AS churned_customers,
    ROUND(SUM(Attrition_Flag = 'Attrited Customer') * 100.0/ COUNT(*),2) AS churn_rate_pct
FROM bankchurners
GROUP BY utilization_band
ORDER BY churn_rate_pct DESC;


# Average Transaction amount & count by churn status
SELECT 
	Attrition_Flag ,
    ROUND(AVG(Total_Trans_Amt), 2) AS avg_trans_amt,
    ROUND(AVG(Total_Trans_Ct), 2)  AS avg_trans_count
FROM bankchurners
GROUP by Attrition_Flag;

# Most at-risk segments by income & card type
SELECT
	Income_Category,
    Card_Category,
    COUNT(*) as total_customers,
    SUM(Attrition_Flag = 'Attrited Customer') AS churned,
    ROUND(SUM(Attrition_Flag ='Attrited Customer') * 100.0/ COUNT(*),2) AS churn_rate_pct
FROM bankchurners
GROUP BY Income_Category, Card_Category
HAVING COUNT(*) > 50
ORDER BY churn_rate_pct DESC
LIMIT 10;






















