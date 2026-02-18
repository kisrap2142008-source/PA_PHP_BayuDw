-- ============================================================
-- KRETA KITA — database.sql
-- Schema & Seed Data
-- ============================================================

CREATE DATABASE IF NOT EXISTS kreta_kita CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kreta_kita;

-- ── Drop existing tables ──────────────────────────────────────
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS trains;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- ── 1. users ──────────────────────────────────────────────────
CREATE TABLE users (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  role       ENUM('admin','user') NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 2. trains ─────────────────────────────────────────────────
CREATE TABLE trains (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  train_name  VARCHAR(100) NOT NULL,
  origin      VARCHAR(100) NOT NULL,
  destination VARCHAR(100) NOT NULL,
  price       DECIMAL(12,2) NOT NULL DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 3. schedules ──────────────────────────────────────────────
CREATE TABLE schedules (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  train_id        INT UNSIGNED NOT NULL,
  departure_time  DATETIME NOT NULL,
  arrival_time    DATETIME NOT NULL,
  available_seats INT UNSIGNED NOT NULL DEFAULT 20,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (train_id) REFERENCES trains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 4. bookings ───────────────────────────────────────────────
CREATE TABLE bookings (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id        INT UNSIGNED NOT NULL,
  schedule_id    INT UNSIGNED NOT NULL,
  seat_number    VARCHAR(10) NOT NULL,
  booking_code   VARCHAR(20) NOT NULL UNIQUE,
  payment_status ENUM('Pending','Paid','Cancelled') NOT NULL DEFAULT 'Pending',
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)     REFERENCES users(id)     ON DELETE CASCADE,
  FOREIGN KEY (schedule_id) REFERENCES schedules(id) ON DELETE CASCADE,
  UNIQUE KEY uq_schedule_seat (schedule_id, seat_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── SEED: Users ───────────────────────────────────────────────
-- Admin: admin@kretakita.com / admin123
-- User:  user@kretakita.com  / user123
-- Demo Credentials:
-- Admin : admin@kretakita.com  / password
-- User  : user@kretakita.com   / password
-- (password for all accounts = "password")
INSERT INTO users (name, email, password, role) VALUES
('Administrator', 'admin@kretakita.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('Budi Santoso',  'user@kretakita.com',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Dewi Lestari',  'dewi@example.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Andi Wijaya',   'andi@example.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');

-- ── SEED: Trains ──────────────────────────────────────────────
INSERT INTO trains (train_name, origin, destination, price) VALUES
('Argo Bromo Anggrek', 'Jakarta',   'Surabaya',  450000),
('Gajayana Ekspres',   'Jakarta',   'Malang',    420000),
('Taksaka Pagi',       'Jakarta',   'Yogyakarta',280000),
('Bima Ekspres',       'Surabaya',  'Jakarta',   450000),
('Sancaka Utama',      'Surabaya',  'Yogyakarta',175000),
('Lodaya Pagi',        'Bandung',   'Yogyakarta',230000),
('Turangga Ekspres',   'Bandung',   'Surabaya',  380000),
('Argo Wilis',         'Bandung',   'Surabaya',  360000),
('Sembrani Ekspres',   'Jakarta',   'Surabaya',  410000),
('Malioboro Ekspres',  'Yogyakarta','Malang',    145000);

-- ── SEED: Schedules ───────────────────────────────────────────
INSERT INTO schedules (train_id, departure_time, arrival_time, available_seats) VALUES
-- Jakarta -> Surabaya (Argo Bromo Anggrek)
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 7 HOUR,  DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 15 HOUR, 20),
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 20 HOUR, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 4 HOUR,  15),
(1, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 7 HOUR,  DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 15 HOUR, 20),
(1, DATE_ADD(CURDATE(), INTERVAL 3 DAY) + INTERVAL 7 HOUR,  DATE_ADD(CURDATE(), INTERVAL 3 DAY) + INTERVAL 15 HOUR, 18),
-- Jakarta -> Malang (Gajayana)
(2, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 17 HOUR, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 7 HOUR,  18),
(2, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 17 HOUR, DATE_ADD(CURDATE(), INTERVAL 3 DAY) + INTERVAL 7 HOUR,  20),
-- Jakarta -> Yogyakarta (Taksaka)
(3, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 8 HOUR,  DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 16 HOUR + INTERVAL 30 MINUTE, 20),
(3, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 22 HOUR, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 6 HOUR + INTERVAL 30 MINUTE,  16),
(3, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 8 HOUR,  DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 16 HOUR + INTERVAL 30 MINUTE, 20),
-- Surabaya -> Jakarta (Bima)
(4, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 16 HOUR, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 0 HOUR,  20),
(4, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 16 HOUR, DATE_ADD(CURDATE(), INTERVAL 3 DAY) + INTERVAL 0 HOUR,  20),
-- Surabaya -> Yogyakarta (Sancaka)
(5, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 6 HOUR,  DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 11 HOUR, 20),
(5, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 14 HOUR, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 19 HOUR, 20),
-- Bandung -> Yogyakarta (Lodaya)
(6, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 7 HOUR,  DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 15 HOUR, 20),
(6, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 7 HOUR,  DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 15 HOUR, 20),
-- Bandung -> Surabaya (Turangga)
(7, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 19 HOUR, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 7 HOUR,  18),
(7, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 19 HOUR, DATE_ADD(CURDATE(), INTERVAL 3 DAY) + INTERVAL 7 HOUR,  20),
-- Yogyakarta -> Malang (Malioboro)
(10, DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 9 HOUR,  DATE_ADD(CURDATE(), INTERVAL 1 DAY) + INTERVAL 13 HOUR, 20),
(10, DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 9 HOUR,  DATE_ADD(CURDATE(), INTERVAL 2 DAY) + INTERVAL 13 HOUR, 20);

-- ── SEED: Bookings (sample data) ──────────────────────────────
INSERT INTO bookings (user_id, schedule_id, seat_number, booking_code, payment_status) VALUES
(2, 1,  'S01', 'KK-2025-AA001', 'Paid'),
(2, 3,  'S05', 'KK-2025-BB002', 'Paid'),
(3, 7,  'S03', 'KK-2025-CC003', 'Paid'),
(3, 12, 'S07', 'KK-2025-DD004', 'Pending'),
(4, 1,  'S02', 'KK-2025-EE005', 'Paid'),
(4, 5,  'S10', 'KK-2025-FF006', 'Cancelled'),
(2, 14, 'S04', 'KK-2025-GG007', 'Pending'),
(3, 7,  'S12', 'KK-2025-HH008', 'Paid');

-- Adjust available_seats for booked schedules
UPDATE schedules SET available_seats = available_seats - 2 WHERE id = 1;
UPDATE schedules SET available_seats = available_seats - 1 WHERE id = 3;
UPDATE schedules SET available_seats = available_seats - 2 WHERE id = 7;
UPDATE schedules SET available_seats = available_seats - 1 WHERE id = 12;
UPDATE schedules SET available_seats = available_seats - 1 WHERE id = 14;

