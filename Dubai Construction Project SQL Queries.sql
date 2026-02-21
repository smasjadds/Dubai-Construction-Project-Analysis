--Total Projects.
SELECT COUNT(Distinct Project_no) as 'Total Projects'
FROM Project_Information


--How many projects are currently active and completed.
SELECT Project_status, 
COUNT(Distinct project_no) as 'Total Projects'
FROM Project_Information
GROUP BY Project_status


--How many project each year.
SELECT YEAR(PROJECT_CREATION_DATE) AS 'Year', 
COUNT(Distinct project_no) as 'Total Projects'
FROM Project_Information
GROUP BY YEAR(PROJECT_CREATION_DATE)
ORDER BY 1


--Which consultant handeled the most project.
SELECT TOP 1 Consultant_name, 
COUNT( DISTINCT PROJECT_NO) AS 'Total Projects'
FROM Project_Information
WHERE consultant_name IS NOT NULL
GROUP BY consultant_name
ORDER BY 2 DESC


--Which consultant have the highest project completion rate.
Select Consultant_name,
COUNT(*) AS 'Total Projects',
SUM(CASE WHEN Project_status = 'Open' THEN 1 ELSE 0 END) 'Completed Projects',
CONCAT((SUM(CASE WHEN Project_status = 'Open' THEN 1 ELSE 0 END) * 100 / 
COUNT(*)),'%') AS 'Completion rate percentage'
FROM Project_Information
WHERE Consultant_name IS NOT NULL
GROUP BY consultant_name
HAVING COUNT(*) > 1000
ORDER BY 'Completion rate percentage' DESC


--Average project month duration per consultant.
SELECT Consultant_name,
AVG(DATEDIFF(MONTH, PROJECT_CREATION_DATE, PROJECT_COMPLETION_DATE)) AS 'Average Months'
FROM Project_Information
WHERE project_completion_date IS NOT NULL
AND project_completion_date>=project_creation_date
GROUP BY consultant_name


--Which contractor completed the most projects.
SELECT Contractor_name,
COUNT(DISTINCT PROJECT_NO) AS 'Total Projects'
FROM Project_Information
WHERE contractor_name is not null
AND project_status = 'Closed'
GROUP BY contractor_name
ORDER BY 2 DESC


--What is the time duration for each project.
SELECT Project_no as 'Project Number',
DATEDIFF(MONTH, PROJECT_CREATION_DATE, PROJECT_COMPLETION_DATE) as 'Time Duration'
FROM Project_Information
WHERE PROJECT_COMPLETION_DATE IS NOT NULL


--Delay in days for each project
SELECT PROJECT_NO AS 'Project Number', 
DATEDIFF(DAY,PROJECT_COMPLETION_DATE,EXPECTED_COMPLETION_DATE) 'Delay'
FROM Project_Information
WHERE expected_completion_date IS NOT NULL
AND project_completion_date IS NOT NULL
AND expected_completion_date < project_completion_date


--How many projects completed on time or before the expected completion date.
SELECT PROJECT_NO AS 'Project Number', 
DATEDIFF(DAY,PROJECT_COMPLETION_DATE,EXPECTED_COMPLETION_DATE) 'Days'
FROM Project_Information
WHERE expected_completion_date IS NOT NULL
AND project_completion_date IS NOT NULL
AND expected_completion_date >=project_completion_date


--What is the average time between permit date and work start date.
SELECT Project_no,
DATEDIFF(Day,permit_date,project_creation_date) 'Days between permit and creation date'
FROM Project_Information
WHERE permit_date< project_creation_date


--Which consultant face the longest approval time.
SELECT TOP 1 Project_no,Consultant_name,
DATEDIFF(Day,permit_date,project_creation_date) 'Days between permit and creation date'
FROM Project_Information
WHERE permit_date< project_creation_date
ORDER BY 3 DESC


--Which application type is most common.
SELECT lower(Applicant_type)AS 'Application Type',
COUNT(DISTINCT PROJECT_NO) AS 'Total Projects'
FROM Project_Information
GROUP BY applicant_type


--Which application type has the highest completion rate.
SELECT LOWER(Applicant_type) AS Application_type,
COUNT(*) AS 'Total Projects',
SUM(CASE WHEN PROJECT_STATUS = 'Open' THEN 1 ELSE 0 END) AS 'Acitve Projects',
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END) AS 'Completed Projects',
CONCAT((SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END * 100)
/COUNT(*)),'%') AS 'Completion Rate'
FROM Project_Information
GROUP BY applicant_type


--TOP 5 parcel IDs which have highest projects.
SELECT TOP 5 PARCEL_ID,
COUNT(DISTINCT PROJECT_NO) AS 'Total Projects'
FROM Project_Information
GROUP BY parcel_id
ORDER BY 2 DESC


--Which contractor-consultant performs best.
SELECT Project_no,Contractor_name, Consultant_name,
DATEDIFF(DAY,Project_creation_date,Project_completion_date)
AS 'Total days taken in project creation'
FROM Project_Information
WHERE project_creation_date<project_completion_date
AND contractor_name is not null
AND consultant_name is not null
ORDER BY 4


--Which month has the highest number of project starts of each year.
SELECT * FROM (
SELECT DATEPART(YYYY,PROJECT_CREATION_DATE) AS 'Year',
DATEPART(MM,PROJECT_CREATION_DATE) AS 'Month',
COUNT(DISTINCT PROJECT_No) AS 'Total Projects',
ROW_NUMBER() OVER
(PARTITION BY DATEPART(YYYY,PROJECT_CREATION_DATE) ORDER BY COUNT(DISTINCT PROJECT_No) DESC) RN
FROM Project_Information
GROUP BY DATEPART(YYYY,PROJECT_CREATION_DATE),DATEPART(MM,PROJECT_CREATION_DATE)) XYZ
WHERE RN =1


--Segment contractors based on project completion.
SELECT Contractor_name, COUNT(DISTINCT PROJECT_NO) AS 'Total Projects',
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END) AS 'Completed Projects', 
CASE 
WHEN 
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END)
<=100 THEN 'Low Performing'
WHEN 
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END)
<=500 THEN 'Medium Performing'
WHEN 
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END)
> 500 THEN 'High Performing'END AS 'Segment'
FROM Project_Information
WHERE Contractor_name is not null
GROUP BY contractor_name
ORDER BY 3 DESC


--What percentage of total projects are incomplete.
SELECT COUNT(DISTINCT PROJECT_NO) AS 'Total Projects',
SUM(CASE WHEN PROJECT_STATUS = 'Open' THEN 1 ELSE 0 END) AS 'Incomplete Projects',
CONCAT((SUM(CASE WHEN PROJECT_STATUS = 'Open' THEN 1 ELSE 0 END * 100)/
COUNT(DISTINCT PROJECT_NO)), '%') AS 'Incomplete Projects Percentage'
FROM Project_Information


--Ranking TOP 3 contractors who has completed the highest projects.
SELECT * FROM
(
SELECT Contractor_name,
SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END) AS 'Completed Projects',
ROW_NUMBER() OVER (ORDER BY SUM(CASE WHEN PROJECT_STATUS = 'Closed' THEN 1 ELSE 0 END) DESC) Rank
FROM Project_Information
WHERE contractor_name is not null
GROUP BY contractor_name
) XYZ
WHERE Rank <=3
































--


