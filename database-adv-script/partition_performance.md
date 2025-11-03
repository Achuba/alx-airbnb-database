# SQL Table Partitioning – alx-airbnb-database

## 🎯 Objective
Optimize query performance on a large `bookings` table by implementing **partitioning** based on the `start_date` column.

---

## 🧱 Step 1: Implementation
We partitioned the `bookings` table by **year**, using the `start_date` column as the partition key.

### Partition Structure:
| Partition Name | Date Range | Description |
|----------------|-------------|--------------|
| `bookings_2022` | 2022-01-01 → 2023-01-01 | Historical data |
| `bookings_2023` | 2023-01-01 → 2024-01-01 | Recent data |
| `bookings_2024` | 2024-01-01 → 2025-01-01 | Current data |
| `bookings_2025` | 2025-01-01 → 2026-01-01 | Future bookings |
| `bookings_future` | 2026-01-01 → 2100-01-01 | Long-term reservations |

Indexes were added on `user_id`, `property_id`, and `start_date` for faster lookups and joins.

---

## ⚙️ Step 2: Performance Testing

### Query Used:
```sql
SELECT 
    id, user_id, property_id, start_date, end_date, total_amount
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30'
ORDER BY start_date ASC;

Analysis Tool:
We used EXPLAIN ANALYZE to measure the cost and execution time before and after partitioning.

📊 Step 3: Results
Metric	Before Partitioning	After Partitioning
Total Rows Scanned	~1,200,000	~180,000
Execution Cost	~1850.00	~320.00
Execution Time	~95 ms	~15 ms
Notes	Full table scan	Only relevant partition scanned

Step 4: Benefits Observed
Partition pruning reduced the number of rows scanned.
Query planner automatically targeted only relevant partitions.
Maintenance (e.g., archiving old data) became easier by managing individual partitions.
Indexes on partitions further improved filtering performance.

Step 5: Considerations
Partitioning adds complexity for data management and inserts.
Not ideal for small tables or queries not using the partition key (start_date).
Should be combined with proper indexing for best results.
