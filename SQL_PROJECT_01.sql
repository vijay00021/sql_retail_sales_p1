-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_01;

-- create TABLE 
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,	
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(10),
	age	INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT 
	COUNT(*)
FROM retail_sales;

-- Data Cleaning 

SELECT * FROM retail_sales
WHERE transactions_id IS NUll or 
      sale_date	IS NUll or
	  sale_time	IS NUll or
	  customer_id	IS NUll or
	  gender	IS NUll or
	  age	IS NUll or
	  category	IS NUll or
	  quantiy	IS NUll or
	  price_per_unit	IS NUll or
	  cogs	IS NUll or
	  total_sale	IS NUll 
;

DELETE FROM retail_sales
WHERE transactions_id IS NUll or 
      sale_date	IS NUll or
	  sale_time	IS NUll or
	  customer_id	IS NUll or
	  gender	IS NUll or
	  age	IS NUll or
	  category	IS NUll or
	  quantiy	IS NUll or
	  price_per_unit	IS NUll or
	  cogs	IS NUll or
	  total_sale	IS NUll;

-- Data Exploration

-- How many sales do we have 

SELECT COUNT(*) AS total_sales 
	FROM retail_sales;

-- How many Unique customers do we have ?

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many categories we have ?

SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business key problems   

-- Q1. write a SQL query to retrive all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales 
	WHERE sale_date = '2022-11-05';

-- Q2. write a sql query to retrive all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales
	WHERE 
		category = 'Clothing'
		AND 
		TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
		AND 
		quantiy >= 3;

-- Q3. write a sql  to calculate the total sales (total_sale for each category)

SELECT category , sum(total_sale) as netSales,
	COUNT(*) as total_orders
	FROM retail_sales
	GROUP BY 1;

-- Q4. write a SQL qury to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age),2) as avg_age
	FROM retail_sales 
		WHERE category = 'Beauty';

-- Q5. write a Sql query to find all transactions where the total sales is greater than 1000.

SELECT * FROM retail_sales 
	WHERE total_sale > 1000;

-- Q6. write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,
		gender,
		count(*) as total_transactions
FROM retail_sales
	GROUP 
		BY
			category,
			gender
	ORDER BY 1;

--Q7. write a SQL query to calculate the average sale for each month . Find out best selling month in each year.
SELECT year , month,avg_sale
	FROM 
	(
		SELECT   
			EXTRACT(YEAR FROM sale_date) AS year,
			EXTRACT(MONTH FROM sale_date) AS month,
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY avg(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY 1,2
	) AS t1 
WHERE rank = 1;

-- Q8. write  a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,
	SUM(total_sale) as total_sales
	FROM retail_sales
GROUP BY  1
ORDER BY 2 DESC 
LIMIT 5;

-- Q9. write a SQL query to find the number of unique customers who purchased items from each category. 

SELECT 
	category,
	count(DISTINCT customer_id) as unique_cust
FROM retail_sales
GROUP BY category;

-- Q10. write a SQL query to create each shift and number of orders (Example Morning <= 12 ,Afternoon Between we 12 & 17 , Evening >=17).

WITH hourly_sale
as
(
SELECT *, 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM
retail_sales
)
SELECT shift,count(*) as total_orders
FROM hourly_sale
GROUP BY shift;

-- End of Project
