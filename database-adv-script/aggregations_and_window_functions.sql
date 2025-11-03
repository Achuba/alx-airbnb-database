-- 1️⃣ Aggregation Query:
-- Find the total number of bookings made by each user using COUNT and GROUP BY

SELECT 
    u.id AS user_id,
    u.name AS user_name,
    COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b
    ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC, u.name ASC;



-- 2️⃣ Window Function Query (RANK and ROW_NUMBER):
-- Rank properties based on the total number of bookings they have received
-- Include both ROW_NUMBER() and RANK() for comparison

SELECT 
    p.id AS property_id,
    p.name AS property_name,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.id) DESC) AS booking_row_number
FROM properties p
LEFT JOIN bookings b
    ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY booking_rank ASC, property_name ASC;
