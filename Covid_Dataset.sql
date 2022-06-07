SELECT *
FROM CovidDeaths$;

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 AS deathPercentage
FROM CovidDeaths$;

--Countries with Highest covidcases
SELECT continent, location, population, MAX(total_cases) AS Maximum_Case, MAX((total_cases/population)) AS Percentinfected
FROM CovidDeaths$
WHERE location != 'world' AND location != continent
GROUP BY continent,location, population
ORDER BY Percentinfected DESC;

--Countries with highest death count
SELECT location, population, MAX(CAST(Total_deaths AS INT)) AS MaxDeath_Count
FROM CovidDeaths$
WHERE location != 'world' AND location != continent
GROUP BY location, population
ORDER BY MaxDeath_Count DESC;

--Continents with Highest Death count
SELECT continent,MAX(CAST(total_deaths AS INT)) AS MaxDeath_Continent
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY MaxDeath_Continent DESC;

--Global New_Deaths Percentage
SELECT SUM(new_cases) AS total_Newcases, SUM(CAST(new_deaths AS INT)) AS total_Newdeaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS total_NewDeathPercent
FROM CovidDeaths$
WHERE continent IS NOT NULL --AND new_cases IS NOT NULL AND new_deaths IS NOT NULL
--GROUP BY date
ORDER BY total_Newdeaths DESC;


--Covid Death Percentage in United States
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 AS deathPercentage
FROM CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2;

--Covid Population Percentage in United States
SELECT location, date, total_cases, total_deaths, population, (total_cases/population) * 100 AS Covidtest_Percent
FROM CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2;

--Death percentage in Nigeria
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 AS deathPercentage
FROM CovidDeaths$
WHERE location LIKE 'Nig__ia%'
ORDER BY 1,2;

--Covidtest Percentage in Nigeria
SELECT location, date, total_cases, total_deaths, population, (total_cases/population) * 100 AS Covidtest_percent
FROM CovidDeaths$
WHERE location LIKE 'Nig__ia%'
ORDER BY 1,2;

--Death Percentage in Africa
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 AS deathPercentage
FROM CovidDeaths$
WHERE location LIKE 'afr%'
ORDER BY 1,2;

--Covid Test Population Percentage in Africa
SELECT location, date, total_cases, new_cases, total_deaths, population, (total_cases/population) * 100 AS Covidtest_percent
FROM CovidDeaths$
WHERE location = 'Africa';

--Joining Tables
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations))  OVER (PARTITION BY death.location ORDER BY death.location,death.date)  AS people_vaccinated
FROM CovidDeaths$ death
JOIN 
CovidVaccination$ vac
ON death.location = vac.location AND death.date = vac.date
WHERE death.continent IS NOT NULL
ORDER BY 2, 3;




--TABLE
DROP TABLE IF EXISTS Vaccinated_Percent;
CREATE TABLE Vaccinated_Percent(
continent VARCHAR(200),
location VARCHAR(200),
date DATETIME,
population INT,
new_vaccinations INT,
people_vaccinated FLOAT
);

INSERT INTO Vaccinated_Percent

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations))  OVER (PARTITION BY death.location ORDER BY death.location,death.date)  AS people_vaccinated
FROM CovidDeaths$ death
JOIN 
CovidVaccination$ vac
ON death.location = vac.location AND death.date = vac.date
WHERE death.continent IS NOT NULL

SELECT *, (people_vaccinated/population) * 100
FROM Vaccinated_Percent;

--VIEW FOR VISUALIZATION
CREATE VIEW Vacinnated_Percent as
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations))  OVER (PARTITION BY death.location ORDER BY death.location,death.date)  AS people_vaccinated
FROM CovidDeaths$ death
JOIN 
CovidVaccination$ vac
ON death.location = vac.location AND death.date = vac.date
WHERE death.continent IS NOT NULL

SELECT *
FROM Vaccinated_Percent
