## Group Name: QueryMasters

## Team Members
- [Your Name]
- [Partner's Name]

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
Compare Values with Previous or Next Records.png
