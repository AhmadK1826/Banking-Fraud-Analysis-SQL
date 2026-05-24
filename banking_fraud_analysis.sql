USE banking_fraud_db;

-- Question 1: How many total banking transactions are included in the dataset?

SELECT 
    COUNT(*) AS total_transactions
FROM banking_transactions;

-- Question 2: How many fraudulent and non-fraudulent transactions are there?

SELECT 
    SUM(CASE WHEN fraud_flag = 'FALSE' THEN 1 ELSE 0 END) AS total_non_fraudulent_transactions,
    SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions
FROM banking_transactions;

-- Question 3: What percentage of all banking transactions are fraudulent?


SELECT ROUND((SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS fraud_percentage
FROM banking_transactions;

-- Question 4: What are the minimum, maximum, and average transaction amounts?


SELECT MIN(transaction_amount) AS min_transaction_amount ,
 MAX(transaction_amount) AS max_transaction_amount ,
 ROUND(AVG(transaction_amount),2) AS avg_transaction_amount
FROM banking_transactions;

-- Question 5: What is the average transaction amount for fraudulent and non-fraudulent transactions?


SELECT 
    CASE 
        WHEN fraud_flag = 'TRUE' THEN 'Fraud'
        ELSE 'Non-Fraud'
    END AS transaction_status,
    ROUND(AVG(transaction_amount), 2) AS avg_transaction_amount
FROM banking_transactions
GROUP BY fraud_flag;

-- Question 6: Which payment channel has the highest number of fraudulent transactions?


SELECT payment_channel,
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS  total_fraudulent_transactions
FROM banking_transactions 
GROUP BY payment_channel 
ORDER BY total_fraudulent_transactions DESC
LIMIT 1;

-- Question 7: What is the fraud percentage within each payment channel?


SELECT payment_channel , 
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
       ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS fraud_percentage
FROM banking_transactions
GROUP BY payment_channel
ORDER BY fraud_percentage DESC;

-- Question 8: Which authentication type has the highest fraud percentage?

SELECT authentication_type , 
       COUNT(*) AS total_transactions,
	   SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
       ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM banking_transactions
GROUP BY authentication_type
ORDER BY fraud_percentage DESC;

-- Question 9: Are Password Only transactions riskier than other authentication types?

SELECT CASE WHEN authentication_type = 'Password Only' THEN 'Password Only' ELSE 'Other Authentication Types' END AS authentication_group,
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
       ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS fraud_percentage
FROM banking_transactions
GROUP BY CASE WHEN authentication_type = 'Password Only' THEN 'Password Only' ELSE 'Other Authentication Types'END
ORDER BY fraud_percentage DESC;

-- Question 10: Are transactions without a physical card more likely to be fraudulent?

SELECT CASE WHEN card_present_flag = 1 THEN 'Card Present' ELSE 'Card Not Present' END AS card_status,
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
       ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM banking_transactions
GROUP BY card_present_flag
ORDER BY fraud_percentage DESC;

-- Question 11: What is the average device risk score for fraudulent and non-fraudulent transactions?

SELECT CASE WHEN fraud_flag = 'TRUE' THEN 'Fraud' ELSE 'Non-Fraud' END AS transaction_status,
       ROUND(AVG(device_risk_score), 2) AS avg_device_risk_score
FROM banking_transactions
GROUP BY fraud_flag;

-- Question 12: Does a higher anomaly score indicate a higher fraud risk?

SELECT 
    CASE 
        WHEN anomaly_score < 0.30 THEN 'Low Anomaly'
        WHEN anomaly_score < 0.70 THEN 'Medium Anomaly'
        ELSE 'High Anomaly'
    END AS anomaly_level,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
    ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM banking_transactions
GROUP BY anomaly_level
ORDER BY fraud_percentage DESC;

-- Question 13: What is the average transaction velocity score for fraudulent and non-fraudulent transactions?

SELECT 
    CASE WHEN fraud_flag = 'TRUE' THEN 'Fraud' ELSE 'Non-Fraud' END AS transaction_status,
    ROUND(AVG(transaction_velocity_score), 2) AS avg_transaction_velocity_score
FROM banking_transactions
GROUP BY fraud_flag;

-- Question 14: What are the top 10 riskiest transactions based on anomaly score and device risk score?

SELECT 
    transaction_id,
    transaction_amount,
    anomaly_score,
    device_risk_score,
    ROUND(anomaly_score + device_risk_score, 2) AS risk_score,
    fraud_flag
FROM banking_transactions
ORDER BY risk_score DESC
LIMIT 10;

-- Question 15: Are transactions from suspicious IP addresses more likely to be fraudulent?

SELECT 
    CASE WHEN suspicious_ip_flag = 1 THEN 'Suspicious IP' ELSE 'Normal IP' END AS ip_status,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_fraudulent_transactions,
    ROUND(SUM(CASE WHEN fraud_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM banking_transactions
GROUP BY suspicious_ip_flag
ORDER BY fraud_percentage DESC;







    
       
