USE adashi_staging;

-- High-Value Customers with Multiple Products
-- Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

SELECT 
    cu.id AS owner_id,
    CONCAT(cu.first_name, '  ', cu.last_name) AS name,
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) AS investment_count,
    COALESCE(SUM(sa.confirmed_amount), 0) AS total_deposits
FROM 
    users_customuser cu
LEFT JOIN 
    plans_plan pp ON cu.id = pp.owner_id
LEFT JOIN 
    savings_savingsaccount sa ON pp.id = sa.plan_id
WHERE 
    (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)
    AND EXISTS (
        SELECT 1 
        FROM savings_savingsaccount sa2 
        WHERE sa2.plan_id = pp.id 
        AND sa2.confirmed_amount > 0
    )
GROUP BY 
    cu.id, cu.name
HAVING 
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) >= 1
ORDER BY 
    total_deposits DESC;
    