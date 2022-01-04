-- Exercise reference: https://sqlzoo.net/wiki/Window_LAG

-- The example uses a WHERE clause to show the cases in 'Italy' in March 2020.
-- Modify the query to show data from Spain.
-- SELECT  name
--        ,DAY(whn)
--        ,confirmed
--        ,deaths
--        ,recovered
-- FROM covid
   WHERE name = 'Spain'
-- AND MONTH(whn) = 3
-- AND YEAR(whn) = 2020
-- ORDER BY whn;

-- Modify the query to show confirmed for the day before.
-- SELECT  name
--        ,DAY(whn)
--        ,confirmed
          ,LAG(confirmed,1) OVER (PARTITION BY name ORDER BY whn)
-- FROM covid
-- WHERE name = 'Italy'
-- AND MONTH(whn) = 3
-- AND YEAR(whn) = 2020
-- ORDER BY whn;

-- Show the number of new cases for each day, for Italy, for March.
SELECT  name
       ,DAY(whn)
       ,confirmed - LAG(confirmed,1) OVER (ORDER BY whn) AS new
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3
AND YEAR(whn) = 2020;

-- Show the number of new cases in Italy for each week in 2020 - show Monday
-- only.
SELECT  name
       ,DATE_FORMAT(whn,'%Y-%m-%d')
       ,confirmed - LAG(confirmed,1) OVER (order by whn) AS 'new_this_week'
FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0
AND YEAR(whn) = 2020
ORDER BY whn;

-- Show the number of new cases in Italy for each week - show Monday only.
-- This time JOIN a table using DATE arithmetic.
SELECT  tw.name
       ,DATE_FORMAT(tw.whn,'%Y-%m-%d')
       ,(tw.confirmed - lw.confirmed) AS new_this_week
FROM covid AS tw -- this week
LEFT JOIN covid AS lw -- last week
ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn AND tw.name = lw.name
WHERE tw.name = 'Italy'
AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

-- The query shown shows the number of confirmed cases together with the world
-- ranking for cases. Include the ranking for the number of deaths in the table.
-- SELECT  name
--        ,confirmed
--        ,RANK() OVER (ORDER BY confirmed DESC) AS 'rank confirmed'
--        ,deaths
          ,RANK() OVER (ORDER BY deaths DESC) AS 'rank death'
-- FROM covid
-- WHERE whn = '2020-04-20'
-- ORDER BY confirmed DESC;

-- The query shown includes a JOIN the world table so we can access the total
-- population of each country and calculate infection rates
-- (in cases per 100,000). Show the infect rate ranking for each country.
-- Only include countries with a population of at least 10 million.
-- SELECT  world.name
--        ,ROUND (100000 * confirmed / population, 0)
          ,RANK() OVER (ORDER BY confirmed / population) AS rank
-- FROM covid
-- JOIN world
-- ON covid.name = world.name
-- WHERE whn = '2020-04-20'
-- AND population > 10000000
-- ORDER BY population DESC;

-- For each country that has had at least 1000 new cases in a single day, show
-- the date of the peak number of new cases.
SELECT  name
       ,date
       ,cases_daily as peakNewCases
FROM
(
	SELECT  name
	       ,date
	       ,cases_daily
	       ,RANK() OVER (PARTITION BY name ORDER BY cases_daily DESC) AS rank
	FROM
	(
		SELECT  name
		       ,DATE_FORMAT(whn,'%Y-%m-%d')                                         AS date
		       ,confirmed - LAG (confirmed,1) OVER (PARTITION BY name ORDER BY whn) AS cases_daily
		FROM covid
	) AS counting_day_cases
	WHERE cases_daily >= 1000
) AS ranking_days
WHERE rank = 1
ORDER BY date;
