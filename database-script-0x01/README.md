# Airbnb Database Schema — SQL Implementation

## Objective
Define the Airbnb database schema using SQL, ensuring all tables, relationships, and constraints adhere to **Third Normal Form (3NF)**.

---

## Description
This SQL script (`schema.sql`) creates the full Airbnb relational database structure with properly defined:
- Primary and foreign keys
- Unique and check constraints
- Indexed columns for performance optimization

The schema includes entities such as:
- **User** (with roles)
- **Property**
- **Booking**
- **Payment**
- **Review**
- **Message**
- **Location**
- **Role**

---

## Key Features
- **Normalization:** Database fully adheres to 3NF design principles.
- **Constraints:** Enforced data integrity through PK, FK, UNIQUE, and CHECK constraints.
- **Indexes:** Optimized frequently queried columns (email, foreign keys, city, etc.).
- **Referential Actions:** `ON DELETE CASCADE` and `ON DELETE SET NULL` ensure relational consistency.

---

## Usage

### 1️⃣ Create the Database
```sql
CREATE DATABASE airbnb_db;
\c airbnb_db;
