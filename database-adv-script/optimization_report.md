# SQL Query Optimization Report – alx-airbnb-database

## 🎯 Objective
Refactor complex queries to improve performance by reducing unnecessary joins, selecting only required columns, and leveraging indexes.

---

## 🧪 Step 1: Initial Query

### Query
```sql
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
ORDER BY pay.payment_date DESC;


Step 2: Optimization Strategy
Identified Issues:
Unnecessary columns (u.email, p.location) increased I/O.
All INNER JOINs forced full scans even when some tables had missing relationships.
Missing indexes on payments.payment_date and payments.booking_id.
Solutions Implemented:
Selected only required columns.
Converted JOIN payments to LEFT JOIN (since some bookings might not have payments yet).
Added indexes to optimize JOIN and ORDER BY.
Applied WHERE pay.amount IS NOT NULL to filter relevant results efficiently.

Step 3: Optimized Query
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
ORDER BY pay.payment_date DESC;

Step 4: Indexes Used
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_payment_date ON payments(payment_date);

