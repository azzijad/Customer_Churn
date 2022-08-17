-- Finding Churn % and Lost MRR
SELECT 
    ROUND(COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    quarter_data) * 100,
            1) AS churned_percentage
FROM
    quarter_data
WHERE
    customer_status = 'Churned';
    
SELECT 
	ROUND(SUM(mrr))
FROM churn;
    
-- New Joiners and MRR

SELECT 
    ROUND(COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    quarter_data) * 100,
            1) AS joined_percentage
FROM
    quarter_data
WHERE
    customer_status = 'Joined';
    
SELECT 
    ROUND(SUM(mrr))
FROM
    quarter_data
WHERE
    customer_status = 'Joined';
    
-- Calculating recurring revenue lost by tenure range
SELECT 
    CASE
        WHEN a.tenure < 7 THEN 'A. 0 - 6 Months'
        WHEN 7 <= a.tenure AND a.tenure < 13 THEN 'B. 6 - 12 Months'
        WHEN 13 <= a.tenure AND a.tenure < 19 THEN 'C. 1 - 1.5 Years'
        WHEN 19 <= a.tenure AND a.tenure < 25 THEN 'D. 1.5 - 2 Years'
        WHEN 25 <= a.tenure AND a.tenure < 37 THEN 'E. 2 - 3 Years'
        WHEN 37 <= a.tenure AND a.tenure < 49 THEN 'F. 3 - 4 Years'
        WHEN 49 <= a.tenure AND a.tenure < 61 THEN 'G. 4 - 5 Years'
        WHEN a.tenure >= 61 THEN 'H. 5+ Years'
    END AS tenure_range,
    ROUND(SUM(mrr) / (SELECT 
                    SUM(mrr)
                FROM
                    churn) * 100,
            2) AS percent_lost_mrr,
    ROUND(SUM(mrr) / (SELECT 
                    SUM(mrr)
                FROM
                    quarter_data) * 100,
            2) AS percent_total_mrr
FROM
    churn a
GROUP BY tenure_range
ORDER BY tenure_range;

-- Calculating mean mrr across tenure and filtering by customer status

SELECT 
    a.tenure_range, a.customers__mean_mrr, b.churn_mean_mrr
FROM
    (SELECT 
        CASE
                WHEN a.tenure <= 6 THEN 'A. 0-6 Months'
                WHEN a.tenure > 6 AND a.tenure < 13 THEN 'B. 6-12 Months'
                WHEN a.tenure > 12 AND a.tenure < 25 THEN 'C. 1-2 Years'
                WHEN a.tenure > 24 AND a.tenure < 37 THEN 'D. 2-3 Years'
                WHEN a.tenure > 36 AND a.tenure < 49 THEN 'E. 3-4 Years'
                WHEN a.tenure > 48 AND a.tenure < 61 THEN 'F. 4-5 Years'
                ELSE 'G. 5+ Years'
            END AS tenure_range,
            ROUND(AVG(mrr), 0) AS customers__mean_mrr
    FROM
        customers a
    GROUP BY tenure_range) a
        JOIN
    (SELECT 
        CASE
                WHEN a.tenure <= 6 THEN 'A. 0-6 Months'
                WHEN a.tenure > 6 AND a.tenure < 13 THEN 'B. 6-12 Months'
                WHEN a.tenure > 12 AND a.tenure < 25 THEN 'C. 1-2 Years'
                WHEN a.tenure > 24 AND a.tenure < 37 THEN 'D. 2-3 Years'
                WHEN a.tenure > 36 AND a.tenure < 49 THEN 'E. 3-4 Years'
                WHEN a.tenure > 48 AND a.tenure < 61 THEN 'F. 4-5 Years'
                ELSE 'G. 5+ Years'
            END AS tenure_range,
            ROUND(AVG(mrr), 0) AS churn_mean_mrr
    FROM
        churn a
    GROUP BY tenure_range) b ON a.tenure_range = b.tenure_range
GROUP BY a.tenure_range
ORDER BY a.tenure_range;

-- Checking churn with respect to gender

SELECT gender, ROUND(count(gender)/(SELECT count(gender) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY gender
ORDER BY gender;

-- Checking churn with respect to age

SELECT
	CASE
		WHEN age < 31 THEN 'A. 20-30'
        WHEN age > 30 AND age < 41 THEN 'B. 30-40'
        WHEN age > 40 AND age < 51 THEN 'C. 40-50'
        WHEN age > 50 AND age < 61 THEN 'D. 50-60'
        WHEN age > 60 AND age < 71 THEN 'E. 60-70'
        ELSE 'F. 70+'
	END as age_range
	, ROUND(count(age)/(SELECT count(age) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY age_range
ORDER BY age_range;

-- Churn with respect to marriage

SELECT married, ROUND(count(married)/(SELECT count(married) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY married;

-- Churn with respect to marriage

SELECT married, dependents, ROUND(count(dependents)/(SELECT count(dependents) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY married, dependents
ORDER BY married, dependents;

SELECT city, ROUND(count(city)/(SELECT count(city) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY city
ORDER BY percent_total DESC;

-- Chekcing churn with respect to tenure
SELECT 
    CASE
        WHEN a.tenure < 7 THEN 'A. 0 - 6 Months'
        WHEN 7 <= a.tenure AND a.tenure < 13 THEN 'B. 6 - 12 Months'
        WHEN 13 <= a.tenure AND a.tenure < 19 THEN 'C. 1 - 1.5 Years'
        WHEN 19 <= a.tenure AND a.tenure < 25 THEN 'D. 1.5 - 2 Years'
        WHEN 25 <= a.tenure AND a.tenure < 37 THEN 'E. 2 - 3 Years'
        WHEN 37 <= a.tenure AND a.tenure < 49 THEN 'F. 3 - 4 Years'
        WHEN 49 <= a.tenure AND a.tenure < 61 THEN 'G. 4 - 5 Years'
        WHEN a.tenure >= 61 THEN 'H. 5+ Years'
    END AS seniority,
    ROUND(COUNT(tenure)/(SELECT count(city) FROM quarter_data)*100,2) AS frequency_of_churn
FROM
    churn a
GROUP BY seniority
ORDER BY seniority;


-- Chekcing active customers with respect to tenure
SELECT 
    CASE
        WHEN a.tenure < 7 THEN 'A. 0 - 6 Months'
        WHEN 7 <= a.tenure AND a.tenure < 13 THEN 'B. 6 - 12 Months'
        WHEN 13 <= a.tenure AND a.tenure < 19 THEN 'C. 1 - 1.5 Years'
        WHEN 19 <= a.tenure AND a.tenure < 25 THEN 'D. 1.5 - 2 Years'
        WHEN 25 <= a.tenure AND a.tenure < 37 THEN 'E. 2 - 3 Years'
        WHEN 37 <= a.tenure AND a.tenure < 49 THEN 'F. 3 - 4 Years'
        WHEN 49 <= a.tenure AND a.tenure < 61 THEN 'G. 4 - 5 Years'
        WHEN a.tenure >= 61 THEN 'H. 5+ Years'
    END AS seniority,
    ROUND(COUNT(tenure)/(SELECT COUNT(*) FROM customers)*100,2) AS frequency
FROM
    customers a
GROUP BY seniority
ORDER BY seniority;


-- Checking Churn Category trends in highest churn rate cities
SELECT 
    churn_category
	, ROUND(COUNT(churn_category) / (SELECT 
                    SUM(a.frequency)
                FROM
                    (SELECT 
                        zip_code, COUNT(zip_code) AS frequency
                    FROM
                        churn
                    WHERE
                        city IN ('San Diego' , 'Los Angeles')
                    GROUP BY zip_code) AS a) * 100,
            2) AS frequency
FROM
    churn
WHERE
    city IN ('San Diego' , 'Los Angeles')
GROUP BY churn_category
ORDER BY frequency DESC;

-- Checking the churn given services (high level)

SELECT 
	CASE 
		WHEN phone_service = 'Yes' AND internet_service = 'Yes' THEN 'Both'
        WHEN phone_service = 'Yes' AND internet_service = 'No' THEN 'Phone'
        WHEN phone_service = 'No' AND internet_service = 'Yes' THEN 'Internet'
        ELSE 'None'
	END as services
    , ROUND(COUNT(*)/(SELECT COUNT(*) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY services
ORDER BY percent_total DESC;

-- Checking churn vs billing cycle, paperless billing, and payment methods

SELECT billing_cycle, ROUND(COUNT(*)/(SELECT COUNT(*) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY billing_cycle;

SELECT paperless_billing, ROUND(COUNT(*)/(SELECT COUNT(*) FROM quarter_data)*100,2) as percent_total
FROM churn
GROUP BY paperless_billing;