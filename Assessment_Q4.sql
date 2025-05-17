USE adashi_staging;

-- Customer Lifetime Value (CLV) Estimation
-- For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

SELECT 
    cu.id AS customer_id,
    CONCAT(cu.first_name, '  ', cu.last_name) AS name,
    TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), NOW()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    ROUND((COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), NOW()), 0)) * 12 * 
          (AVG(sa.confirmed_amount / 100) * 0.001), 2) AS estimated_clv
FROM 
    users_customuser cu
LEFT JOIN 
    savings_savingsaccount sa ON cu.id = sa.owner_id
WHERE 
    sa.transaction_date IS NOT NULL
GROUP BY 
    cu.id, cu.name
HAVING 
    COUNT(sa.id) > 0
ORDER BY 
    estimated_clv DESC;
    