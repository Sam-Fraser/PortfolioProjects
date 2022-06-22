CREATE TABLE covid_deaths (
    iso_code VARCHAR(10),
    continent VARCHAR(20),
    location VARCHAR(100),
    date DATE,
    population INT,
    total_cases INT,
    new_cases INT,
    new_cases_smoothed DOUBLE,
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed DOUBLE,
    total_cases_per_million DOUBLE,
    new_cases_per_million DOUBLE,
    new_cases_smoothed_per_million DOUBLE,
    total_deaths_per_million DOUBLE,
    new_deaths_per_million DOUBLE,
    new_deaths_smoothed_per_million DOUBLE,
    reproduction_rate DOUBLE,
    icu_patients INT,
    icu_patients_per_million DOUBLE,
    hosp_patients INT,
    hosp_patients_per_million DOUBLE,
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million DOUBLE,
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million DOUBLE
    );

LOAD DATA LOCAL INFILE "D:/Data_Projects/Covid19_Case_Study/covid_deaths.csv"
	INTO TABLE covid_deaths
    FIELDS TERMINATED BY ','
		ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;
    
CREATE TABLE covid_vaccinations (
	iso_code VARCHAR(10),
    continent VARCHAR(20),
    location VARCHAR(100),
    date DATE,
    total_tests INT,
    new_tests INT,
    total_tests_per_thousand DOUBLE,
    new_tests_per_thousand DOUBLE,
    new_tests_smoothed INT,
    new_tests_smoothed_per_thousand DOUBLE,
    positive_rate DOUBLE,
    tests_per_case DOUBLE,
    tests_units VARCHAR(20),
    total_vaccinations INT,
    people_vaccinated INT,
    people_fully_vaccinated INT,
    total_boosters INT,
    new_vaccinations INT,
    new_vaccinations_smoothed INT,
    total_vaccinations_per_hundred DOUBLE,
    people_vaccinated_per_hundred DOUBLE,
    people_fully_vaccinated_per_hundred DOUBLE,
    total_boosters_per_hundred DOUBLE,
    new_vaccinations_smoothed_per_million INT,
    new_people_vaccinated_smoothed INT,
    new_people_vaccinated_smoothed_per_hundred DOUBLE,
    stringency_index DOUBLE,
    population_density DOUBLE,
    median_age DOUBLE,
    aged_65_older DOUBLE,
    aged_70_older DOUBLE,
    gdp_per_capita DOUBLE,
    extreme_poverty DOUBLE,
    cardiovasc_death_rate DOUBLE,
    diabetes_prevalence DOUBLE,
    female_smokers DOUBLE,
    male_smokers DOUBLE,
    handwashing_facilities DOUBLE,
    hospital_beds_per_thousand DOUBLE,
    life_expectancy DOUBLE,
    human_development_index DOUBLE,
    excess_mortality_cumulative_absolute DOUBLE,
    excess_mortality_cumulative DOUBLE,
    excess_mortality DOUBLE,
    excess_mortality_cumulative_per_million DOUBLE
);

LOAD DATA LOCAL INFILE "D:/Data_Projects/Covid19_Case_Study/covid_vaccinations.csv"
	INTO TABLE covid_vaccinations
    FIELDS TERMINATED BY ','
		ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;