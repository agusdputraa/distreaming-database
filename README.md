# diStreaming Database - Mini Project SQL

Database untuk platform streaming film sederhana yang mencakup manajemen user, film, kategori, riwayat tontonan, favorit, dan rating.

---

##  1. ERD (Entity Relationship Diagram)

### Entitas yang Dibuat

Project ini memiliki **6 entitas** (melebihi minimum 3 entitas yang diminta):

| No | Entitas | Deskripsi |
|----|---------|-----------|
| 1 | `users` | Data pengguna platform |
| 2 | `movie_categories` | Kategori/genre film |
| 3 | `movies` | Data film yang tersedia |
| 4 | `user_watch_history` | Riwayat tontonan user |
| 5 | `user_favorites` | Film favorit user |
| 6 | `user_ratings` | Rating dan review user |

##  2. Primary Key, Relationship & Cardinality

### Primary Key Masing-Masing Tabel

| Tabel | Primary Key | Tipe Data |
|-------|-------------|-----------|
| `users` | `user_id` | INT AUTO_INCREMENT |
| `movie_categories` | `category_id` | INT AUTO_INCREMENT |
| `movies` | `movie_id` | INT AUTO_INCREMENT |
| `user_watch_history` | `history_id` | INT AUTO_INCREMENT |
| `user_favorites` | `favorite_id` | INT AUTO_INCREMENT |
| `user_ratings` | `rating_id` | INT AUTO_INCREMENT |

### Relationship Antar Tabel

| Relasi | Tipe | Penjelasan |
|--------|------|------------|
| `movie_categories` → `movies` | **One-to-Many (1:M)** | Satu kategori dapat memiliki banyak film |
| `users` → `user_watch_history` | **One-to-Many (1:M)** | Satu user dapat menonton banyak film |
| `movies` → `user_watch_history` | **One-to-Many (1:M)** | Satu film dapat ditonton banyak user |
| `users` → `user_favorites` | **One-to-Many (1:M)** | Satu user dapat memfavoritkan banyak film |
| `movies` → `user_favorites` | **One-to-Many (1:M)** | Satu film dapat difavoritkan banyak user |
| `users` → `user_ratings` | **One-to-Many (1:M)** | Satu user dapat memberi rating ke banyak film |
| `movies` → `user_ratings` | **One-to-Many (1:M)** | Satu film dapat dirating oleh banyak user |

### Cardinality

- **`movie_categories` ↔ `movies`**: 1 kategori : N film (1:N)
- **`users` ↔ `movies`** (via `user_watch_history`): M user : N film (M:N) — *Many-to-Many*
- **`users` ↔ `movies`** (via `user_favorites`): M user : N film (M:N) — *Many-to-Many*
- **`users` ↔ `movies`** (via `user_ratings`): M user : N film (M:N) — *Many-to-Many*

> **Catatan**: Relasi Many-to-Many diimplementasikan menggunakan tabel junction/bridge (`user_watch_history`, `user_favorites`, `user_ratings`).

---

## 3. Skema Database MySQL (DDL)

### CREATE DATABASE

```sql
DROP DATABASE IF EXISTS diStreaming;
CREATE DATABASE diStreaming;
USE diStreaming;
```

### CREATE TABLE dengan PK, FK, NOT NULL, dan Constraints

#### Tabel `users`
```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(150) NOT NULL,
    user_created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_user_email (user_email)
);
```

#### Tabel `movie_categories`
```sql
CREATE TABLE movie_categories (
    category_id INT AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id)
);
```

#### Tabel `movies`
```sql
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
```

#### Tabel `user_watch_history`
```sql
CREATE TABLE user_watch_history (
    history_id INT AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    watched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    progress INT NULL,
    PRIMARY KEY (history_id),
    CONSTRAINT fk_history_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_history_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

#### Tabel `user_favorites`
```sql
CREATE TABLE user_favorites (
    favorite_id INT AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (favorite_id),
    UNIQUE KEY uk_user_movie_favorite (user_id, movie_id),
    CONSTRAINT fk_favorites_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorites_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

#### Tabel `user_ratings`
```sql
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
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ratings_movie 
        FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_score CHECK (score >= 0.0 AND score <= 10.0)
);
```

---

##  4. Data Insertion (DML)

Setiap tabel telah diisi dengan **10-15 record** sesuai requirement:

| Tabel | Jumlah Record |
|-------|---------------|
| `users` | 15 records |
| `movie_categories` | 10 records |
| `movies` | 15 records |
| `user_watch_history` | 15 records |
| `user_favorites` | 12 records |
| `user_ratings` | 12 records |

*Lihat file `diStreaming.sql` untuk detail lengkap INSERT statements.*

---

##  5. SQL Fundamentals

### 5.1 Tampilkan Seluruh Film dari Tabel Movies

```sql
SELECT * FROM movies;
```

**Hasil**: Menampilkan semua 15 film dengan kolom `movie_id`, `movie_title`, `movie_rating`, `movie_release_year`, dan `category_id`.

---

### 5.2 Tampilkan Film dengan Rating di Atas 8.0

```sql
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_rating > 8.0
ORDER BY movie_rating DESC;
```

**Hasil**:
| movie_id | movie_title | movie_rating | movie_release_year |
|----------|-------------|--------------|-------------------|
| 8 | Finding Nemo 3 | 8.9 | 2024 |
| 6 | Galaxy Quest 2 | 8.7 | 2024 |
| 1 | The Last Warrior | 8.5 | 2023 |
| 10 | Dragon Kingdom | 8.3 | 2023 |
| 5 | Eternal Love Story | 8.2 | 2021 |
| 13 | Tears of Joy | 8.1 | 2022 |

---

### 5.3 Tampilkan 5 User Pertama Berdasarkan Nama (A-Z)

```sql
SELECT user_id, user_name, user_email, user_created_at 
FROM users 
ORDER BY user_name ASC 
LIMIT 5;
```

**Hasil**:
| user_id | user_name | user_email |
|---------|-----------|------------|
| 1 | Ahmad Rizki | ahmad.rizki@email.com |
| 2 | Budi Santoso | budi.santoso@email.com |
| 3 | Citra Dewi | citra.dewi@email.com |
| 4 | Dian Permata | dian.permata@email.com |
| 5 | Eko Prasetyo | eko.prasetyo@email.com |

---

### 5.4 Tampilkan Film yang Judulnya Mengandung Kata "Love"

```sql
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_title LIKE '%Love%';
```

**Hasil**:
| movie_id | movie_title | movie_rating | movie_release_year |
|----------|-------------|--------------|-------------------|
| 2 | Love in Paris | 7.8 | 2022 |
| 5 | Eternal Love Story | 8.2 | 2021 |
| 14 | Love Actually 2 | 7.9 | 2024 |

---

### 5.5 Tampilkan Film yang Rilis pada Tahun 2024

```sql
SELECT movie_id, movie_title, movie_rating, movie_release_year 
FROM movies 
WHERE movie_release_year = 2024;
```

**Hasil**:
| movie_id | movie_title | movie_rating | movie_release_year |
|----------|-------------|--------------|-------------------|
| 3 | Laugh Out Loud | 6.9 | 2024 |
| 6 | Galaxy Quest 2 | 8.7 | 2024 |
| 8 | Finding Nemo 3 | 8.9 | 2024 |
| 11 | Speed Racer X | 7.4 | 2024 |
| 14 | Love Actually 2 | 7.9 | 2024 |

---

##  6. Aggregate & Conditional Logic

### 6.1 Hitung Total User yang Terdaftar

```sql
SELECT COUNT(*) AS total_users FROM users;
```

**Hasil**: `total_users = 15`

---

### 6.2 Hitung Jumlah Film per Kategori (COUNT + GROUP BY)

```sql
SELECT 
    mc.category_id,
    mc.category_name,
    COUNT(m.movie_id) AS total_movies
FROM movie_categories mc
LEFT JOIN movies m ON mc.category_id = m.category_id
GROUP BY mc.category_id, mc.category_name
ORDER BY total_movies DESC;
```

**Hasil**:
| category_id | category_name | total_movies |
|-------------|---------------|--------------|
| 5 | Romance | 3 |
| 1 | Action | 2 |
| 2 | Comedy | 2 |
| 4 | Horror | 2 |
| 3 | Drama | 1 |
| 6 | Sci-Fi | 1 |
| 7 | Thriller | 1 |
| 8 | Animation | 1 |
| 9 | Documentary | 1 |
| 10 | Fantasy | 1 |

---

### 6.3 Kategori Film Berdasarkan Rating (CASE WHEN)

```sql
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
```

**Hasil**:
| movie_title | movie_rating | rating_category |
|-------------|--------------|-----------------|
| Finding Nemo 3 | 8.9 | Top Rated |
| Galaxy Quest 2 | 8.7 | Top Rated |
| The Last Warrior | 8.5 | Top Rated |
| Dragon Kingdom | 8.3 | Popular |
| Eternal Love Story | 8.2 | Popular |
| Tears of Joy | 8.1 | Popular |
| Love Actually 2 | 7.9 | Popular |
| Love in Paris | 7.8 | Popular |
| The Silent Hour | 7.5 | Popular |
| Speed Racer X | 7.4 | Popular |
| Dark Shadows | 7.2 | Popular |
| Nature Unveiled | 7.0 | Popular |
| Laugh Out Loud | 6.9 | Regular |
| Nightmare Returns | 6.8 | Regular |
| Comedy Night | 6.5 | Regular |

---

##  7. Join Statements

### 7.1 Tampilkan Daftar Film Lengkap (INNER JOIN)

```sql
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
```

**Hasil**: Menampilkan 15 film lengkap dengan nama kategori, rating, tahun rilis, dan tier rating.

---

### 7.2 Tampilkan Kategori yang Belum Memiliki Film (LEFT JOIN)

```sql
SELECT 
    mc.category_id,
    mc.category_name,
    COUNT(m.movie_id) AS total_movies
FROM movie_categories mc
LEFT JOIN movies m ON mc.category_id = m.category_id
GROUP BY mc.category_id, mc.category_name
HAVING COUNT(m.movie_id) = 0;
```

**Hasil**: *Empty set* — Semua kategori sudah memiliki minimal 1 film.

---

##  Query Tambahan

### Riwayat Tontonan User dengan Detail Film

```sql
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
```

### Film Paling Populer (Berdasarkan Jumlah Favorit)

```sql
SELECT 
    m.movie_title,
    mc.category_name,
    m.movie_rating,
    COUNT(uf.favorite_id) AS total_favorites
FROM movies m
INNER JOIN movie_categories mc ON m.category_id = mc.category_id
LEFT JOIN user_favorites uf ON m.movie_id = uf.movie_id
GROUP BY m.movie_id, m.movie_title, mc.category_name, m.movie_rating
ORDER BY total_favorites DESC
LIMIT 5;
```

---

##  Cara Menjalankan

1. Buka MySQL client (MySQL Workbench, phpMyAdmin, atau CLI)
2. Jalankan file `diStreaming.sql`
3. Database `diStreaming` akan otomatis dibuat dengan semua tabel dan data

```bash
mysql -u root -p < diStreaming.sql
```
