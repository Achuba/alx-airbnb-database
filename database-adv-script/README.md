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
