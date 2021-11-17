-- Exercise reference: https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
-- Notes about table(make sure you included the last dot in the adress):
-- https://sqlzoo.net/wiki/Read_the_notes_about_this_table.
-- -----------------------------------------------------------------
--                           Table sample:
--
--                             world
-- | name        | continent | area    | population | gdp          |
-- | ----------- | --------- | ------- | ---------- | ------------ |
-- | Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
-- | Albania     | Europe    | 28748   | 2831741    | 12960000000  |
-- | Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
-- | Andorra     | Europe    | 468     | 78115      | 3712000000   |
-- | Angola      | Africa    | 1246700 | 20609294   | 100990000000 |
--                              ...
-- -----------------------------------------------------------------

-- List each country name where the population is larger than that of 'Russia'.
SELECT  name
FROM world
WHERE population > (
SELECT  population
FROM world
WHERE name = 'Russia');

-- Show the countries in Europe with a per capita GDP greater
-- than 'United Kingdom'.
SELECT  name
FROM world
WHERE continent = 'Europe'
AND gdp/population > (
SELECT  gdp/population
FROM world
WHERE name = 'United Kingdom');

-- List the name and continent of countries in the continents containing
-- either Argentina or Australia. Order by name of the country.
SELECT  name
       ,continent
FROM world
WHERE continent IN ( SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name;

-- Which country has a population that is more than Canada but less than Poland?
-- Show the name and the population.
SELECT  name
       ,population
FROM world
WHERE population > (
SELECT  population
FROM world
WHERE name = 'Canada') AND population < (
SELECT  population
FROM world
WHERE name = 'Poland');

-- Show the name and the population of each country in Europe.
-- Show the population as a percentage of the population of Germany.
-- The format should be name, percentage.
SELECT  name
       ,CONCAT (ROUND (population * 100 / (
SELECT  population
FROM world
WHERE name = 'Germany') ), '%') AS percentage
FROM world
WHERE continent = 'Europe';

-- Which countries have a GDP greater than every country in Europe?
-- [Give the name only.] (Some countries may have NULL gdp values.)
SELECT  name
FROM world
WHERE (gdp > ALL (
SELECT  gdp
FROM world
WHERE continent = 'Europe'
AND gdp > 0));

-- Find the largest country (by area) in each continent,
-- show the continent, the name and the area:
SELECT  continent
       ,name
       ,area
FROM world AS candidate
WHERE (area >= ALL (
SELECT  area
FROM world AS each_same_continent
WHERE each_same_continent.continent = candidate.continent));

-- List each continent and the name of the country
-- that comes first alphabetically.

-- SELECT continent, MIN(name)
-- FROM world
-- GROUP BY continent;
-- But guess I have to use nested SELECT for this one:
SELECT  continent
       ,name
FROM world AS candidate
WHERE (name <= ALL (
SELECT  name
FROM world AS each_same_continent
WHERE each_same_continent.continent = candidate.continent));

-- Find the continents where all countries have a population <= 25000000.
-- Then find the names of the countries associated with these continents.
-- Show name, continent and population.
(
	SELECT  name
	       ,continent
	FROM world
	WHERE population <= 25000000);
