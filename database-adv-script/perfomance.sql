-- ==============================================================
--  PERFORMANCE TESTING SCRIPT
--  Objective: Refactor complex queries to improve performance
-- ==============================================================


-- 1️⃣ Initial (Unoptimized) Query
-- Retrieves all bookings with user, property, and payment details

EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    u.name AS user_name,
    u.email AS user_email,
    p.name AS property_name,
    p.location,
    pay.amount,
    pay.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id
WHERE pay.amount > 0
AND pay.status = 'completed'
ORDER BY pay.payment_date DESC;


-- ==============================================================
-- 2️⃣ Refactored (Optimized) Query
-- Goal: Reduce execution time by removing unnecessary columns,
-- applying proper indexing, and avoiding redundant joins.
-- ==============================================================

EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    u.name AS user_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_date
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE pay.amount IS NOT NULL
AND pay.status = 'completed'
ORDER BY pay.payment_date DESC;


-- ==============================================================
-- 3️⃣ Index Recommendations
-- These should already exist if database_index.sql was executed,
-- but they are repeated here for clarity.
-- ==============================================================

-- Users
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id);

-- Bookings
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);

-- Payments
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
