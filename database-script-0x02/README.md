# Airbnb Database — Sample Data Seeding

## Objective
Populate the Airbnb database with **realistic sample data** for testing and demonstration.

---

## Description
This script (`seed.sql`) inserts meaningful records for all tables:
- Roles (guest, host, admin)
- Users (hosts, guests, admin)
- Locations (cities in Europe)
- Properties (linked to hosts)
- Bookings (linked to guests and properties)
- Payments (for confirmed bookings)
- Reviews (user feedback)
- Messages (host–guest communication)

---

## Usage

### 1️⃣ Ensure Schema Exists
First, create the schema using:
```bash
psql -U your_username -d airbnb_db -f ../database-script-0x01/schema.sql
