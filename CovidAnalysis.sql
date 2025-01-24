#Using the covid analysis database

use CovidAnalysis; 

select * from CovidDeaths;

#creating a temp_date column to change the datatype of the 'date column' to date

ALTER TABLE CovidDeaths ADD COLUMN temp_date DATE;
UPDATE CovidDeaths
SET temp_date = STR_TO_DATE(CAST(date AS CHAR), '%m/%d/%y');

#dropping the date column

alter table CovidDeaths
drop column date;

#Renaming the temp_date column to date

alter table CovidDeaths
change temp_date date DATE;

/*ANALYSIS BY LOCATION*/

#Selecting the columns of interest from the CovidDeaths table and sorting by the first 2 columns

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by location, date; 

#Analysing the Death Percentage per day in United States
#Shows United States had the most % deaths (10.91%) on 2020-03-02  

select location, date, round((total_deaths/total_cases * 100),2)  as PercentageofDeath
from CovidDeaths
where location = 'United States' and continent is not null
order by PercentageofDeath desc;

#Analysing the percentage of population that got Covid in the US

select location, date, (total_cases/Population) * 100 as PercentageAffected
from CovidDeaths
where location = 'United States' and continent is not null
order by PercentageAffected desc;

#Analysing the top 10 countries with highest infection rates compared to the total population

select location, Population, max(total_cases) as HighestCount, max((total_cases/Population)*100) as PercentagePopulationInfected
from CovidDeaths
where continent is not null
group by location, Population
order by PercentagePopulationInfected desc
limit 10;

#Countries with highest death count per population 
#United States has the highest death count

select location, max(total_deaths) as DeathCount
from CovidDeaths
where continent is not null
group by location 
order by DeathCount desc;

/*Analysis by Continent*/

#Continents with highest death count

select continent, max(total_deaths) as ContinentDeathCount
from CovidDeaths
where continent is not null
group by continent
order by ContinentDeathCount desc;

/*Global Analysis*/

#For CovidVaccine Table- creating a temp_date column to change the datatype of the 'date column' to date

ALTER TABLE CovidVaccine ADD COLUMN temp_date DATE;
UPDATE CovidVaccine
SET temp_date = STR_TO_DATE(CAST(date AS CHAR), '%m/%d/%y');

#dropping the date column

alter table CovidVaccine
drop column date;

#Renaming the temp_date column to date

alter table CovidVaccine
change temp_date date DATE;


#Exploring the Covid Vaccinations table and joining the two tables together

##Data of Total vaccinations compared to total population per location per day

SELECT 
    D.continent,
    D.location,
    D.date,
    D.population,
    V.new_vaccinations
FROM
    CovidDeaths D
    INNER JOIN CovidVaccine V ON D.location = V.location
    AND D.date = V.date
WHERE 
    D.continent IS NOT NULL
ORDER BY 
    D.continent, D.location, D.date;


#Cumulative Vaccination (Rolling Sum) per Location 

select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as Signed)) over (partition by D.location order by D.date) as RollingVaccinations
from CovidDeaths D
inner join CovidVaccine V
on D.date = V.date
and D.location = V.location
where D.continent is not null
order by D.location, D.date;

#Using Common Table Expressions(CTE) to calculate the percentage of Rolling Vaccinations vs Total Population

WITH CumulativeVacPop AS (
    SELECT 
        D.continent, 
        D.location, 
        D.date, 
        D.Population, 
        V.new_vaccinations,
        SUM(CAST(V.new_vaccinations AS SIGNED)) OVER (PARTITION BY D.location ORDER BY D.date) AS RollingVaccinations
    FROM 
        CovidDeaths D
    INNER JOIN 
        CovidVaccine V
    ON D.date = V.date
    AND D.location = V.location
    WHERE 
        D.continent IS NOT NULL
)
SELECT 
    continent, 
    location, 
    date, 
    Population, 
    RollingVaccinations, 
    (RollingVaccinations / Population) * 100 AS VaccinationPercentage
FROM 
    CumulativeVacPop;
    
#Using Temporary Table to perform the Vaccination percentage calculation

CREATE TABLE CumulativeVaccination (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rollingVAC NUMERIC
);

#inserting data into the table

insert into CumulativeVaccination
select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(cast(V.new_vaccinations as Signed)) over (partition by D.location order by D.date) as RollingVaccinations
from CovidDeaths D
inner join CovidVaccine V
on D.date = V.date
and D.location = V.location;

#Checking if the insertion is complete

select * from CumulativeVaccination;

#Creating View for Storing Data

create view RollingVac as 

(SELECT 
        D.continent, 
        D.location, 
        D.date, 
        D.Population, 
        V.new_vaccinations,
        SUM(CAST(V.new_vaccinations AS SIGNED)) OVER (PARTITION BY D.location ORDER BY D.date) AS RollingVaccinations
    FROM 
        CovidDeaths D
    INNER JOIN 
        CovidVaccine V
    ON D.date = V.date
    AND D.location = V.location
    WHERE 
        D.continent IS NOT NULL);

select * from RollingVac;

