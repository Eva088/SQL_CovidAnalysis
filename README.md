# COVID-19 Data Analysis

This code provides an in-depth analysis of COVID-19 data using two primary datasets: `CovidDeaths` and `CovidVaccine`. The analysis is performed on a per-location, per-continent, and global level to provide insights into death rates, vaccination rates, and the overall impact of COVID-19. Below are the key steps and operations performed:

## **Data Preprocessing**
- Conversion of the `date` column in both `CovidDeaths` and `CovidVaccine` tables to the `DATE` data type using temporary columns and string manipulation.
- Dropping the original `date` column and renaming the new `temp_date` column to `date`.

## **Analysis by Location**
- Calculation of total cases, new cases, total deaths, and population for each location.
- Death percentage analysis for the United States, identifying the day with the highest percentage of deaths.
- Percentage of the population affected by COVID-19 in the U.S. on a per-day basis.
- Identification of the top 10 countries with the highest infection rates relative to their population.
- Determination of countries with the highest death count per population.

## **Analysis by Continent**
- Calculation of the continents with the highest death count from COVID-19.

## **Global Analysis**
- Merging the `CovidDeaths` and `CovidVaccine` tables to analyze vaccination data alongside COVID-19 cases and deaths.
- Rolling sum of vaccinations per location, calculated as a cumulative total over time.
- Calculation of the percentage of the population vaccinated using a Common Table Expression (CTE) to handle the cumulative data.
- Creation of a temporary table (`CumulativeVaccination`) to store vaccination data and calculate vaccination percentages.
- A view (`RollingVac`) is created to persist the rolling vaccination data and support future queries.

## **Technical Details**
- Use of SQL window functions (`SUM(...) OVER(...)`) to compute rolling sums.
- Application of aggregate functions like `MAX` and `SUM` to analyze total cases, deaths, and vaccinations.
- Dynamic data filtering to exclude rows where `continent` is `NULL`.

This script is ideal for conducting time-based and geographical analyses on COVID-19 data, providing both daily and cumulative insights. It demonstrates data manipulation using SQL, particularly for large datasets that require complex aggregation and transformation.
