# SQL Index Optimization – alx-airbnb-database

## 🎯 Objective
Improve query performance by identifying high-usage columns and creating appropriate indexes.

---

## 🧠 Step 1: Identify High-Usage Columns

Based on common queries used in the **Airbnb database**:

| Table      | High-Usage Columns | Reason |
|-------------|-------------------|--------|
| `users`     | `email`, `name`   | Used in WHERE and ORDER BY clauses |
| `bookings`  | `user_id`, `property_id`, `start_date` | Used in JOIN and filtering |
| `properties`| `location`, `name` | Used in searches and ordering |

---

## ⚙️ Step 2: Create Indexes

```sql
-- Users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_name ON users(name);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_start_date ON bookings(start_date);

-- Properties table
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_name ON properties(name);
