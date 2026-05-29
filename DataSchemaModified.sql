CREATE TABLE users (
    user_id INTEGER NOT NULL,
    login VARCHAR(30) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    user_role VARCHAR(20) NOT NULL,
    CONSTRAINT users_pk PRIMARY KEY (user_id),
    CONSTRAINT users_login_uq UNIQUE (login),
    CONSTRAINT users_email_uq UNIQUE (email),
    CONSTRAINT users_role_ck CHECK (
        user_role IN ('visitor', 'manager', 'admin')
    )
);

CREATE TABLE restaurants (
    restaurant_id INTEGER NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    restaurant_address VARCHAR(200) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    seat_capacity INTEGER NOT NULL,
    description VARCHAR(500),
    manager_id INTEGER NOT NULL
        REFERENCES users (user_id),
    CONSTRAINT restaurants_pk PRIMARY KEY (restaurant_id),
    CONSTRAINT restaurants_capacity_ck CHECK (
        seat_capacity BETWEEN 1 AND 1000
    )
);

CREATE TABLE tables (
    table_id INTEGER NOT NULL,
    table_number INTEGER NOT NULL,
    seat_count INTEGER NOT NULL,
    table_status VARCHAR(10) NOT NULL,
    restaurant_id INTEGER NOT NULL
        REFERENCES restaurants (restaurant_id),
    CONSTRAINT tables_pk PRIMARY KEY (table_id),
    CONSTRAINT tables_capacity_ck CHECK (seat_count BETWEEN 1 AND 20),
    CONSTRAINT tables_status_ck CHECK (
        table_status IN ('available', 'blocked')
    ),
    CONSTRAINT tables_number_ck CHECK (table_number > 0)
);

CREATE TABLE time_slots (
    slot_id INTEGER NOT NULL,
    slot_start TIME NOT NULL,
    slot_end TIME NOT NULL,
    duration_min INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL
        REFERENCES restaurants (restaurant_id),
    CONSTRAINT time_slots_pk PRIMARY KEY (slot_id),
    CONSTRAINT time_slots_duration_ck CHECK (duration_min = 30),
    CONSTRAINT time_slots_order_ck CHECK (slot_end > slot_start)
);

CREATE TABLE bookings (
    booking_id INTEGER NOT NULL,
    booking_date DATE NOT NULL,
    guests_count INTEGER NOT NULL,
    booking_status VARCHAR(10) NOT NULL,
    qr_code VARCHAR(20) NOT NULL,
    visitor_id INTEGER NOT NULL REFERENCES users (user_id),
    table_id INTEGER NOT NULL REFERENCES tables (table_id),
    slot_id INTEGER NOT NULL REFERENCES time_slots (slot_id),
    CONSTRAINT bookings_pk PRIMARY KEY (booking_id),
    CONSTRAINT bookings_qr_uq UNIQUE (qr_code),
    CONSTRAINT bookings_guests_ck CHECK (
        guests_count BETWEEN 1 AND 20
    ),
    CONSTRAINT bookings_status_ck CHECK (
        booking_status IN ('confirmed', 'cancelled', 'completed')
    )
);

CREATE TABLE demand_metrics (
    metric_id INTEGER NOT NULL,
    metric_date DATE NOT NULL,
    hour_of_day INTEGER NOT NULL,
    load_percent NUMERIC(5, 2) NOT NULL,
    booked_count INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL
        REFERENCES restaurants (restaurant_id),
    CONSTRAINT demand_metrics_pk PRIMARY KEY (metric_id),
    CONSTRAINT demand_metrics_hour_ck CHECK (
        hour_of_day BETWEEN 0 AND 23
    ),
    CONSTRAINT demand_metrics_load_ck CHECK (
        load_percent BETWEEN 0 AND 100
    ),
    CONSTRAINT demand_metrics_booked_ck CHECK (booked_count >= 0)
);
