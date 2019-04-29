use sakila;

select *
from actor;

#1a
select first_name, last_name
from actor;

#1b
select concat(first_name, ' ' , last_name) as "Actor Name"
from actor;

#2a
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

#2b
select actor_id, first_name, last_name
from actor
where last_name like '%GEN';

#2c
select last_name, first_name
from actor
where last_name like '%Li%'
Order by last_name, first_name;

#2d
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3a
select *
from actor;

ALTER Table actor
Add description BLOB;

#3b 
ALTER TABLE actor
DROP COLUMN description;

#4a
select last_name, count(last_name)
from actor
group by last_name;

#4b
select last_name, count(last_name)
from actor
group by last_name
HAVING COUNT(last_name) > 1; 

#4c 
select *
from actor
where last_name like '%william%';

Update actor
Set first_name = 'HARPO'
where actor_id = 172;

#4d
Update actor
Set first_name = 'GROUCHO'
where actor_id = 172;

#5a
SHOW CREATE TABLE address;

#6a
Select first_name, last_name, address
from staff st 
join address ad
On (st.address_id = ad.address_id);

#6b 
SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff INNER JOIN payment ON
staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%';

#6c  List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, COUNT(Distinct Actor_id)
from film fil
inner join film_actor filac ON (fil.film_id = filac.film_id)
Group by title;

#6d How many copies of the film Hunchback Impossible exist in the inventory system?
select*
from inventory;
select COUNT(title)
from film
join inventory on (film.film_id = inventory.film_id)
where title = "Hunchback Impossible";

#6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, sum(p.amount) AS 'Total Paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.last_name;


#7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies
#starting with the letters K and Q whose language is English.

select title
from film 
Where title LIKE 'K%' OR title LIKE 'Q%'
AND title IN
(
SELECT title
FROM film
WHERE language_id = 1;

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select first_name, last_name
from actor
where actor_id in
(
Select actor_id
from film_actor
where film_id IN
(
Select film_id
from film
where title = 'Alone Trip'
));


#7c. You want to run an email marketing campaign in Canada,
#for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT cus.first_name, cus.last_name, cus.email
from customer cus
join address a ON (cus.address_id = a.address_id)
JOIN city cty
on (cty.city_id = a.city_id)
JOIN country 
ON (country.country_id = cty.country_id)
Where country.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
#Identify all movies categorized as family films.

Select title, description
From film
Where film_id in(
Select film_id From film_category
Where category_id In
(
Select category_id From category
Where name = "Family"
));

#7e. Display the most frequently rented movies in descending order.
Select f.title, Count(rental_id) AS 'Times Rented'
From rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
Group by f.title
Order by 'Times Rented' DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
Select s.store_id, SUM(amount) AS 'Revenue'
From payment p
Join rental r
on (p.rental_id = r.rental_id)
Join inventory i
on (i.inventory_id = r.inventory_id)
Join store s 
ON (s.store_id = i.store_id)
Group by s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
Select s.store_id, cty.city, country.country
From store s
join address a
On (s.address_id = a.address_id)
Join city cty
on (cty.city_id =a.city_id)
Join country
on (country.country_id = cty.country_id);

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
#category, film_category, inventory, payment, and rental.)

Select c.name AS 'Genre', SUM(p.amount) AS 'Gross'
From category c
Join film_category fc
on (c.category_id = fc.category_id)
join inventory i
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p 
on (r.rental_id = p.rental_id)
Group by c.name 
Order by Gross Limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_revenue AS
Select c.name AS 'Genre', SUM(p.amount) AS 'Gross'
From category c 
join film_category fc
on(c.category_id = fc.category_id)
JOIN inventory i
ON (fc.film_id = i.film_id)
JOIN rental r
ON (i.inventory_id = r.inventory_id)
join payment p 
on (r.rental_id = p.rental_id)
Group by c.name 
order by Gross limit 5;

#8b. How would you display the view that you created in 8a?
Select * from genre_revenue;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view genre_revenue;



