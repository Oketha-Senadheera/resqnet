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
