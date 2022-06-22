SELECT 
	*
FROM 
	covid19project.covid_deaths
WHERE continent <> ''
ORDER BY 
	3,4;

/* SELECT 
	*
FROM 
	covid19project.covid_vaccinations
ORDER BY 
	3,4; */

-- Select Data that we are going to be using
SELECT
	location, date, total_cases, new_cases, total_deaths, population
FROM 
	covid19project.covid_deaths
ORDER BY 
	1,2;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in the United States
SELECT
	location, date, total_cases, total_deaths,
    (total_deaths/total_cases)*100 AS death_percentage
FROM 
	covid19project.covid_deaths
WHERE location like '%states%'
ORDER BY 
	1,2;
    
-- Looking at the total cases vs population
-- Shows what percentage of the population got covid
SELECT
	location, date, total_cases, population,
    (total_cases/population)*100 AS infection_percentage
FROM 
	covid19project.covid_deaths
WHERE location like '%states%'
ORDER BY 
	1,2;

-- BREAKING THINGS DOWN BY COUNTRY

-- Looking at Countries with Highest Infection Rate Compared to Population
SELECT
	location, MAX(total_cases) as highest_infection_count, population,
    (MAX(total_cases)/population)*100 AS pop_infection_percentage
FROM 
	covid19project.covid_deaths
WHERE 
	continent <> ''
GROUP BY
	location, population
ORDER BY 
	pop_infection_percentage DESC;
    
-- Showing Countries with Highest Death counts
SELECT
	location, MAX(total_deaths) AS total_death_count
FROM 
	covid19project.covid_deaths
WHERE 
	continent <> ''
GROUP BY
	location
ORDER BY 
	total_death_count DESC;
    
-- BREAKING THINGS DOWN BY CONTINENT

-- Showing death count by continent using location
SELECT
	location, MAX(total_deaths) as total_death_count
FROM 
	covid19project.covid_deaths
WHERE 
	location IN ('North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania')
GROUP BY
	location
ORDER BY 
	total_death_count DESC;
    
-- Using a subquery to get total death count based on continent by summing countries max death counts
SELECT 
	continent, SUM(total_death_count) AS continent_death_count
FROM
	(SELECT
		continent, location, MAX(total_deaths) AS total_death_count
	FROM 
		covid19project.covid_deaths
	WHERE 
		continent <> ''
	GROUP BY
		location
	ORDER BY 
		total_death_count DESC) AS country_death_counts
GROUP BY 
	continent
ORDER BY
	continent_death_count DESC;

-- Showing continents with the highest infection rate compared to population
SELECT
	location, MAX(total_cases) as highest_infection_count, population,
    (MAX(total_cases)/population)*100 AS pop_infection_percentage
FROM 
	covid19project.covid_deaths
WHERE 
	location IN ('North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania')
GROUP BY
	location, population
ORDER BY 
	pop_infection_percentage DESC;
    
-- GLOBAL NUMBERS

-- Showing global new cases and new deaths per day
SELECT
	date, 
    SUM(new_cases) AS global_new_cases,
	SUM(new_deaths) AS global_new_deaths
FROM 
	covid19project.covid_deaths
WHERE 
	continent <> ''
GROUP BY 
	date
ORDER BY 
	1,2;
   
-- Showing global total cases, total deaths, and death percentage since 2020-01-01
SELECT
    SUM(new_cases) AS global_cases,
	SUM(new_deaths) AS global_deaths,
    (SUM(new_deaths)/SUM(new_cases))*100 AS global_death_percentage
FROM 
	covid19project.covid_deaths
WHERE 
	continent <> '';

SELECT
	MAX(total_cases), 
    MAX(total_deaths),
    (MAX(total_deaths)/MAX(total_cases))*100 AS global_death_percentage
FROM
	covid19project.covid_deaths
WHERE
	location LIKE 'world';
    
-- Joining deaths and vaccinations tables
-- Looking at total population vs vaccinations
SELECT
	deaths.continent, deaths.location, deaths.date, deaths.population,
	vacs.new_vaccinations,
    SUM(vacs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccinations
FROM
	covid19project.covid_deaths AS deaths
    JOIN covid19project.covid_vaccinations AS vacs
		ON deaths.location = vacs.location
		AND deaths.date = vacs.date
WHERE
	deaths.continent <> '';
    
-- USE CTE
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
	AS
(
SELECT
	deaths.continent, deaths.location, deaths.date, deaths.population,
	vacs.new_vaccinations,
    SUM(vacs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccinations
FROM
	covid19project.covid_deaths AS deaths
    JOIN covid19project.covid_vaccinations AS vacs
		ON deaths.location = vacs.location
		AND deaths.date = vacs.date
WHERE
	deaths.continent <> '')
SELECT 
	*, (rolling_vaccinations/population)*100 AS pop_percent_vaccinated
FROM 
	pop_vs_vac;
 
-- USE TEMP TABLE
DROP TABLE IF exists percent_pop_vaccinated;
CREATE TABLE percent_pop_vaccinated (
	continent VARCHAR(255),
    location VARCHAR(255),
    date DATE,
    population INT,
    new_vaccinations INT,
    rolling_vaccinations DOUBLE
);

INSERT INTO percent_pop_vaccinated
SELECT
	deaths.continent, deaths.location, deaths.date, deaths.population,
	vacs.new_vaccinations,
    SUM(vacs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccinations
FROM
	covid19project.covid_deaths AS deaths
    JOIN covid19project.covid_vaccinations AS vacs
		ON deaths.location = vacs.location
		AND deaths.date = vacs.date
WHERE
	deaths.continent <> '';
    
SELECT 
	*, (rolling_vaccinations/population)*100 AS percent_vaccinated
FROM
	percent_pop_vaccinated;
    
-- Creating View to store data for later visualizations

CREATE VIEW 
	percent_population_vaccinated AS
SELECT
	deaths.continent, deaths.location, deaths.date, deaths.population,
	vacs.new_vaccinations,
    SUM(vacs.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccinations
FROM
	covid19project.covid_deaths AS deaths
    JOIN covid19project.covid_vaccinations AS vacs
		ON deaths.location = vacs.location
		AND deaths.date = vacs.date
WHERE
	deaths.continent <> '';