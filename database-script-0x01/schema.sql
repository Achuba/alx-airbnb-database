-- Airbnb Database Schema
-- Objective: Define all entities, constraints, and indexes according to the 3NF design.

-- Drop tables if they already exist (for development purposes)
DROP TABLE IF EXISTS Message, Review, Payment, Booking, Property, Location, Role, "User" CASCADE;

-- ========================
-- Table: Role
-- ========================
CREATE TABLE Role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- ========================
-- Table: User
-- ========================
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role_id INT REFERENCES Role(role_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON "User"(email);

-- ========================
-- Table: Location
-- ========================
CREATE TABLE Location (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE INDEX idx_location_city ON Location(city);
CREATE INDEX idx_location_country ON Location(country);

-- ========================
-- Table: Property
-- ========================
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location_id UUID REFERENCES Location(location_id) ON DELETE SET NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location_id);

-- ========================
-- Table: Booking
-- ========================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_property ON Booking(property_id);

-- ========================
-- Table: Payment
-- ========================
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES Booking(booking_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')) NOT NULL
);

CREATE INDEX idx_payment_booking ON Payment(booking_id);

-- ========================
-- Table: Review
-- ========================
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES Property(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_review_user ON Review(user_id);

-- ========================
-- Table: Message
-- ========================
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES "User"(user_id) ON DELETE CASCADE,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_message_sender ON Message(sender_id);
CREATE INDEX idx_message_recipient ON Message(recipient_id);

-- ========================
-- Default Role Values
-- ========================
INSERT INTO Role (role_name)
VALUES ('guest'), ('host'), ('admin');
