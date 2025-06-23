/* 
Answer: What are the most optimal skills to learn (aka it's in high demand and a high paying skill)?
- Identify skills in high demand and associated with gih average salaries for Data Analyst roles 
- Concentrates on remote positions with specified salaries 
- Why?Target skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analyst
*/


WITH high_demand_skills AS 
    (SELECT 
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills_job_dim.skill_id, skills_dim.skills
)

SELECT
    high_demand_skills.*, 
    ROUND (AVG (salary_year_avg), 0) AS avg_salary
FROM high_demand_skills
INNER JOIN skills_dim ON skills_dim.skills = high_demand_skills.skills
INNER JOIN skills_job_dim ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE high_demand_skills.demand_count > '10'
GROUP BY 
 high_demand_skills.skill_id, high_demand_skills.skills, high_demand_skills.demand_count
ORDER BY 
    avg_salary DESC,
    high_demand_skills.demand_count DESC
LIMIT 25

WITH high_demand_skills AS (
    SELECT 
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS jp
    INNER JOIN skills_job_dim AS sjd ON jp.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE jp.job_title_short = 'Data Analyst' 
      AND jp.job_work_from_home IS TRUE
    GROUP BY sd.skills
    ORDER BY demand_count DESC
    LIMIT 25
)

-- Main query: Join back with job_postings_fact to get salary info
SELECT 
    hds.skills,
    hds.demand_count,
    AVG(jp.salary_year_avg) AS avg_salary
FROM high_demand_skills AS hds
INNER JOIN skills_dim AS sd ON hds.skills = sd.skills
INNER JOIN skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jp ON jp.job_id = sjd.job_id
GROUP BY hds.skills, hds.demand_count
ORDER BY 
    avg_salary DESC,hds.demand_count DESC
LIMIT 25;


-- Rewriting this same query more concisely
SELECT 
    skills_job_dim.skill_id, 
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS True AND 
    salary_year_avg IS NOT NULL 
GROUP BY 
    skills_job_dim.skill_id, skills_dim.skills
HAVING 
    COUNT (skills_job_dim.job_id)> '10'
ORDER BY avg_salary DESC
LIMIT 25