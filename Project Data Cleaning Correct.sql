-- Data Cleaning

-- 1.Remove Duplicate
-- 2.Standardize the data
-- 3.Null the value or blank values
-- 4.Remove any column

-- 1.Remove Duplicate
SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- A.check the similar row
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) row_num
FROM layoffs_staging;

-- B.find the similar row
WITH duplicate_cte AS
(SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
    stage, country, funds_raised_millions) row_num
FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- C.Buat tabel baru untuk menghapus row_num > 1
CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` bigint DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT  *
FROM layoffs_staging3
WHERE row_num > 1;

INSERT INTO layoffs_staging3
SELECT *, 
	ROW_NUMBER() OVER
			(PARTITION BY company, 
            location, 
            industry, 
            total_laid_off, 
            percentage_laid_off, 
            `date`, 
			stage, 
            country, 
            funds_raised_millions) row_num
FROM layoffs_staging;

-- D.hapus baris
DELETE
FROM
WHERE row_num > 1;

-- E.Periksa tabel setelah dihapus
SELECT *
FROM layoffs_staging3
WHERE row_num > 1;

-- 2.Standardizing  Data

-- A. Menghilankan spasi absurd
SELECT company, TRIM(company)
FROM layoffs_staging3;

-- B.Update tabel sebelumnya 
UPDATE layoffs_staging3
SET company = TRIM(company);

-- C.Update Tulisan Crypto... menjadi crypto saja
UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- D.Periksa Hasilnya
SELECT *
FROM layoffs_staging3
WHERE industry LIKE 'Crypto';

-- F.Menghapus Titik 
SELECT DISTINCT country, TRIM(TRAILING '.'FROM country)
FROM layoffs_staging3
ORDER BY 1;

-- G.Menghapus karakter di belakang tulisan
UPDATE layoffs_staging3
SET country = TRIM(TRAILING '.'FROM country)
WHERE country LIKE 'United States%';

-- H.Mengganti format tanggal
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging3;

-- I.Update perubahan tanggal
UPDATE layoffs_staging3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- G.Mengubah tipe data Date
ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;

-- H.Kasus dimana nilai industry airbnb kososng
SELECT *
FROM layoffs_staging3
WHERE company = 'Airbnb';


-- I.Mengecek nilai industry yang kosong dan null 
SELECT t1.industry, t1.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t2.industry = '')
AND t2.industry IS NOT NULL;

-- J.Mengisi kolom kososng dengan Null
UPDATE layoffs_staging3
SET industry = NULL
WHERE industry = '';

-- K.Update nilai pengisisan nilai industry
UPDATE layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging3;