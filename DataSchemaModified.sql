CREATE TABLE users (
    user_id INTEGER NOT NULL,
    user_login VARCHAR(30) NOT NULL,
    pwd_hash VARCHAR(64) NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    user_phone VARCHAR(15),
    access_level VARCHAR(20) NOT NULL,
    PRIMARY KEY (user_id),
    UNIQUE (user_login),
    UNIQUE (user_email),
    CHECK (access_level IN ('visitor', 'manager', 'admin'))
);

CREATE TABLE restaurants (
    restaurant_id INTEGER NOT NULL,
    restaurant_title VARCHAR(100) NOT NULL,
    restaurant_addr VARCHAR(200) NOT NULL,
    cuisine_kind VARCHAR(50) NOT NULL,
    seat_capacity INTEGER NOT NULL,
    restaurant_info VARCHAR(500),
    manager_id INTEGER NOT NULL,
    PRIMARY KEY (restaurant_id),
    CHECK (seat_capacity BETWEEN 1 AND 1000)
);

CREATE TABLE tables (
    table_id INTEGER NOT NULL,
    table_num INTEGER NOT NULL,
    seat_count INTEGER NOT NULL,
    table_avail VARCHAR(10) NOT NULL,
    restaurant_id INTEGER NOT NULL,
    PRIMARY KEY (table_id),
    CHECK (seat_count BETWEEN 1 AND 20),
    CHECK (table_avail IN ('available', 'blocked')),
    CHECK (table_num > 0)
);

CREATE TABLE time_slots (
    slot_id INTEGER NOT NULL,
    slot_start_tm TIME NOT NULL,
    slot_finish TIME NOT NULL,
    slot_duration INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    PRIMARY KEY (slot_id),
    CHECK (slot_duration = 30),
    CHECK (slot_finish > slot_start_tm)
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
    PRIMARY KEY (booking_id),
    UNIQUE (qr_code),
    CHECK (guests_count BETWEEN 1 AND 20),
    CHECK (booking_state IN ('confirmed', 'cancelled', 'completed'))
);

CREATE TABLE demand_metrics (
    metric_id INTEGER NOT NULL,
    metric_dt DATE NOT NULL,
    hour_of_day INTEGER NOT NULL,
    load_pct NUMERIC(5, 2) NOT NULL,
    booked_count INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    PRIMARY KEY (metric_id),
    CHECK (hour_of_day BETWEEN 0 AND 23),
    CHECK (load_pct BETWEEN 0 AND 100),
    CHECK (booked_count >= 0)
);
