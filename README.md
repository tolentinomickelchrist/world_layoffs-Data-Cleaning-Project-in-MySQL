Layoffs Data Cleaning (MySQL)
- This project is about cleaning and organizing a global layoffs dataset using MySQL. The goal was to make the data accurate, consistent, and ready for analysis.

What I Did:
- Removed duplicate rows with a ROW_NUMBER() check.

- Cleaned up text fields by trimming spaces and fixing inconsistent names (e.g., “Crypto” variations, trailing periods in “United States”).

- Converted the date column from text to proper DATE format.

- Filled in missing industries where possible, and set empty strings to NULL.

- Deleted rows that had no layoff data at all.

- Dropped temporary columns used for cleaning.

Tools:
MySQL

Result:
A cleaned dataset that’s consistent, easy to query, and ready for deeper analysis or visualization.
