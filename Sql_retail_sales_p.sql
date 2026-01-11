-- SQL Retail sales Analysis
CREATE DATABASE sql_project_p1;
-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),	
	quantity INT,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT

);

SELECT * FROM retail_sales
LIMIT 10

-- To check if correct data is imported
SELECT 
	COUNT(*) 
FROM retail_sales

--To check for the NULL values
-- Data cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	

--Data Exploration
-- How many sales we have
SELECT COUNT(*) as total_sale FROM retail_sales 

--How many unique customers we have
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Q.1 write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of nov-2022

SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	quantity >= 4
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

-- Q.3 write a sql query to calculate the total sales (total_sale) for each category
SELECT 
	category,
	sum(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 write a sql query to find the avg age of customers who purchased items from the 'Beauty' category
SELECT 
	ROUND(AVG(age), 2) as avg_cust_age
FROM retail_sales
WHERE category = 'Beauty'

--Q.5 write a sql query to find all transactions where the total sale is greater than 100.

SELECT * 
FROM retail_sales
WHERE total_sale > 1000

--Q.6 write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1


-------------------Q.7 Write a sql query to calculate the average sale for each month.find out best selling month in each year.
SELECT * FROM
	year,
	month,
	avg_sale
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
)
--ORDER BY 1, 3 DESC
as t1
WHERE rank = 1


--Q.8 Write a sql query to find the top 5 customers based on the higest total sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5

--Q.9 Write a sql query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cust
FROM retail_sales
GROUP BY 1

-------------- Q.10 write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
WITH hourly_sale
AS
(
SELECT * ,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift


--END OF PROJECT