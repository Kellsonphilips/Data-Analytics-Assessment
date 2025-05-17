USE adashi_staging;

-- Transaction Frequency Analysis
-- Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT 
        customer_id,
        name,
        CASE 
            WHEN total_transactions / NULLIF(tenure_months, 0) >= 10 THEN 'High Frequency'
            WHEN total_transactions / NULLIF(tenure_months, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            WHEN total_transactions / NULLIF(tenure_months, 0) <= 2 THEN 'Low Frequency'
        END AS frequency_category,
        total_transactions / NULLIF(tenure_months, 0) AS avg_transactions_per_month
    FROM (
        SELECT 
            cu.id AS customer_id,
            cu.name,
            COUNT(sa.id) AS total_transactions,
            TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) + 1 AS tenure_months
        FROM 
            users_customuser cu
        LEFT JOIN 
            savings_savingsaccount sa ON cu.id = sa.owner_id
        GROUP BY 
            cu.id, cu.name
        HAVING 
            COUNT(sa.id) > 0
    ) AS CustomerTransactions
) AS MonthlyAvg
GROUP BY 
    frequency_category
ORDER BY 
    CASE frequency_category 
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
    