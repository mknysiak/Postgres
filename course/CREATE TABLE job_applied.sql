CREATE TABLE job_applied
(
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

INSERT INTO job_applied
VALUES 
    (1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'),
    (2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    false,
    NULL,
    'interview scheduled');

ALTER TABLE job_applied 
ADD Salary INT,
ADD Multi INT;

UPDATE job_applied
SET Salary = 10000, Multi = 2
WHERE job_id = 1;

UPDATE job_applied
SET Salary = 20000, Multi = 3
WHERE job_id = 2;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN Multi;

DROP TABLE job_applied

SELECT
    *,
    Salary*Multi AS Full_Salary
FROM job_applied

