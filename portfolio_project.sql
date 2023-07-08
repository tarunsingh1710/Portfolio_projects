USE COVID;
SELECT * FROM covid_vaccinations;
SELECT * FROM covid_Death;

-- Selecting Data to be Used for This Project --
Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
FROM COVID_Death
Order by 1,2;

-- Estiamting Deaths occured with comparison to cases identified in Canada --
Select Location, Date, Total_Cases,  Total_Deaths, (Total_Deaths/Total_Cases)*100 AS DeathPercentage
FROM COVID_DEATH
WHERE LOCATION= 'Canada'
Order by 1,2;

-- Calculating the % of people getting Covid from the entire Population --
Select Location, Date, Total_Cases,  Population, (Total_Cases/Population )*100 AS Infectionpercentage
FROM COVID_DEATH
-- WHERE LOCATION= 'Canada'
Order by 1,2;

-- Looking at countries with Highest Infection Rate in the world --
Select Location, MAX( Total_Cases),  Population, MAX((Total_Cases/Population ))*100 AS MAX_Infectionpercentage
FROM COVID_DEATH
-- WHERE LOCATION= 'Canada'
GROUP BY Location, Population
Order by MAX_Infectionpercentage DESC;

-- Looking at countries with Highest Death Rate in the world --
Select Location, MAX( Total_Cases) AS TOTAL_DEATHS,  Population, MAX((Total_Deaths /Population ))*100 AS MAX_Deathpercentage
FROM COVID_DEATH
-- WHERE LOCATION= 'Canada'
WHERE continent is not null
GROUP BY Location, Population
Order by TOTAL_DEATHS DESC;

-- Looking at continents with Highest Death Rate in the world --
Select Continent, MAX( Total_Cases) AS TOTAL_DEATHS
FROM COVID_DEATH
WHERE continent is not null
GROUP BY Continent
Order by TOTAL_DEATHS DESC;

-- Looking at Global Numbers for cases and deaths at different points of time
Select Date, Sum(Total_Cases) as Total_cases_in_World, Sum(Total_Deaths) as Total_Deaths_In_World , SUM(total_deaths)/ sum(total_cases) *100 AS World_death_percentage
From covid_death
Where continent is not null
 Group by date
Order by 1,2;

Select location, Sum(Total_Cases) as Total_cases, Sum(Total_Deaths) as Total_Deaths , SUM(total_deaths)/ sum(total_cases) *100 AS Location_death_percentage
From covid_death
Where continent is not null
 Group by location
Order by 1,2;

Select Sum(Total_Cases) as Total_cases, Sum(Total_Deaths) as Total_Deaths , SUM(total_deaths)/ sum(total_cases) *100 AS World_death_percentage
From covid_death
Order by 1,2;

-- Looking at the stats for total population vs vaccinations done

Select Death.continent, death.location, death.Date , Death.population
From Covid_Death Death 
JOIN covid_vaccinations vacc 
ON Death.location = vacc.Location
Order by 1,2,3; 

-- Estimating percentage of vacciantion done on the entire population vs infection percentage

Select Death.continent, death.location, death.Date , Death.population , (Death.Total_Cases/Death.Population )*100 AS Infectionpercentage , (Vacc.total_vaccinations/Vacc.population)*100 AS vaccination_Percentage
From Covid_Death Death 
JOIN covid_vaccinations vacc 
ON Death.location = vacc.Location
Order by 1,2,3;  

-- Calculation Number of new vaccination on basis of date and Country

Select Death.continent, death.location, death.Date , Death.population , vacc.new_vaccinations, Sum(vacc.new_vaccinations) Over (partition by Death.LOCATION order by Death.location) as people_vaccinated_cumilative
From Covid_Death Death 
JOIN covid_vaccinations vacc 
ON Death.location = vacc.Location
Order by 1,2,3;  

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, people_vaccinated_cumilative)
as
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as people_vaccinated_cumilative,
 (people_vaccinated_cumilative/population)*100
From Covid_Death Death 
JOIN covid_vaccinations vacc 
ON Death.location = vacc.Location
where dea.continent is not null 

)
Select *, (people_vaccinated_cumilative/Population)*100
From PopvsVac;



-- Creating View for visuals

Create View people_vaccinated_cumilative AS
Select Death.continent, death.location, death.Date , Death.population ,  (Vacc.total_vaccinations/Vacc.population)*100 AS vaccination_Percentage
From Covid_Death Death 
JOIN covid_vaccinations vacc 
ON Death.location = vacc.Location;

