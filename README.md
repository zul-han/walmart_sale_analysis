# Walmart Sales Analysis
![walmart](https://raw.githubusercontent.com/Masterx-AI/Project_Retail_Analysis_with_Walmart/main/Wallmart1.jpg)

## Data Source
This data was obtained from Kaggle: [Walmart Dataset](https://www.kaggle.com/datasets/yasserh/walmart-dataset "kaggle walmart dataset").

The dataset contain sales data for 45 Walmart stores. The columns include: 
|Columns | Description |
|---|---|
|Store | Store number|
|Date | Sales week start date|
|Weekly_Sales | Sales |
|Holiday_Flag | Mark on the presence or absence of a holiday|
|Temperature | Air temperature in the region|
|Fuel_price | Fuel cost on the region|
|CPI | Consumer price index|
|Unemployment | Unemployment rate|
|

## Background
This is a descriptive analysis of the Walmart sale, one of the leading retail store in US. This analysis aimed to answer:
- How do sales vary across the stores?
- What is the weekly sales pattern?
- Does holiday flag indicate a significant change in sales?
- How do external factors as region temperature, fuel cost, consumer price index, unemployment rate correlate with weekly sales?

## Steps followed
1. **Data loading**: The data was loaded into PostgreSQL.
```postgresql
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

COPY public."walmart_sales"
FROM 'C:\Users\User\Desktop\Walmart_sales.csv' 
DELIMITER ',' CSV HEADER;
```
2. **Data Cleaning**: Upon checking, there were no duplicate or missing values. However, there are 34 (0.005%) outliers detected in `weekly_sale` column.

| store | date       | weekly_sale | holiday_flag | temperature | fuel_price | cpi         | unemployment |
| ----- | ---------- | ----------- | ------------ | ----------- | ---------- | ----------- | ------------ |
| 2     | 2010-12-24 | 3436007.68  | 0            | 49.97       | 2.886      | 211.0646599 | 8.163        |
| 2     | 2011-12-23 | 3224369.8   | 0            | 46.66       | 3.112      | 218.9995495 | 7.441        |
| 4     | 2010-11-26 | 2789469.45  | 1            | 48.08       | 2.752      | 126.6692667 | 7.127        |
| 4     | 2010-12-17 | 2740057.14  | 0            | 46.57       | 2.884      | 126.8794839 | 7.127        |
| 4     | 2010-12-24 | 3526713.39  | 0            | 43.21       | 2.887      | 126.9835806 | 7.127        |
| 4     | 2011-11-25 | 3004702.33  | 1            | 47.96       | 3.225      | 129.8364    | 5.143        |
| 4     | 2011-12-16 | 2771397.17  | 0            | 36.44       | 3.149      | 129.8980645 | 5.143        |
| 4     | 2011-12-23 | 3676388.98  | 0            | 35.92       | 3.103      | 129.9845484 | 5.143        |
| 6     | 2010-12-24 | 2727575.18  | 0            | 55.07       | 2.886      | 212.9165082 | 7.007        |
| 10    | 2010-11-26 | 2939946.38  | 1            | 55.33       | 3.162      | 126.6692667 | 9.003        |
| 10    | 2010-12-17 | 2811646.85  | 0            | 59.15       | 3.125      | 126.8794839 | 9.003        |
| 10    | 2010-12-24 | 3749057.69  | 0            | 57.06       | 3.236      | 126.9835806 | 9.003        |
| 10    | 2011-11-25 | 2950198.64  | 1            | 60.68       | 3.76       | 129.8364    | 7.874        |
| 10    | 2011-12-23 | 3487986.89  | 0            | 48.36       | 3.541      | 129.9845484 | 7.874        |
| 13    | 2010-11-26 | 2766400.05  | 1            | 28.22       | 2.83       | 126.6692667 | 7.795        |
| 13    | 2010-12-17 | 2771646.81  | 0            | 35.21       | 2.842      | 126.8794839 | 7.795        |
| 13    | 2010-12-24 | 3595903.2   | 0            | 34.9        | 2.846      | 126.9835806 | 7.795        |
| 13    | 2011-11-25 | 2864170.61  | 1            | 38.89       | 3.445      | 129.8364    | 6.392        |
| 13    | 2011-12-16 | 2760346.71  | 0            | 27.85       | 3.282      | 129.8980645 | 6.392        |
| 13    | 2011-12-23 | 3556766.03  | 0            | 24.76       | 3.186      | 129.9845484 | 6.392        |
| 14    | 2010-11-26 | 2921709.71  | 1            | 46.15       | 3.039      | 182.7832769 | 8.724        |
| 14    | 2010-12-17 | 2762861.41  | 0            | 30.51       | 3.14       | 182.517732  | 8.724        |
| 14    | 2010-12-24 | 3818686.45  | 0            | 30.59       | 3.141      | 182.54459   | 8.724        |
| 14    | 2011-12-23 | 3369068.99  | 0            | 42.27       | 3.389      | 188.9299752 | 8.523        |
| 20    | 2010-11-26 | 2811634.04  | 1            | 46.66       | 3.039      | 204.9621    | 7.484        |
| 20    | 2010-12-10 | 2752122.08  | 0            | 24.27       | 3.109      | 204.6877378 | 7.484        |
| 20    | 2010-12-17 | 2819193.17  | 0            | 24.07       | 3.14       | 204.6321194 | 7.484        |
| 20    | 2010-12-24 | 3766687.43  | 0            | 25.17       | 3.141      | 204.6376731 | 7.484        |
| 20    | 2011-11-25 | 2906233.25  | 1            | 46.38       | 3.492      | 211.4120757 | 7.082        |
| 20    | 2011-12-16 | 2762816.65  | 0            | 37.16       | 3.413      | 212.0685039 | 7.082        |
| 20    | 2011-12-23 | 3555371.03  | 0            | 40.19       | 3.389      | 212.2360401 | 7.082        |
| 23    | 2010-12-24 | 2734277.1   | 0            | 22.96       | 3.15       | 132.7477419 | 5.287        |
| 27    | 2010-12-24 | 3078162.08  | 0            | 31.34       | 3.309      | 136.597273  | 8.021        |
| 27    | 2011-12-23 | 2739019.75  | 0            | 41.59       | 3.587      | 140.528765  | 7.906        |
|       |            |             |              |             |            |             |              |

However, the outliers are not removed as it is actually representative of the data and not due to measurement or typographical error.

3. **Exploratory Data Analysis (EDA)**: The dataset were explored to answer the question.
- Example 1: _What is the total sale by store?_
```PostgreSQL
SELECT
	store,
	ROUND(SUM(weekly_sale), 2) AS total_sale
FROM walmart_sales
GROUP BY store
ORDER BY total_sale DESC;
```
- Example 2: _Which store having average sale more than overall average sale?_
```PostgreSQL
SELECT 
	store,
	AVG(weekly_sale) AS average_overall_sale
FROM walmart_sales
GROUP BY store
HAVING AVG(weekly_sale) > (SELECT AVG(weekly_sale) FROM walmart_sales)
ORDER BY average_overall_sale DESC;
```
- Example 3: _Does the external factors affacting the sale?_
```PostgreSQL
SELECT 
	CORR(weekly_sale, temperature) AS sale_temp_corr,
	CORR(weekly_sale, fuel_price) AS sale_fuel_corr,
	CORR(weekly_sale, cpi) AS sale_cpi_corr,
	CORR(weekly_sale, unemployment) AS sale_unemployment_corr
FROM walmart_sales;
```
4. **Data Visualization** The data was visualized using Power BI.

![walmart_sale_snip](https://github.com/zul-han/walmart_sale_analysis/assets/152273894/d630ff3b-a424-486a-89ca-7e6465b69cc7)

## Result
The insights obtained were to answer the previous raised business questions:
1. **How do the sales vary across store?**
- The sales were quite varied across the stores with Store ID 20 having the highest sale of $301.4 million over the overall time period and Store ID 33 having the lowest sale of $37.16 million over the overall time period. 

- Top 10 stores with the highest sale are Store ID 20, 4, 14, 13, 2, 10, 27, 6, 1, and 39.

| store | average_overall_sale |
| ----- | -------------------- |
| 20    | 2107676.87 |
| 4     | 2094712.96 |
| 14    | 2020978.40 |
| 13    | 2003620.31 |
| 2     | 1925751.34 |
| 10    | 1899424.57 |
| 27    | 1775216.20 |
| 6     | 1564728.19 |
| 1     | 1555264.40 |
| 39    | 1450668.13 |


2. **What is the weekly sales pattern?**

![weekly_sales_pattern](https://github.com/zul-han/walmart_sale_analysis/assets/152273894/4856dfaf-63f1-48ed-8a47-1f806d8e6b35)

- The average sale (indicated by the blue line) showing relatively constant pattern with spike of sale at the end of November and December for both year 2010 and 2011 might be due to Chrismas celebration.

3. **Does holiday flag indicate significant change in sale?**
- The average overall sale including holiday was $1046964.88 and the average overall sale excluding holiday was $1041256.38 showing difference of $5708.5, representing 0.005% of the average overall sale. Thus, it is inferred that holiday flag do not affect average sale significantly.

4. **Does the external factors affect sale?**
- Below show the Pearson correlation coeffecient for weekly sales and external factors:

| External factors | Pearson correlation coeffecient |
| --- | --- | 
| Temperature | -0.0638 |
| Fuel Price | 0.0094 | 
| CPI | -0.0726 |
| Unemployment rate | -0.1061 | 

Although the Pearson correlation coeffecient are good for screening, is it necessary to confirm through visualization.

After re-evaluating by the visualization, it seems that the external factors do not effect the weekly sales.
