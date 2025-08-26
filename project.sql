-- Top 10 Data Analyst jobs
SELECT
    name,
    job_title_short,
    job_title,
    job_location,
    job_work_from_home,
    job_country,
    salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR job_location = 'Poland')
ORDER BY salary_year_avg DESC
LIMIT 10;

-- Top jobs skills
WITH topten AS(
SELECT *
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR job_location = 'Poland')
ORDER BY salary_year_avg DESC
LIMIT 10
)

SELECT
    skills,
    type,
    count(skills) AS demand_skills
FROM topten
LEFT JOIN skills_job_dim ON topten.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills, type
ORDER BY demand_skills DESC;

-- Most demand skills for Data Analyst
SELECT
    skills_job_dim.skill_id,
    skills,
    count(skills) AS demand_skills 
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_work_from_home = TRUE AND
    job_title_short = 'Data Analyst'
GROUP BY skills, skills_job_dim.skill_id
ORDER BY demand_skills DESC
LIMIT 5;

--Top skills based on salary
SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY avg_salary DESC;

-- Most demand skills and with highest salary
SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary,
    count(skills) as demand_skills
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY skills
HAVING
    count(skills) >10
ORDER BY
    avg_salary DESC,
    demand_skills DESC
LIMIT 25;