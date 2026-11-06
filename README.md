# Retail-Sales-SQL-Analysis

## Business Problem: 
To understand sales, profit , customer and discounts on a simulated retail-sales dataset.

## Dataset:
- Simulated retail sales data (not from a real company).
- 3 csv tables: orders, customers, and products, cleaned (4240 rows) exported from Jupyter.
- Period: Jan 2024 – Dec 2025
  
## Steps:
1. Imported 3 csv files into SQLite.
2. Joined the tables to answer business questions on sales, customers, and products.
3. Used GROUP BY and HAVING to summarize sales by region, category, and month.
4. Used CASE WHEN to compare profit margin across discount levels.
5. Used a CTE and a window function to find average customer spend and to identify top products per category.
6. Exported the results.

## Key findings:
1. Technology category generate the highest sales with 17% profit margin, however office supplies recorded 2nd highest sales with highest 25.6% profit margin.
2. The monthly trend shows the highest order volume from October to December.
3. Products with zero discounts maintained an 18.1% profit margin and aggressive discounts over 10% resulted in a -6.6% net loss. 
4. East Region: Highest overall sales value at ₹2,71,72,858.


## Tools:
DB Browser (SQLite)

