/* PROBLEM TO LEARN AFTER FINISHING THE YOUTUBE

First problem 
Identify the top 5 skills that are most prequently mentioned in jobpostings. Use a subsquery to find the skill IDs with the highest counts in the skills_job_dim table and then join this results
with the skills_dim table to get the skill names.

Second problem
Determine the size cateory (small, medium, or lager)
for each company by first identifying the number of job postings
they have. A company is considered 'small' if it has less than 10 job postings, 
'medium' if the number of job postings is between 100 and 50, and 'large'
if it has more than 50 jobs postings. 
Implement a subsquery job counts per company before classifying them based on size. 

*/

SELECT 
    job_id,
    skill_id 
FROM skills_job_dim as skills_to_job