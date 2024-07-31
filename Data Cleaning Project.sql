-- data cleaning 

SELECT *
FROM mytable;

-- 1. Remove duplicate
-- 2. Standardize the data
-- 3. null value or Blank value
-- 4. Remove row and column not needed

 Create table layoffs_staging 
 like mytable;

SELECT *
from layoffs_staging;

Insert layoffs_staging
SELECT *
FROM mytable;


------------------------------------------------
SELECT *,
ROW_Number() Over(partition by company,location,industry,total_laid_off, percentage_laid_off, 'date',stage, country, funds_raised_millions) as row_num
From layoffs_staging;

WITH
Duplicate_CTE AS
(
	SELECT *,
ROW_Number() Over(partition by company,location,industry,total_laid_off, percentage_laid_off, 'date',stage, country, funds_raised_millions)as row_num
From layoffs_staging
)
SELECT *
FROM Duplicate_CTE
WHERE row_num >1;

SELECT *
from layoffs_staging
where company = 'Airbnb';


SELECT *
from layoffs_staging
where company = 'shopee';

SELECT *
from layoffs_staging
where company = 'zymergen';


WITH
Duplicate_CTE AS
(
	SELECT *,
ROW_Number() Over(partition by company,location,industry,total_laid_off, percentage_laid_off, 'date',stage, country, funds_raised_millions)as row_num
From layoffs_staging
)
delete
FROM Duplicate_CTE
WHERE row_num >1;


 CREATE TABLE `layoffs_staging2` (
  `company` text COLLATE utf16_unicode_ci,
  `location` text COLLATE utf16_unicode_ci,
  `industry` text COLLATE utf16_unicode_ci,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text COLLATE utf16_unicode_ci,
  `date` text COLLATE utf16_unicode_ci,
  `stage` text COLLATE utf16_unicode_ci,
  `country` text COLLATE utf16_unicode_ci,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_unicode_ci;


SELECT *
from layoffs_staging2
WHERE row_num >1;


Insert Into layoffs_staging2
	SELECT *,
ROW_Number() Over(partition by company,location,industry,total_laid_off, percentage_laid_off, 'date',stage, country, funds_raised_millions)as row_num
From layoffs_staging;


DELETE
from layoffs_staging2
WHERE row_num >1;



-- Standardizing data



SELECT *
from layoffs_staging2;

SeLECT company,(trim(company))
from layoffs_staging2;

Update layoffs_staging
SET company = trim(company);

SELECT Distinct industry
from layoffs_staging2
Order by 1;

SELECT *
from layoffs_staging2
WHERE industry like 'crypto%';

Update layoffs_staging2
Set industry = 'Crypto'
WHERE industry like'crypto%';

SELECT Distinct country
from layoffs_staging2
order by 1;

Select distinct country, TRIM(Trailing '.' From country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = TRIM(Trailing '.' From country)
Where country like 'United States%';

select distinct country 
from layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN formatted_date;





-- remove null or blank value




select *
from layoffs_staging2;

select*
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

SELECT *
from layoffs_staging2
WHERE industry IS NULL
or industry= '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
from layoffs_staging2
WHERE company = 'Airbnb'; 


SELEct t1.company,t1.industry,t2.company,t2.industry
from layoffs_staging2  t1
JOIn layoffs_staging2 t2
	on t1.company= t2.company
WHERE t1.industry is NULL or t1.industry =''
AND t2.industry is not null;

Update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
and t2.industry is not null;



SELECT *
from layoffs_staging2
where company like 'Bally%';


select*
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

delete
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

Select *
from layoffs_staging2;

ALTER table layoffs_staging2
DROP COLUMN row_num;


