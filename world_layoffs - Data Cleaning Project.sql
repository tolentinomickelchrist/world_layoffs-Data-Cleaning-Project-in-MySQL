-- data cleaning 

SELECT * 
from layoffs;

-- 1. remove duplicates
-- 2. standardize the data
-- 3. null values or blank values
-- 4. remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * 
FROM layoffs;


SELECT * 
from layoffs_staging;


WITH CTE_duplicates as(
SELECT  * ,
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, 
	percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)
SELECT * 
FROM CTE_duplicates
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

/* 
create new table layoffs_staging2
right-click layoffs_staging, click "copy to clipboard",  click "create statement", then ctrl + v
add column named row_num to display value greater than 1 if the row has duplicate/s
*/
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- insert the data from layoffs_staging to layoffs_staging2 

INSERT INTO layoffs_staging2
SELECT  * ,
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, 
	percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;
-- show rows that has duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;
-- delete rows that has duplicates
DELETE 
FROM layoffs_staging2
WHERE row_num > 1
;
-- check if it was deleted successfully
SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;
-- DUPLICATES HAVE BEEN REMOVED SUCCESSFULLY

SELECT *
FROM layoffs_staging2;

-- STANDARDIZING DATA
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;
-- looking for something that's not a white space// specify
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- (update) trim countries that has period on it
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- fix date column
SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');
-- change date column data type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

-- look for null or blank values in the industry column
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb';

-- 
SELECT t1.industry, T2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry is NOT NULL;

-- set industry's blank values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- set industry values to null values of industry 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

-- delete rows where total_laid_off and percentage_laid_off are NULL 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

-- delete row_num (used for locating duplicate rows)
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
SELECT *
FROM layoffs_staging2;





