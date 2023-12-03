

SELECT * 
FROM A_task.dbo.['owid-covid-data$']
Order by 3,4 

SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
--Where continent in not null
Order by 1,2 



--SELECT * 
--FROM PortfolioProject.dbo.CovidVaccination
--Order by 3,4 

SELECT Location, date, total_cases, new_cases, total_deaths, population_density
FROM PortfolioProject.dbo.CovidDeaths
Order by 1,2

--Total cases Vs Total deaths

SELECT Location, date, total_cases, new_deaths_smoothed, (population_density/total_cases) as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
Order by 1,2

--Total Cases Vs Population
SELECT Location, date, total_cases, population_density, (total_cases/population_density)*100 as PopulationPercentage
FROM PortfolioProject.dbo.CovidDeaths
Where location like '%Afghanistan%'
Order by 1,2

--Countries with highest rate of infection with the population 

SELECT Location,  population_density, MAX(total_cases) as highestinfection, MAX((total_cases/population_density))*100 as PopulationPercentage
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%Afghanistan%'
Group by Location,  population_density
Order by PopulationPercentage desc 

--Countries with highest death

SELECT Location, MAX(total_cases) as highestDeath
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%Afghanistan%'
Group by Location
Order by highestDeath desc 

SELECT continent, MAX(total_cases) as highestDeath
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%Afghanistan%'
Group by continent
Order by highestDeath desc 

--Global Numbers

SELECT  SUM(new_cases) as Totalcases, SUM(new_deaths) as Totaldeaths, (SUM(new_deaths)/SUM(new_cases))*100 as PercentageDeaths
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not NULL
--Group by date
Order by 1,2

Select *
from PortfolioProject..CovidVacc

--Total Population Vs Vaccination 
Select dea.continent, dea.location, dea.date, dea.population_density,  vac.new_vaccinations, 
SUM(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
From PortfolioProject..CovidDeaths  dea
Join PortfolioProject..CovidVacc  Vac
  ON Dea.Location = Vac.location
  and Dea.date = Vac.date
  Where dea.continent is not NULL
Order by 2,3

 --CTE

 With PopvsVac (Continent, location, date, Population, new_vaccination,  Peoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density,  vac.new_vaccinations,
 SUM(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
 From PortfolioProject..CovidDeaths  dea
 Join PortfolioProject..CovidVacc  Vac
  ON Dea.Location = Vac.location
  and Dea.date = Vac.date
  Where dea.continent is not NULL
-- Order by 2,3
 )

 Select *, (Peoplevaccinated/Population)*100
 from PopvsVac

 select * 
 from PortfolioProject..CovidVacc

 --TEMP TABLE
 Drop Table if exists #PrecentageVaccinated
 Create table #PrecentageVaccinated
 (
 Continent nvarchar (255),
 Location nvarchar (255),
 date datetime,
 Population numeric, 
 new_vaccination numeric,
 Peoplevaccinated numeric
 )
 insert into #PrecentageVaccinated
 Select dea.continent, dea.location, dea.date, dea.population_density,  vac.new_vaccinations,
 SUM(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
 From PortfolioProject..CovidDeaths  dea
 Join PortfolioProject..CovidVacc  Vac
  ON Dea.Location = Vac.location
  and Dea.date = Vac.date
 --Where dea.continent is not NULL
-- Order by 2,3

 Select *
 from #PrecentageVaccinated

 --creating view for later visualization 

Create view PrecentageVaccinated as
  Select dea.continent, dea.location, dea.date, dea.population_density,  vac.new_vaccinations,
 SUM(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
 From PortfolioProject..CovidDeaths  dea
 Join PortfolioProject..CovidVacc  Vac
  ON Dea.Location = Vac.location
  and Dea.date = Vac.date
 Where dea.continent is not NULL
-- Order by 2,3

Select * 
From PrecentageVaccinated


