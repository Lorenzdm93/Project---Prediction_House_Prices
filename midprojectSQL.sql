create database if not exists house_price_regression;
use house_price_regression;

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS=0;
SHOW VARIABLES LIKE "secure_file_priv";


SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

select * from house_price_data
limit 10;

drop table if exists house_price_data;
CREATE TABLE house_price_data (
  `id` varchar(24) NOT NULL,
  `date` varchar(24) DEFAULT NULL,
  `bedrooms` int(4) DEFAULT NULL,
  `bathrooms` float DEFAULT NULL,
  `sqft_living` float DEFAULT NULL,
  `sqft_lot` float DEFAULT NULL,
  `floors` float DEFAULT NULL,
  `waterfront` int(4) DEFAULT NULL,
  `view` int(4) DEFAULT NULL,
  `condition` int(4) DEFAULT NULL,
  `grade` int(4) DEFAULT NULL,
  `sqft_above` float DEFAULT NULL,
  `sqft_basement` float DEFAULT NULL,
  `yr_built` int(11) DEFAULT NULL,
  `yr_renovated` int(11) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lon` float DEFAULT NULL,
  `sqft_living15` float DEFAULT NULL,
  `sqft_lot15` float DEFAULT NULL,
  `price` int(12) DEFAULT NULL
  -- CONSTRAINT PRIMARY KEY (`id`)  -- constraint keyword is optional but its a good practice
);

load data local infile 'C:/Users/Lorenzo/IronHack/DATACAMP/week5/project_regression_data_clean.csv'
into table house_price_data
fields terminated BY ',';

select * from house_price_data;

select count(*) from house_price_data;

#Use the alter table command to drop the column date from the database, 
#as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

alter table house_price_data
drop column date;

#Use sql query to find how many rows of data you have
select count(*) from house_price_data;

#What are the unique values in the column __ ?
select distinct bedrooms from house_price_data
order by bedrooms;

select distinct bathrooms from house_price_data
order by bathrooms;

select distinct floors from house_price_data
order by floors;

select distinct house_price_data.condition from house_price_data
order by house_price_data.condition;

select distinct grade from house_price_data
order by grade;

#Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

select * from house_price_data
order by price desc
limit 10;

#What is the average price of all the properties in your data?
select avg(price) from house_price_data;

#10.What is the average price of the houses grouped by bedrooms?
select bedrooms, round(avg(price)) as average from house_price_data
group by bedrooms
order by bedrooms, average;

#10.What is the average sqft_living of the houses grouped by bedrooms?
select bedrooms, round(avg(sqft_living)) as average from house_price_data
group by bedrooms
order by bedrooms, average;

#10.What is the average price of the houses with a waterfront and without a waterfront?
select waterfront, round(avg(price)) as average from house_price_data
group by waterfront
order by waterfront, average;

#10.Is there any correlation between the columns condition and grade? 
select house_price_data.condition, avg(grade) from house_price_data
group by house_price_data.condition
order by house_price_data.condition;

#One of the customers is only interested in the following houses:
#Number of bedrooms either 3 or 4
#Bathrooms more than 3
#One Floor
#No waterfront
#Condition should be 3 at least
#Grade should be 5 at least
#Price less than 300000

select * from house_price_data
where bedrooms in (3 , 4)
and bathrooms >= 3 -- no results with > 3 but many with >=
and floors = 1 
and waterfront = 0 
and house_price_data.condition >= 3 
and grade >= 5 
and price < 300000
order by price;

#Your manager wants to find out the list 
#of properties whose prices are twice more than the average of all the properties in the database. 
#Write a query to show them the list of such properties. You might need to use a sub query for this problem.

select * from house_price_data
where price > 2*(select avg(price) from house_price_data);

#Since this is something that the senior management is regularly interested in, create a view of the same query
CREATE VIEW 2xavg AS
select * from house_price_data
where price > 2*(select avg(price) from house_price_data);

#Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?
SELECT bedrooms, round(avg(price),0), avg(price) - lag(avg(price),1) OVER (ORDER BY bedrooms) AS Difference
FROM house_price_data
WHERE bedrooms in (3, 4)
group by bedrooms;

#What are the different locations where properties are available in your database?
select distinct zip_code, count(id) as num_properties from house_price_data
group by zip_code
order by zip_code asc;

#Show the list of all the properties that were renovated
select * from house_price_data
where yr_renovated <> 0
order by yr_renovated;

#Provide the details of the property that is the 11th most expensive property in your database
select * from house_price_data
order by price desc
limit 1 offset 10;