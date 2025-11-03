-- ==============================================================
--  DATABASE INDEX CREATION SCRIPT
--  Objective: Improve query performance using indexes
-- ==============================================================

-- 1️⃣ Create index on Users table
-- Frequently used in WHERE, JOIN, and ORDER BY clauses
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_name ON users(name);

-- 2️⃣ Create index on Bookings table
-- user_id and property_id are commonly used in JOIN and WHERE conditions
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_start_date ON bookings(start_date);

-- 3️⃣ Create index on Properties table
-- Often used in filters and joins
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_name ON properties(name);

-- ==============================================================
--  Performance Analysis
-- ==============================================================

-- Example: Check query performance before and after indexing

-- Before adding indexes
EXPLAIN ANALYZE
SELECT u.name, b.start_date, b.end_date, p.name
FROM users u
JOIN bookings b ON u.id = b.user_id
JOIN properties p ON b.property_id = p.id
WHERE u.email = 'example@email.com';

-- After adding indexes
-- Run the same EXPLAIN ANALYZE command and compare cost/time
