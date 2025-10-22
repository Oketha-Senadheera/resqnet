-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: resqnet-do-user-25057272-0.d.db.ondigitalocean.com:25060
-- Generation Time: Oct 22, 2025 at 08:22 AM
-- Server version: 8.0.35
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `defaultdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `collection_points`
--

CREATE TABLE `collection_points` (
  `collection_point_id` int NOT NULL,
  `ngo_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `location_landmark` varchar(150) DEFAULT NULL,
  `full_address` varchar(255) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`collection_point_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `collection_points`
--

INSERT INTO `collection_points` (`collection_point_id`, `ngo_id`, `name`, `location_landmark`, `full_address`, `contact_person`, `contact_number`) VALUES
(2, 5, 'community center', 'near the library', 'rggrgrguoihykgjtfrhgyhujnik', 'Nishkyy', '0123456789'),
(4, 31, 'Point1', 'Near the library', 'Point1, Main street, Colombo 01', 'Person1', '0123456789'),
(5, 31, 'Point2', 'Near the Park', 'Point2, Main street, Colombo 01', 'Person2', '0123456789');

-- --------------------------------------------------------

--
-- Table structure for table `disaster_reports`
--

CREATE TABLE `disaster_reports` (
  `report_id` int NOT NULL,
  `user_id` int NOT NULL,
  `reporter_name` varchar(100) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `disaster_type` enum('Flood','Landslide','Fire','Earthquake','Tsunami','Other') NOT NULL,
  `other_disaster_type` varchar(100) DEFAULT NULL,
  `disaster_datetime` datetime NOT NULL,
  `location` varchar(255) NOT NULL,
  `proof_image_path` varchar(255) DEFAULT NULL,
  `confirmation` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `description` text,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `verified_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `disaster_reports`
--

INSERT INTO `disaster_reports` (`report_id`, `user_id`, `reporter_name`, `contact_number`, `disaster_type`, `other_disaster_type`, `disaster_datetime`, `location`, `proof_image_path`, `confirmation`, `status`, `description`, `submitted_at`, `verified_at`) VALUES
(1, 4, 'abc', '0123456789', 'Fire', NULL, '2025-10-15 23:43:00', 'colombo', 'uploads/disaster-reports/1761043315270_Screenshot 2025-10-18 225243.png', 1, 'Approved', '', '2025-10-21 10:41:55', '2025-10-21 10:43:45'),
(2, 4, 'tgtg', '0123456789', 'Earthquake', NULL, '2025-10-21 11:19:00', 'colombo', NULL, 1, 'Rejected', '', '2025-10-21 11:19:28', '2025-10-21 13:49:50'),
(3, 4, 'tgtg', '0123456789', 'Earthquake', NULL, '2025-10-21 13:46:00', 'colombo', 'uploads/disaster-reports/1761054433197_unnamed (1).png', 1, 'Approved', '', '2025-10-21 13:47:12', '2025-10-21 13:48:16');

-- --------------------------------------------------------

--
-- Table structure for table `donations`
--

CREATE TABLE `donations` (
  `donation_id` int NOT NULL,
  `user_id` int NOT NULL,
  `collection_point_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `email` varchar(150) NOT NULL,
  `address` varchar(255) NOT NULL,
  `collection_date` date NOT NULL,
  `time_slot` enum('9am–12pm','12pm–4pm','6pm–9pm') NOT NULL,
  `special_notes` text,
  `confirmation` tinyint(1) NOT NULL DEFAULT '1',
  `status` enum('Pending','Received','Cancelled','Delivered') DEFAULT 'Pending',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `received_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`donation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `donations`
--

INSERT INTO `donations` (`donation_id`, `user_id`, `collection_point_id`, `name`, `contact_number`, `email`, `address`, `collection_date`, `time_slot`, `special_notes`, `confirmation`, `status`, `submitted_at`, `received_at`, `cancelled_at`, `delivered_at`) VALUES
(1, 4, 4, 'Moda Hashen', '0767017867', 'hashen@xleron.io', '23, School Avenue, Colombo 05, Colombo', '2025-10-22', '12pm–4pm', '', 1, 'Cancelled', '2025-10-22 05:40:50', NULL, '2025-10-22 05:45:44', NULL),
(2, 4, 5, 'Moda Hashen', '0767017867', 'hashen@xleron.io', '23, School Avenue, Colombo 05, Colombo', '2025-10-22', '6pm–9pm', '', 1, 'Received', '2025-10-22 05:41:37', '2025-10-22 05:43:37', NULL, '2025-10-22 05:43:37'),
(3, 4, 2, 'Moda Hashen', '0767017867', 'hashen@xleron.io', '23, School Avenue, Colombo 05, Colombo', '2025-10-22', '6pm–9pm', '', 1, 'Pending', '2025-10-22 05:45:35', NULL, NULL, NULL),
(4, 4, 2, 'Moda Hashen', '0767017867', 'hashen@xleron.io', '23, School Avenue, Colombo 05, Colombo', '2025-10-22', '12pm–4pm', '', 1, 'Pending', '2025-10-22 05:55:18', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `donation_inventory_log`
--

CREATE TABLE `donation_inventory_log` (
  `log_id` int NOT NULL,
  `donation_id` int NOT NULL,
  `item_id` int NOT NULL,
  `collection_point_id` int NOT NULL,
  `quantity` int NOT NULL,
  `action` enum('Received','Updated') NOT NULL,
  `logged_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `donation_items`
--

CREATE TABLE `donation_items` (
  `donation_item_id` int NOT NULL,
  `donation_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`donation_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `donation_items`
--

INSERT INTO `donation_items` (`donation_item_id`, `donation_id`, `item_id`, `quantity`) VALUES
(1, 1, 2, 3),
(2, 1, 30, 3),
(3, 1, 27, 3),
(4, 1, 22, 4),
(5, 2, 8, 1),
(6, 2, 32, 1),
(7, 2, 30, 1),
(8, 2, 20, 1),
(9, 2, 22, 1),
(10, 3, 32, 1),
(11, 4, 23, 1);

-- --------------------------------------------------------

--
-- Table structure for table `donation_items_catalog`
--

CREATE TABLE `donation_items_catalog` (
  `item_id` int NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `category` enum('Medicine','Food','Shelter') NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `donation_items_catalog`
--

INSERT INTO `donation_items_catalog` (`item_id`, `item_name`, `category`) VALUES
(1, 'Amoxicillin', 'Medicine'),
(2, 'Antiseptic solution', 'Medicine'),
(3, 'Bandages', 'Medicine'),
(4, 'Paracetamol', 'Medicine'),
(5, 'Aspirin', 'Medicine'),
(6, 'Antifungal powder', 'Medicine'),
(7, 'Mosquito repellent', 'Medicine'),
(8, 'Diabetes tablets', 'Medicine'),
(9, 'Sanitary pads', 'Medicine'),
(10, 'Cotton wool', 'Medicine'),
(11, 'Alcohol swabs', 'Medicine'),
(12, 'Rice', 'Food'),
(13, 'Dhal', 'Food'),
(14, 'Canned fish', 'Food'),
(15, 'Infant formula', 'Food'),
(16, 'Baby food jars or sachets', 'Food'),
(17, 'Drinking water', 'Food'),
(18, 'Instant noodles', 'Food'),
(19, 'Biscuits', 'Food'),
(20, 'Canned meat', 'Food'),
(21, 'Milk powder', 'Food'),
(22, 'Cooking oil', 'Food'),
(23, 'Sleeping mats', 'Shelter'),
(24, 'Blankets', 'Shelter'),
(25, 'Towels', 'Shelter'),
(26, 'Toothbrush', 'Shelter'),
(27, 'Soap', 'Shelter'),
(28, 'Basic clothing', 'Shelter'),
(29, 'Candles', 'Shelter'),
(30, 'Plates, cups', 'Shelter'),
(31, 'Baby diapers', 'Shelter'),
(32, 'Baby clothes', 'Shelter'),
(33, 'Disinfectant', 'Shelter');

-- --------------------------------------------------------

--
-- Table structure for table `donation_requests`
--

CREATE TABLE `donation_requests` (
  `request_id` int NOT NULL,
  `user_id` int NOT NULL,
  `relief_center_name` varchar(150) NOT NULL,
  `status` enum('Pending','Approved') DEFAULT 'Pending',
  `special_notes` text,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `donation_requests`
--

INSERT INTO `donation_requests` (`request_id`, `user_id`, `relief_center_name`, `status`, `special_notes`, `submitted_at`, `approved_at`) VALUES
(1, 4, 'abc', 'Approved', 'km;m', '2025-10-21 08:38:38', '2025-10-21 08:41:02'),
(2, 4, 'abc', 'Approved', '', '2025-10-21 11:52:58', '2025-10-21 11:54:00'),
(3, 4, 'abc', 'Pending', '', '2025-10-21 11:58:48', '2025-10-21 12:35:36'),
(4, 29, 'panadura', 'Pending', 'hi', '2025-10-21 13:23:03', NULL),
(5, 29, 'Colombo', 'Pending', 'hello', '2025-10-21 13:36:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `donation_request_items`
--

CREATE TABLE `donation_request_items` (
  `request_item_id` int NOT NULL,
  `request_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`request_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `donation_request_items`
--

INSERT INTO `donation_request_items` (`request_item_id`, `request_id`, `item_id`, `quantity`) VALUES
(1, 1, 22, 1),
(2, 1, 3, 3),
(3, 1, 1, 1),
(4, 1, 26, 8),
(5, 2, 14, 1),
(6, 2, 16, 1),
(10, 3, 22, 1),
(11, 3, 20, 1),
(12, 4, 15, 10),
(13, 5, 14, 10),
(14, 5, 7, 2),
(15, 5, 18, 15),
(16, 5, 23, 5);

-- --------------------------------------------------------

--
-- Table structure for table `general_user`
--

CREATE TABLE `general_user` (
  `user_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `house_no` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `gn_division` varchar(100) DEFAULT NULL,
  `sms_alert` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `general_user`
--

INSERT INTO `general_user` (`user_id`, `name`, `contact_number`, `house_no`, `street`, `city`, `district`, `gn_division`, `sms_alert`) VALUES
(4, 'Moda Hashen', '0767017867', '23', 'School Avenue', 'Colombo 05', 'Colombo', 'Colombo 05', 1),
(10, 'induwara', '0714098656', '', '', '', '', '', 0),
(11, 'ushibb', '0714098656', '', '', '', '', '', 0),
(12, 'nushrath', '0757692757', '', '', '', '', '', 0),
(13, 'Nishkyy', '0123456789', '', '', '', '', '', 1),
(15, 'Test2', '0767017867', '1231', '160 School Avenue', 'Colombo', 'Colombo', '222', 0),
(18, 'anotheradmin', '0123456789', '', '', '', '', '', 0),
(20, 'jghgjgjg', '344567', '', '', '', '', '', 0),
(22, 'nushrathjameel', '0757692757', '', '', '', '', '', 0),
(29, 'Ushitha Induwara', '0714098656', '', '', '', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `grama_niladhari`
--

CREATE TABLE `grama_niladhari` (
  `user_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `gn_division` varchar(100) DEFAULT NULL,
  `service_number` varchar(50) DEFAULT NULL,
  `gn_division_number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `grama_niladhari`
--

INSERT INTO `grama_niladhari` (`user_id`, `name`, `contact_number`, `address`, `gn_division`, `service_number`, `gn_division_number`) VALUES
(19, 'ToolGenie1', '0767017867', 'fcvfrv', 'colombo 051', '333', '222'),
(25, 'Hashen Udara hehe', '0767017867', 'n3zir9WXQFUQ4DE62scGgxHasBMZ5ocNGX', 'colombo 05', '333', '222'),
(26, 'gn1', '0767017867', '147 Catalyst Avdjse', 'colombo 05', '333', '222');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL,
  `ngo_id` int NOT NULL,
  `collection_point_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int DEFAULT '0',
  `status` enum('In Stock','Low on Stock','Out of Stock') GENERATED ALWAYS AS ((case when (`quantity` = 0) then _utf8mb4'Out of Stock' when (`quantity` < 20) then _utf8mb4'Low on Stock' else _utf8mb4'In Stock' end)) STORED,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inventory_id`, `ngo_id`, `collection_point_id`, `item_id`, `quantity`, `last_updated`) VALUES
(1, 31, 5, 8, 8, '2025-10-22 05:49:01'),
(2, 31, 5, 32, 1, '2025-10-22 05:43:38'),
(3, 31, 5, 30, 1, '2025-10-22 05:43:39'),
(4, 31, 5, 20, 1, '2025-10-22 05:43:39'),
(5, 31, 5, 22, 1, '2025-10-22 05:43:40');

-- --------------------------------------------------------

--
-- Table structure for table `ngos`
--

CREATE TABLE `ngos` (
  `user_id` int NOT NULL,
  `organization_name` varchar(150) NOT NULL,
  `registration_number` varchar(100) NOT NULL,
  `years_of_operation` int DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contact_person_name` varchar(100) DEFAULT NULL,
  `contact_person_telephone` varchar(20) DEFAULT NULL,
  `contact_person_email` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ngos`
--

INSERT INTO `ngos` (`user_id`, `organization_name`, `registration_number`, `years_of_operation`, `address`, `contact_person_name`, `contact_person_telephone`, `contact_person_email`) VALUES
(5, 'ABC', '12', 2, '147 Catalyst Avdjse', 'Hashen', '1234567890', 'emhashn@gmail.com'),
(30, 'new', 'S203', NULL, '', '', '', ''),
(31, 'NGO1', '123', 12, 'NGO1, Main street, Colombo 01', 'Person1', '', 'person1@abc.com'),
(32, 'NGO2', '1234', 10, 'NGO2, Main street, Colombo 02', 'Person2', '0123456789', 'person2@abc.com'),
(33, 'NGO3', '12345', 10, 'NGO3, Main street, Colombo 03', 'Person3', '0123456789', 'person3@abc.com'),
(34, 'NGO4', '123456', 10, 'NGO4, Main street, Colombo 04', 'Person4', '0123456789', 'person4@abc.com'),
(35, 'NGO5', '12356', 10, 'NGO5, Main street, Colombo 04', 'Person5', '0123456789', 'person5@abc.com');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `token` varchar(64) NOT NULL,
  `user_id` int NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `skill_id` int NOT NULL,
  `skill_name` varchar(100) NOT NULL,
  PRIMARY KEY (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skill_id`, `skill_name`) VALUES
(2, 'Firefighting'),
(1, 'Medical Professional'),
(4, 'Rescue & Handling'),
(3, 'Swimming / Lifesaving');

-- --------------------------------------------------------

--
-- Table structure for table `skills_volunteers`
--

CREATE TABLE `skills_volunteers` (
  `user_id` int NOT NULL,
  `skill_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `skills_volunteers`
--

INSERT INTO `skills_volunteers` (`user_id`, `skill_id`) VALUES
(6, 1),
(9, 1),
(6, 2),
(9, 2),
(9, 3),
(9, 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(150) NOT NULL,
  `role` enum('general','volunteer','ngo','grama_niladhari','dmc') NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `email`, `role`) VALUES
(1, 'admin@example.com', '$2a$10$jYH9jFhLl5DISzzOnLGyxOcOPwPcRuhePxcd84zpNegf/6hkHBAXe', 'admin@example.com', 'dmc'),
(4, 'hash', '$2a$10$z4Z2WEdyEM4MjY4C2GPkDuRK5p5ZiZi3BHXhjSwgkLdGIecQD/Rj6', 'hashen@xleron.io', 'general'),
(5, 'abc', '$2a$10$F.20NQZ.lj78JjEJX1wiMuS3UReIpEGbmin//COVom3AIK.XhgACW', 'hashsandbox@gmail.com', 'ngo'),
(6, 'hashen', '$2a$10$O6xbNoEIdTrgxihpcThDzOWEu.Fs/hFPi2g6dLYfdFHLnT7/tRsCq', 'info@xleron.io', 'volunteer'),
(8, 'efff', '$2a$10$Z3BX/s6A2gV4usPbsupUEO7vAjFlA7ic0r9IvSEUYk9HHksVVRsyy', 'manager@example.com', 'volunteer'),
(9, 'jjjjj', '$2a$10$APPfyY2p6DqkHA/L4Ej7JebAy2q/ZayxeXzGEvOcTTFxpkh/CUPHG', 'emhashenudara@gmail.com', 'volunteer'),
(10, 'induwara', '$2a$10$A7vp21MoKx9sidxOHAOYt.9JjFj1BElK5FcDFFVisV/CdEfMsXuMe', 'ushithainduwara4@gmail.com', 'general'),
(11, 'ushi', '$2a$10$r6dlVS/mWHNlJjuir9gr.OIVOuTAH7HfG9Z/dUPAqLO..SsuDL/J6', 'ushithainduwara45@gmail.com', 'general'),
(12, 'nushrath', '$2a$10$NJJs1eKHGlqc2RhGIxalT.5AB9ekSORwIqc6OC3oaiXvrgFk1F5U6', 'nusrathjameel2002@gmail.com', 'general'),
(13, 'nishnish', '$2a$10$MFQ9R3WFE5OvINFJqtRBbeUh2NSJXLw3vW.H7Rm7K9ih2K5HgaE3K', 'nish@abc.com', 'grama_niladhari'),
(15, 'admin1@example.com', '$2a$10$9F6GkezZvNhx4EmVWhaf2.UrYt12ONNyEq58IcDW1/ZN1N5L3/0Gq', 'admin1@example.com', 'general'),
(18, 'adminanother', '$2a$10$ey7BwiJYB0nDq0h9mrsDhOXQug0JquHFbzKk16gHLmdt3gpB/4P3.', 'anotheradmin@abc.com', 'dmc'),
(19, 'hashsandboxk', '$2a$10$zr2pgC5NNiy.4D4eTW15W.yRY653vURXpYKPqMjhh2s5dkI0IsSW.', 'hashen@xleron.ip', 'grama_niladhari'),
(20, 'hey', '$2a$10$hs8nX8s.fmewYAy6P/jg8uSrXIudwkNmhQ1Jf0ylZ6eiynx45ERLi', 'kkkkkkkkk', 'general'),
(22, 'Nush', '$2a$10$7aorJnjVchvYqpzB8mfNuuOCll.ycUHKiwnD6J2Yi8Qf2J.ndK.da', 'nusrath2002@gmail.com', 'general'),
(25, 'hashsandboxy', '$2a$10$JzG/eVDCCxAYt8YIsIWSR.8dbj1//v7ZMaputrTqgvzWTrNotKDkS', 'admin@example.com12', 'grama_niladhari'),
(26, 'gn1', '$2a$10$7cRQaRFa1JUx1J2.H/3.quGwvHL9uxGk90wCrKkfmdOP80o.c5OU.', 'gn1@abc.com', 'grama_niladhari'),
(29, 'Ushitha', '$2a$10$jKIIWI0pCk2zBQUvmEEo3ex6BXNKSVqEEmlnn7Cnee70njLrl7iCa', 'ushithainduwara@gmail.com', 'general'),
(30, '123456', '$2a$10$gzyJgfVBkHrABGDzMATKOOyLHnU5N7A7Vop62exT31HIOM577iGjG', '1234@gmail.com', 'ngo'),
(31, 'NGO1', '$2a$10$u02hc2wxVPgWfopnWOsH4.NgxqUXf0WeYoKJ277fzLTjYwfZZ1W7S', 'ngo1@abc.com', 'ngo'),
(32, 'NGO2', '$2a$10$hNxZqUsUgQK7aARCrVtwNOYAClj5YcI0jyKf12oFogoYRp7k6Wb7C', 'ngo2@abc.com', 'ngo'),
(33, 'NGO3', '$2a$10$tLkMznYzbUaa/CvJls2wLePwQNEKwmMRPIA8K6/Xf2rS/erDCcDkO', 'ngo3@abc.com', 'ngo'),
(34, 'NGO4', '$2a$10$M2wGdjDEJXSLeGnqufJ.uOpWIJZwD6iwv/3qr.wbN2YwX9fwXUJei', 'ngo4@abc.com', 'ngo'),
(35, 'NGO5', '$2a$10$UXzFYcnlXcfms8K4lfK4SOmlfzj7n6sJTRkMlUfcsw1MK8OrbtaGO', 'ngo5@abc.com', 'ngo');

-- --------------------------------------------------------

--
-- Table structure for table `volunteers`
--

CREATE TABLE `volunteers` (
  `user_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `house_no` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `gn_division` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `volunteers`
--

INSERT INTO `volunteers` (`user_id`, `name`, `age`, `gender`, `contact_number`, `house_no`, `street`, `city`, `district`, `gn_division`) VALUES
(6, 'moda hashen', 22, 'other', '0767017867', '1231', 'jdhsjdsd', 'Torontosdhf', 'Gampaha', 'FGBE'),
(8, 'test test', 22, 'female', '0767017867', '23', '160 School Avenue', 'Torontosdhf', 'Kalutara', 'BHBsd'),
(9, 'test2', 22, 'male', '0767017867', '1231', 'jdhsjdsd', 'Boralesgamuwa', 'Gampaha', 'FGBE');

-- --------------------------------------------------------

--
-- Table structure for table `volunteer_preferences`
--

CREATE TABLE `volunteer_preferences` (
  `preference_id` int NOT NULL,
  `preference_name` varchar(100) NOT NULL,
  PRIMARY KEY (`preference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `volunteer_preferences`
--

INSERT INTO `volunteer_preferences` (`preference_id`, `preference_name`) VALUES
(6, 'Food Distribution'),
(4, 'Logistics Support'),
(3, 'Medical Aid'),
(1, 'Search & Rescue'),
(5, 'Shelter Management'),
(2, 'Technical Support');

-- --------------------------------------------------------

--
-- Table structure for table `volunteer_preference_volunteers`
--

CREATE TABLE `volunteer_preference_volunteers` (
  `user_id` int NOT NULL,
  `preference_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`preference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `volunteer_preference_volunteers`
--

INSERT INTO `volunteer_preference_volunteers` (`user_id`, `preference_id`) VALUES
(6, 1),
(6, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6);

-- --------------------------------------------------------

--
-- Table structure for table `volunteer_task`
--

CREATE TABLE `volunteer_task` (
  `id` int NOT NULL,
  `volunteer_id` int NOT NULL,
  `disaster_id` int NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `date_assigned` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) DEFAULT 'assigned',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `volunteer_task`
--

INSERT INTO `volunteer_task` (`id`, `volunteer_id`, `disaster_id`, `role`, `date_assigned`, `status`) VALUES
(5, 2, 3, 'Search and Rescue', '2025-10-17 00:00:00', 'In Progress'),
(6, 7, 34, 'helper', '2025-10-17 00:00:00', 'active'),
(7, 7, 34, 'Rescue Coordinator', '2025-10-09 00:00:00', 'active'),
(8, 78, 34, 'Childcare Support', '2025-10-23 00:00:00', 'Completed');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `collection_points`
--
ALTER TABLE `collection_points`
  ADD KEY `fk_collection_point_ngo` (`ngo_id`);

--
-- Indexes for table `disaster_reports`
--
ALTER TABLE `disaster_reports`
  ADD KEY `fk_disaster_report_user` (`user_id`);

--
-- Indexes for table `donations`
--
ALTER TABLE `donations`
  ADD KEY `fk_donations_user` (`user_id`),
  ADD KEY `fk_donations_collection_point` (`collection_point_id`);

--
-- Indexes for table `donation_inventory_log`
--
ALTER TABLE `donation_inventory_log`
  ADD KEY `fk_log_donation` (`donation_id`),
  ADD KEY `fk_log_item` (`item_id`),
  ADD KEY `fk_log_collection` (`collection_point_id`);

--
-- Indexes for table `donation_items`
--
ALTER TABLE `donation_items`
  ADD KEY `fk_donation_items_donation` (`donation_id`),
  ADD KEY `fk_donation_items_catalog_item` (`item_id`);

--
-- Indexes for table `donation_items_catalog`
--
ALTER TABLE `donation_items_catalog`
  ADD UNIQUE KEY `uq_item_name` (`item_name`);

--
-- Indexes for table `donation_requests`
--
ALTER TABLE `donation_requests`
  ADD KEY `fk_donation_request_user` (`user_id`);

--
-- Indexes for table `donation_request_items`
--
ALTER TABLE `donation_request_items`
  ADD KEY `fk_donation_items_request` (`request_id`),
  ADD KEY `fk_donation_items_catalog` (`item_id`);

--
-- Indexes for table `general_user`
--
-- Primary key for general_user defined inline in CREATE TABLE

--
-- Indexes for table `grama_niladhari`
--
-- Primary key for grama_niladhari defined inline in CREATE TABLE

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD UNIQUE KEY `uq_inventory_ngo_cp_item` (`ngo_id`,`collection_point_id`,`item_id`),
  ADD KEY `fk_inventory_collection_point` (`collection_point_id`),
  ADD KEY `fk_inventory_item` (`item_id`);

--
-- Indexes for table `ngos`
--
-- Primary key for ngos defined inline in CREATE TABLE

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD KEY `idx_prt_user_expires` (`user_id`,`expires_at`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD UNIQUE KEY `uq_skills_name` (`skill_name`);

--
-- Indexes for table `skills_volunteers`
--
ALTER TABLE `skills_volunteers`
  ADD KEY `fk_skills_volunteers_skill` (`skill_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indexes for table `volunteers`
--
-- Primary key for volunteers defined inline in CREATE TABLE

--
-- Indexes for table `volunteer_preferences`
--
ALTER TABLE `volunteer_preferences`
  ADD UNIQUE KEY `uq_preferences_name` (`preference_name`);

--
-- Indexes for table `volunteer_preference_volunteers`
--
ALTER TABLE `volunteer_preference_volunteers`
  ADD KEY `fk_vpv_preference` (`preference_id`);

--
-- Indexes for table `volunteer_task`
--
-- Primary key for volunteer_task defined inline in CREATE TABLE

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `collection_points`
--
ALTER TABLE `collection_points`
  MODIFY `collection_point_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `disaster_reports`
--
ALTER TABLE `disaster_reports`
  MODIFY `report_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `donations`
--
ALTER TABLE `donations`
  MODIFY `donation_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `donation_inventory_log`
--
ALTER TABLE `donation_inventory_log`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `donation_items`
--
ALTER TABLE `donation_items`
  MODIFY `donation_item_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `donation_items_catalog`
--
ALTER TABLE `donation_items_catalog`
  MODIFY `item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `donation_requests`
--
ALTER TABLE `donation_requests`
  MODIFY `request_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `donation_request_items`
--
ALTER TABLE `donation_request_items`
  MODIFY `request_item_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `inventory_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `skill_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `volunteer_preferences`
--
ALTER TABLE `volunteer_preferences`
  MODIFY `preference_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `volunteer_task`
--
ALTER TABLE `volunteer_task`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `collection_points`
--
ALTER TABLE `collection_points`
  ADD CONSTRAINT `fk_collection_point_ngo` FOREIGN KEY (`ngo_id`) REFERENCES `ngos` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `disaster_reports`
--
ALTER TABLE `disaster_reports`
  ADD CONSTRAINT `fk_disaster_report_user` FOREIGN KEY (`user_id`) REFERENCES `general_user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `donations`
--
ALTER TABLE `donations`
  ADD CONSTRAINT `fk_donations_collection_point` FOREIGN KEY (`collection_point_id`) REFERENCES `collection_points` (`collection_point_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_donations_user` FOREIGN KEY (`user_id`) REFERENCES `general_user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_inventory_log`
--
ALTER TABLE `donation_inventory_log`
  ADD CONSTRAINT `fk_log_collection` FOREIGN KEY (`collection_point_id`) REFERENCES `collection_points` (`collection_point_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_log_donation` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`donation_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_log_item` FOREIGN KEY (`item_id`) REFERENCES `donation_items_catalog` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_items`
--
ALTER TABLE `donation_items`
  ADD CONSTRAINT `fk_donation_items_catalog_item` FOREIGN KEY (`item_id`) REFERENCES `donation_items_catalog` (`item_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_donation_items_donation` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`donation_id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_requests`
--
ALTER TABLE `donation_requests`
  ADD CONSTRAINT `fk_donation_request_user` FOREIGN KEY (`user_id`) REFERENCES `general_user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_request_items`
--
ALTER TABLE `donation_request_items`
  ADD CONSTRAINT `fk_donation_items_catalog` FOREIGN KEY (`item_id`) REFERENCES `donation_items_catalog` (`item_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_donation_items_request` FOREIGN KEY (`request_id`) REFERENCES `donation_requests` (`request_id`) ON DELETE CASCADE;

--
-- Constraints for table `general_user`
--
ALTER TABLE `general_user`
  ADD CONSTRAINT `fk_general_user_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `grama_niladhari`
--
ALTER TABLE `grama_niladhari`
  ADD CONSTRAINT `fk_gn_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `fk_inventory_collection_point` FOREIGN KEY (`collection_point_id`) REFERENCES `collection_points` (`collection_point_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inventory_item` FOREIGN KEY (`item_id`) REFERENCES `donation_items_catalog` (`item_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inventory_ngo` FOREIGN KEY (`ngo_id`) REFERENCES `ngos` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `ngos`
--
ALTER TABLE `ngos`
  ADD CONSTRAINT `fk_ngos_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `skills_volunteers`
--
ALTER TABLE `skills_volunteers`
  ADD CONSTRAINT `fk_skills_volunteers_skill` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_skills_volunteers_volunteer` FOREIGN KEY (`user_id`) REFERENCES `volunteers` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `volunteers`
--
ALTER TABLE `volunteers`
  ADD CONSTRAINT `fk_volunteers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `volunteer_preference_volunteers`
--
ALTER TABLE `volunteer_preference_volunteers`
  ADD CONSTRAINT `fk_vpv_preference` FOREIGN KEY (`preference_id`) REFERENCES `volunteer_preferences` (`preference_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vpv_volunteer` FOREIGN KEY (`user_id`) REFERENCES `volunteers` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
