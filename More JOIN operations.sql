/*1.List the films WHERE the yr is 1962 [Show id, title]*/

SELECT id, title
 FROM movie
 WHERE yr=1962

/* 2.Give year of 'Citizen Kane'.*/

SELECT yr
FROM movie
WHERE title LIKE 'Citizen Kane'

/*3.List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.*/

SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star%Trek%'
ORDER BY yr

/*4.What id number does the actor 'Glenn Close' have?*/

SELECT id
FROM actor
WHERE name LIKE 'Glenn Close'

/*5.What is the id of the film 'Casablanca'*/

SELECT id
FROM movie
WHERE title LIKE 'Casablanca'

/*6.Obtain the cast list for 'Casablanca'.
what is a cast list?Use movieid=11768, (or whatever value you got FROM the previous questiON)*/

SELECT name
FROM actor JOIN casting ON id=actorid
WHERE movieid=11768

/*7.Obtain the cast list for the film 'Alien'*/

SELECT name
FROM actor JOIN casting ON id=actorid
WHERE movieid=(SELECT id FROM movie WHERE title LIKE 'Alien')

/*8.List the films in which 'HarrisON Ford' has appeared*/

SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

/*9.List the films WHERE 'HarrisON Ford' has appeared - but not in the starring role. 
[Note: the ord field of casting gives the positiON of the actor. If ord=1 then this actor is in the starring role]*/

SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford'
AND ord <> 1

/*10.List the films together with the leading star for all 1962 films.*/

SELECT title , name
FROM movie JOIN casting ON id=movieid
JOIN actor ON actor.id=actorid
WHERE yr=1962 and ord=1

/*11.Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any 
year in which he made more than 2 movies.*/

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)>2

/*12.List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"?
Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).
Title is not a unique field, create a table of IDs in your subquery*/

SELECT title, name FROM 
	movie JOIN casting ON (movie.id = movieid)
		  JOIN actor ON (actor.id = actorid)
		  WHERE ord = 1 AND movieid IN (SELECT movieid FROM casting
										WHERE actorid IN (SELECT id FROM actor
 														 WHERE name='Julie Andrews'))

/*13.Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles*/

SELECT name
FROM actor JOIN casting ON id=actorid
WHERE ord=1
GROUP BY name
HAVING count(name)>=30

/*14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.*/

SELECT title, count(actorid)
FROM movie JOIN casting ON id=movieid
WHERE yr=1978
GROUP BY title
ORDER BY count(actorid) desc,title

/*15.List all the people who have worked with 'Art Garfunkel'.*/

SELECT distinct name
FROM actor JOIN casting ON id=actorid
WHERE movieid IN (SELECT movieid FROM casting
JOIN actor ON id=actorid WHERE name ='Art Garfunkel')
AND name <> 'Art Garfunkel'