CREATE TABLE users (
    user_id INTEGER NOT NULL,
    user_login VARCHAR(30) NOT NULL,
    pwd_hash VARCHAR(64) NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    user_phone VARCHAR(15),
    access_level VARCHAR(20) NOT NULL,
    CONSTRAINT users_pk PRIMARY KEY (user_id),
    CONSTRAINT users_login_uq UNIQUE (user_login),
    CONSTRAINT users_email_uq UNIQUE (user_email),
    CONSTRAINT users_level_ck CHECK (
        access_level IN ('visitor', 'manager', 'admin')
    )
);

CREATE TABLE restaurants (
    restaurant_id INTEGER NOT NULL,
    restaurant_title VARCHAR(100) NOT NULL,
    restaurant_addr VARCHAR(200) NOT NULL,
    cuisine_kind VARCHAR(50) NOT NULL,
    seat_capacity INTEGER NOT NULL,
    restaurant_info VARCHAR(500),
    manager_id INTEGER NOT NULL,
    CONSTRAINT restaurants_pk PRIMARY KEY (restaurant_id),
    CONSTRAINT restaurants_capacity_ck CHECK (
        seat_capacity BETWEEN 1 AND 1000
    )
);

CREATE TABLE tables (
    table_id INTEGER NOT NULL,
    table_num INTEGER NOT NULL,
    seat_count INTEGER NOT NULL,
    table_avail VARCHAR(10) NOT NULL,
    restaurant_id INTEGER NOT NULL,
    CONSTRAINT tables_pk PRIMARY KEY (table_id),
    CONSTRAINT tables_capacity_ck CHECK (seat_count BETWEEN 1 AND 20),
    CONSTRAINT tables_avail_ck CHECK (
        table_avail IN ('available', 'blocked')
    ),
    CONSTRAINT tables_number_ck CHECK (table_num > 0)
);

CREATE TABLE time_slots (
    slot_id INTEGER NOT NULL,
    slot_begin TIME NOT NULL,
    slot_finish TIME NOT NULL,
    slot_duration INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    CONSTRAINT time_slots_pk PRIMARY KEY (slot_id),
    CONSTRAINT time_slots_duration_ck CHECK (slot_duration = 30),
    CONSTRAINT time_slots_order_ck CHECK (slot_finish > slot_begin)
);

CREATE TABLE bookings (
    booking_id INTEGER NOT NULL,
    booking_dt DATE NOT NULL,
    guests_count INTEGER NOT NULL,
    booking_state VARCHAR(10) NOT NULL,
    qr_code VARCHAR(20) NOT NULL,
    visitor_id INTEGER NOT NULL,
    table_id INTEGER NOT NULL,
    slot_id INTEGER NOT NULL,
    CONSTRAINT bookings_pk PRIMARY KEY (booking_id),
    CONSTRAINT bookings_qr_uq UNIQUE (qr_code),
    CONSTRAINT bookings_guests_ck CHECK (guests_count BETWEEN 1 AND 20),
    CONSTRAINT bookings_state_ck CHECK (
        booking_state IN ('confirmed', 'cancelled', 'completed')
    )
);

CREATE TABLE demand_metrics (
    metric_id INTEGER NOT NULL,
    metric_dt DATE NOT NULL,
    hour_of_day INTEGER NOT NULL,
    load_pct NUMERIC(5, 2) NOT NULL,
    booked_count INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    CONSTRAINT demand_metrics_pk PRIMARY KEY (metric_id),
    CONSTRAINT demand_metrics_hour_ck CHECK (hour_of_day BETWEEN 0 AND 23),
    CONSTRAINT demand_metrics_load_ck CHECK (load_pct BETWEEN 0 AND 100),
    CONSTRAINT demand_metrics_booked_ck CHECK (booked_count >= 0)
);
