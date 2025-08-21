# 🧹 SQL Data Cleaning Project - World Layoffs

## 📖 Overview
This is my **first data cleaning project** using SQL.  
I used the "World Layoffs" dataset to practice cleaning raw data and transforming it into an analysis-ready format.

## 📂 Dataset
- Source: Public layoffs dataset (from [Kaggle](https://www.kaggle.com/) or similar)  
- Records before cleaning: XXXX  
- Records after cleaning: XXXX  

## 🔧 Steps I Did
1. **Removed duplicates**  
   - Identified duplicate rows using `ROW_NUMBER()`  
   - Deleted duplicates to keep the dataset consistent  

2. **Standardized text format**  
   - Trimmed unwanted characters (e.g., trailing dots in country names)  
   - Fixed inconsistent values  

3. **Converted date column**  
   - Used `STR_TO_DATE()` to change from text (`VARCHAR`) to proper `DATE` type  

4. **Handled NULL values**  
   - Replaced missing industry values by joining with other rows of the same company  

5. **Dropped unnecessary columns**  
   - Example: `row_num` after cleaning  

## 📊 Result
Now the dataset is clean and can be used for analysis.  
Example of cleaned data:

| company  | industry    | total_laid_off | date       | country       |
|----------|------------|----------------|------------|---------------|
| AdRoll   | Marketing  | 210            | 2020-03-31 | United States |
| Advata   | Healthcare | 32             | 2022-10-28 | United States |

## 📁 Files in this repo
- `Project Data Cleaning Correct.sql` → all SQL queries  
- `README.md` → project documentation  

---

👨‍💻 Created by [Caesar John](https://github.com/caesar-john)  

