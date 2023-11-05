USE lco_films;
show tables; 
-- The table names are:
-- actor, address, category, city, country, film, film_actor, film_category, language
desc actor; -- actor_id, first_name, last_name, address_id, last_update
desc address; -- address_id, address, address2, district, city_id, postal_code, phone, last_update
desc category; -- category_id, name, last_update
desc city; -- city_id, city, country_id, last_update
desc country; -- country_id, country, last_update
desc film; -- film_id, title, description, release_year, language_id, original_language_id, 
		   -- rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update
desc film_actor; -- actor_id, film_id, last_update
desc film_category; -- film_id, category_id, last_update
desc language; -- language_id, name, last_update

									****ASSIGNMENT****
--------------------------------------------------------------------------------------------------------------

-- Q1) Which categories of movies released in 2018? Fetch with the number of movies. 

select c.name, c.category_id, f3.release_year,f3.title, count(c.name) as No_of_movies from category c
inner join 
(select f1.film_id, f1.title, f1.release_year, f2.category_id from film f1 
left join film_category f2 on f1.film_id = f2.film_id
where release_year = 2018 ) f3 on c.category_id = f3.category_id
group by c.name order by count(c.name) desc;

-------------------------------------------------------------------------------------------------------------

-- Q2) Update the address of actor id 36 to “677 Jazz Street”.

update address
set address = "677 Jazz Street" where address_id = 
( select address_id from actor where actor_id=36);

-------------------------------------------------------------------------------------------------------------

-- Q3) Add the new actors (id : 105 , 95) in film  ARSENIC INDEPENDENCE (id:41).

INSERT INTO film_actor (actor_id, film_id) values (105,41), (95,41);

-------------------------------------------------------------------------------------------------------------

-- Q4) Get the name of films of the actors who belong to India.

select distinct film.title, country.country from country
inner join city on country.country_id = city.country_id
inner join address on city.city_id = address.city_id
inner join actor on address.address_id = actor.address_id
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
where country = "India";

-------------------------------------------------------------------------------------------------------------

-- Q5) How many actors are from the United States?

select count(actor.actor_id) as No_of_actors from country
inner join city on country.country_id = city.country_id
inner join address on city.city_id = address.city_id
inner join actor on address.address_id = actor.address_id
where country = "United States" group by country.country;

--------------------------------------------------------------------------------------------------------------

-- Q6) Get all languages in which films are released in the year between 2001 and 2010.

SELECT l.name, f.release_year, count(f.film_id) as No_of_movies from film f
left join language l on f.language_id = l.language_id
where f.release_year between 2001 and 2010
group by l.name;

-------------------------------------------------------------------------------------------------------------

-- Q7) The film ALONE TRIP (id:17) was actually released in Mandarin, update the info.

update film set language_id = (select language_id from language where name = 'Mandarin')
where film_id = 17

-------------------------------------------------------------------------------------------------------------

-- Q8) Fetch cast details of films released during 2005 and 2015 with PG rating.

Select concat(a.first_name,' ', a.last_name) as actor_name, f1.title as film_title, f1.release_year, f1.rating from film f1
left join film_actor f2 on f1.film_id = f2.film_id
left join actor a on f2.actor_id = a.actor_id
where f1.release_year between 2005 and 2015 and f1.rating = 'pg';

-------------------------------------------------------------------------------------------------------------

-- Q9) In which year most films were released?

select release_year, count(title) as No_of_films from film
group by release_year order by count(title) desc limit 1;  

-------------------------------------------------------------------------------------------------------------

-- Q10) In which year least number of films were released?

select release_year, count(title) as No_of_films from film
group by release_year order by count(title) limit 1;  

-------------------------------------------------------------------------------------------------------------

-- Q11) Get the details of the film with maximum length released in 2014 .

select title, description, release_year, max(length) as length from film
where release_year = 2014
group by length order by max(length) desc limit 1;

-------------------------------------------------------------------------------------------------------------

-- Q12) Get all Sci- Fi movies with NC-17 ratings and language they are screened in.

select c.name as genre, f1.title,f1.release_year, f1.rating, l.name as language from film f1
left join film_category f2 on f1.film_id = f2.film_id
left join category c on f2.category_id = c.category_id
left join language l on f1.language_id = l.language_id
where f1.rating = 'NC-17' and c.name = 'Sci-Fi';

-------------------------------------------------------------------------------------------------------------

-- Q13) The actor FRED COSTNER (id:16) shifted to a new address:
--      055,  Piazzale Michelangelo, Postal Code - 50125 , District - Rifredi at Florence, Italy. 
-- 	    Insert the new city and update the address of the actor.

(S1)  Insert into `city` (`city`, `country_id`) values ('Florence', 
	    (select country_id from country c2 where c2.country = 'Italy'));

(S2)  Update `address` a1
		inner join actor a2 on a1.address_id = a2.address_id
		set a1.address = '055,  Piazzale Michelangelo', a1.postal_code = '50125', 
            a1.district = 'Rifredi', 
            a1.city_id = (select city_id from city where city = 'Florence')
		where actor_id = 16;

-------------------------------------------------------------------------------------------------------------

-- Q14) A new film “No Time to Die” is releasing in 2020 whose details are : 
-- 		Title :- No Time to Die
-- 		Description: Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself 
-- 		  hot on the trail of a mysterious villain, who's armed with a dangerous new technology.
-- 		Language: English,			Org. Language : English
-- 		Length : 100,				Rental_duration : 6
-- 		Rental_rate : 3.99,			Rating : PG-13
-- 		Replacement_cost : 20.99,	Special_Features = Trailers,Deleted Scenes

-- 		Insert the above data.

INSERT INTO FILM (title, `description`, release_year, language_id,original_language_id, rental_duration, rental_rate, `length`, replacement_cost, rating, special_features) 
values ('No Time to Die', "Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who's armed with a dangerous new technology.",
2020, (select language_id from `language` where `name` = 'English'), (select language_id from `language` where `name` = 'English'), 6, 3.99, 100, 20.99, 'PG-13', 'Trailers,Deleted Scenes');

-------------------------------------------------------------------------------------------------------------

-- Q15) Assign the category Action, Classics, Drama  to the movie “No Time to Die” .

INSERT INTO film_category (film_id, category_id) 
values ( (select film_id from film where film.title = 'No Time to Die'), (select category_id from category where category.name ='Action')),
( (select film_id from film where film.title = 'No Time to Die'), (select category_id from category where category.name ='Classics')),
( (select film_id from film where film.title = 'No Time to Die'), (select category_id from category where category.name ='Drama'));

-------------------------------------------------------------------------------------------------------------

-- Q16) Assign the cast: PENELOPE GUINESS, NICK WAHLBERG, JOE SWANK to the movie “No Time to Die” .

INSERT INTO film_actor (actor_id, film_id) values
( (select actor_id from actor a where a.first_name = 'PENELOPE' AND a.last_name='GUINESS'), 
	(select film_id from film f where f.title='NO TIME TO DIE')),
( (select actor_id from actor a where a.first_name = 'NICK' AND a.last_name='WAHLBERG'), 
	(select film_id from film f where f.title='NO TIME TO DIE')),
( (select actor_id from actor a where a.first_name = 'JOE' AND a.last_name='SWANK'), 
	(select film_id from film f where f.title='NO TIME TO DIE'));

-------------------------------------------------------------------------------------------------------------

-- Q17) Assign a new category Thriller  to the movie ANGELS LIFE.

(S1)  INSERT INTO CATEGORY (`name`) values ('Thriller');

(S2)  INSERT INTO FILM_CATEGORY (FILM_ID, CATEGORY_ID) VALUES
		( (select film_id from film f where f.title = 'ANGELS LIFE'),
			(select category_id from category c where c.name = 'Thriller') );

-------------------------------------------------------------------------------------------------------------

-- Q18) Which actor acted in most movies?

select a.actor_id, a.first_name, a.last_name, count(f.film_id) as No_of_films from actor a 
left join film_actor f on a.actor_id = f.actor_id
group by f.actor_id order by count(f.film_id) desc limit 1;
 
-------------------------------------------------------------------------------------------------------------

-- Q19) The actor JOHNNY LOLLOBRIGIDA was removed from the movie GRAIL FRANKENSTEIN. 
--      How would you update that record?

Delete from film_actor where actor_id = (select actor_id from actor a where a.first_name='JOHNNY' and a.last_name='LOLLOBRIGIDA')
						AND film_id = (select film_id from film f where f.title = 'GRAIL FRANKENSTEIN');

-------------------------------------------------------------------------------------------------------------

-- Q20) The HARPER DYING movie is an animated movie with Drama and Comedy. 
-- 		Assign these categories to the movie.

Insert Into film_category (film_id, category_id) values
	( (select film_id from film f where f.title = 'harper dying'), 
		(select category_id from category c where c.name = 'Drama')),
	( (select film_id from film f where f.title = 'harper dying'), 
		(select category_id from category c where c.name = 'Comedy'));

-------------------------------------------------------------------------------------------------------------

-- Q21) The entire cast of the movie WEST LION has changed. The new actors are:
--      DAN TORN, MAE HOFFMAN, SCARLETT DAMON. How would you update the record in the safest way?

(S1) Delete from film_actor where film_id =(select film_id from film where title = 'west lion');

(S2) Insert into film_actor (actor_id, film_id) values
	((select actor_id from actor where first_name = 'DAN' and last_name = 'TORN'),
		(select film_id from film where title = 'west lion')),
	((select actor_id from actor where first_name = 'MAE' and last_name = 'HOFFMAN'),
		(select film_id from film where title = 'west lion')),
	((select actor_id from actor where first_name = 'SCARLETT' and last_name = 'DAMON'),
		(select film_id from film where title = 'west lion'));
select * from film_category where film_id = 969

-------------------------------------------------------------------------------------------------------------

-- Q22) The entire category of the movie WEST LION was wrongly inserted. The correct categories are:
--       Classics, Family, Children. How would you update the record ensuring no wrong data is left?

Delete from film_category where film_id = (select film_id from film where title = 'west lion');

Insert into film_category (film_id, category_id) values
	((select film_id from film f where f.title = 'west lion'),
	 (select category_id from category c where c.name = 'Classics')),
	((select film_id from film f where f.title = 'west lion'),
	 (select category_id from category c where c.name = 'Family')),
	((select film_id from film f where f.title = 'west lion'),
	 (select category_id from category c where c.name = 'Children'));

-------------------------------------------------------------------------------------------------------------

-- 
