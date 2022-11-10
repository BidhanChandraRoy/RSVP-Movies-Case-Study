USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- We can find the solution by using two different ways
-- 1) we can take count of each table idivisually.
-- 2) we can get row counts for all the column by a single query by using information_schema
-- Here, we are going to follow the 2nd method for better optimisation 

SELECT table_name,
       table_rows 
FROM   information_schema.tables
WHERE  table_schema = 'imdb'; 

/*_____________________________________
No of rows for each tables are:
Output:
+ --------------- + --------------- +
| TABLE_NAME      | TABLE_ROWS      |
+ --------------- + --------------- +
| director_mapping | 3867            |
| genre           | 14662           |
| movie           | 8680            |
| names           | 23173           |
| ratings         | 8230            |
| role_mapping    | 14325           |
+ --------------- + --------------- +
_______________________________________*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- using CASE statement to count the no of null values present in each columns.
-- 1 if there is null values elso 0 and sum of 1 will give the no of null values.

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS null_id,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS null_title,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS null_year,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS null_date_published,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS null_duration,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS null_country,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS null_worlwide_gross_income,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS null_languages,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS null_production_company
FROM   movie; 
/*__________________________________________________________________________________________________
Here, we can see that 4 columns have null values which are country, worlwide_gross_income languages
& production_company. There null value counts of those columns are 20, 3724, 194, 528 respectively.
____________________________________________________________________________________________________*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year.
SELECT year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

/*_____________________________________________
Highest number of movies were released in 2017.
output:
+ --------- + --------------------- +
| year      | number_of_movies      |
+ --------- + --------------------- +
| 2017      | 3052                  |
| 2018      | 2944                  |
| 2019      | 2001                  |
+ --------- + --------------------- +
_______________________________________________*/

-- Number of movies released each month.
SELECT Month(date_published) AS month_num,
       Count(title)          AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 

/*___________________________________________________________________________________________________________
Highest number of movies is produced in the month of March and the lowest no of movies produces in December.
output:
+ -------------- + --------------------- +
| month_num      | number_of_movies      |
+ -------------- + --------------------- +
| 1              | 804                   |
| 2              | 640                   |
| 3              | 824                   |
| 4              | 680                   |
| 5              | 625                   |
| 6              | 580                   |
| 7              | 493                   |
| 8              | 678                   |
| 9              | 809                   |
| 10             | 801                   |
| 11             | 625                   |
| 12             | 438                   |
+ -------------- + --------------------- +
______________________________________________________________________________________________________________*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- As there are many value of country column which indicates that many film had produced in multiple location.
-- So now we are going to check wether USA and India are present in any of the rows in country column by using LIKE operator.

SELECT year,
       Count(DISTINCT id) AS movie_count_2019
FROM   movie
WHERE  ( Upper(country) LIKE '%INDIA%'
          OR Upper(country) LIKE '%USA%' )
       AND year = 2019; 

/*________________________________________________________________________________________
In 2019, there are 1059 films which had been produced in USA or INDIA as per this dataset.
Output:
+ --------- + --------------------- +
| year      | movie_count_2019      |
+ --------- + --------------------- +
| 2019      | 1059                  |
+ --------- + --------------------- +
__________________________________________________________________________________________*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

/*_________________________________________________________________________________________________________________
There are 13 different genres of movies in the dataset which are Drama, Fantasy, Thriller, Comedy, Horror, Family,
Romance, Adventure, Action, Sci-Fi, Crime, Mystery, Others.
Output:
+ ---------- +
| genre      |
+ ---------- +
| Drama      |
| Fantasy    |
| Thriller   |
| Comedy     |
| Horror     |
| Family     |
| Romance    |
| Adventure  |
| Action     |
| Sci-Fi     |
| Crime      |
| Mystery    |
| Others     |
+ ---------- +
____________________________________________________________________________________________________________________*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- To get the overall genre wise movie counts , we have to movie and genre table by inner join.
SELECT g.genre,
       Count(m.title) AS movie_counts_by_genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY movie_counts_by_genre DESC
LIMIT  1; 

/*___________________________________________________________
The highest no of movies from the Drama Genre which is 4285.
Output:
+ ---------- + -------------------------- +
| genre      | movie_counts_by_genre      |
+ ---------- + -------------------------- +
| Drama      | 4285                       |
+ ---------- + -------------------------- +
_____________________________________________________________*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- To get the count of movies which are single genre , we are going to use common table expression.
WITH single_genre
     AS (SELECT movie_id,
                Count(genre)
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT Count(*) as movie_count_by_only_genre
FROM   single_genre;

/*_________________________________________________
3289 movies are there which belongs to only genre.
Output:
+ ------------------------------ +
| movie_count_by_only_genre      |
+ ------------------------------ +
| 3289                           |
+ ------------------------------ +
___________________________________________________*/


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- By joining movie and genre table, we can get the average duration of movies in each genre
SELECT g.genre,
       Round(Avg(m.duration), 2) AS avg_duration
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

/*___________________________________________________________________________________________________________________________________
 The average duration of movies in each genre :
Output:
+ ---------- + ----------------- +
| genre      | avg_duration      |
+ ---------- + ----------------- +
| Action     | 112.88            |
| Romance    | 109.53            |
| Crime      | 107.05            |
| Drama      | 106.77            |
| Fantasy    | 105.14            |
| Comedy     | 102.62            |
| Adventure  | 101.87            |
| Mystery    | 101.80            |
| Thriller   | 101.58            |
| Family     | 100.97            |
| Others     | 100.16            |
| Sci-Fi     | 97.94             |
| Horror     | 92.72             |
+ ---------- + ----------------- +
where we can clearly see that average duration of action movies are very high and the average time of horror films are very less.
__________________________________________________________________________________________________________________________________*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- to get the ranking  of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced, we have used rank function
WITH genre_ranking
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_ranking
WHERE  genre = 'Thriller'; 

/*____________________________________________________________________________________________________________
The rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced is 3rd.
Output:
+ ---------- + ---------------- + --------------- +
| genre      | movie_count      | genre_rank      |
+ ---------- + ---------------- + --------------- +
| Thriller   | 1484             | 3               |
+ ---------- + ---------------- + --------------- +
_______________________________________________________________________________________________________________*/



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Checking minimum and maximum values in  each column of the ratings table except the movie_id column
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS min_median_rating
FROM   ratings;

/*______________________________________________________________________________________________________________________________________________
Output:
+ ------------------- + ------------------- + -------------------- + -------------------- + ---------------------- + ---------------------- +
| min_avg_rating      | max_avg_rating      | min_total_votes      | max_total_votes      | min_median_rating      | min_median_rating      |
+ ------------------- + ------------------- + -------------------- + -------------------- + ---------------------- + ---------------------- +
| 1.0                 | 10.0                | 100                  | 725138               | 1                      | 10                     |
+ ------------------- + ------------------- + -------------------- + -------------------- + ---------------------- + ---------------------- +
_______________________________________________________________________________________________________________________________________________*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- for finding the top 10 movies with title , we have to do inner join between movie and ratings table.
-- for getting rank we are going to use rank() function.
SELECT     m.title,
           r.avg_rating,
           Rank() OVER(ORDER BY r.avg_rating DESC)
FROM       movie   AS m
INNER JOIN ratings AS r
ON         m.id = r.movie_id limit 10;

/*__________________________________________________________________________________________________________
Top movies which are top rated i.e 10 are Kirket and Love in Kilnerry in theis dataset.
Output:
+ ---------------------------------- + --------------- + -------------------------------------------- +
| title                              | avg_rating      | Rank() OVER(ORDER BY r.avg_rating DESC)      |
+ ---------------------------------- + --------------- + -------------------------------------------- +
| Kirket                             | 10.0            | 1                                            |
| Love in Kilnerry                   | 10.0            | 1                                            |
| Gini Helida Kathe                  | 9.8             | 3                                            |
| Runam                              | 9.7             | 4                                            |
| Fan                                | 9.6             | 5                                            |
| Android Kunjappan Version 5.25     | 9.6             | 5                                            |
| Yeh Suhaagraat Impossible          | 9.5             | 7                                            |
| Safe                               | 9.5             | 7                                            |
| The Brighton Miracle               | 9.5             | 7                                            |
| Shibu                              | 9.4             | 10                                           |
+ ---------------------------------- + --------------- + -------------------------------------------- +
____________________________________________________________________________________________________________*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


-- summarising the rating table by median_ratings based on the movie counts
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

/*____________________________________________
The most films have a median rating of seven.
Output:
+ ------------------ + ---------------- +
| median_rating      | movie_count      |
+ ------------------ + ---------------- +
| 7                  | 2257             |
| 6                  | 1975             |
| 8                  | 1030             |
| 5                  | 985              |
| 4                  | 479              |
| 9                  | 429              |
| 10                 | 346              |
| 3                  | 283              |
| 2                  | 119              |
| 1                  | 94               |
+ ------------------ + ---------------- +
______________________________________________*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- finding out the production house which has most no movies having ratings >8.
-- for this we have done common table expression (CTE) from where we get the list of production house name.
-- To get the target production house limiting result by 3
WITH prod_comp_with_movies AS
(
           SELECT     m.production_company,
                      Count(m.id)                             AS movie_count,
                      Rank() OVER( ORDER BY Count(m.id) DESC) AS prod_company_rank
           FROM       movie                                   AS m
           INNER JOIN ratings                                 AS r
           ON         m.id = r.movie_id
           WHERE      avg_rating > 8
           AND        production_company IS NOT NULL
           GROUP BY   production_company )
SELECT *
FROM   prod_comp_with_movies limit 3;

/*_______________________________________________________________________________________________________
Dream Warrior Pictures and  National Theatre Live are the production house with whome RSVP Movies can 
partner for its next project.
Output:
Top three production house:
+ ----------------------- + ---------------- + ---------------------- +
| production_company      | movie_count      | prod_company_rank      |
+ ----------------------- + ---------------- + ---------------------- +
| Dream Warrior Pictures  | 3                | 1                      |
| National Theatre Live   | 3                | 1                      |
| Lietuvos Kinostudija    | 2                | 3                      |
+ ----------------------- + ---------------- + ---------------------- +

__________________________________________________________________________________________________________*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To get the count of movies in each genre in march 2017 in the USA which had more than 1000 vote
-- we need to join movie, genre and ratings column by inner join.
SELECT g.genre,
       Count(m.id) AS movie_count
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

/*_______________________________________________________________
We can see that highest no of movies was made on Drama genre.
Output:
+ ---------- + ---------------- +
| genre      | movie_count      |
+ ---------- + ---------------- +
| Drama      | 24               |
| Comedy     | 9                |
| Action     | 8                |
| Thriller   | 8                |
| Sci-Fi     | 7                |
| Crime      | 6                |
| Horror     | 6                |
| Mystery    | 4                |
| Romance    | 4                |
| Fantasy    | 3                |
| Adventure  | 3                |
| Family     | 1                |
+ ---------- + ---------------- +
_________________________________________________________________*/



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
ORDER  BY avg_rating DESC; 

/*_________________________________________________________________________
There are 8 movies that statswith 'The' and average rating is more than 8.
We can use group by satement to remove the repeatation of title.
The Brighton Miracle is the highest rated movies in this list.
Output:
+ -------------------------------------- + --------------- + ---------- +
| title                                  | avg_rating      | genre      |
+ -------------------------------------- + --------------- + ---------- +
| The Brighton Miracle                   | 9.5             | Drama      |
| The Colour of Darkness                 | 9.1             | Drama      |
| The Blue Elephant 2                    | 8.8             | Drama      |
| The Blue Elephant 2                    | 8.8             | Horror     |
| The Blue Elephant 2                    | 8.8             | Mystery    |
| The Irishman                           | 8.7             | Crime      |
| The Irishman                           | 8.7             | Drama      |
| The Mystery of Godliness: The Sequel   | 8.5             | Drama      |
| The Gambinos                           | 8.4             | Crime      |
| The Gambinos                           | 8.4             | Drama      |
| Theeran Adhigaaram Ondru               | 8.3             | Action     |
| Theeran Adhigaaram Ondru               | 8.3             | Crime      |
| Theeran Adhigaaram Ondru               | 8.3             | Thriller   |
| The King and I                         | 8.2             | Drama      |
| The King and I                         | 8.2             | Romance    |
+ -------------------------------------- + --------------- + ---------- +
____________________________________________________________________________*/



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- To get the movie counts of the movies released between 1 April 2018 and 1 April 2019 and median rating of 8
-- we need to join movie and ratings table.
SELECT median_rating,
       Count(*) AS movie_count
FROM   movie AS m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating; 

/*____________________________________________________________________________________________________
There are 361 movies which were released between 1 April 2018 and 1 April 2019 and median rating of 8.
Output:
+ ------------------ + ---------------- +
| median_rating      | movie_count      |
+ ------------------ + ---------------- +
| 8                  | 361              |
+ ------------------ + ---------------- +
______________________________________________________________________________________________________*/



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- checking the total votes for German or italian movies by joining movie and rating table.
SELECT m.languages,
       r.total_votes
FROM   movie AS m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  Upper(languages) LIKE 'GERMAN'
        OR Upper(languages) LIKE 'ITALIAN'
GROUP  BY languages; 

/*________________________________________________________
Yes. German movies get more votes than Italian movies.
Output:
+ -------------- + ---------------- +
| languages      | total_votes      |
+ -------------- + ---------------- +
| German         | 4695             |
| Italian        | 1684             |
+ -------------- + ---------------- +

___________________________________________________________*/



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- using CASE statement to count the no of null values present in each columns.
-- 1 if there is null values elso 0 and sum of 1 will give the no of null values.
SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

/*____________________________________________________________________________________________________
Here, we can see that 3 colums which have null values are height, date_of_birth and known_for_movies.
Output:
+ --------------- + ----------------- + ------------------------ + --------------------------- +
| name_nulls      | height_nulls      | date_of_birth_nulls      | known_for_movies_nulls      |
+ --------------- + ----------------- + ------------------------ + --------------------------- +
| 0               | 17335             | 13431                    | 15226                       |
+ --------------- + ----------------- + ------------------------ + --------------------------- +

_______________________________________________________________________________________________________*/



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- to get the desired result , first we will  try to get the top three genre where average rating >8.
-- next we will join genre, rating, names, director mapping, top 3 genre table.
WITH top_3_genre AS
(
           SELECT     g.genre,
                      Count(m.id)                            AS movie_count,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         m.id=g.movie_id
           INNER JOIN ratings AS r
           ON         m.id=r.movie_id
           WHERE      avg_rating>8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre             AS g
using      (movie_id)
INNER JOIN ratings 
using      (movie_id)
INNER JOIN names AS n
ON         d.name_id = n.id
INNER JOIN top_3_genre
using      (genre)
WHERE      avg_rating>8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3;

/*________________________________________________________________________________________________
James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose 
movies have an average rating > 8.
Output:
+ ------------------ + ---------------- +
| James Mangold      | 4                |
| Anthony Russo      | 3                |
| Soubin Shahir      | 3                |
+ ------------------ + ---------------- +
___________________________________________________________________________________________________*/




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To get the top two actor whose median rating is more than equal to 8 , we need to join three tables
-- which are role mapping , names and ratings
SELECT n.name              AS actor_name,
       Count(rol.movie_id) AS movie_count
FROM   role_mapping AS rol
       INNER JOIN names AS n
               ON rol.name_id = n.id
       INNER JOIN ratings USING (movie_id)
WHERE  median_rating >= 8
GROUP  BY name
ORDER  BY movie_count DESC
LIMIT  2;

/*_________________________________________________________________________________
Mammootty & Mohanlal are the top two actors whose movies have a median rating >= 8.
Output:
+ --------------- + ---------------- +
| actor_name      | movie_count      |
+ --------------- + ---------------- +
| Mammootty       | 8                |
| Mohanlal        | 5                |
+ --------------- + ---------------- +
___________________________________________________________________________________*/




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- by doing inner join of movie and ratings table, we can check the top 3 production house.
SELECT     m.production_company,
           Sum(r.total_votes)                             AS vote_count,
           Rank() OVER (ORDER BY Sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie                                          AS m
INNER JOIN ratings                                        AS r
ON         m.id = r.movie_id
GROUP BY   production_company limit 3;

/*____________________________________________________________________________________________________________________________________________
Marvel Studios,Twentieth Century Fox & Warner Bros. are the top three production houses based on the number of votes received by their movies.
Output:
+ ----------------------- + --------------- + ------------------- +
| Marvel Studios          | 2656967         | 1                   |
| Twentieth Century Fox   | 2411163         | 2                   |
| Warner Bros.            | 2396057         | 3                   |
+ ----------------------- + --------------- + ------------------- +
______________________________________________________________________________________________________________________________________________*/



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- We are going to use role mapping, names, rating  and movie tables to get the desired results.
-- we are going to use cte to get the rank or the actor
WITH actor_details AS
(
           SELECT     n.NAME AS actor_name,
                      r.total_votes,
                      Count(rol.movie_id)                                         AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes)/Sum(total_votes),2) AS actor_avg_rating
           FROM       role_mapping                                                AS rol
           INNER JOIN names                                                       AS n
           ON         rol.name_id = n.id
           INNER JOIN ratings AS r
           using      (movie_id)
           INNER JOIN movie AS m
           ON         rol.movie_id = m.id
           WHERE      category = 'actor'
           AND        Upper(country) = 'INDIA'
           GROUP BY   NAME
           HAVING     Count(rol.movie_id)>=5 )
SELECT   *,
         Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM     actor_details limit 5;

/*____________________________________________________________________________________________________
Vijay Sethupathi is the top actor who acted atleast 5 movies and have the highest rating.
Output:
Top five list of actors.
+ ---------------- + ---------------- + ---------------- + --------------------- + --------------- +
| actor_name       | total_votes      | movie_count      | actor_avg_rating      | actor_rank      |
+ ---------------- + ---------------- + ---------------- + --------------------- + --------------- +
| Vijay Sethupathi | 20364            | 5                | 8.42                  | 1               |
| Fahadh Faasil    | 3684             | 5                | 7.99                  | 2               |
| Yogi Babu        | 223              | 11               | 7.83                  | 3               |
| Joju George      | 413              | 5                | 7.58                  | 4               |
| Ammy Virk        | 169              | 6                | 7.55                  | 5               |
+ ---------------- + ---------------- + ---------------- + --------------------- + --------------- +
_______________________________________________________________________________________________________*/


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- We are going to use role mapping, names, rating  and movie tables to get the desired results.
-- we are going to use cte to get the rank or the Actress
WITH actress_details AS
(
           SELECT     n.NAME AS actress_name,
                      r.total_votes,
                      Count(rol.movie_id)                                         AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       role_mapping                                                AS rol
           INNER JOIN names                                                       AS n
           ON         rol.name_id = n.id
           INNER JOIN ratings AS r
           using      (movie_id)
           INNER JOIN movie AS m
           ON         rol.movie_id = m.id
           WHERE      category = 'actress'
           AND        Upper(country) = 'INDIA'
           AND 		  Upper(languages) LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     Count(rol.movie_id)>=3 )
SELECT   *,
         Rank() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_details limit 5;

/*____________________________________________________________________________________________________________________
Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor & Kriti Kharbanda are the top five actresses in Hindi movies
released in India based on their average ratings.
Output:
+ ----------------- + ---------------- + ---------------- + ----------------------- + ----------------- +
| actress_name      | total_votes      | movie_count      | actress_avg_rating      | actress_rank      |
+ ----------------- + ---------------- + ---------------- + ----------------------- + ----------------- +
| Taapsee Pannu     | 2269             | 3                | 7.74                    | 1                 |
| Kriti Sanon       | 14978            | 3                | 7.05                    | 2                 |
| Divya Dutta       | 345              | 3                | 6.88                    | 3                 |
| Shraddha Kapoor   | 3349             | 3                | 6.63                    | 4                 |
| Kriti Kharbanda   | 1280             | 3                | 4.80                    | 5                 |
+ ----------------- + ---------------- + ---------------- + ----------------------- + ----------------- +
_______________________________________________________________________________________________________________________*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using case statement to categorize the movies.
SELECT m.title,
       r.avg_rating,
       ( CASE
           WHEN r.avg_rating > 8 THEN 'Superhit movies'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN r.avg_rating < 5 THEN 'Flop movies'
         END ) AS movie_category_by_rating
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON m.id = g.movie_id
WHERE  Upper(genre) LIKE '%THRILLER%'; 
            
/*____________________________________________________________________________________________
list of hriller movies as per avg rating and classified them in the above mentioned category.
Output:
+ ------------------------ + --------------- + ----------------------------- +
| title                    | avg_rating      | movie_category_by_rating      |
+ ------------------------ + --------------- + ----------------------------- +
| Der müde Tod             | 7.7             | Hit movies                    |
| Fahrenheit 451           | 4.9             | Flop movies                   |
| Pet Sematary             | 5.8             | One-time-watch movies         |
| Dukun                    | 6.9             | One-time-watch movies         |
| Back Roads               | 7.0             | Hit movies                    |
| Countdown                | 5.4             | One-time-watch movies         |
| Staged Killer            | 3.3             | Flop movies                   |
| Vellaipookal             | 7.3             | Hit movies                    |
| Uriyadi 2                | 7.3             | Hit movies                    |
| Incitement               | 7.5             | Hit movies                    |
| Rakshasudu               | 8.4             | Superhit movies               |
| Trois jours et une vie   | 6.6             | One-time-watch movies         |
| Killer in Law            | 5.1             | One-time-watch movies         |
| Kalki                    | 7.3             | Hit movies                    |
| Milliard                 | 2.7             | Flop movies                   |
| Vinci Da                 | 7.2             | Hit movies                    |
| Gunned Down              | 5.1             | One-time-watch movies         |
| Deviant Love             | 3.5             | Flop movies                   |
| Storozh                  | 6.3             | One-time-watch movies         |
| Sivappu Manjal Pachai    | 7.2             | Hit movies                    |
+------------------------- + --------------- + ----------------------------- +
showing 20 results out of 1484.
______________________________________________________________________________________________*/



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- to solve this problem we need to use frame to calculate running total duration and moving average duration
SELECT g.genre,
       Round(Avg(m.duration), 2)                    AS avg_duration,
       SUM(Round(Avg(m.duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(m.duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding )       AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
       inner join ratings AS r
               ON m.id = r.movie_id
GROUP  BY genre
ORDER  BY genre; 

/*__________________________________________________________________________________________
Output:
+ ---------- + ----------------- + --------------------------- + ------------------------ +
| genre      | avg_duration      | running_total_duration      | moving_avg_duration      |
+ ---------- + ----------------- + --------------------------- + ------------------------ +
| Action     | 112.88            | 112.88                      | 112.880000               |
| Adventure  | 101.87            | 214.75                      | 107.375000               |
| Comedy     | 102.62            | 317.37                      | 105.790000               |
| Crime      | 107.05            | 424.42                      | 106.105000               |
| Drama      | 106.77            | 531.19                      | 106.238000               |
| Family     | 100.97            | 632.16                      | 105.360000               |
| Fantasy    | 105.14            | 737.30                      | 105.328571               |
| Horror     | 92.72             | 830.02                      | 103.752500               |
| Mystery    | 101.80            | 931.82                      | 103.535556               |
| Others     | 100.16            | 1031.98                     | 103.198000               |
| Romance    | 109.53            | 1141.51                     | 103.773636               |
| Sci-Fi     | 97.94             | 1239.45                     | 102.415455               |
| Thriller   | 101.58            | 1341.03                     | 102.389091               |
+ ---------- + ----------------- + --------------------------- + ------------------------ +
____________________________________________________________________________________________*/


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- By using CTE, we will find top 3 genre then top five highest-grossing movies of each year that belong to the top three genres.
WITH top_3_genre_by_movie_count AS
(
           SELECT     g.genre,
                      Count(m.id)                            AS movie_count,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         m.id= g.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3), top_5_highest_grossing AS
(
           SELECT     g.genre,
                      m.year,
                      m.title                                                                                                                                AS movie_name,
                      Cast(Replace(Replace(Ifnull(m.worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                               AS worlwide_gross_income ,
                      Rank() OVER (partition BY year ORDER BY Cast(Replace(Replace(Ifnull(m.worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC) AS movie_rank
           FROM       movie                                                                                                                                  AS m
           INNER JOIN genre                                                                                                                                  AS g
           ON         m.id= g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_genre_by_movie_count)
           GROUP BY   movie_name)
SELECT *
FROM   top_5_highest_grossing
WHERE  movie_rank<=5;

/*__________________________________________________________________________________________________________________
Top 5 highest grossing movies for each year:
Output:
+ ---------- + --------- + --------------------------------------- + -------------------------- + --------------- +
| genre      | year      | movie_name                              | worlwide_gross_income      | movie_rank      |
+ ---------- + --------- + --------------------------------------- + -------------------------- + --------------- +
| Action     | 2017      | Star Wars: Episode VIII - The Last Jedi | 1332539889                 | 1               |
| Action     | 2017      | The Fate of the Furious                 | 1236005118                 | 2               |
| Comedy     | 2017      | Despicable Me 3                         | 1034799409                 | 3               |
| Action     | 2017      | Jumanji: Welcome to the Jungle          | 962102237                  | 4               |
| Action     | 2017      | Spider-Man: Homecoming                  | 880166924                  | 5               |
| Action     | 2018      | Avengers: Infinity War                  | 2048359754                 | 1               |
| Action     | 2018      | Black Panther                           | 1346913161                 | 2               |
| Action     | 2018      | Jurassic World: Fallen Kingdom          | 1308467944                 | 3               |
| Action     | 2018      | The Villain                             | 1300000000                 | 4               |
| Action     | 2018      | Incredibles 2                           | 1242805359                 | 5               |
| Action     | 2019      | Avengers: Endgame                       | 2797800564                 | 1               |
| Drama      | 2019      | The Lion King                           | 1655156910                 | 2               |
| Action     | 2019      | Spider-Man: Far from Home               | 1131845802                 | 3               |
| Action     | 2019      | Captain Marvel                          | 1128274794                 | 4               |
| Comedy     | 2019      | Toy Story 4                             | 1073168585                 | 5               |
+ ---------- + --------- + --------------------------------------- + -------------------------- + --------------- +
_____________________________________________________________________________________________________________________*/



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Count(m.id)                            AS movie_count,
           Rank() OVER(ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM       movie                                  AS m
INNER JOIN ratings                                AS r
ON         m.id = r.movie_id
WHERE      median_rating>=8
AND        production_company IS NOT NULL
AND        position(',' IN languages)>0
GROUP BY   production_company limit 2;

 /*______________________________________________________________________________________________________
 Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest
number of hits (median rating >= 8) among multilingual movies.
 Output:
 + ----------------------- + ---------------- + ------------------- +
| production_company      | movie_count      | prod_comp_rank      |
+ ----------------------- + ---------------- + ------------------- +
| Star Cinema             | 7                | 1                   |
| Twentieth Century Fox   | 4                | 2                   |
+ ----------------------- + ---------------- + ------------------- +
 _______________________________________________________________________________________________________*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_details AS
(
           SELECT     n.NAME,
                      r.total_votes,
                      Count(rol.movie_id)                                         AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       role_mapping                                                AS rol
           INNER JOIN names                                                       AS n
           ON         rol.name_id = n.id
           INNER JOIN ratings AS r
           using      (movie_id)
           INNER JOIN genre
           using      (movie_id)
           WHERE      category = 'actress'
           AND        genre = 'drama'
           AND        avg_rating>8
           GROUP BY   NAME)
SELECT  *,
         Rank() OVER(ORDER BY movie_count DESC)
FROM     actress_details limit 3;

/*____________________________________________________________________________________________________________________________________
Parvathy Thiruvothu,Susan Brown and Amanda Lawrence are the top 3 actresses based on number of Super Hit movies (average rating >8) 
in drama genre.
Output:
+ ------------------- + ---------------- + ---------------- + ----------------------- + ------------------------------------------- +
| NAME                | total_votes      | movie_count      | actress_avg_rating      | Rank() OVER(ORDER BY movie_count DESC)      |
+ ------------------- + ---------------- + ---------------- + ----------------------- + ------------------------------------------- +
| Parvathy Thiruvothu | 3684             | 2                | 8.25                    | 1                                           |
| Susan Brown         | 365              | 2                | 8.94                    | 1                                           |
| Amanda Lawrence     | 365              | 2                | 8.94                    | 1                                           |
+ ------------------- + ---------------- + ---------------- + ----------------------- + ------------------------------------------- +
______________________________________________________________________________________________________________________________________*/



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

*/
-- Type you code below:

WITH next_movie_date_published_details AS
(
           SELECT     d.name_id,
                      n.NAME,
                      d.movie_id,
                      m.duration,
                      r.avg_rating,
                      r.total_votes,
                      m.date_published,
                      Lead(m.date_published,1) OVER(partition BY d.name_id ORDER BY m.date_published,d.movie_id) AS next_movie_date_published
           FROM       director_mapping                                                                           AS d
           INNER JOIN names                                                                                      AS n
           ON         d.name_id = n.id
           INNER JOIN movie AS m
           ON         d.movie_id=m.id
           INNER JOIN ratings AS r
           using      (movie_id) ), top_director_details AS
(
       SELECT *,
              Datediff(next_movie_date_published,date_published) AS date_difference
       FROM   next_movie_date_published_details )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)      AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_details
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

/*___________________________________________________________________________________________________________________________________________________________________________________________
The list of top 9 directors are:
Output:
+ ---------------- + ------------------ + --------------------- + ------------------------- + --------------- + ---------------- + --------------- + --------------- + ------------------- +
| director_id      | director_name      | number_of_movies      | avg_inter_movie_days      | avg_rating      | total_votes      | min_rating      | max_rating      | total_duration      |
+ ---------------- + ------------------ + --------------------- + ------------------------- + --------------- + ---------------- + --------------- + --------------- + ------------------- +
| nm2096009        | Andrew Jones       | 5                     | 190.75                    | 3.02            | 1989             | 2.7             | 3.2             | 432                 |
| nm1777967        | A.L. Vijay         | 5                     | 176.75                    | 5.42            | 1754             | 3.7             | 6.9             | 613                 |
| nm0814469        | Sion Sono          | 4                     | 331.00                    | 6.03            | 2972             | 5.4             | 6.4             | 502                 |
| nm0831321        | Chris Stokes       | 4                     | 198.33                    | 4.33            | 3664             | 4.0             | 4.6             | 352                 |
| nm0515005        | Sam Liu            | 4                     | 260.33                    | 6.23            | 28557            | 5.8             | 6.7             | 312                 |
| nm0001752        | Steven Soderbergh  | 4                     | 254.33                    | 6.48            | 171684           | 6.2             | 7.0             | 401                 |
| nm0425364        | Jesse V. Johnson   | 4                     | 299.00                    | 5.45            | 14778            | 4.2             | 6.5             | 383                 |
| nm2691863        | Justin Price       | 4                     | 315.00                    | 4.50            | 5343             | 3.0             | 5.8             | 346                 |
| nm6356309        | Özgür Bakar        | 4                     | 112.00                    | 3.75            | 1092             | 3.1             | 4.9             | 374                 |
+ ---------------- + ------------------ + --------------------- + ------------------------- + --------------- + ---------------- + --------------- + --------------- + ------------------- +
______________________________________________________________________________________________________________________________________________________________________________________________*/



