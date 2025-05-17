## Data Analyst Assessment

This repository contains the SQL queries, results, and documentation for my Data Analyst Assessment.

### Question 1: High-Value Customers with Multiple Products

### Approach:
Joined users_customuser, plans_plan, and savings_savingsaccount using owner_id and plan_id. 
Used CONCAT(first_name, ' ', last_name) to combine names (since the schema had separate first_name and last_name columns), <br> EXISTS to ensure funded plans (confirmed_amount > 0), and <br> HAVING to filter for customers with both savings and investment plans. <br> 
Converted confirmed_amount from kobo to Naira.

#### Output: owner_id, name, savings_count, investment_count, total_deposits.

Result Screenshot: 
<img width="1440" alt="Assessment_Q1_result" src="https://github.com/user-attachments/assets/ebb745cf-d438-4270-9ce4-d35344c7361d" />

### Question 2: Transaction Frequency Analysis

### Approach: 
Calculated total transactions and tenure using TIMESTAMPDIFF(MONTH, ...) for accurate month differences, categorized averages into frequency bands (High: ≥10, Medium: 3–9, Low: ≤2 transactions/month), and aggregated by category. <br>
Added WHERE frequency_category IS NOT NULL to exclude NULL results.

#### Output: frequency_category, customer_count, avg_transactions_per_month.

Result Screenshot:
<img width="1440" alt="Assessment_Q2_result" src="https://github.com/user-attachments/assets/26b8059b-c216-4855-b193-d78efe3c8ac7" />

### Question 3: Account Inactivity Alert

### Approach: 
Joined plans_plan with savings_savingsaccount, used MAX(transaction_date) and DATEDIFF to identify accounts with no transactions for over 365 days. <br>
Derived account type using CASE on is_regular_savings and is_a_fund.

#### Output: plan_id, owner_id, type, last_transaction_date, inactivity_days.

Result Screenshot:
<img width="1440" alt="Assessment_Q3_result" src="https://github.com/user-attachments/assets/ef968e44-47f3-45a4-aa9b-7c6b9a02ec34" />

### Question 4: Customer Lifetime Value (CLV) Estimation

### Approach: 
Used TIMESTAMPDIFF(MONTH, MIN(transaction_date), NOW()) to calculate tenure (since signup_date was unavailable, <br> used earliest transaction date as a proxy), <br> counted transactions, and applied the CLV formula with 0.1% profit on confirmed_amount (converted from kobo to Naira). <br> 
Added WHERE transaction_date IS NOT NULL to handle NULL dates.

#### Output: customer_id, name, tenure_months, total_transactions, estimated_clv.

Result Screenshot:
<img width="1440" alt="Assessment_Q4_result" src="https://github.com/user-attachments/assets/0bbcdfa3-4083-4b44-bfe6-faca3b4ee6aa" />

### Challenges

**Q1:** Adjusted for first_name and last_name instead of a single name column, ensuring proper concatenation and GROUP BY compliance. <br>
Added kobo-to-Naira conversion for total_deposits.

**Q2:** Fixed an error with DATEDIFF(MONTH, ...) by switching to TIMESTAMPDIFF, as MySQL doesn’t support interval-based DATEDIFF. <br>
Excluded NULL rows caused by zero tenure or invalid dates using WHERE frequency_category IS NOT NULL.

**Q3:** Used MySQL-compatible DATEDIFF and NOW() for inactivity calculation. <br>
Ensured GROUP BY included the CASE expression to comply with ONLY_FULL_GROUP_BY.

**Q4:** Initially faced errors due to missing signup_date; used MIN(transaction_date) as a proxy for tenure. <br>
Fixed DATEDIFF error with TIMESTAMPDIFF, added kobo-to-Naira conversion, and handled NULL transaction_date values.
