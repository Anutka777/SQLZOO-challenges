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

-- Show the total population of the world.
SELECT  SUM(population)
FROM world;

-- List all the continents - just once each.
SELECT  DISTINCT(continent)
FROM world;

-- Give the total GDP of Africa
SELECT  SUM(gdp)
FROM world
WHERE continent = 'Africa';
