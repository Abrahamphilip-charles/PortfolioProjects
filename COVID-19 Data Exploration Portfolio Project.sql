select * from portfoliotest..CovidDeaths order by 3,4

--select * from portfoliotest..[Covid vacination] order by 3,4

select location, date, total_cases , new_cases, total_deaths, population 
from portfoliotest..CovidDeaths order by 1,2

--total cases vs total deaths

select location, date, total_cases , new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfoliotest..CovidDeaths order by 1,2

-- on a particular location
--shows likelyhood of increasing in your country
select location, date, total_cases , new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfoliotest..CovidDeaths where location like '%united kingdom%' order by 1,2

--total cases vs population
-- Shows the percentage of population got covid
select location, date, total_cases , new_cases, population,
(total_cases/population)*100 as Percentage
from portfoliotest..CovidDeaths where location like 
'%united kingdom%' order by 1,2

--countries with highest infection rate compared with population

select location, population, max(total_cases) as highestinfectioncount , 
max((total_cases/population))*100 as percentagepopulationinfected
from portfoliotest..CovidDeaths
--where location like '%unitedkingdom%'
group by location, population
order by percentagepopulationinfected desc


-- Showing countries with highest death count per population


select location, max(cast(total_deaths as int))as totaldeathcount 
from portfoliotest..CovidDeaths
--where location like '%unitedkingdom%'
group by location
order by totaldeathcount desc
 

 select location, max(cast(total_deaths as int))as totaldeathcount 
from portfoliotest..CovidDeaths
--where location like '%unitedkingdom%'
where continent is not null
group by location
order by totaldeathcount desc
 
 --continent with highest death count

  select location, max(cast(total_deaths as int))as totaldeathcount 
from portfoliotest..CovidDeaths
--where location like '%unitedkingdom%'
where continent is  null
group by location
order by totaldeathcount desc


--global numbers

select date , sum (new_cases) as total_cases, sum (cast(new_deaths as int))as total_deaths,
sum (cast(new_deaths as int))/sum (new_cases)*100
as deathpercentage from portfoliotest..CovidDeaths
where continent is not null
group by date
order by 1,2

--total deaths across the world

select   sum (new_cases) as total_cases, sum (cast(new_deaths as int))as total_deaths,
sum (cast(new_deaths as int))/sum (new_cases)*100
as deathpercentage from portfoliotest..CovidDeaths
where continent is not null
--group by date
order by 1,2

-- looking at total population vs vacinations


select dea.continent,dea.location,dea.date, dea.population ,
vac.new_vaccinations ,sum (cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as rolllingpeoplevaccinated
--,(rolllingpeoplevaccinated/population)*100
from portfoliotest..Covidvacination vac join portfoliotest..CovidDeaths dea 
on dea.location=vac.location 
and dea.date=vac .date
where dea.continent is not null 
order by 2,3


--using cte

with popsvac (continent , location , date , population, new_vaccinations , rollingpeoplevaccinated)as
(
select dea.continent,dea.location,dea.date, dea.population ,
vac.new_vaccinations ,sum (cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as rolllingpeoplevaccinated
--,(rolllingpeoplevaccinated/population)*100
from portfoliotest..Covidvacination vac join portfoliotest..CovidDeaths dea 
on dea.location=vac.location 
and dea.date=vac .date
where dea.continent is not null 
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100 from popsvac


-- temp table

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255), location nvarchar(255),
date datetime, population numeric, new_vaccinations numeric,rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date, dea.population ,
vac.new_vaccinations ,sum (cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as rolllingpeoplevaccinated
--,(rolllingpeoplevaccinated/population)*100
from portfoliotest..Covidvacination vac join portfoliotest..CovidDeaths dea 
on dea.location=vac.location 
and dea.date=vac .date
--where dea.continent is not null 
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100 from #percentpopulationvaccinated




-- creating view to store data fot later visualization

create view percentpopulationvaccinated as 
select dea.continent,dea.location,dea.date, dea.population ,
vac.new_vaccinations ,sum (cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as rolllingpeoplevaccinated
--,(rolllingpeoplevaccinated/population)*100
from portfoliotest..Covidvacination vac join portfoliotest..CovidDeaths dea 
on dea.location=vac.location 
and dea.date=vac .date
where dea.continent is not null 
--order by 2,3


select * from percentpopulationvaccinated

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like "%states%'
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location order by TotalDeathCount desc