/*
Question: What skills are required for the top-paying data analyst jobs? 
- Use when top 10 highest-paying Data Analyst jobs from first query
- Add the spesific skills required for these roles 
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries

*/


WITH highest_paying_job AS 
    (SELECT
        job_id,
        job_title, 
        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL 
    ORDER BY salary_year_avg DESC
    LIMIT 10)

SELECT 
    highest_paying_job.*,
    skills
FROM highest_paying_job
INNER JOIN skills_job_dim ON highest_paying_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
 