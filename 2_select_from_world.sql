-- Exercise reference: https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial
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

-- Show the name, continent and population of all countries.
SELECT  name
       ,continent
       ,population
FROM world;

-- Show the name for the countries
-- that have a population of at least 200 million.
SELECT  name
FROM world
WHERE population >= 200000000;

-- Give the name and the per capita GDP for those countries
-- with a population of at least 200 million.
SELECT  name
       ,gdp/population AS 'per capita GDP'
FROM world
WHERE population >= 200000000;

-- Show the name and population in millions for the countries of the
-- continent 'South America'.
SELECT  name
       ,population/1000000 AS population
FROM world
WHERE continent = 'South America';

-- Show the name and population for France, Germany, Italy.
SELECT  name
       ,population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- Show the countries which have a name that includes the word 'United'.
SELECT  name
FROM world
WHERE name LIKE '%United%';

-- Two ways to be big: A country is big if
-- it has an area of more than 3 million sq km or
-- it has a population of more than 250 million.
-- Show the countries that are big by area or big by population.
-- Show name, population and area.
SELECT  name
       ,population
       ,area
FROM world
WHERE area > 3000000 OR population > 250000000;

-- Show the countries that are big by area (more than 3 million) or
-- big by population (more than 250 million) but not both.
-- Show name, population and area.
SELECT  name
       ,population
       ,area
FROM world
WHERE (area > 3000000 AND population <= 250000000)
OR (area <= 3000000 AND population > 250000000);

-- For each country on continent South America show population in millions and
-- GDP in billions both to 2 decimal places.
SELECT  name
       ,ROUND(population/1000000,2) AS population
       ,ROUND(gdp/1000000000,2)     AS GDP
FROM world
WHERE continent = 'South America';

-- Show per-capita GDP for the trillion (1000000000000; that is 12 zeros)
-- dollar countries to the nearest $1000.
SELECT  name
       ,ROUND(gdp/population,-3) AS 'per capita GDP'
FROM world
WHERE gdp >= 1000000000000;

-- Show the name and capital where the name and the capital have
-- the same number of characters.
SELECT  name
       ,capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);

-- Show the name and the capital where the first letters of each match.
-- Don't include countries where the name and the capital are the same word.
SELECT  name
       ,capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
AND name <> capital;

-- Find the country that has all the vowels and no spaces in its name.
SELECT  name
FROM world
WHERE name LIKE '%a%'
AND name LIKE '%o%'
AND name LIKE '%i%'
AND name LIKE '%u%'
AND name LIKE '%e%'
AND name NOT LIKE '% %';
