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
💰In this section I wanted to check top ten job opportunities which were published on job page in 2023. I focused on three aspects here: it is Data Analyst job which is located in Poland, if not wanted to do it remotly and what company offers this job.

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

![Top Paying Roles](images\top10.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts which has been created via Google Colab based on SQL query results.*

### 2. Skills for Top Paying Jobs
🛠️To identify the key competencies demanded by high-paying positions, I merged job listing information with skill datasets, uncovering what qualifications employers prioritize for lucrative roles and what kind of skill this is.

```sql
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
HAVING 
    skills IS NOT NULL AND
    count(skills) > 1
ORDER BY demand_skills DESC;
```

Among the top 10 best-paying data analyst roles in 2023, certain skills consistently stand out:
- SQL takes the top spot, appearing in 8 of the listings.
- Python is a close second, featured in 7 roles.
- Tableau ranks high as well, showing up in 6 positions.

Additional tools and languages such as R, Snowflake, Pandas, and Excel also make appearances, though with less frequency—indicating a more specialized or situational demand.

![Skills required for top paying jobs](images\top10skills.png)
*This bar chart illustrates the frequency of key skills across the top 10 highest-paying data analyst roles. It was created in Google Colab using SQL query results.*

### 3. Most Wanted Skills for Data Analysts
💡By running this query, I was able to pinpoint the skills most commonly sought after in job listings—highlighting the areas where demand is strongest.

```sql
SELECT
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
```

Top Skills in Demand for Data Analysts (2023)

- Core Tools Still Reign: SQL and Excel continue to be indispensable, underscoring the value of solid fundamentals in data wrangling and spreadsheet mastery.
- Tech-Driven Insights: Proficiency in Python, Tableau, and Power BI is increasingly vital, reflecting the growing emphasis on technical fluency for crafting compelling visual narratives and guiding strategic decisions.

<center>

| Skills | Demand Count |
| :----: | :----------: |
| SQL      | 7291       |
| Excel    | 4611       |
| Python   | 4330       |
| Tableu   | 3745       |
| Power BI | 2609       |

</center>

Table of the demand for the top 5 skills in data analyst job postings.

### 4. Top 10 Skills Based on Salary
🔍Analyzing average salaries across skill sets uncovered which competencies command the highest pay—offering clear insight into where the financial value lies.

```sql
SELECT
    skills,
    type,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    skills IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY skills, type
ORDER BY avg_salary DESC
LIMIT 10;
```

<center>

|   Skills  |     Type    | Average Salary (USD) |
|:--------------:|:----------------:|:-------------------------:|
| SVN            | Other            | 400,000                   |
| Solidity       | Programming      | 179,000                   |
| Couchbase      | Databases        | 160,515                   |
| DataRobot      | Analyst Tools    | 155,486                   |
| Golang         | Programming      | 155,000                   |
| MXNet          | Libraries        | 149,000                   |
| dplyr          | Libraries        | 147,633                   |
| VMware         | Cloud            | 147,500                   |
| Terraform      | Other            | 146,734                   |
| Twilio         | Sync             | 138,500                   |

</center>

Table of the top 5 paid skills in data analyst job postings.

Skills like SVN, Solidity, and Couchbase lead with the highest salaries, showing strong demand for niche tools and programming expertise. Machine learning libraries, cloud platforms, and DevOps tools like MXNet, VMware, and Terraform also offer competitive pay, highlighting the value of technical depth and infrastructure knowledge in analytics roles.

### 5. Most Optimal Skills to Learn
📊By merging demand trends with compensation data, this analysis spotlighted skills that are not only widely sought after (mentioned more than 10 times) but also financially rewarding—providing a clear direction for targeted upskilling.

```sql
SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary,
    count(skills) as demand_skills
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY skills
HAVING
    count(skills) >10
ORDER BY
    avg_salary DESC,
    demand_skills DESC
LIMIT 15;
```

<center>

Results

|   Skills  | Average Salary (USD) | Demand Count |
|:--------------:|:------------------------:|:----------------:|
| Kafka          | 129,999                  | 40               |
| PyTorch        | 125,226                  | 20               |
| Perl           | 124,686                  | 20               |
| TensorFlow     | 120,647                  | 24               |
| Cassandra      | 118,407                  | 11               |
| Atlassian      | 117,966                  | 15               |
| Airflow        | 116,387                  | 71               |
| Scala          | 115,480                  | 59               |
| Linux          | 114,883                  | 58               |
| Confluence     | 114,153                  | 62               |
| PySpark        | 114,058                  | 49               |
| MongoDB        | 113,608                  | 52               |
| GCP            | 113,065                  | 78               |
| Spark          | 113,002                  | 187              |
| Splunk         | 112,928                  | 15               |

</center>

Table of the most optimal skills for data analyst sorted by salary.

This dataset highlights skills that offer competitive salaries despite moderate demand. Technologies like Kafka, PyTorch, and Perl stand out with average salaries above $120K, even though their demand counts are relatively low. Tools such as Airflow, Spark, and GCP show a healthier balance between demand and pay, making them strategic choices for analysts aiming to maximize both marketability and compensation.

# Conclusion

🚀 SQL Skills Unlocked I sharpened my SQL game—mastering complex queries, temp tables, and data aggregation with tools like GROUP BY, COUNT(), and AVG() to turn raw data into real insights.

📈 Key Takeaways from the Analysis

- Remote data analyst roles can hit salaries up to $650K.
- SQL is both the most in-demand and a top-paying skill—essential for career growth.
- Niche tools like SVN and Solidity offer premium salaries.
- For maximum market value, SQL stands out as the smartest skill to invest in.

🧠 Final Thoughts This project boosted my technical toolkit and revealed where the real value lies in the data job market. Staying sharp and learning continuously is the key to staying competitive.
