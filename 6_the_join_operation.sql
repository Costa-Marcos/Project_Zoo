-- 1. 
-- Show the matchid and player name for all goals scored by Germany.

SELECT matchid, player FROM goal WHERE teamid = 'GER';

-- 2.
-- Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2 FROM game WHERE id = 1012;

-- 3.
-- Show the player, teamid, stadium and mdate for every German goal.

SELECT goal.player, goal.teamid, game.stadium, game.mdate
FROM game JOIN goal ON (game.id = goal.matchid) 
WHERE goal.teamid = 'GER';

-- 4.
-- Show the team1, team2 and player for every goal scored by a player called Mario.

SELECT game.team1, game.team2, goal.player 
FROM goal JOIN game ON (game.id = goal.matchid) 
WHERE goal.player LIKE 'Mario%';

-- 5.
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes.

SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal JOIN eteam ON (goal.teamid = eteam.id)
WHERE gtime <= 10;

-- 6.
-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT game.mdate, eteam.teamname 
FROM game JOIN eteam ON (game.team1 = eteam.id) 
WHERE eteam.coach = 'Fernando Santos';

-- 7.
-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT goal.player 
FROM goal JOIN game ON (game.id = goal.matchid) 
WHERE game.stadium = 'National Stadium, Warsaw';

-- 8.
-- show the name of all players who scored a goal against Germany.

SELECT DISTINCT(goal.player)
FROM game JOIN goal ON goal.matchid = game.id 
WHERE (game.team1='GER' OR game.team2='GER') 
AND (goal.teamid <> 'GER') 
ORDER BY goal.player;

-- 9.
-- Show teamname and the total number of goals scored.

SELECT eteam.teamname, COUNT(goal.player) AS number_of_goals
FROM eteam JOIN goal ON eteam.id = goal.teamid
GROUP BY eteam.teamname ORDER BY eteam.teamname;

-- 10.
-- Show the stadium and the number of goals scored in each stadium.

SELECT game.stadium, COUNT(*) AS goals_scored 
FROM game JOIN goal ON game.id = goal.matchid 
GROUP BY game.stadium;

-- 11.
-- For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT goal.matchid, game.mdate, COUNT(*)
FROM game JOIN goal ON goal.matchid = game.id 
WHERE (team1 = 'POL' OR team2 = 'POL') 
GROUP BY goal.matchid, game.mdate;

-- 12.
-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.

SELECT goal.matchid, game.mdate, COUNT(goal.matchid) 
FROM goal JOIN game ON (goal.matchid = game.id) 
WHERE (game.team1 = 'GER' OR game.team2 = 'GER') 
AND (goal.teamid = 'GER') 
GROUP BY goal.matchid, game.mdate;

-- 13.
-- List every match with the goals scored by each team as shown.
--     mdate    | team1	|score1	| team2	| score2
-- 1 July 2012  |  ESP	|    4	|  ITA  |   0
-- 10 June 2012 |  ESP	|    1	|  ITA  |   1
-- 10 June 2012 |  IRL	|    1	|  CRO  |   3
-- ...
-- Sort your result by mdate, matchid, team1 and team2.

SELECT game.mdate, game.team1,
SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) AS score1,
game.team2,
SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal ON goal.matchid = game.id 
GROUP BY game.mdate, game.team1, game.team2, goal.matchid 
ORDER BY game.mdate, goal.matchid, game.team1, game.team2;

