SELECT * FROM raw_data
LIMIT 5;

CREATE TABLE quarter_data as (

SELECT 
	`Customer ID` as customer_id
    ,`Gender` as gender
    ,`Age` as age
    ,`Married` as married
    ,`Number of Dependents` as dependents
    ,`City` as city
    ,`Zip Code` as zip_code
    ,`Number of Referrals` as referrals
    ,`Tenure in Months` as tenure
    ,`Offer` as offer
    ,`Phone Service` as phone_service
    ,`Multiple Lines` as multiple_lines
    ,`Internet Service` as internet_service
    ,`Online Security` as online_security
    ,`Online Backup` as online_backup
    ,`Device Protection Plan` as device_protection
    ,`Premium Tech Support` as premium_support
    ,`Streaming TV` as tv
    ,`Streaming Movies` as movies
    ,`Streaming Music` as music
    ,`Unlimited Data` as unlimited_data
    ,`Internet Type` as internet_type
    ,`Avg Monthly GB Download` as avg_bandwidth_consumption
    ,`Contract` as billing_cycle
    ,`Paperless Billing` as paperless_billing
    ,`Payment Method` as payment_method
    ,`Monthly Charge` as last_month_charge
    ,`Total Charges` as total_charges
    ,`Total Refunds` as total_refunds
    ,`Total Extra Data Charges` as total_extra_charge
    ,`Total Long Distance Charges` as total_long_distance_charge
    ,`Total Revenue` as total_revenue
    ,`Customer Status` as customer_status
    ,`Churn Category` as churn_category
    ,`Churn Reason` as churn_reason
FROM 
	raw_data
);

ALTER TABLE quarter_data
ADD mrr double
AFTER total_revenue;

UPDATE quarter_data
SET mrr = (total_revenue - total_long_distance_charge - total_extra_charge + total_refunds)/tenure;

UPDATE quarter_data
SET mrr = ROUND(mrr,2);

ALTER TABLE quarter_data
ADD amr double
AFTER mrr;

UPDATE quarter_data
SET amr = ROUND(total_revenue/tenure,2);

CREATE TABLE customers as (
SELECT *
FROM quarter_data
WHERE customer_status <> 'Churned'
);

CREATE TABLE churn as (
SELECT *
FROM quarter_data
WHERE customer_status = 'Churned'
);

ALTER TABLE customers
DROP COLUMN customer_status,
DROP COLUMN churn_category,
DROP COLUMN churn_reason;

ALTER TABLE churn
DROP COLUMN customer_status;