/* Business problem - Analyze customer data retrieved through membership cards for marketing purposes.
Which segments are the highest spending and how they can be targeted*/

/* Number of customers*/
SELECT count(*) 
FROM customer; -- 2000

/* Number of customers split by gender*/
SELECT count(*), gender
FROM customer
group by gender; -- more women shoppers than men

/*Max and Min age of customers*/
SELECT max(Age) FROM customer; -- 99
SELECT min(Age) FROM customer; -- 0

SELECT count(*) FROM customer 
WHERE Age = 0;

SELECT count(*) FROM customer 
WHERE Age = 99;

SELECT AVG(Age) from customer; -- 48

/*Max and Min income of customers*/
SELECT max(Annual_Income) from customer; -- 189K
SELECT min(Annual_Income) from customer; -- 0

SELECT AVG(Annual_Income) from customer; -- 110 K


SELECT max(Spending_Score) from customer; -- 100
SELECT min(Spending_Score) from customer; -- 0
SELECT avg(Spending_Score) from customer; -- 50

SELECT Profession, count(*) as Workers  from customer
GROUP BY Profession
ORDER BY Workers DESC;

SELECT max(Work_Experience) from customer; -- 17
SELECT min(Work_Experience) from customer; -- 0
SELECT avg(Work_Experience) from customer; -- 4

SELECT max(Family_Size) from customer; -- 9
SELECT min(Family_Size) from customer; -- 1
SELECT avg(Family_Size) from customer; -- 3 or 4

-- Splitting shoppers based into groups based on their spending score for further analysis
SELECT *,
CASE 
WHEN Spending_Score >= 90 THEN 'Platinum'
WHEN Spending_Score >= 75 AND Spending_Score < 90 THEN 'Diamond'
WHEN Spending_Score >= 50 AND Spending_Score <75 THEN 'Gold'
WHEN Spending_Score >= 25 AND Spending_Score <50 THEN 'Silver'
ELSE 'Bronze'
END AS Shopper_Status
FROM customer;

-- Creating a  table to insert the results from the above case statement

-- Create copy of main table to preserve original table
CREATE TABLE cust_updated  SELECT * FROM customer;

-- Creating new table with new column Shopper Status:
CREATE TABLE cust_new AS
SELECT *,
CASE 
WHEN Spending_Score >= 90 THEN 'Platinum'
WHEN Spending_Score >= 75 AND Spending_Score < 90 THEN 'Diamond'
WHEN Spending_Score >= 50 AND Spending_Score <75 THEN 'Gold'
WHEN Spending_Score >= 25 AND Spending_Score <50 THEN 'Silver'
ELSE 'Bronze'
END AS Shopper_Status
FROM cust_updated;

-- Analyzing Shoppers by Status

SELECT * FROM cust_new limit 20;

-- Total shoppers split by spending score (Shopper_Status)
SELECT Shopper_Status, count(*) as Total_Shoppers
FROM cust_new
GROUP BY Shopper_Status
ORDER BY Total_Shoppers;

-- Gender distribution between shoppers per Shopper_Status category
SELECT Shopper_Status, Gender, count(*) AS Tot_cust FROM cust_new
WHERE Shopper_Status = 'Platinum'
GROUP BY Gender
UNION ALL
SELECT Shopper_Status, Gender, count(*) AS Tot_cust FROM cust_new
WHERE Shopper_Status = 'Diamond'
GROUP BY Gender
UNION ALL
SELECT Shopper_Status, Gender, count(*) AS Tot_cust FROM cust_new
WHERE Shopper_Status = 'Gold'
GROUP BY Gender
UNION ALL
SELECT Shopper_Status, Gender, count(*) AS Tot_cust FROM cust_new
WHERE Shopper_Status = 'Silver'
GROUP BY Gender
UNION ALL
SELECT Shopper_Status, Gender, count(*) AS Tot_cust FROM cust_new
WHERE Shopper_Status = 'Bronze'
GROUP BY Gender; 

-- Shopper Income Analysis
SELECT Shopper_Status, round(avg(Annual_Income)) as Min_Income
FROM cust_new
GROUP BY Shopper_Status
ORDER BY Min_Income DESC;

SELECT Shopper_Status, round(min(Annual_Income)) as Min_Income
FROM cust_new
GROUP BY Shopper_Status
ORDER BY Min_Income DESC;

SELECT Shopper_Status, round(max(Annual_Income)) as Max_Income
FROM cust_new
GROUP BY Shopper_Status
ORDER BY Max_Income DESC;

SELECT Shopper_Status, Gender, round(avg(Annual_Income)) as Avg_Income
FROM cust_new
GROUP BY Shopper_Status, Gender
ORDER BY Shopper_Status;

-- Shopper analysis by profession
SELECT Shopper_Status, Profession, count(*) as Workers
from cust_new
WHERE Shopper_Status = 'Platinum'
GROUP BY Shopper_Status, Profession
UNION ALL
SELECT Shopper_Status, Profession, count(*) as Workers
from cust_new
WHERE Shopper_Status = 'Diamond'
GROUP BY Shopper_Status, Profession
UNION ALL
SELECT Shopper_Status, Profession, count(*) as Workers
from cust_new
WHERE Shopper_Status = 'Gold'
GROUP BY Shopper_Status, Profession
UNION ALL
SELECT Shopper_Status, Profession, count(*) as Workers
from cust_new
WHERE Shopper_Status = 'Silver'
GROUP BY Shopper_Status, Profession
UNION ALL
SELECT Shopper_Status, Profession, count(*) as Workers
from cust_new
WHERE Shopper_Status = 'Bronze'
GROUP BY Shopper_Status, Profession
ORDER BY Profession;

-- Shopper Analysis by age
SELECT Shopper_Status, round(avg(Age)) as cust_age from cust_new
GROUP BY Shopper_Status
ORDER BY cust_age;

SELECT Shopper_Status, round(min(Age)) as cust_age from cust_new
GROUP BY Shopper_Status
ORDER BY cust_age;-- 0 insufficient data

SELECT Shopper_Status, round(max(Age)) as cust_age from cust_new
GROUP BY Shopper_Status
ORDER BY cust_age;-- 99 unexpected

-- Top 5 ages with most customers
SELECT Age, count(*) as cust_num
FROM cust_new
GROUP BY Age
ORDER BY cust_num DESC;

-- Shopper Analysis by work experience
SELECT Shopper_Status, (avg(Work_Experience)) as cust_exp from cust_new
GROUP BY Shopper_Status
ORDER BY cust_exp;

SELECT Shopper_Status, Work_Experience, count(*) as customers 
from cust_new
WHERE Shopper_Status = 'Platinum'
GROUP BY Work_Experience
UNION ALL
SELECT Shopper_Status, Work_Experience, count(*) as customers from cust_new
WHERE Shopper_Status = 'Diamond'
GROUP BY Work_Experience
UNION ALL
SELECT Shopper_Status, Work_Experience, count(*) as customers from cust_new
WHERE Shopper_Status = 'Gold'
GROUP BY Work_Experience
UNION ALL
SELECT Shopper_Status, Work_Experience, count(*) as customers from cust_new
WHERE Shopper_Status = 'Silver'
GROUP BY Work_Experience
UNION ALL
SELECT Shopper_Status, Work_Experience, count(*) as customers from cust_new
WHERE Shopper_Status = 'Bronze'
GROUP BY Work_Experience
ORDER BY Work_Experience, customers;

-- Shopper Analysis by family size
SELECT Shopper_Status, round(avg(Family_Size)) as avg_fam from cust_new
GROUP BY Shopper_Status
ORDER BY avg_fam;

SELECT Shopper_Status, round(min(Family_Size)) as avg_fam from cust_new
GROUP BY Shopper_Status
ORDER BY avg_fam;

SELECT Shopper_Status, round(max(Family_Size)) as avg_fam from cust_new
GROUP BY Shopper_Status
ORDER BY avg_fam;

SELECT Shopper_Status, Family_Size, count(*) as customers 
from cust_new
WHERE Shopper_Status = 'Platinum'
GROUP BY Family_Size
UNION ALL
SELECT Shopper_Status, Family_Size, count(*) as customers from cust_new
WHERE Shopper_Status = 'Diamond'
GROUP BY Family_Size
UNION ALL
SELECT Shopper_Status, Family_Size, count(*) as customers from cust_new
WHERE Shopper_Status = 'Gold'
GROUP BY Family_Size
UNION ALL
SELECT Shopper_Status, Family_Size, count(*) as customers from cust_new
WHERE Shopper_Status = 'Silver'
GROUP BY Family_Size
UNION ALL
SELECT Shopper_Status, Family_Size, count(*) as customers from cust_new
WHERE Shopper_Status = 'Bronze'
GROUP BY Family_Size
ORDER BY Family_Size, customers;

/********************************** THE END *************************************************/
































