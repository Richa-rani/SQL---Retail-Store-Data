CREATE DATABASE Retail_store;

USE Retail_store;

SELECT * FROM [dbo].[Cust_data]
SELECT * FROM [dbo].['Transaction Data$']

SELECT TOP 1 * FROM [dbo].['Transaction Data$']
SELECT TOP 1 * FROM [dbo].[Cust_data]

DELETE FROM [dbo].['Transaction Data$']
WHERE MCN IS NULL;

DELETE FROM [dbo].['Transaction Data$']
WHERE Store_ID IS NULL OR Cash_Memo_No IS NULL

WITH Final_Data AS (
	SELECT * FROM [dbo].['Transaction Data$'] AS T1
	LEFT JOIN [dbo].[Cust_data] AS T2
	ON T1.MCN = T2.CustID
)
SELECT * FROM [dbo].[Final_Data$];

SELECT TOP 1 * FROM [dbo].[Final_Data$];

ALTER TABLE [dbo].['Transaction Data$']
ADD Discount DECIMAL(10, 2);

UPDATE [dbo].['Transaction Data$']
SET Discount = TotalAmount - SaleAmount;

--Q1. Count the number of observations having any of the variables is having null value/missing values?

SELECT COUNT(*) AS Count_null
FROM [dbo].[Final_Data$]
WHERE ItemCount IS NULL OR
      TransactionDate IS NULL OR
	  TotalAmount IS NULL OR
	  SaleAmount IS NULL OR
	  SalePercent IS NULL OR
	  Cash_Memo_No IS NULL OR
	  Dep1Amount IS NULL OR
	  Dep2Amount IS NULL OR
	  Dep3Amount IS NULL OR
	  Dep4Amount IS NULL OR
	  Store_ID IS NULL OR
	  MCN IS NULL

--Q2. How many customers have shopped? (Hint: Distinct Customers)
  
SELECT COUNT (DISTINCT MCN) AS Distinct_count 
FROM [dbo].[Final_Data$]
	
--Q3.  How many shoppers (customers) visiting more than 1 store?

SELECT COUNT (DISTINCT MCN) AS Distinct_count
FROM [dbo].[Final_Data$]
GROUP BY MCN
HAVING COUNT (DISTINCT Store_ID) > 1;

--Q4. What is the distribution of shoppers by day of the week? How the customer shopping behavior on each day of week? (Hint: You are required to calculate 
      --number of customers, number of transactions, total sale amount, total quantity etc.. by each week day)

SELECT DATENAME(WEEKDAY, TransactionDate) AS Week_day, COUNT (DISTINCT MCN) AS Distinct_CustID, COUNT(*) AS Num_trans, 
	SUM(SaleAmount) AS Total_sales, SUM(ItemCount) AS Total_quantity
FROM [dbo].[Final_Data$]
GROUP BY DATENAME(WEEKDAY, TransactionDate)
ORDER BY Week_day;

--Q5.  What is the average revenue per customer/average revenue per customer by each location?

SELECT SUM(SaleAmount)/COUNT (DISTINCT MCN) AS AVG_Revenue_cust
FROM [dbo].[Final_Data$];

SELECT Location, AVG(SaleAmount) AS Avg_revenue_LOCA
FROM [dbo].[Final_Data$]
GROUP BY Location;

--Q6. Average revenue per customer by each store etc

SELECT DISTINCT Store_ID, AVG(SaleAmount) AS Avg_revenue
FROM [dbo].[Final_Data$]
GROUP BY Store_ID
ORDER BY Store_ID;

--Q7. Find the department spend by store wise?

ALTER TABLE [dbo].[Final_Data$]
ADD Department_spend FLOAT;

UPDATE [dbo].[Final_Data$]
SET Department_spend = Dep1Amount + Dep2Amount + Dep3Amount + Dep4Amount;

SELECT DISTINCT Store_ID, SUM(Department_spend) AS Total_spend
FROM [dbo].[Final_Data$]
GROUP BY Store_ID;

--Q8. What is the Latest transaction date and Oldest Transaction date? (Finding the minimum and maximum transaction dates)

SELECT MIN(TransactionDate) AS Min_date, MAX(TransactionDate) AS Max_date
FROM [dbo].[Final_Data$];

--Q9. How many months of data provided for the analysis?

SELECT COUNT(DISTINCT CONVERT(VARCHAR(7),TransactionDate, 120)) AS Num_months
FROM [dbo].[Final_Data$];


--Q10. Find the top 3 locations in terms of spend and total contribution of sales out of total sales?

SELECT TOP 3 SUM(SaleAmount)/SUM(TotalAmount) AS Contribution_sales, Location, SUM(Department_spend) AS Spend
FROM [dbo].[Final_Data$]
GROUP BY Location
ORDER BY SUM(Department_spend) DESC;

--Q11. Find the customer count and Total Sales by Gender?

SELECT Gender, COUNT (MCN) AS Customer_count, SUM(SaleAmount) AS Total_sale
FROM [dbo].[Final_Data$]
GROUP BY Gender;

--Q12. What is total  discount and percentage of discount given by each location?

SELECT Location, SUM(Discount) AS Total_discount, SUM(Discount)/SUM(TotalAmount) * 100 AS Percentage_discount
FROM [dbo].[Final_Data$]
GROUP BY Location;

--Q13. Which segment of customers contributing maximum sales?

SELECT TOP 1 Cust_seg, SUM(SaleAmount) AS Total_sale
FROM [dbo].[Final_Data$]
GROUP BY Cust_seg
ORDER BY Total_sale DESC;

--Q14. What is the average transaction value by location, gender, segment?

SELECT Location, Gender, Cust_seg, AVG(SaleAmount) AS Average_trans
FROM [dbo].[Final_Data$]
GROUP BY Location, Gender, Cust_seg;

--Q15. Create Customer_360 Table with below columns

CREATE TABLE Customer360(Customer_id int,
Gender varchar,
[Location] varchar,
Age int,
Cust_seg int,
No_of_transactions int,
No_of_items int,
Total_sale_amount int,
Average_transaction_value int,
TotalSpend_Dep1 int,
TotalSpend_Dep2 int,
TotalSpend_Dep3 int,
TotalSpend_Dep4 int,
No_Transactions_Dep1 int,
No_Transactions_Dep2 int,
No_Transactions_Dep3 int,
No_Transactions_Dep4 int,
No_Transactions_Weekdays int,
No_Transactions_Weekends int,
Rank_based_on_Spend int,
Decile int);

SELECT * FROM [dbo].[Customer360];

