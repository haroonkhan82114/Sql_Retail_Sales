-- Sql Retail Sales Analysis

CreateDatabase Sales_Analysis


-- Create Tables

Drop table if exists Retail_Sales;
Create Table Retail_Sales
(
transactions_id int Primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

Select * from Retail_Sales;

Select Count(*) from Retail_sales;


--Data Cleaning

--Checking Null Value in Table

Select * from Retail_sales
where
transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null
;



--Checking Null Values in All Columns with Dynamic Query
SELECT
    column_name,
	data_type
	FROM information_schema.columns
	WHERE table_schema = 'public'
     AND table_name = 'retail_sales';

--Dynamic SQL

  DO $$
DECLARE
    sql_query TEXT;
BEGIN

    SELECT
    'SELECT ' ||
    string_agg(
        'COUNT(*) - COUNT(' || column_name || ') AS ' ||
        column_name || '_nulls',
        ', '
    ) ||
    ' FROM retail_sales'
    INTO sql_query

    FROM information_schema.columns
    WHERE table_name = 'retail_sales';

    RAISE NOTICE '%', sql_query;

END $$;


 SELECT COUNT(*) - COUNT(total_sale) AS total_sale_nulls,
 COUNT(*) - COUNT(sale_date) AS sale_date_nulls,
 COUNT(*) - COUNT(sale_time) AS sale_time_nulls,
 COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
 COUNT(*) - COUNT(cogs) AS cogs_nulls,
 COUNT(*) - COUNT(transactions_id) AS transactions_id_nulls,
 COUNT(*) - COUNT(age) AS age_nulls,
 COUNT(*) - COUNT(quantiy) AS quantiy_nulls,
 COUNT(*) - COUNT(price_per_unit) AS price_per_unit_nulls,
 COUNT(*) - COUNT(gender) AS gender_nulls,
 COUNT(*) - COUNT(category) AS category_nulls
 FROM retail_sales

--Delete Null Values 

Delete  from Retail_sales 
 where
transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null
;


Select Count(*) from Retail_Sales;


-- Data Exploration

--How many sales we have
Select count(*) as Total_Sales 
from Retail_sales; 

--How many customers we have
Select Count(Customer_id) as Total_Customers
from Retail_Sales;


--How many customers we have
Select Count(Customer_id) as Total_Customers
from Retail_Sales;

--How many Unique customers we have
Select Count(Distinct(Customer_id)) as Total_Customers
from Retail_Sales;

--Data Anylasis Business Key problems and Answer

--Q.1 Write a Sql Query to Retrive all Colums from sales made on 2022-11-05

Select * from Retail_sales
where sale_date='2022-11-05';

---- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

Select * from Retail_sales
where category = 'Clothing' and
quantiy <4 and to_char(sale_date,'yyyy-mm')='2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

Select Category, Sum(total_sale),count(Transactions_id)
from Retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select Customer_id, round(Avg(age),0) as Average_Sales
from Retail_sales
where category='Beauty' group by Customer_id;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from Retail_sales 
where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select category,gender, count(*) 
from retail_sales
group by category,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select Year,Month,Avg_TotalSales,Rank from
(
Select Extract(YEAR from sale_date) as Year,
Extract(MONTH from sale_date) as Month,
Avg(total_sale) as Avg_TotalSales, 
Rank() over (Partition by Extract(YEAR from sale_date)
order by Avg(total_sale) desc) as Rank
from retail_sales
group by 1, 2)t
where rank=1;

-- -- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Select Customer_id,Sum(Total_Sale) as TotalSales
from Retail_Sales 
group by Customer_id 
order by TotalSales desc limit 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select category,
count(Distinct(Customer_id)) as Unique_Customer,
count(transactions_id) as Total_Transaction
from Retail_sales
group by Category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

Select 
Case


		When extract(Hour from Sale_Time) < 12
		 Then 'Morning_Shift'
		
		 When extract(Hour from Sale_Time) between 12 and 17
		 Then 'Afternoon_Shift'
		 
		 
		 Else 'Evening'
 
 End as Shift, Count(Transactions_id) as No_of_Customer
 from Retail_Sales group by Shift;
 
-------------End of Project-------------------------

Select * from retail_sales;



