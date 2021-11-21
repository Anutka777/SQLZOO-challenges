-- Exercise reference: https://sqlzoo.net/wiki/NSS_Tutorial

-- ---------------------------------------------------------
--                           Table deatails

--               | Field               | Type         |
--               |---------------------|--------------|
--               | ukprn               | varchar(8)   |
--               | institution         | varchar(100) |
--               | subject             | varchar(60)  |
--               | level               | varchar(50)  |
--               | question            | varchar(10)  |
--               | A_STRONGLY_DISAGREE | int(11)      |
--               | A_DISAGREE          | int(11)      |
--               | A_NEUTRAL           | int(11)      |
--               | A_AGREE             | int(11)      |
--               | A_STRONGLY_AGREE    | int(11)      |
--               | A_NA                | int(11)      |
--               | CI_MIN              | int(11)      |
--               | score               | int(11)      |
--               | CI_MAX              | int(11)      |
--               | response            | int(11)      |
--               | sample              | int(11)      |
--               | aggregate           | char(1)      |

-- It has one row per institution, subject, qwestion.
-- ---------------------------------------------------------

-- The example shows the number who responded for:
-- * question 1
-- * at 'Edinburgh Napier University'
-- * studying '(8) Computer Science'

-- Show the the percentage who STRONGLY AGREE
SELECT  A_STRONGLY_AGREE
FROM nss
WHERE question = 'Q01'
AND institution = 'Edinburgh Napier University'
AND subject = '(8) Computer Science';

-- Show the institution and subject where
-- the score is at least 100 for question 15.
SELECT  institution
       ,subject
FROM nss
WHERE question = 'Q15'
AND score >= 100;

-- Show the institution and score where the score for '(8) Computer Science' is
-- less than 50 for question 'Q15'.
SELECT  institution
       ,score
FROM nss
WHERE question = 'Q15'
AND subject = '(8) Computer Science'
AND score < 50;

-- Show the subject and total number of students who responded to question 22
-- for each of the subjects '(8) Computer Science' and
-- '(H) Creative Arts and Design'.
SELECT  subject
       ,SUM(response)
FROM nss
WHERE question = 'Q22'
GROUP BY  subject
HAVING subject IN ('(8) Computer Science', '(H) Creative Arts AND Design');

-- Show the subject and total number of students who A_STRONGLY_AGREE to
-- question 22 for each of the subjects '(8) Computer Science' and 
-- (H) Creative Arts and Design'.
SELECT  subject
       ,SUM(A_STRONGLY_AGREE * response / 100) AS 'total'
FROM nss
WHERE question='Q22'
GROUP BY  subject
HAVING subject IN ('(8) Computer Science', '(H) Creative Arts AND Design');

-- Show the percentage of students who A_STRONGLY_AGREE to question 22 for the
-- subject '(8) Computer Science' show the same figure for the subject
-- '(H) Creative Arts and Design'.
SELECT  subject
       ,ROUND(SUM(response * A_STRONGLY_AGREE / 100) / SUM (response) * 100)
FROM nss
WHERE question='Q22'
AND subject IN ('(8) Computer Science', '(H) Creative Arts AND Design')
GROUP BY  subject;

-- Show the average scores for question 'Q22' for each institution that include
-- 'Manchester' in the name.
SELECT  institution
       ,ROUND(SUM(response * score / 100) / SUM (response) * 100)
FROM nss
WHERE question='Q22'
AND (institution LIKE '%Manchester%')
GROUP BY  institution
ORDER BY institution;

-- Show the institution, the total sample size and the number of computing
--mstudents for institutions in Manchester for 'Q01'.
SELECT  institution
       ,SUM(sample)  AS 'total sample'
       ,SUM(CASE
              WHEN subject = '(8) Computer Science'
              THEN sample
              ELSE 0
            END) AS comp
FROM nss
WHERE question='Q22'
AND (institution LIKE '%Manchester%')
GROUP BY  institution;
