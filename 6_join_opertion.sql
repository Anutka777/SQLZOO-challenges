-- Exersice and tables reference: https://sqlzoo.net/wiki/The_JOIN_operation

-- Show the matchid and player name for all goals scored by Germany.
-- To identify German players, check for: teamid = 'GER'.
SELECT  matchid
       ,player
FROM goal
WHERE teamid = 'GER';

-- Show id, stadium, team1, team2 for just game 1012.
SELECT  id
       ,stadium
       ,team1
       ,team2
FROM game
WHERE id = 1012;

-- Show the player, teamid, stadium and mdate for every German goal.
SELECT  player
       ,teamid
       ,stadium
       ,mdate
FROM goal
JOIN game
ON (matchid = game.id)
WHERE teamid = 'GER';

-- Show the team1, team2 and player for every goal scored by a player
-- called Mario.
SELECT  team1
       ,team2
       ,player
FROM game
JOIN goal
ON (game.id = matchid)
WHERE player LIKE 'Mario%';

-- Show player, teamid, coach, gtime for all goals scored in the first 10
-- minutes gtime<=10.
SELECT  player
       ,teamid
       ,coach
       ,gtime
FROM goal
JOIN eteam
ON (teamid = eteam.id)
WHERE gtime <= 10;

-- List the dates of the matches and the name of the team in which
-- 'Fernando Santos' was the team1 coach.
SELECT  mdate
       ,teamname
FROM game
JOIN eteam
ON (team1 = eteam.id)
WHERE coach = 'Fernando Santos';

-- List the player for every goal scored in a game where the stadium was
-- 'National Stadium, Warsaw'.
SELECT  player
FROM goal
JOIN game
ON (matchid = game.id)
WHERE stadium = 'National Stadium, Warsaw';

-- Show the name of all players who scored a goal against Germany.
SELECT  DISTINCT player
FROM game
JOIN goal
ON matchid = game.id
WHERE (team1 = 'GER' OR team2 = 'GER')
AND teamid <> 'GER';

-- Show teamname and the total number of goals scored.
SELECT  teamname
       ,COUNT(*) AS 'goals scored'
FROM eteam
JOIN goal
ON eteam.id = teamid
GROUP BY  teamname
ORDER BY teamname;

-- Show the stadium and the number of goals scored in each stadium.
SELECT  stadium
       ,COUNT(*) AS 'goals scored'
FROM game
JOIN goal
ON (game.id = matchid)
GROUP BY  stadium;

-- For every match involving 'POL', show the matchid, date and the number of
-- goals scored.
SELECT  matchid
       ,mdate
       ,COUNT(*) AS 'goals scored'
FROM game
JOIN goal
ON (matchid = id)
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY  matchid
         ,mdate;

-- For every match where 'GER' scored, show matchid, match date and the number
-- of goals scored by 'GER'.
SELECT  matchid
       ,mdate
       ,COUNT(*) AS 'goals scored by Germany'
FROM goal
JOIN game
ON (matchid = game.id)
WHERE teamid = 'GER'
GROUP BY  matchid
         ,mdate;

-- List every match with the goals scored by each team as shown:
-- | mdate        | team1 | score1 | team2 | score2 |
-- | 1 July 2012  | ESP   | 4      | ITA   | 0      |
-- | 10 June 2012 | ESP   | 1      | ITA   | 1      |
-- | 10 June 2012 | IRL   | 1      | CRO   | 3      |
--                          ...
-- Sort your result by mdate, matchid, team1 and team2.
SELECT  mdate
       ,team1
       ,SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1
       ,team2
       ,SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT JOIN goal -- Using LEFT, otherwise matches without goals will not be shown.
ON matchid = id
GROUP BY  mdate
         ,team1
         ,team2
ORDER BY mdate
         ,matchid
         ,team1
         ,team2;
