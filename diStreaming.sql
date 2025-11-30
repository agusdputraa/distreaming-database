-- ============================================
-- diStreaming Database - Complete SQL Script
-- ============================================

-- ============================================
-- SECTION 1: DATABASE CREATION
-- ============================================
DROP DATABASE IF EXISTS diStreaming;
CREATE DATABASE diStreaming;
USE diStreaming;

-- ============================================
-- SECTION 2: TABLE CREATION (DDL)
-- ============================================

-- TABEL 1: USERS
CREATE TABLE users (
    user_id INT AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(150) NOT NULL,
    user_created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_user_email (user_email)
);

-- TABEL 2: MOVIE_CATEGORIES
CREATE TABLE movie_categories (
    category_id INT AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id)
);

-- TABEL 3: MOVIES
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT NOT NULL,
    movie_title VARCHAR(150) NOT NULL,
    movie_rating DECIMAL(3,1) NOT NULL,
    movie_release_year YEAR NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (movie_id),
    CONSTRAINT fk_movies_category 
        FOREIGN KEY (category_id) REFERENCES movie_categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- TABEL 4: USER_WATCH_HISTORY
CREATE TABLE user_watch_history (
    history_id INT AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    watched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    progress INT NULL,
    PRIMARY KEY (history_id),
    CONSTRAINT fk_history_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_history_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABEL 5: USER_FAVORITES
CREATE TABLE user_favorites (
    favorite_id INT AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (favorite_id),
    UNIQUE KEY uk_user_movie_favorite (user_id, movie_id),
    CONSTRAINT fk_favorites_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_favorites_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- TABEL 6: USER_RATINGS
CREATE TABLE user_ratings (
    rating_id INT AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    score DECIMAL(3,1) NOT NULL,
    review_text TEXT NULL,
    rated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (rating_id),
    UNIQUE KEY uk_user_movie_rating (user_id, movie_id),
    CONSTRAINT fk_ratings_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ratings_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_score CHECK (score >= 0.0 AND score <= 10.0)
);

-- ============================================
-- SECTION 3: DATA INSERTION (DML)
-- ============================================

-- Insert Users (15 records)
INSERT INTO users (user_name, user_email, user_created_at) VALUES
('Ahmad Rizki', 'ahmad.rizki@email.com', '2024-01-15 08:30:00'),
('Budi Santoso', 'budi.santoso@email.com', '2024-01-20 10:15:00'),
('Citra Dewi', 'citra.dewi@email.com', '2024-02-01 14:00:00'),
('Dian Permata', 'dian.permata@email.com', '2024-02-10 09:45:00'),
('Eko Prasetyo', 'eko.prasetyo@email.com', '2024-02-15 16:30:00'),
('Fitri Handayani', 'fitri.handayani@email.com', '2024-03-01 11:00:00'),
('Galih Pratama', 'galih.pratama@email.com', '2024-03-05 13:20:00'),
('Hana Safitri', 'hana.safitri@email.com', '2024-03-10 15:45:00'),
('Irfan Maulana', 'irfan.maulana@email.com', '2024-03-15 08:00:00'),
('Jasmine Putri', 'jasmine.putri@email.com', '2024-03-20 17:30:00'),
('Kevin Wijaya', 'kevin.wijaya@email.com', '2024-04-01 10:00:00'),
('Linda Kusuma', 'linda.kusuma@email.com', '2024-04-05 12:15:00'),
('Michael Tan', 'michael.tan@email.com', '2024-04-10 14:30:00'),
('Nadia Rahma', 'nadia.rahma@email.com', '2024-04-15 09:00:00'),
('Oscar Putra', 'oscar.putra@email.com', '2024-04-20 16:00:00');

-- Insert Movie Categories (10 records)
INSERT INTO movie_categories (category_name) VALUES
('Action'),
('Comedy'),
('Drama'),
('Horror'),
('Romance'),
('Sci-Fi'),
('Thriller'),
('Animation'),
('Documentary'),
('Fantasy');

-- Insert Movies (15 records)
INSERT INTO movies (movie_title, movie_rating, movie_release_year, category_id) VALUES
('The Last Warrior', 8.5, 2023, 1),
('Love in Paris', 7.8, 2022, 5),
('Laugh Out Loud', 6.9, 2024, 2),
('Dark Shadows', 7.2, 2023, 4),
('Eternal Love Story', 8.2, 2021, 5),
('Galaxy Quest 2', 8.7, 2024, 6),
('The Silent Hour', 7.5, 2023, 7),
('Finding Nemo 3', 8.9, 2024, 8),
('Nature Unveiled', 7.0, 2022, 9),
('Dragon Kingdom', 8.3, 2023, 10),
('Speed Racer X', 7.4, 2024, 1),
('Comedy Night', 6.5, 2023, 2),
('Tears of Joy', 8.1, 2022, 3),
('Love Actually 2', 7.9, 2024, 5),
('Nightmare Returns', 6.8, 2023, 4);

-- Insert User Watch History (15 records)
INSERT INTO user_watch_history (user_id, movie_id, watched_at, progress) VALUES
(1, 1, '2024-05-01 20:00:00', 120),
(1, 6, '2024-05-02 21:30:00', 145),
(2, 2, '2024-05-01 19:00:00', 110),
(3, 8, '2024-05-03 14:00:00', 95),
(4, 3, '2024-05-04 20:30:00', 100),
(5, 5, '2024-05-05 21:00:00', 130),
(6, 10, '2024-05-06 19:30:00', 140),
(7, 4, '2024-05-07 22:00:00', 105),
(8, 7, '2024-05-08 20:00:00', 115),
(9, 9, '2024-05-09 15:00:00', 90),
(10, 1, '2024-05-10 21:00:00', 120),
(11, 11, '2024-05-11 20:30:00', 108),
(12, 13, '2024-05-12 19:00:00', 125),
(13, 14, '2024-05-13 21:30:00', 112),
(14, 15, '2024-05-14 22:00:00', 98);

-- Insert User Favorites (12 records)
INSERT INTO user_favorites (user_id, movie_id, added_at) VALUES
(1, 1, '2024-05-01 22:00:00'),
(1, 6, '2024-05-02 23:00:00'),
(2, 2, '2024-05-01 21:00:00'),
(3, 8, '2024-05-03 16:00:00'),
(4, 5, '2024-05-04 22:00:00'),
(5, 10, '2024-05-05 23:00:00'),
(6, 1, '2024-05-06 21:30:00'),
(7, 13, '2024-05-07 23:30:00'),
(8, 6, '2024-05-08 22:00:00'),
(9, 8, '2024-05-09 17:00:00'),
(10, 14, '2024-05-10 23:00:00'),
(11, 11, '2024-05-11 22:30:00');

-- Insert User Ratings (12 records)
INSERT INTO user_ratings (user_id, movie_id, score, review_text, rated_at) VALUES
(1, 1, 9.0, 'Film action terbaik tahun ini!', '2024-05-01 23:00:00'),
(1, 6, 8.5, 'Sci-fi yang sangat menarik', '2024-05-02 23:30:00'),
(2, 2, 8.0, 'Romantis dan menyentuh hati', '2024-05-01 22:00:00'),
(3, 8, 9.5, 'Animasi yang sangat menghibur untuk keluarga', '2024-05-03 17:00:00'),
(4, 3, 7.0, 'Cukup lucu, tapi bisa lebih baik', '2024-05-04 23:00:00'),
(5, 5, 8.5, 'Cerita cinta yang mendalam', '2024-05-05 23:30:00'),
(6, 10, 8.0, 'Fantasy yang epic!', '2024-05-06 22:00:00'),
(7, 4, 7.5, 'Cukup menegangkan', '2024-05-08 00:00:00'),
(8, 7, 7.8, 'Thriller yang bikin deg-degan', '2024-05-08 23:00:00'),
(9, 9, 7.2, 'Dokumenter yang informatif', '2024-05-09 18:00:00'),
(10, 1, 8.8, 'Action nya keren banget!', '2024-05-10 23:30:00'),
(11, 11, 7.5, 'Racing movie yang seru', '2024-05-11 23:00:00');

-- ============================================
-- SECTION 4: CRUD OPERATIONS
-- ============================================

-- CREATE (Insert)
-- Contoh menambah user baru
-- INSERT INTO users (user_name, user_email) VALUES ('Putri Anggraini', 'putri.anggraini@email.com');

-- READ (Select)
-- Membaca semua data
SELECT * FROM users;
SELECT * FROM movies;
SELECT * FROM movie_categories;

-- UPDATE
-- Contoh update nama user
-- UPDATE users SET user_name = 'Ahmad Rizki Pratama' WHERE user_id = 1;

-- DELETE
-- Contoh hapus user
-- DELETE FROM users WHERE user_id = 15;

-- ============================================
-- SECTION 5: SQL FUNDAMENTALS
-- ============================================

-- 5.1 Tampilkan seluruh film dari tabel Movies
SELECT * FROM movies;

-- 5.2 Tampilkan film dengan rating di atas 8.0
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_rating > 8.0
ORDER BY movie_rating DESC;

-- 5.3 Tampilkan 5 user pertama berdasarkan nama (A-Z)
SELECT user_id, user_name, user_email, user_created_at 
FROM users 
ORDER BY user_name ASC 
LIMIT 5;

-- 5.4 Tampilkan film yang judulnya mengandung kata "Love"
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_title LIKE '%Love%';

-- 5.5 Tampilkan film yang rilis pada tahun 2024
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_release_year = 2024;

-- ============================================
-- SECTION 6: AGGREGATE & CONDITIONAL LOGIC
-- ============================================

-- 6.1 Hitung total user yang terdaftar
SELECT COUNT(*) AS total_users FROM users;

-- 6.2 Hitung jumlah film per kategori (COUNT + GROUP BY)
SELECT 
    mc.category_id,
    mc.category_name,
    COUNT(m.movie_id) AS total_movies
FROM movie_categories mc
LEFT JOIN movies m ON mc.category_id = m.category_id
GROUP BY mc.category_id, mc.category_name
ORDER BY total_movies DESC;

-- 6.3 Kategori film berdasarkan rating menggunakan CASE WHEN
SELECT 
    movie_id,
    movie_title,
    movie_rating,
    CASE 
        WHEN movie_rating >= 8.5 THEN 'Top Rated'
        WHEN movie_rating >= 7.0 AND movie_rating < 8.5 THEN 'Popular'
        ELSE 'Regular'
    END AS rating_category
FROM movies
ORDER BY movie_rating DESC;

-- ============================================
-- SECTION 7: JOIN STATEMENTS
-- ============================================

-- 7.1 Tampilkan daftar film lengkap (kategori, rating, release year) - INNER JOIN
SELECT 
    m.movie_id,
    m.movie_title,
    mc.category_name AS category,
    m.movie_rating,
    m.movie_release_year,
    CASE 
        WHEN m.movie_rating >= 8.5 THEN 'Top Rated'
        WHEN m.movie_rating >= 7.0 THEN 'Popular'
        ELSE 'Regular'
    END AS rating_tier
FROM movies m
INNER JOIN movie_categories mc ON m.category_id = mc.category_id
ORDER BY m.movie_rating DESC;

-- 7.2 Tampilkan kategori yang belum memiliki film sama sekali - LEFT JOIN
SELECT 
    mc.category_id,
    mc.category_name,
    COUNT(m.movie_id) AS total_movies
FROM movie_categories mc
LEFT JOIN movies m ON mc.category_id = m.category_id
GROUP BY mc.category_id, mc.category_name
HAVING COUNT(m.movie_id) = 0;

-- ============================================
-- ADDITIONAL JOIN STATEMENTS
-- ============================================

-- 7.3 Tampilkan riwayat tontonan user dengan detail film
SELECT 
    u.user_name,
    m.movie_title,
    mc.category_name,
    uwh.watched_at,
    uwh.progress AS progress_minutes
FROM user_watch_history uwh
INNER JOIN users u ON uwh.user_id = u.user_id
INNER JOIN movies m ON uwh.movie_id = m.movie_id
INNER JOIN movie_categories mc ON m.category_id = mc.category_id
ORDER BY uwh.watched_at DESC;

-- 7.4 Tampilkan film favorit user beserta rating yang diberikan
SELECT 
    u.user_name,
    m.movie_title,
    mc.category_name,
    uf.added_at AS favorited_at,
    ur.score AS user_score,
    ur.review_text
FROM user_favorites uf
INNER JOIN users u ON uf.user_id = u.user_id
INNER JOIN movies m ON uf.movie_id = m.movie_id
INNER JOIN movie_categories mc ON m.category_id = mc.category_id
LEFT JOIN user_ratings ur ON uf.user_id = ur.user_id AND uf.movie_id = ur.movie_id
ORDER BY u.user_name, uf.added_at DESC;

-- 7.5 Tampilkan user yang belum pernah menonton film apapun
SELECT 
    u.user_id,
    u.user_name,
    u.user_email
FROM users u
LEFT JOIN user_watch_history uwh ON u.user_id = uwh.user_id
WHERE uwh.history_id IS NULL;

-- 7.6 Tampilkan film paling populer (berdasarkan jumlah favorit)
SELECT 
    m.movie_id,
    m.movie_title,
    mc.category_name,
    m.movie_rating,
    COUNT(uf.favorite_id) AS total_favorites
FROM movies m
INNER JOIN movie_categories mc ON m.category_id = mc.category_id
LEFT JOIN user_favorites uf ON m.movie_id = uf.movie_id
GROUP BY m.movie_id, m.movie_title, mc.category_name, m.movie_rating
ORDER BY total_favorites DESC, m.movie_rating DESC
LIMIT 10;

-- 7.7 Tampilkan rata-rata score dari user ratings per film
SELECT 
    m.movie_id,
    m.movie_title,
    m.movie_rating AS official_rating,
    COALESCE(AVG(ur.score), 0) AS avg_user_rating,
    COUNT(ur.rating_id) AS total_reviews
FROM movies m
LEFT JOIN user_ratings ur ON m.movie_id = ur.movie_id
GROUP BY m.movie_id, m.movie_title, m.movie_rating
ORDER BY avg_user_rating DESC;
