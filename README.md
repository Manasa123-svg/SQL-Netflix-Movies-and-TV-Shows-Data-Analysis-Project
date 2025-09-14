# Netflix Movies and TV Shows Data Analysis using SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
 select
   type,
   count(*)
   from netflix
   group by 1
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
	where
	release_year='2020'
	and
	type='Movie'
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
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
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
  select type,
  duration 
  from netflix 
  where type='Movie'  
  and duration is not null 
  order by split_part(duration,' ',1)::int desc
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
   select *
   from
   netflix
   where to_date(date_added,'month dd,yyyy')>=current_date -interval '5 years'
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
 select * from
  (
  select *,
  unnest(string_to_array(director,',')) as director_name
  from netflix)
  where director_name='Rajiv Chilaka'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
  select *
   from netflix
   where type='TV Show'
   and
   split_part(duration,' ',1)::int >5
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
 select
   unnest(string_to_array(listed_in,',')) as content,
   count(*) as total_content
   from netflix
   group by 1
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql

select * from netflix
where type='Movie'
and
listed_in ='Documentaries'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
 select * from netflix
   where  director is null
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
	where 
	casts like '%Salman Khan%'
	and
	release_year>extract (year from current_date) -10
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
   select 
   unnest(string_to_array(casts,',')) as actors,
   count(*)
   from netflix
   where country='India'
   group by 1
   order by 2 desc
   limit 10
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql

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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



