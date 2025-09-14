

create database netflix;

DROP TABLE IF EXISTS NETFLIX;

CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(100),
	listed_in	VARCHAR(400),
	description VARCHAR(550)
);

select * from netflix;

select count(*) from netflix

--find the null values

select count(*) from netflix
where 
show_id is null
or
type is null
or
title is null
or
director is null
or
casts is null
or 
country is null
or
date_added is null
or 
release_year is null
or 
rating is null
or 
duration is null
or
listed_in is null
or
description is null


'''1. Count the number of Movies vs TV Shows'''

   select
   type,
   count(*)
   from netflix
   group by 1

 '''2. Find the most common rating for movies and TV shows'''


    select
	type,
	rating,
	rating_count
	from
	(
    select
	type,
	rating,
	count(*) as rating_count,
	rank() over(partition by type order by count(*) desc) as rk
	from netflix
	group by 1,2
	order by 3 desc) as x
	where rk=1

   
   


'''3. List all movies released in a specific year (e.g., 2020)'''

	select * from netflix
	where
	release_year='2020'
	and
	type='Movie'

'''4. Find the top 5 countries with the most content on Netflix'''

    select * from
	(
	select
	unnest(string_to_array(country,',')) as country,
	count(*) as total_content
	from netflix
	group by 1) as x
	where country is not null
	order by 2 desc
	limit 5

'''5. Identify the longest movie'''

  select type,
  duration 
  from netflix 
  where type='Movie'  
  and duration is not null 
  order by split_part(duration,' ',1)::int desc



'''6. Find content added in the last 5 years'''

   select * from
   netflix
   where to_date(date_added,'month dd,yyyy')>=current_date -interval '5 years'

'''7. Find all the movies/TV shows by director 'Rajiv Chilaka'!'''

  select * from
  (
  select *,
  unnest(string_to_array(director,',')) as director_name
  from netflix)
  where director_name='Rajiv Chilaka'
  
'''8. List all TV shows with more than 5 seasons'''

   select *
   from netflix
   where type='TV Show'
   and
   split_part(duration,' ',1)::int >5
   

'''9. Count the number of content items in each genre'''

   select
   unnest(string_to_array(listed_in,',')) as content,
   count(*) as total_content
   from netflix
   group by 1

   
1'''0.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release! '''

   SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100,1 
		
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release desc
limit 5

   
'''11. List all movies that are documentaries'''

select * from netflix
where type='Movie'
and
listed_in ='Documentaries'

'''12. Find all content without a director'''

   select * from netflix
   where  director is null
   
'''13. Find how many movies actor 'Salman Khan' appeared in last 10 years!'''

	select * from netflix
	where 
	casts like '%Salman Khan%'
	and
	release_year>extract (year from current_date) -10

'''14. Find the top 10 actors who have appeared in the highest number of movies produced in India.'''

   select 
   unnest(string_to_array(casts,',')) as actors,
   count(*)
   from netflix
   where country='India'
   group by 1
   order by 2 desc
   limit 10

   

'''15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.'''

select
content,
type,
count(*)
from
(
select *,
case
when description like '%Kill%' or description like '%violence%' then 'bad '
else 'Good'
end as content
from netflix) 
group by 1,2
order by 3


