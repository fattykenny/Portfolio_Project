
--Global New_Deaths Percentage
SELECT SUM(new_cases) AS total_Newcases, SUM(CAST(new_deaths AS INT)) AS total_Newdeaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS total_NewDeathPercent
FROM CovidDeaths$
WHERE continent IS NOT NULL --AND new_cases IS NOT NULL AND new_deaths IS NOT NULL
ORDER BY 1,2;

              --2
--CONTINENT TOTAL_NEWDEATHS
SELECT location, SUM(CONVERT(INT, new_deaths)) AS total_NewDeaths
FROM CovidDeaths$
WHERE continent IS NULL AND location NOT IN ('world', 'European Union', 'International')
GROUP BY location
ORDER BY total_NewDeaths DESC;

               --3
--Percentage of Infected Population
SELECT location, population, MAX(total_cases) AS max_totalcases, (MAX(total_cases))/population *100 AS Percent_InfectedPop
FROM CovidDeaths$
GROUP BY location, population
ORDER BY Percent_InfectedPop DESC;

				--4
--Percentage of Infected Population with respective dates
SELECT location, population,date, MAX(total_cases) AS max_totalcases, (MAX(total_cases))/population *100 AS Percent_InfectedPop
FROM CovidDeaths$
GROUP BY location, population, date
ORDER BY Percent_InfectedPop DESC;
