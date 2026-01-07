USE Covid;

CREATE TABLE covid_deaths (
    iso_code            VARCHAR(10),
    continent           VARCHAR(50),
    location            VARCHAR(100),
    date                DATE,
    population           DOUBLE,
    total_cases         DOUBLE,
    new_cases           DOUBLE,
    new_cases_smoothed  DOUBLE,
    total_deaths        DOUBLE,
    new_deaths          DOUBLE,
    new_deaths_smoothed DOUBLE,
    total_cases_per_million        DOUBLE,
    new_cases_per_million          DOUBLE,
    new_cases_smoothed_per_million DOUBLE,
    total_deaths_per_million        DOUBLE,
    new_deaths_per_million          DOUBLE,
    new_deaths_smoothed_per_million DOUBLE,
    reproduction_rate   DOUBLE,
    icu_patients        DOUBLE,
    icu_patients_per_million DOUBLE,
    hosp_patients       DOUBLE,
    hosp_patients_per_million DOUBLE,
    weekly_icu_admissions DOUBLE,
    weekly_icu_admissions_per_million DOUBLE,
    weekly_hosp_admissions DOUBLE,
    weekly_hosp_admissions_per_million DOUBLE
);

DROP TABLE IF EXISTS covid_vaccinations_staging;
CREATE TABLE covid_vaccinations (
  iso_code        VARCHAR(10),
  continent       VARCHAR(50),
  location        VARCHAR(100),
  date            DATE,
  new_tests                       DOUBLE,
  total_tests                     DOUBLE,
  total_tests_per_thousand        DOUBLE,
  new_tests_per_thousand          DOUBLE,
  new_tests_smoothed              DOUBLE,
  new_tests_smoothed_per_thousand DOUBLE,
  positive_rate                   DOUBLE,
  tests_per_case                  DOUBLE,
  tests_units                     VARCHAR(50),
  total_vaccinations              DOUBLE,
  people_vaccinated               DOUBLE,
  people_fully_vaccinated         DOUBLE,
  new_vaccinations                DOUBLE,
  new_vaccinations_smoothed       DOUBLE,
  total_vaccinations_per_hundred  DOUBLE,
  people_vaccinated_per_hundred   DOUBLE,
  people_fully_vaccinated_per_hundred DOUBLE,
  new_vaccinations_smoothed_per_million DOUBLE,
  stringency_index                DOUBLE,
  population_density              DOUBLE,
  median_age                      DOUBLE,
  aged_65_older                   DOUBLE,
  aged_70_older                   DOUBLE,
  gdp_per_capita                  DOUBLE,
  extreme_poverty                 DOUBLE,
  cardiovasc_death_rate           DOUBLE,
  diabetes_prevalence             DOUBLE,
  female_smokers                  DOUBLE,
  male_smokers                    DOUBLE,
  handwashing_facilities          DOUBLE,
  hospital_beds_per_thousand      DOUBLE,
  life_expectancy                 DOUBLE,
  human_development_index         DOUBLE
);

SELECT *
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

SELECT *
FROM covid_vaccinations
ORDER BY 3, 4;

-- Select the data that we are going to be using for our analysis.

SELECT location,
       date,
       total_cases,
       new_cases,
       total_deaths,
       population
FROM covid_deaths
ORDER BY 1, 2;

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract COVID-19 in your country
SELECT location, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at total cases vs population
-- shows what percentage of populaton got covid
SELECT location, date, population, total_cases, (total_cases / population)*100 as PerecentPopulationInfected
FROM covid_deaths
WHERE location like '%states%'
ORDER BY 1,2;


-- Looking at countries with highest infection rates compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases / population)) * 100 as PerecentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PerecentPopulationInfected DESC;


-- this is showing the countries with the highest death count per population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Let's break things down by continent
-- showing continents with the highest death count per population
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths) / SUM(new_cases) * 100) as DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2;


-- Looking at total population vs vaccinations
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- USE CTE

WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
    FROM covid_deaths dea
    JOIN covid_vaccinations vac
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/ Population)*100
FROM PopvsVac;

-- Temp table
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
    (
        continent varchar(255),
        location varchar(255),
        date date,
        population double,
        new_vaccinations double,
        RollingPeopleVaccinated double
);

INSERT into PercentPopulationVaccinated

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date;


SELECT *, (RollingPeopleVaccinated/ Population)*100
FROM PercentPopulationVaccinated;


-- creating view to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
    SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

CREATE VIEW DeathCountByContinent AS
    SELECT continent, MAX(total_deaths) AS TotalDeathCount
    FROM covid_deaths
    WHERE continent IS NOT NULL
    GROUP BY continent
    ORDER BY TotalDeathCount DESC;


CREATE VIEW DeathCountByCountry AS
    SELECT location, MAX(total_deaths) AS TotalDeathCount
    FROM covid_deaths
    WHERE continent IS NOT NULL
    GROUP BY location
    ORDER BY TotalDeathCount DESC;

CREATE VIEW MaxInfectedCountAndRateByCountry AS
    SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases / population)) * 100 as PerecentPopulationInfected
    FROM covid_deaths
    GROUP BY location, population
    ORDER BY PerecentPopulationInfected DESC;