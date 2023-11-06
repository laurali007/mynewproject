/* Create a View called “forestation” */ 

DROP VIEW IF EXISTS forestation;

CREATE VIEW forestation AS
SELECT 
    t1.country_name,
    t1.year,
    t3.region,
    t3.income_group,
    t1.forest_area_sqkm,
    t2.total_area_sq_mi,
    t2.total_area_sq_mi*2.59 AS total_area_sqkm,
    (SUM(t1.forest_area_sqkm)/(SUM(t2.total_area_sq_mi)*2.59))*100 AS forest_area_pct
FROM forest_area t1
JOIN land_area t2 ON t1.country_code = t2.country_code AND t1.year = t2.year
JOIN regions t3 ON t3.country_code = t1.country_code
GROUP BY 
    t1.country_name,
    t1.year,
    t3.region,
    t3.income_group,
    t1.forest_area_sqkm,
    t2.total_area_sq_mi,
    t2.total_area_sq_mi*2.59;

/* PART 1: GLOBAL SITUATION 

     a. What was the total forest area (in sq km) of the world in 1990? 
    Please keep in mind that you can use the country record denoted as “World" in the region table.*/

SELECT SUM(forest_area_sqkm) AS total_forest_area
FROM forestation 
WHERE year = 1990 AND country_name = 'World'; 

    /* ANSWER: 41282694.9 */ 

/* b. What was the total forest area (in sq km) of the world in 2016? 
    Please keep in mind that you can use the country record in the table is denoted as “World.” */

SELECT SUM(forest_area_sqkm) AS total_forest_area
FROM forestation 
WHERE year = 2016 AND country_name = 'World'; 

    /* ANSWER: 39958245.9 */ 

    /* c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */

SELECT 
    (SELECT SUM(forest_area_sqkm) FROM forestation WHERE year = 1990 AND country_name = 'World') - 
    (SELECT SUM(forest_area_sqkm) FROM forestation WHERE year = 2016 AND country_name = 'World') AS forest_area_change;

    /* ANSWER: 1324449 */ 

    /* d. What was the percent change in forest area of the world between 1990 and 2016? */

SELECT 
    (((SELECT SUM(forest_area_sqkm) FROM forestation WHERE year = 2016 AND country_name = 'World') - 
    (SELECT SUM(forest_area_sqkm) FROM forestation WHERE year = 1990 AND country_name = 'World')) /
    (SELECT SUM(forest_area_sqkm) FROM forestation WHERE year = 1990 AND country_name = 'World')) * 100 AS forest_area_change_pct;

     /* ANSWER: -3.2% */    

    /* e. If you compare the amount of forest area lost between 1990 and 2016, 
    to which country's total area in 2016 is it closest to? */ 

SELECT DISTINCT 
    country_name,
    total_area_sqkm,
    ABS(total_area_sqkm-1324449) AS difference
FROM forestation 
WHERE year = 2016 
ORDER BY difference ASC
LIMIT 1;

     /* ANSWER: Peru, 1279999.9891 sqkm  */    
