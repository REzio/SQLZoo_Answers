/*1. LISt each country name WHERE the population IS larger than that of 'Russia'.*/

SELECT name FROM world
  WHERE population >
     (SELECT population 
     	FROM world
      WHERE name='Russia')

/*2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.*/

SELECT name 
FROM world
WHERE continent LIKE 'Europe' 
	AND  gdp/population > (SELECT gdp/population 
							FROM world 
							WHERE name LIKE 'United kingdom')

/*3. LISt the name AND continent of countries in the continents containing either Argentina or Australia. 
Order by name of the country.*/

SELECT name, continent
FROM world
WHERE continent IN (SELECT continent 
					FROM world 
					WHERE name IN ('argentina', 'australia')) 
order by name

/*4.Which country has a population that IS more than Canada but less than PolAND? Show the name AND the population.*/

SELECT name,population
FROM world
WHERE population < (SELECT population 
					FROM world 
					WHERE name LIKE 'polAND') 
	AND population >(SELECT population 
					FROM world 
					WHERE name LIKE 'canada')

/*5. Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
Show the name AND the population of each country in Europe. Show the population as a percentage of the population of Germany.*/

SELECT name, concat(
				round(
					population/(SELECT population 
								FROM world 
								WHERE name LIKE 'germany')* 100,0),'%') AS population
FROM world
WHERE continent LIKE 'europe'

/*6.Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)*/

SELECT name
  FROM world
 WHERE gdp > ALL(SELECT gdp
                           FROM world
                          WHERE gdp>0 AND continent LIKE 'europe')

/*7.Find the largest country (by area) in each continent, show the continent, the name AND the area:*/

SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

/*8.LISt each continent AND the name of the country that comes first alphabeticALLy.*/

SELECT continent, name
FROM world x
WHERE name <= ALL (SELECT name FROM world y 
					WHERE x.continent = y.continent 
						AND name IS NOT NULL)

/*9.Find the continents WHERE ALL countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent AND population.*/

SELECT name,continent,population
FROM world x
WHERE continent NOT IN (SELECT continent FROM world y 
						WHERE x.continent = y.continent 
						AND population > 25000000)

/*10.Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries AND continents.*/

SELECT name, continent
FROM world x
WHERE population > ALL (SELECT population*3 FROM world y 
						WHERE x.continent = y.continent 
						AND population > 0 
						AND x.name != y.name)