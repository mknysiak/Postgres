# Introduction
This project analyzes the 2023 job market using datasets collected from job listing aggregators. The data covers a wide range of programming-related roles, but this analysis focuses specifically on data analyst positions. The goal is to identify top-paying roles, the most in-demand skills, and the intersection of high demand with high salaries, while also serving as a practical exercise in learning and applying SQL for real-world data analysis.

The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

SQL code to check answers on above queries by clicking here: [Jobs](https://github.com/mknysiak/Postgres/blob/main/project.sql)  

# Tools which were used
In exploring the data analyst job market, I relied on a set of essential tools:

- SQL – the core language of the analysis, used to query datasets and extract meaningful patterns.
- PostgreSQL – the database system selected to efficiently store and manage the job postings data.
- Visual Studio Code – the primary environment for writing and running SQL queries, as well as managing the database.
- Git & GitHub – indispensable for version control, documentation, and publishing the SQL scripts and results, enabling both transparency and collaboration.

# Analysis

### 1. Top Paying Data Analyst Jobs
In this section I wanted to check top ten job opportunities which were published on job page in 2023. I focused on three aspects here: it is Data Analyst job which is located in Poland, if not wanted to do it remotly and what company offers this job.

```sql
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
```

Overview of the top Data Analyst roles in 2023:
- Salary Spectrum: The top 10 positions range from $184,000 to $650,000 annually, highlighting the strong earning potential in data analytics.
- Range of Employers: High-paying opportunities are offered by organizations such as SmartAsset, Meta, and AT&T, illustrating demand across multiple sectors.
- Role Diversity: Job titles vary widely, from Data Analyst to Director of Analytics, underscoring the breadth of responsibilities and specializations within the field.


# Conclusion


