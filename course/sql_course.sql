/*
:: - converting into different data type;
SELECT '2023-02-19':: DATE;
DROP TABLE abc - usuwa tabele
ALTER TABLE old_name RENAME TO new_name - zmiana nazwy tabeli
*/

SELECT *
FROM skills_dim
LIMIT 500;

SELECT *
FROM skills_job_dim
LIMIT 500;

SELECT *
FROM job_postings_fact
LIMIT 500;

SELECT *
FROM company_dim
LIMIT 500;

SELECT
    job_title AS title,
    job_location AS location,
    job_posted_date::TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(DAY FROM job_posted_date) AS day
FROM job_postings_fact
LIMIT 100;

SELECT
    COUNT(job_id) AS job_posted_no,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_no DESC;

SELECT
    AVG(salary_year_avg) AS year_avg,
    AVG(salary_hour_avg) AS hour_avg,
    job_schedule_type
FROM job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY job_schedule_type;

SELECT
    COUNT(job_id) AS monthly_jobs,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') = 2023
GROUP BY MONTH
ORDER BY MONTH ASC;

SELECT
    company_dim.name,
    job_posted_date,
    job_health_insurance
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_health_insurance = TRUE AND EXTRACT(MONTH FROM job_posted_date) BETWEEN 4 AND 6
ORDER BY job_posted_date ASC;

CREATE TABLE jan_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE feb_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE mar_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT
    COUNT(job_id) AS no_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

SELECT
    COUNT(job_id) AS no_of_jobs,
    CASE
        WHEN salary_year_avg > 100000 THEN 'High'
        WHEN salary_year_avg BETWEEN 70000 AND 100000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY salary_category
ORDER BY AVG(salary_year_avg) DESC;

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(Month from job_posted_date) = 1
    LIMIT 500
) AS jan_jobs;

WITH jan_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month from job_posted_date) = 1
)
SELECT *
FROM jan_jobs;

SELECT name AS company_name
FROM company_dim
LIMIT 100
WHERE company_id IN (
    SELECT
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
);

WITH jobs AS (
SELECT
    company_id,
    COUNT(job_id) AS no_of_jobs
FROM job_postings_fact
GROUP BY company_id
ORDER BY company_id
)
SELECT
    jobs.company_id,
    company_dim.name,
    jobs.no_of_jobs
FROM jobs
LEFT JOIN company_dim ON jobs.company_id = company_dim.company_id
ORDER BY jobs.no_of_jobs DESC;

-- subqueries moze byc z select, from, where
SELECT
    skills_dim.skill_id,
    skills,
    COUNT(skills_job_dim.skill_id),
    job_postings_fact.job_title_short,
    job_work_from_home
FROM skills_job_dim
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
GROUP BY (skills, skills_dim.skill_id, job_postings_fact.job_title_short, job_work_from_home)
HAVING job_work_from_home = TRUE AND job_title_short = 'Data Analyst'
ORDER BY count DESC
LIMIT 5;

SELECT
    job_postings_fact.company_id,
    name,
    count(job_id) AS job_count,
    CASE
        WHEN COUNT(job_id) < 10 THEN 'Small'
        WHEN COUNT(job_id) BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS companyjobs
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
GROUP BY (job_postings_fact.company_id, name)
ORDER BY job_count DESC
LIMIT 50;

WITH firstq AS (
SELECT
    job_id,
    salary_year_avg
FROM jan_jobs
UNION ALL
SELECT
    job_id,
    salary_year_avg
FROM feb_jobs
UNION ALL
SELECT
    job_id,
    salary_year_avg
FROM mar_jobs
)

SELECT
    firstq.job_id,
    firstq.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM firstq
LEFT JOIN skills_job_dim ON firstq.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg > 70000;


