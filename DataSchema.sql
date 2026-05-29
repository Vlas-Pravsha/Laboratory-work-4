CREATE TABLE users (
    user_id   INTEGER,
    login     VARCHAR(30),
    password_hash VARCHAR(64),
    email     VARCHAR(100),
    phone     VARCHAR(15),
    role      VARCHAR(20)
);

CREATE TABLE restaurants (
    restaurant_id INTEGER,
    name          VARCHAR(100),
    address       VARCHAR(200),
    cuisine_type  VARCHAR(50),
    capacity      INTEGER,
    description   VARCHAR(500),
    manager_id    INTEGER
);

CREATE TABLE tables (
    table_id      INTEGER,
    number        INTEGER,
    capacity      INTEGER,
    status        VARCHAR(10),
    restaurant_id INTEGER
);

CREATE TABLE time_slots (
    slot_id       INTEGER,
    start_time    TIME,
    end_time      TIME,
    duration_min  INTEGER,
    restaurant_id INTEGER
);

CREATE TABLE bookings (
    booking_id  INTEGER,
    date        DATE,
    guests_count INTEGER,
    status      VARCHAR(10),
    qr_code     VARCHAR(20),
    visitor_id  INTEGER,
    table_id    INTEGER,
    slot_id     INTEGER
);

CREATE TABLE demand_metrics (
    metric_id     INTEGER,
    date          DATE,
    hour          INTEGER,
    load_percent  NUMERIC(5, 2),
    booked_count  INTEGER,
    restaurant_id INTEGER
);

-- PRIMARY KEYS

ALTER TABLE users
    ADD CONSTRAINT users_pk PRIMARY KEY (user_id);

ALTER TABLE restaurants
    ADD CONSTRAINT restaurants_pk PRIMARY KEY (restaurant_id);

ALTER TABLE tables
    ADD CONSTRAINT tables_pk PRIMARY KEY (table_id);

ALTER TABLE time_slots
    ADD CONSTRAINT time_slots_pk PRIMARY KEY (slot_id);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_pk PRIMARY KEY (booking_id);

ALTER TABLE demand_metrics
    ADD CONSTRAINT demand_metrics_pk PRIMARY KEY (metric_id);

-- UNIQUE CONSTRAINTS

ALTER TABLE users
    ADD CONSTRAINT users_login_unique UNIQUE (login);

ALTER TABLE users
    ADD CONSTRAINT users_email_unique UNIQUE (email);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_qr_code_unique UNIQUE (qr_code);

-- NOT NULL

ALTER TABLE users ALTER COLUMN login SET NOT NULL;
ALTER TABLE users ALTER COLUMN password_hash SET NOT NULL;
ALTER TABLE users ALTER COLUMN email SET NOT NULL;
ALTER TABLE users ALTER COLUMN role SET NOT NULL;

ALTER TABLE restaurants ALTER COLUMN name SET NOT NULL;
ALTER TABLE restaurants ALTER COLUMN address SET NOT NULL;
ALTER TABLE restaurants ALTER COLUMN cuisine_type SET NOT NULL;
ALTER TABLE restaurants ALTER COLUMN capacity SET NOT NULL;
ALTER TABLE restaurants ALTER COLUMN manager_id SET NOT NULL;

ALTER TABLE tables ALTER COLUMN number SET NOT NULL;
ALTER TABLE tables ALTER COLUMN capacity SET NOT NULL;
ALTER TABLE tables ALTER COLUMN status SET NOT NULL;
ALTER TABLE tables ALTER COLUMN restaurant_id SET NOT NULL;

ALTER TABLE time_slots ALTER COLUMN start_time SET NOT NULL;
ALTER TABLE time_slots ALTER COLUMN end_time SET NOT NULL;
ALTER TABLE time_slots ALTER COLUMN duration_min SET NOT NULL;
ALTER TABLE time_slots ALTER COLUMN restaurant_id SET NOT NULL;

ALTER TABLE bookings ALTER COLUMN date SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN guests_count SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN status SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN qr_code SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN visitor_id SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN table_id SET NOT NULL;
ALTER TABLE bookings ALTER COLUMN slot_id SET NOT NULL;

ALTER TABLE demand_metrics ALTER COLUMN date SET NOT NULL;
ALTER TABLE demand_metrics ALTER COLUMN hour SET NOT NULL;
ALTER TABLE demand_metrics ALTER COLUMN load_percent SET NOT NULL;
ALTER TABLE demand_metrics ALTER COLUMN booked_count SET NOT NULL;
ALTER TABLE demand_metrics ALTER COLUMN restaurant_id SET NOT NULL;

-- FOREIGN KEYS

ALTER TABLE restaurants
    ADD CONSTRAINT restaurants_manager_fk
    FOREIGN KEY (manager_id) REFERENCES users (user_id);

ALTER TABLE tables
    ADD CONSTRAINT tables_restaurant_fk
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id);

ALTER TABLE time_slots
    ADD CONSTRAINT time_slots_restaurant_fk
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_visitor_fk
    FOREIGN KEY (visitor_id) REFERENCES users (user_id);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_table_fk
    FOREIGN KEY (table_id) REFERENCES tables (table_id);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_slot_fk
    FOREIGN KEY (slot_id) REFERENCES time_slots (slot_id);

ALTER TABLE demand_metrics
    ADD CONSTRAINT demand_metrics_restaurant_fk
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id);

-- CHECK CONSTRAINTS

ALTER TABLE users
    ADD CONSTRAINT users_role_check
    CHECK (role IN ('visitor', 'manager', 'admin'));

ALTER TABLE users
    ADD CONSTRAINT users_email_check
    CHECK (email ~ '^[a-z0-9][a-z0-9._-]*@[a-z][a-z0-9._-]*\.[a-z]{2,4}$');

ALTER TABLE users
    ADD CONSTRAINT users_phone_check
    CHECK (phone ~ '^(\([0-9]{3}\))?[0-9]{3}-[0-9]{4}$');

ALTER TABLE restaurants
    ADD CONSTRAINT restaurants_capacity_check
    CHECK (capacity BETWEEN 1 AND 1000);

ALTER TABLE tables
    ADD CONSTRAINT tables_capacity_check
    CHECK (capacity BETWEEN 1 AND 20);

ALTER TABLE tables
    ADD CONSTRAINT tables_status_check
    CHECK (status IN ('available', 'blocked'));

ALTER TABLE tables
    ADD CONSTRAINT tables_number_check
    CHECK (number > 0);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_guests_check
    CHECK (guests_count BETWEEN 1 AND 20);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_status_check
    CHECK (status IN ('confirmed', 'cancelled', 'completed'));

ALTER TABLE bookings
    ADD CONSTRAINT bookings_qr_code_check
    CHECK (qr_code ~ '^BK-[0-9]{4}-[0-9]{5}$');

ALTER TABLE time_slots
    ADD CONSTRAINT time_slots_duration_check
    CHECK (duration_min = 30);

ALTER TABLE time_slots
    ADD CONSTRAINT time_slots_order_check
    CHECK (end_time > start_time);

ALTER TABLE demand_metrics
    ADD CONSTRAINT demand_metrics_hour_check
    CHECK (hour BETWEEN 0 AND 23);

ALTER TABLE demand_metrics
    ADD CONSTRAINT demand_metrics_load_check
    CHECK (load_percent BETWEEN 0 AND 100);

ALTER TABLE demand_metrics
    ADD CONSTRAINT demand_metrics_booked_check
    CHECK (booked_count >= 0);
