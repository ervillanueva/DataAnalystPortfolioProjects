CREATE DATABASE humanResources;

-- creating the table
USE humanResources;
CREATE TABLE humanResources (
    id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    birthdate TEXT,
    gender VARCHAR(20),
    race VARCHAR(20),
    department VARCHAR(100) NOT NULL,
    jobtitle VARCHAR(40),
    location VARCHAR(40),
    hire_date TEXT,
    termdate TEXT,
    location_city VARCHAR(100),
    location_state VARCHAR(30)
);

-- fixing the birthdate
SET sql_safe_updates = 0;
 UPDATE humanResources
 SET birthdate = CASE
     WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
     WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
     ELSE NULL
 END;

-- altering the type of birthdate
ALTER TABLE humanResources
MODIFY COLUMN birthdate DATE;

-- fixing the hire_date
 UPDATE humanResources
 SET hire_date = CASE
     WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
     WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
     ELSE NULL
 END;

ALTER TABLE humanResources
MODIFY COLUMN hire_date DATE;


-- fixing termdate
UPDATE humanResources
    SET termdate = CASE
        WHEN termdate IS NOT NULL AND termdate != '' AND termdate != 'termdate' THEN date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
        ELSE NULL
    END;

ALTER TABLE humanResources
MODIFY COLUMN termdate DATE;

-- adding an age column
ALTER TABLE humanResources
ADD COLUMN age INT;

UPDATE humanResources
SET age = timestampdiff(YEAR, birthdate, CURDATE());

-- selecting the youngest person
SELECT MIN(age) AS youngest,
       MAX(age) AS oldest
FROM humanResources;

-- counting the number of people under 18
SELECT COUNT(*)
FROM humanResources
WHERE age < 18;

-- QUESTIONS!

-- 1. What is the gender break down of employees in the company?
SELECT gender, COUNT(*) AS COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;
-- 2. What is the race/ ethnicity break down of employees in the company?
SELECT race, COUNT(*) as COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY COUNT DESC;
-- 3. What is the age distribution of employees in the company?
SELECT
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,gender, COUNT(*) AS COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at the headquarters versus remote locations?
SELECT location, COUNT(*) AS COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT ROUND(AVG(datediff(termdate, hire_date))/365, 0) AS AVG_LENGTH_EMPLOYMENT
FROM humanResources
WHERE termdate IS NOT NULL AND termdate <= curdate() AND age >= 18;

-- 6. How does gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) as COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender, department
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT humanResources.jobtitle, COUNT(*) AS COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department,
       total_count,
       terminated_count,
       terminated_count/ total_count AS termination_rate
FROM (
    SELECT department,
           COUNT(*) as total_count,
           SUM(CASE WHEN humanResources.termdate IS NOT NULL  AND humanResources.termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM humanResources
    WHERE age >= 18
    GROUP BY department
     ) as subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS COUNT
FROM humanResources
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY COUNT DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
-- group by the year, count hire and terminated by year, minus terminated from hire to get number of employees in that year
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations)/hires*100, 2) AS net_change_pct
FROM(
SELECT YEAR(hire_date) as year,
        COUNT(*) as hires,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
 FROM humanResources
 WHERE age >= 18
 GROUP BY YEAR(hire_date)
 ) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department,ROUND(AVG(datediff(termdate, hire_date)/365), 0) AS AVG_TENURE
FROM humanResources
WHERE termdate IS NOT NULL AND termdate <= curdate() AND age >= 18
GROUP BY department;