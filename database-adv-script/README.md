# SQL Joins Practice – alx-airbnb-database

## Objective
This project demonstrates the use of different types of SQL joins to combine data from multiple tables.

## Queries

### 1. INNER JOIN
Retrieves all bookings along with the users who made them.
```sql
SELECT bookings.id, users.name, bookings.property_id, bookings.start_date, bookings.end_date
FROM bookings
INNER JOIN users ON bookings.user_id = users.id;


### 2. LEFT JOIN
Retrieves all properties and their reviews, including those properties without any reviews.
SELECT properties.id, properties.name, reviews.rating, reviews.comment
FROM properties
LEFT JOIN reviews ON properties.id = reviews.property_id;


### 3. FULL OUTER JOIN
Retrieves all users and all bookings — includes users without bookings and bookings without users.
SELECT users.id, users.name, bookings.id, bookings.start_date
FROM users
FULL OUTER JOIN bookings ON users.id = bookings.user_id;


# SQL Subqueries Practice – alx-airbnb-database

## Objective
This exercise demonstrates how to use correlated and non-correlated subqueries.

### 1. Non-correlated Subquery
Find all properties where the average review rating is greater than 4.0.
```sql
SELECT p.id, p.name
FROM properties p
WHERE p.id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
);


### 2. Correlated Subquery
SELECT u.id, u.name
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3;


### Aggregation Query
Find the total number of bookings made by each user.
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b
    ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC, u.name ASC;

###Window Function Query
Rank properties based on how many bookings they’ve received.
SELECT 
    p.id AS property_id,
    p.name AS property_name,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank
FROM properties p
LEFT JOIN bookings b
    ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY booking_rank ASC, property_name ASC;



