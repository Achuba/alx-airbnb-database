# Database Normalization — Airbnb Database

## Objective
Apply normalization principles to ensure the Airbnb database schema is in **Third Normal Form (3NF)**.

---

## Step 1: Review of Initial Schema

### Entities and Attributes

#### **User**
- user_id: Primary Key, UUID, Indexed  
- first_name: VARCHAR, NOT NULL  
- last_name: VARCHAR, NOT NULL  
- email: VARCHAR, UNIQUE, NOT NULL  
- password_hash: VARCHAR, NOT NULL  
- phone_number: VARCHAR, NULL  
- role: ENUM (guest, host, admin), NOT NULL  
- created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

#### **Property**
- property_id: Primary Key, UUID, Indexed  
- host_id: Foreign Key → User(user_id)  
- name: VARCHAR, NOT NULL  
- description: TEXT, NOT NULL  
- location: VARCHAR, NOT NULL  
- pricepernight: DECIMAL, NOT NULL  
- created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  
- updated_at: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP  

#### **Booking**
- booking_id: Primary Key, UUID, Indexed  
- property_id: Foreign Key → Property(property_id)  
- user_id: Foreign Key → User(user_id)  
- start_date: DATE, NOT NULL  
- end_date: DATE, NOT NULL  
- total_price: DECIMAL, NOT NULL  
- status: ENUM (pending, confirmed, canceled), NOT NULL  
- created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

#### **Payment**
- payment_id: Primary Key, UUID, Indexed  
- booking_id: Foreign Key → Booking(booking_id)  
- amount: DECIMAL, NOT NULL  
- payment_date: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  
- payment_method: ENUM (credit_card, paypal, stripe), NOT NULL  

#### **Review**
- review_id: Primary Key, UUID, Indexed  
- property_id: Foreign Key → Property(property_id)  
- user_id: Foreign Key → User(user_id)  
- rating: INTEGER, CHECK (rating >= 1 AND rating <= 5), NOT NULL  
- comment: TEXT, NOT NULL  
- created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

#### **Message**
- message_id: Primary Key, UUID, Indexed  
- sender_id: Foreign Key → User(user_id)  
- recipient_id: Foreign Key → User(user_id)  
- message_body: TEXT, NOT NULL  
- sent_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

---

## Step 2: Normalization Process

### **First Normal Form (1NF)**
- Each table has a **primary key**.
- All attributes contain **atomic values** (no repeating groups or arrays).
- Example: The `location` field in the `Property` table currently stores multiple pieces of information (e.g., “Berlin, Germany”).  
  ➤ To satisfy 1NF, we should decompose `location` into smaller attributes or a separate table.

✅ Result: All tables are in **1NF**.

---

### **Second Normal Form (2NF)**
- The database is in 1NF.  
- All **non-key attributes depend on the whole primary key** (no partial dependencies).  
- None of the tables use composite primary keys; each uses a single-column UUID key.  

✅ Result: All tables are in **2NF**.

---

### **Third Normal Form (3NF)**
- The database is in 2NF.  
- No **transitive dependencies** exist (non-key attributes do not depend on other non-key attributes).

#### Adjustments:
1. **Location Decomposition**
   - The `location` column in `Property` can be split into a separate **Location** table to avoid storing city/country redundantly.  
     Example:
     ```text
     Location(location_id, address, city, state, country)
     ```
   - The `Property` table will now include `location_id` as a foreign key.

2. **Role Values**
   - The `role` ENUM in `User` is acceptable for small static roles.  
     However, for scalability, consider creating a separate **Role** lookup table.

✅ Result: The schema is now in **Third Normal Form (3NF)**.

---

## Step 3: Final Normalized Schema

### **User**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| user_id | UUID | PK | Primary key |
| first_name | VARCHAR |  |  |
| last_name | VARCHAR |  |  |
| email | VARCHAR | UNIQUE |  |
| password_hash | VARCHAR |  |  |
| phone_number | VARCHAR |  |  |
| role | ENUM / FK → Role(role_id) |  |  |
| created_at | TIMESTAMP |  |  |

### **Role**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| role_id | SERIAL / INT | PK |  |
| role_name | VARCHAR | UNIQUE | guest, host, admin |

### **Location**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| location_id | UUID | PK |  |
| address | VARCHAR |  |  |
| city | VARCHAR |  |  |
| state | VARCHAR |  |  |
| country | VARCHAR |  |  |

### **Property**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| property_id | UUID | PK |  |
| host_id | UUID | FK → User(user_id) |  |
| name | VARCHAR |  |  |
| description | TEXT |  |  |
| location_id | UUID | FK → Location(location_id) |  |
| pricepernight | DECIMAL |  |  |
| created_at | TIMESTAMP |  |  |
| updated_at | TIMESTAMP |  |  |

### **Booking**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| booking_id | UUID | PK |  |
| property_id | UUID | FK → Property(property_id) |  |
| user_id | UUID | FK → User(user_id) |  |
| start_date | DATE |  |  |
| end_date | DATE |  |  |
| total_price | DECIMAL |  |  |
| status | ENUM |  | pending, confirmed, canceled |
| created_at | TIMESTAMP |  |  |

### **Payment**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| payment_id | UUID | PK |  |
| booking_id | UUID | FK → Booking(booking_id) |  |
| amount | DECIMAL |  |  |
| payment_date | TIMESTAMP |  |  |
| payment_method | ENUM |  | credit_card, paypal, stripe |

### **Review**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| review_id | UUID | PK |  |
| property_id | UUID | FK → Property(property_id) |  |
| user_id | UUID | FK → User(user_id) |  |
| rating | INTEGER |  | 1–5 |
| comment | TEXT |  |  |
| created_at | TIMESTAMP |  |  |

### **Message**
| Column | Type | Key | Description |
|---------|------|-----|-------------|
| message_id | UUID | PK |  |
| sender_id | UUID | FK → User(user_id) |  |
| recipient_id | UUID | FK → User(user_id) |  |
| message_body | TEXT |  |  |
| sent_at | TIMESTAMP |  |  |

---

## Step 4: Outcome
After normalization:
- All entities follow **Third Normal Form (3NF)**.  
- Redundancy (especially in `location` and `role`) was reduced.  
- The design supports scalability, integrity, and efficient querying.
