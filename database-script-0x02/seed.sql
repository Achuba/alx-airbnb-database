-- Airbnb Database Sample Data
-- Objective: Populate the database with realistic sample data for testing and demonstration.

-- Ensure UUID generation is supported
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ========================
-- Insert Roles
-- ========================
INSERT INTO Role (role_name)
VALUES ('guest'), ('host'), ('admin')
ON CONFLICT (role_name) DO NOTHING;

-- ========================
-- Insert Users
-- ========================
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role_id)
VALUES
    (gen_random_uuid(), 'Alice', 'Johnson', 'alice@example.com', 'hashed_password_1', '+4915123456789', 1),
    (gen_random_uuid(), 'Bob', 'Williams', 'bob@example.com', 'hashed_password_2', '+4915123456790', 2),
    (gen_random_uuid(), 'Charlie', 'Smith', 'charlie@example.com', 'hashed_password_3', '+4915123456791', 1),
    (gen_random_uuid(), 'Diana', 'Brown', 'diana@example.com', 'hashed_password_4', '+4915123456792', 2),
    (gen_random_uuid(), 'Ethan', 'Clark', 'ethan@example.com', 'hashed_password_5', '+4915123456793', 3);

-- ========================
-- Insert Locations
-- ========================
INSERT INTO Location (location_id, address, city, state, country)
VALUES
    (gen_random_uuid(), '123 Main St', 'Berlin', 'Berlin', 'Germany'),
    (gen_random_uuid(), '45 Rue de Paris', 'Paris', 'Île-de-France', 'France'),
    (gen_random_uuid(), '10 Market Square', 'London', 'England', 'UK'),
    (gen_random_uuid(), '99 Ocean Drive', 'Lisbon', 'Lisbon', 'Portugal');

-- ========================
-- Insert Properties
-- ========================
-- Host Bob and Diana each own properties
INSERT INTO Property (property_id, host_id, name, description, location_id, price_per_night)
SELECT gen_random_uuid(), u.user_id, 'Cozy Apartment in Berlin', 'Modern 1-bedroom apartment near city center.', l.location_id, 95.00
FROM "User" u
JOIN Location l ON l.city = 'Berlin'
WHERE u.email = 'bob@example.com'
UNION ALL
SELECT gen_random_uuid(), u.user_id, 'Paris Loft', 'Stylish loft with Eiffel Tower view.', l.location_id, 160.00
FROM "User" u
JOIN Location l ON l.city = 'Paris'
WHERE u.email = 'diana@example.com'
UNION ALL
SELECT gen_random_uuid(), u.user_id, 'London Townhouse', 'Spacious townhouse near the Thames.', l.location_id, 180.00
FROM "User" u
JOIN Location l ON l.city = 'London'
WHERE u.email = 'diana@example.com';

-- ========================
-- Insert Bookings
-- ========================
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-07-01', '2025-07-05', 380.00, 'confirmed'
FROM Property p, "User" u
WHERE p.name = 'Cozy Apartment in Berlin' AND u.email = 'alice@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-08-10', '2025-08-15', 800.00, 'pending'
FROM Property p, "User" u
WHERE p.name = 'Paris Loft' AND u.email = 'charlie@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, '2025-09-01', '2025-09-03', 360.00, 'confirmed'
FROM Property p, "User" u
WHERE p.name = 'London Townhouse' AND u.email = 'alice@example.com';

-- ========================
-- Insert Payments
-- ========================
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
SELECT gen_random_uuid(), b.booking_id, b.total_price, 'credit_card'
FROM Booking b
WHERE b.status = 'confirmed'
UNION ALL
SELECT gen_random_uuid(), b.booking_id, b.total_price, 'paypal'
FROM Booking b
WHERE b.status = 'pending';

-- ========================
-- Insert Reviews
-- ========================
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'Fantastic stay! Highly recommended.'
FROM Property p, "User" u
WHERE p.name = 'Cozy Apartment in Berlin' AND u.email = 'alice@example.com'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 4, 'Beautiful apartment, great location.'
FROM Property p, "User" u
WHERE p.name = 'Paris Loft' AND u.email = 'charlie@example.com';

-- ========================
-- Insert Messages
-- ========================
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Hi Bob, I loved staying at your Berlin apartment!'
FROM "User" u1, "User" u2
WHERE u1.email = 'alice@example.com' AND u2.email = 'bob@example.com'
UNION ALL
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Thanks Alice! You’re welcome anytime.'
FROM "User" u1, "User" u2
WHERE u1.email = 'bob@example.com' AND u2.email = 'alice@example.com';
