CREATE TABLE 
	public.walmart_sales(
		store INT,
		date DATE,
		weekly_sale NUMERIC,
		holiday_flag INT,
		temperature NUMERIC,
		fuel_price NUMERIC,
		cpi NUMERIC,
		unemployment NUMERIC);
		
-- 1. Importing data from CSV
COPY public."walmart_sales"
FROM 'C:\Users\User\Desktop\Walmart_sales.csv' 
DELIMITER ',' CSV HEADER;

-- View data
SELECT *
FROM walmart_sales
LIMIT 10;

-- Count total rows
SELECT COUNT(*)
FROM walmart_sales;


/*
2. Data cleaning:
- checking null values
- checking duplicate rows
- checking outliers
*/

-- 2.1 Check for NULL values
SELECT *
FROM walmart_sales
WHERE 
	store IS NULL OR
	date IS NULL OR
	weekly_sale IS NULL OR
	holiday_flag IS NULL OR
	temperature IS NULL OR
	fuel_price IS NULL OR
	cpi IS NULL OR
	unemployment IS NULL;
	
-- 2.2 Check for duplicate rows
SELECT store, date, weekly_sale, COUNT(*)
FROM walmart_sales
GROUP BY store, date, weekly_sale
HAVING count(*) > 1;

/*
2.3 Check for outlier:
- Separate the weekly_sales into 4 quartile
- Get Q1 and Q3 value, then calculate IQR 
- upper bound = Q1 - (1.5*IQR)
- lower bound = Q3 + (1.5*IQR)
*/

WITH sale_quartile AS (
	SELECT 
		store, 
		weekly_sale,
		NTILE(4) OVER(ORDER BY weekly_sale) AS weekly_sale_quartile
	FROM walmart_sales
	)

SELECT
	weekly_sale_quartile,
	MAX(weekly_sale)
FROM sale_quartile
GROUP BY weekly_sale_quartile
HAVING weekly_sale_quartile IN (1,3);

SELECT (1420405.41 - 552985.34) -- Calculating the IQR

SELECT (1.5 * 867420.07) -- 1.5 * IQR

SELECT (552985.34 - 1301130.105) -- lower bound

SELECT (1420405.41 + 1301130.105) -- upper bound

-- Checking the outliers
SELECT *
FROM walmart_sales
WHERE 
	weekly_sale < -748144.765 
	OR weekly_sale > 2721535.515;


/*
3. Exploratory data analysis:

3.1. Sales by store.
- What is the total sales by store?
- What is the average, minimum and maximum sales by store?
- Which store having sales more than average sale?

3.2. Sales by temperature
- Does temperature effecting the average sale?

3.3. Sales by region fuel cost?
- Does region fuel cost effecting the average sale?

3.4. Sales by cpi
- Does cpi effecting the average sale?

3.5. Sales by unemployment
- Does unemployment effecting the average sale?

3.6. Does holiday affecting average sale?

3.7. What is the sales trend over month?

3.8. Is there any correlation between weekly sale and external factors?

*/

-- 3.1. Sales by store
-- total sales by store
SELECT
	store,
	ROUND(SUM(weekly_sale), 2) AS total_sale
FROM walmart_sales
GROUP BY store
ORDER BY total_sale DESC;

-- average, minimum and maximum sales by store
SELECT
	store,
	ROUND(AVG(weekly_sale), 2) AS avg_sale,
	ROUND(MIN(weekly_sale), 2) AS min_sale,
	ROUND(MAX(weekly_sale), 2) AS max_sale
FROM walmart_sales
GROUP BY store
ORDER BY avg_sale DESC;

-- store having sale more than overall average sale
SELECT 
	store,
	AVG(weekly_sale) AS average_overall_sale
FROM walmart_sales
GROUP BY store
HAVING AVG(weekly_sale) > (SELECT AVG(weekly_sale) FROM walmart_sales)
ORDER BY average_overall_sale DESC;

-- 3.2. average sale by temperature
SELECT 
	ROUND(((temperature - 32)*5/9)) AS temperature_celsius,
	ROUND(AVG(weekly_sale), 2) AS avg_sale
FROM walmart_sales
GROUP BY 
	ROUND(((temperature - 32)*5/9))
ORDER BY temperature_celsius ASC;

-- 3.3. sales by region fuel cost
SELECT 
	ROUND(fuel_price,1) AS fuel_price_rounded,
	ROUND(AVG(weekly_sale),2) AS avg_sale
FROM walmart_sales
GROUP BY fuel_price_rounded
ORDER BY fuel_price_rounded ASC;

-- 3.4. Does cpi affecting the sale?
SELECT 
	ROUND(cpi,-1) AS cpi_rounded, 
	AVG(ROUND(weekly_sale,2)) AS avg_sale
FROM walmart_sales
GROUP BY cpi_rounded
ORDER BY cpi_rounded ASC;

-- 3.5. Does unemployment effecting the sale?
SELECT date, unemployment, weekly_sale
FROM walmart_sales
ORDER BY date ASC;

-- 3.6. Does holiday affecting the sale?
SELECT 
	ROUND(AVG(weekly_sale),2) AS avg_sale_incuding_holiday,
	(SELECT ROUND(AVG(weekly_sale),2) FROM walmart_sales WHERE holiday_flag <> 1) AS avg_sale_excuding_holiday
FROM walmart_sales;

-- 3.7. Sales trend over the months
SELECT
  DATE_TRUNC('month', date) AS sale_month,  -- Change 'month' to 'year' for yearly trends
  SUM(weekly_sale) AS total_sales
FROM walmart_sales
GROUP BY sale_month
ORDER BY sale_month ASC;

/*
3.8. Correlation of weekly sales with external factors:
- temperature
- fuel cost
- customer price index
- unemployment rate
*/

SELECT 
	CORR(weekly_sale, temperature) AS sale_temp_corr,
	CORR(weekly_sale, fuel_price) AS sale_fuel_corr,
	CORR(weekly_sale, cpi) AS sale_cpi_corr,
	CORR(weekly_sale, unemployment) AS sale_unemployment_corr
FROM walmart_sales;



