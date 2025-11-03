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
