USE adashi_staging;
-- Assessment_Q3.sql
-- Account Inactivity Alert
-- Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

SELECT 
    pp.id AS plan_id,
    pp.owner_id,
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(NOW(), MAX(sa.transaction_date)) AS inactivity_days
FROM 
    plans_plan pp
LEFT JOIN 
    savings_savingsaccount sa ON pp.id = sa.plan_id
GROUP BY 
    pp.id, pp.owner_id,
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
    END
HAVING 
    MAX(sa.transaction_date) IS NULL 
    OR DATEDIFF(NOW(), MAX(sa.transaction_date)) > 365
ORDER BY 
    inactivity_days DESC;
    