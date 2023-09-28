--1. Introducing the covid table

SELECT name, DAY(whn),
confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 2. Introducing the LAG function
-- Modify the query to show confirmed for the day before.

SELECT name, DAY(whn), confirmed,
LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 3. Number of new cases
-- Show the number of new cases for each day, for Italy, for March.

SELECT name, DAY(whn), 
(confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS new
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 4. Weekly changes
-- Show the number of new cases in Italy for each week in 2020 - show Monday only.

SELECT name, DATE_FORMAT(whn,'%Y-%m-%d'), 
(confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS new
FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020
ORDER BY whn;

-- 5. LAG using a JOIN
-- Show the number of new cases in Italy for each week - show Monday only.

SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), 
(tw.confirmed - lw.confirmed) AS new
FROM covid tw LEFT JOIN covid lw ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
AND tw.name = lw.name
WHERE tw.name = 'Italy'
AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

-- 6. RANK()
-- Add a column to show the ranking for the number of deaths due to COVID.

SELECT name,
confirmed,
RANK() OVER (ORDER BY confirmed DESC) AS rc,
deaths,
RANK() OVER (ORDER BY deaths DESC) AS rd
FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC

-- 7. Infection rate
-- Show the infection rate ranking for each country. Only include countries with a population of at least 10 million.

SELECT world.name,
ROUND(100000*confirmed/population,2) AS cases_per_100k,
RANK() OVER (ORDER BY (100000*confirmed/population)) AS rank
FROM covid JOIN world ON covid.name=world.name
WHERE covid.whn = '2020-04-20' 
AND world.population > 10000000
ORDER BY population DESC;

-- 8. Turning the corner
-- For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.

SELECT name, date, peakNewCases
FROM
(    
    SELECT name, date, peakNewCases,
    RANK() OVER (PARTITION BY name ORDER BY peakNewCases DESC) AS rank
    FROM
    (
        SELECT name, DATE_FORMAT(whn, '%Y-%m-%d') AS date, 
        confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY 
        whn) 
        AS peakNewCases
        FROM covid
    ) TAB
    WHERE peakNewCases >= 1000
) TAB
WHERE rank = 1 ORDER BY date;



