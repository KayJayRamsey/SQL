#Display the first and last names of all actors from the table actor.
use sakila; 
SELECT first_name, last_name
FROM actor;  

#Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
use sakila; 
SELECT concat(first_name, " ", last_name) AS ActorName
From actor;  

#You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select * from actor 
where first_name = 'Joe';

#Find all actors whose last name contain the letters GEN:
select last_name 
   from actor
   where last_name LIKE '%gen';

#Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:   
select last_name, first_name  
from actor
where last_name LIKE '%LI%'; 

#Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
use sakila;
select country_id, country  
From country 
where country IN ('Afghanistan', 'Bangladesh', 'China'); 

#create a column in the table actor named description and use the data type BLOB
ALTER TABLE Actor
ADD description blob;

#delete column 
ALTER TABLE Actor
DROP COLUMN description;

#List the last names of actors, as well as how many actors have that last name
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name; 

#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT COUNT(actor_ID), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(actor_ID) >= 2;

#The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE Actor 
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE actor_id = 172;  

# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE Actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;  

#You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address; 

#Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff 
Inner Join address 
ON staff.address_id = address.address_id; 

#Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
Select sum(payment.amount), staff.first_name, staff.last_name 
from payment
inner join staff
on payment.staff_id = staff.staff_id 
where payment_date like "2005-08%"
Group by staff.first_name, staff.last_name; 

#List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Select title, count(actor_id) 
from film 
inner join film_actor 
on film.film_id = film_actor.film_id 
Group by title; 

#How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(inventory.film_id) 
from film 
inner join inventory 
on film.film_id = inventory.film_id 
where title like "Hunchback Impossible%" 
group by title, inventory.film_id;

#Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount) "Total Amount Paid" 
from customer
join payment 
on customer.customer_id = payment.customer_id 
group by customer.first_name, customer.last_name
order by customer.last_name ASC;  
 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English
Select film.title, language.name  
from film 
join language 
on film.language_id = language.language_id 
where film.title 
like'K%' OR film.title like 'Q%';  

#Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
 SELECT actor_id
 FROM film_actor
 WHERE film_id IN
 (
  SELECT film_id
  FROM film
  WHERE title = 'Alone Trip'
 )
);

#Need the names and email addresses of all Canadian customers
SELECT first_name, last_name, email, country
FROM customer
JOIN address using (address_ID)
JOIN city using (city_ID)
JOIN country using (country_ID)
WHERE country = 'Canada';

#Identify all movies categorized as family films
SELECT title, name 
FROM film 
JOIN film_category using (film_id)
Join category using (category_id)
WHERE name = 'Family';

#Display the most frequently rented movies in descending order
SELECT f.Title, COUNT(*) AS Frequency
FROM Rental
join inventory inv on inv.inventory_id = Rental.inventory_id
join film f on f.film_id = inv.film_id
GROUP BY f.film_id 
ORDER BY COUNT(*) DESC;

#Write a query to display how much business, in dollars, each store brought in
Select store_id, SUM(amount) as 'Total Amount' 
from store
join staff using (store_id) 
join payment using (staff_id)
group by store_id
order by 'Total Amount';  

#Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store
join address using (address_id)
join city using (city_id)
join country using (country_id)
group by store_id
order by city AND country; 

#List the top five genres in gross revenue in descending order
SELECT name AS 'Genre', SUM(amount) AS 'Gross Revenue'
FROM category
JOIN film_category using (category_id)
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN payment using (rental_id)
GROUP BY name
ORDER BY amount DESC;

#Use the solution from the problem above to create a view
CREATE VIEW top_five_genres (name, revenue) AS
SELECT name AS 'Genre', SUM(amount) AS 'Gross Revenue'
FROM category
JOIN film_category using (category_id)
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN payment using (rental_id)
GROUP BY name
ORDER BY amount DESC;

#Display View
SELECT * FROM top_five_genres;

#Write a query to delete view
DROP VIEW top_five_genres;



