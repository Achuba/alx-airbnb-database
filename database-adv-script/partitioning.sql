-- ==============================================================
--  TABLE PARTITIONING SCRIPT
--  Objective: Optimize query performance on large Booking table
-- ==============================================================

-- 1️⃣ Drop existing table copy if necessary (for testing)
DROP TABLE IF EXISTS bookings_partitioned CASCADE;

-- 2️⃣ Create a partitioned version of the bookings table
-- Partition by RANGE on start_date
CREATE TABLE bookings_partitioned (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
PARTITION BY RANGE (start_date);


-- 3️⃣ Create partitions by year (example: 2022–2026)
CREATE TABLE bookings_2022 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2100-01-01');


-- 4️⃣ Indexes on partitioned table for performance
CREATE INDEX idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_partitioned_start_date ON bookings_partitioned(start_date);


-- 5️⃣ Example query to test performance on partitioned table
EXPLAIN ANALYZE
SELECT 
    id, user_id, property_id, start_date, end_date, total_amount
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30'
ORDER BY start_date ASC;


-- 6️⃣ Comparison query (non-partitioned version)
-- Use same EXPLAIN ANALYZE on the original bookings table
EXPLAIN ANALYZE
SELECT 
    id, user_id, proper_
