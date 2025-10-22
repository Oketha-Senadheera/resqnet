-- Schema definition for core ResQNet tables

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL,
    role ENUM('general', 'volunteer', 'ngo', 'grama_niladhari', 'dmc') NOT NULL,
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS volunteers (
    user_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    age INT,
    gender ENUM('male', 'female', 'other'),
    contact_number VARCHAR(20),
    house_no VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(100),
    district VARCHAR(100),
    gn_division VARCHAR(100),
    CONSTRAINT fk_volunteers_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS general_user (
    user_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_number VARCHAR(20),
    house_no VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(100),
    district VARCHAR(100),
    gn_division VARCHAR(100),
    sms_alert TINYINT(1) DEFAULT 0,
    CONSTRAINT fk_general_user_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_skills_name (skill_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS skills_volunteers (
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (user_id, skill_id),
    CONSTRAINT fk_skills_volunteers_volunteer FOREIGN KEY (user_id) REFERENCES volunteers (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_skills_volunteers_skill FOREIGN KEY (skill_id) REFERENCES skills (skill_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS volunteer_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    preference_name VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_preferences_name (preference_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS volunteer_preference_volunteers (
    user_id INT NOT NULL,
    preference_id INT NOT NULL,
    PRIMARY KEY (user_id, preference_id),
    CONSTRAINT fk_vpv_volunteer FOREIGN KEY (user_id) REFERENCES volunteers (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_vpv_preference FOREIGN KEY (preference_id) REFERENCES volunteer_preferences (preference_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS ngos (
    user_id INT PRIMARY KEY,
    organization_name VARCHAR(150) NOT NULL,
    registration_number VARCHAR(100) NOT NULL,
    years_of_operation INT,
    address VARCHAR(255),
    contact_person_name VARCHAR(100),
    contact_person_telephone VARCHAR(20),
    contact_person_email VARCHAR(150),
    CONSTRAINT fk_ngos_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS grama_niladhari (
    user_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_number VARCHAR(20),
    address VARCHAR(255),
    gn_division VARCHAR(100),
    service_number VARCHAR(50),
    gn_division_number VARCHAR(50),
    CONSTRAINT fk_gn_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    token VARCHAR(64) PRIMARY KEY,
    user_id INT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_prt_user_expires (user_id, expires_at),
    CONSTRAINT fk_password_reset_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS collection_points (
    collection_point_id INT AUTO_INCREMENT PRIMARY KEY,
    ngo_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    location_landmark VARCHAR(150),
    full_address VARCHAR(255) NOT NULL,
    contact_person VARCHAR(100),
    contact_number VARCHAR(20),
    CONSTRAINT fk_collection_point_ngo FOREIGN KEY (ngo_id)
        REFERENCES ngos (user_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE IF NOT EXISTS donation_items_catalog (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category ENUM('Medicine', 'Food', 'Shelter') NOT NULL,
    UNIQUE KEY uq_item_name (item_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE IF NOT EXISTS donation_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                        
    relief_center_name VARCHAR(150) NOT NULL,                                    -- verifying GN officer (from grama_niladhari)
    status ENUM('Pending', 'Approved') DEFAULT 'Pending',
    special_notes TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP NULL,
    approved_at TIMESTAMP NULL,
    CONSTRAINT fk_donation_request_user FOREIGN KEY (user_id)
        REFERENCES general_user (user_id)
        ON DELETE CASCADE,
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE IF NOT EXISTS donation_request_items (
    request_item_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    CONSTRAINT fk_donation_items_request FOREIGN KEY (request_id)
        REFERENCES donation_requests (request_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_donation_items_catalog FOREIGN KEY (item_id)
        REFERENCES donation_items_catalog (item_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS disaster_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reporter_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    disaster_type ENUM('Flood', 'Landslide', 'Fire', 'Earthquake', 'Tsunami', 'Other') NOT NULL,
    other_disaster_type VARCHAR(100) DEFAULT NULL,
    disaster_datetime DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    proof_image_path VARCHAR(255) DEFAULT NULL,
    confirmation BOOLEAN NOT NULL DEFAULT TRUE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    description TEXT DEFAULT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP NULL,
    CONSTRAINT fk_disaster_report_user FOREIGN KEY (user_id)
        REFERENCES general_user (user_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Donations table: stores donation submissions from general users
CREATE TABLE IF NOT EXISTS donations (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                                 -- from general_user
    collection_point_id INT NOT NULL,                     -- from collection_points

    name VARCHAR(150) NOT NULL,                           -- autofilled from general_user
    contact_number VARCHAR(20) NOT NULL,                  -- autofilled
    email VARCHAR(150) NOT NULL,                          -- autofilled
    address VARCHAR(255) NOT NULL,                        -- concatenated (house_no + street + city + district)

    collection_date DATE NOT NULL,
    time_slot ENUM('9am–12pm', '12pm–4pm', '6pm–9pm') NOT NULL,

    special_notes TEXT DEFAULT NULL,
    confirmation BOOLEAN NOT NULL DEFAULT TRUE,            -- must be ticked before submitting
    status ENUM('Pending', 'Received', 'Cancelled', 'Delivered') DEFAULT 'Pending',

    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    received_at TIMESTAMP NULL,
    cancelled_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,

    CONSTRAINT fk_donations_user FOREIGN KEY (user_id)
        REFERENCES general_user (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_donations_collection_point FOREIGN KEY (collection_point_id)
        REFERENCES collection_points (collection_point_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Donation Items table: stores items in each donation
CREATE TABLE IF NOT EXISTS donation_items (
    donation_item_id INT AUTO_INCREMENT PRIMARY KEY,
    donation_id INT NOT NULL,
    item_id INT NOT NULL,                                 -- from donation_items_catalog
    quantity INT NOT NULL CHECK (quantity > 0),

    CONSTRAINT fk_donation_items_donation FOREIGN KEY (donation_id)
        REFERENCES donations (donation_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_donation_items_catalog_item FOREIGN KEY (item_id)
        REFERENCES donation_items_catalog (item_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Inventory table: maintains the NGO's stock of received items
CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    ngo_id INT NOT NULL,                                  -- from ngos
    collection_point_id INT NOT NULL,                     -- from collection_points
    item_id INT NOT NULL,                                 -- from donation_items_catalog
    quantity INT DEFAULT 0 CHECK (quantity >= 0),

    status ENUM('In Stock', 'Low on Stock', 'Out of Stock') GENERATED ALWAYS AS (
        CASE
            WHEN quantity = 0 THEN 'Out of Stock'
            WHEN quantity < 20 THEN 'Low on Stock'
            ELSE 'In Stock'
        END
    ) STORED,

    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_ngo FOREIGN KEY (ngo_id)
        REFERENCES ngos (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_inventory_collection_point FOREIGN KEY (collection_point_id)
        REFERENCES collection_points (collection_point_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_inventory_item FOREIGN KEY (item_id)
        REFERENCES donation_items_catalog (item_id)
        ON DELETE CASCADE,
    UNIQUE KEY uq_inventory_ngo_cp_item (ngo_id, collection_point_id, item_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Donation to Inventory Log (for traceability)
CREATE TABLE IF NOT EXISTS donation_inventory_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    donation_id INT NOT NULL,
    item_id INT NOT NULL,
    collection_point_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    action ENUM('Received', 'Updated') NOT NULL,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_log_donation FOREIGN KEY (donation_id)
        REFERENCES donations (donation_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_log_item FOREIGN KEY (item_id)
        REFERENCES donation_items_catalog (item_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_log_collection FOREIGN KEY (collection_point_id)
        REFERENCES collection_points (collection_point_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
