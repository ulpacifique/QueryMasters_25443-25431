![Finding the Earliest Records](https://github.com/user-attachments/assets/b632568c-c287-4a59-8d64-57687b6e1dea)## Group Name: QueryMasters

## Team Members
-UWIHIRWE Pacifique Lazaro 25443
-GIRINEZA Honore 25431

## Project Overview
This project explores SQL window functions on a retail sales dataset. We demonstrate the use of various analytical functions like LAG(), LEAD(), RANK(), DENSE_RANK(), ROW_NUMBER(), and aggregate window functions to analyze sales data.

## Dataset Description
Our dataset consists of sales transactions from a retail company with the following structure:

- *Sales*: Contains transaction details including product, category, region, employee, date, and amount
- *Categories*: Product categories (Electronics, Clothing, etc.)
- *Regions*: Geographic regions (North, South, East, West, Central)
- *Employees*: Employee information including hire dates

## Tasks and Solutions

### 1. Compare Values with Previous or Next Records

*Query:*
sql
SELECT 
    s.sale_id,
    r.region_name,
    c.category_name,
    s.sale_date,
    s.amount,
    LAG(s.amount) OVER (PARTITION BY s.category_id ORDER BY s.sale_date) AS previous_amount,
    LEAD(s.amount) OVER (PARTITION BY s.category_id ORDER BY s.sale_date) AS next_amount,
    CASE 
        WHEN s.amount > LAG(s.amount) OVER (PARTITION BY s.category_id ORDER BY s.sale_date) THEN 'HIGHER'
        WHEN s.amount < LAG(s.amount) OVER (PARTITION BY s.category_id ORDER BY s.sale_date) THEN 'LOWER'
        WHEN s.amount = LAG(s.amount) OVER (PARTITION BY s.category_id ORDER BY s.sale_date) THEN 'EQUAL'
        ELSE 'FIRST SALE'
    END AS comparison_with_previous
FROM 
    sales s
JOIN 
    categories c ON s.category_id = c.category_id
JOIN 
    regions r ON s.region_id = r.region_id
ORDER BY 
    c.category_name, 
    s.sale_date;


*Explanation:*
- We use the LAG() function to access the previous row's amount within the same category.
- The LEAD() function provides the next row's amount within the same category.
- The CASE statement compares the current amount with the previous amount to determine if it's HIGHER, LOWER, or EQUAL.
- For the first record in each category (no previous record), we display 'FIRST SALE'.

*Screenshot:*
![Compare Values with Previous or Next Records](https://github.com/user-attachments/assets/011c4850-2b31-4f14-aa5a-33643664c59e)


*Real-Life Application:*
This type of analysis helps in identifying sales trends over time within categories. Retailers can track whether sales amounts are consistently increasing or decreasing, helping to identify seasonal patterns or the impact of marketing campaigns.

### 2. Ranking Data within a Category

*Query:*
sql
SELECT 
    s.sale_id,
    c.category_name,
    r.region_name,
    s.amount,
    RANK() OVER (PARTITION BY s.category_id ORDER BY s.amount DESC) AS sales_rank,
    DENSE_RANK() OVER (PARTITION BY s.category_id ORDER BY s.amount DESC) AS sales_dense_rank
FROM 
    sales s
JOIN 
    categories c ON s.category_id = c.category_id
JOIN 
    regions r ON s.region_id = r.region_id
ORDER BY 
    c.category_name, 
    s.amount DESC;


*Explanation of Difference:*
RANK() vs DENSE_RANK():
- RANK(): Assigns the same rank to tied values, then skips the next rank(s).
  - Example: Values [100, 90, 90, 80] get ranks [1, 2, 2, 4]
- DENSE_RANK(): Assigns the same rank to tied values, but doesn't skip ranks.
  - Example: Values [100, 90, 90, 80] get ranks [1, 2, 2, 3]

*Screenshot:*

![Ranking Data within a Category](https://github.com/user-attachments/assets/4efcd5c4-0de2-4476-ad8e-c8998acd7a5c)

*Real-Life Application:*
Ranking functions help businesses identify top-performing products or sales in each category. This is valuable for inventory management, sales team incentives, and marketing decisions. RANK() might be used when you want to strictly limit the number of rankings (like "top 3"), while DENSE_RANK() is useful when you want to ensure all items of equal value receive recognition.

### 3. Identifying Top Records

*Query:*
sql
WITH ranked_sales AS (
    SELECT 
        s.sale_id,
        r.region_name,
        c.category_name,
        s.amount,
        DENSE_RANK() OVER (PARTITION BY s.region_id ORDER BY s.amount DESC) AS sales_rank
    FROM 
        sales s
    JOIN 
        categories c ON s.category_id = c.category_id
    JOIN 
        regions r ON s.region_id = r.region_id
)
SELECT 
    sale_id,
    region_name,
    category_name,
    amount,
    sales_rank
FROM 
    ranked_sales
WHERE 
    sales_rank <= 3
ORDER BY 
    region_name, 
    sales_rank;


*Explanation:*
- We use DENSE_RANK() to ensure that ties (sales with the same amount) receive the same rank.
- The Common Table Expression (CTE) creates a temporary result set with the ranking information.
- We filter the results to only show the top 3 sales from each region.

*Screenshot:*
![Identifying Top Records](https://github.com/user-attachments/assets/32ff46a0-c1bf-4bae-a939-56456b61ad65)

*Real-Life Application:*
Identifying top sales by region allows companies to recognize regional strengths and allocate resources effectively. It can inform regional marketing strategies, help identify regional preferences, and guide inventory distribution across different locations.

### 4. Finding the Earliest Records

*Query:*
sql
WITH ranked_by_date AS (
    SELECT 
        s.sale_id,
        c.category_name,
        s.sale_date,
        s.amount,
        ROW_NUMBER() OVER (PARTITION BY s.category_id ORDER BY s.sale_date) AS date_rank
    FROM 
        sales s
    JOIN 
        categories c ON s.category_id = c.category_id
)
SELECT 
    sale_id,
    category_name,
    sale_date,
    amount,
    date_rank
FROM 
    ranked_by_date
WHERE 
    date_rank <= 2
ORDER BY 
    category_name, 
    date_rank;


*Explanation:*
- ROW_NUMBER() assigns a unique sequential number to each row within each category partition.
- We order by sale_date to ensure the earliest sales get the lowest row numbers.
- By filtering for rows with date_rank <= 2, we get exactly the first two sales for each category.
- This approach handles the case where multiple sales might have occurred on the same date.

*Screenshot:*
![Finding the Earliest Records](https://github.com/user-attachments/assets/5e35bc48-3877-43c9-a7eb-71b93674a1ff)

*Real-Life Application:*
Analyzing the earliest sales in each category can help businesses understand which products started selling first after a product launch or the beginning of a season. This information is valuable for planning future product releases and understanding initial market reception to new product categories.

### 5. Aggregation with Window Functions

*Query:*
sql
SELECT 
    s.sale_id,
    c.category_name,
    r.region_name,
    s.amount,
    MAX(s.amount) OVER (PARTITION BY s.category_id) AS max_amount_in_category,
    MAX(s.amount) OVER () AS max_amount_overall,
    s.amount / MAX(s.amount) OVER (PARTITION BY s.category_id) * 100 AS percentage_of_category_max,
    s.amount / MAX(s.amount) OVER () * 100 AS percentage_of_overall_max
FROM 
    sales s
JOIN 
    categories c ON s.category_id = c.category_id
JOIN 
    regions r ON s.region_id = r.region_id
ORDER BY 
    c.category_name, 
    s.amount DESC;


*Explanation:*
- We calculate the maximum sale amount within each category using MAX() with a PARTITION BY clause.
- We calculate the overall maximum sale amount across all records using MAX() without partitioning.
- We also calculate each sale as a percentage of its category maximum and the overall maximum.
- This provides context for each sale amount relative to both its category and the entire dataset.

*Screenshot:*

![Aggregation with Window  a](https://github.com/user-attachments/assets/f07f289f-d6e1-4151-8262-7af3a62858fa)

*Real-Life Application:*
This analysis helps businesses understand how sales amounts compare both within categories and across the entire business. It can identify categories with higher-value transactions and help normalize sales figures across different product types. The percentage calculations provide a relative scale that makes it easier to compare performance across categories with different price points.

## Conclusion

SQL window functions provide powerful tools for analyzing data across rows without the need for complex self-joins or subqueries. Through this project, we've demonstrated how these functions can be used to:

1. Compare values between adjacent rows (LAG/LEAD)
2. Rank data within categories (RANK/DENSE_RANK)
3. Filter for top performers (DENSE_RANK with filtering)
4. Find earliest transactions (ROW_NUMBER with date ordering)
5. Calculate aggregates while preserving row details (window aggregation)

These techniques enable more sophisticated data analysis directly within SQL queries, making it easier to extract actionable business insights from transactional data.

## References

- [Oracle SQL Window Functions Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Analytic-Functions.html)
- [SQL Tutorial on Window Functions](https://www.youtube.com/watch?v=H6OTMoXjNiM)

  




