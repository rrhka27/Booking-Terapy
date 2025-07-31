-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Jul 2025 pada 06.34
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `therapy_booking`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `therapy_id` int(11) NOT NULL,
  `booking_date` datetime NOT NULL,
  `status` enum('pending','confirmed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `therapy_id`, `booking_date`, `status`, `created_at`) VALUES
(1, 2, 1, '2025-07-21 10:00:00', 'cancelled', '2025-07-20 09:32:39'),
(2, 2, 2, '2025-07-22 14:00:00', 'confirmed', '2025-07-20 09:32:39'),
(3, 3, 3, '2025-07-23 09:00:00', 'cancelled', '2025-07-20 09:32:39'),
(5, 2, 5, '2025-07-26 17:00:00', 'cancelled', '2025-07-26 08:12:32'),
(6, 2, 6, '2025-07-27 10:00:00', 'confirmed', '2025-07-26 10:59:32'),
(7, 6, 1, '2025-07-27 09:00:00', 'cancelled', '2025-07-26 12:35:22'),
(8, 2, 6, '2025-07-31 14:00:00', 'pending', '2025-07-30 04:14:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `therapies`
--

CREATE TABLE `therapies` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `therapies`
--

INSERT INTO `therapies` (`id`, `name`, `description`, `price`, `duration`) VALUES
(1, 'Terapi Pijat Relaksasi', 'Pijat untuk mengurangi stres dan ketegangan otot', '150000.00', 60),
(2, 'Terapi Akupuntur', 'Terapi tradisional untuk menyeimbangkan energi tubuh', '200000.00', 45),
(3, 'Terapi Refleksi', 'Pijat refleksi untuk meningkatkan sirkulasi', '100000.00', 30),
(5, 'Terapi Leuhang', 'terapi pengobatan dengan memanfaatkan uap kukusan rempah-rempah lokal khas Jawa Barat', '35000.00', 15),
(6, 'bekam', 'sering digunakan untuk meredakan rasa sakit di bagian tubuh tertentu.', '50000.00', 30);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `email`) VALUES
(1, 'admin', 'admin', 'admin', 'admin@gmail.com'),
(2, 'user1', 'user', 'user', 'user123@gmail.com'),
(3, 'user2', 'user456', 'user', 'user2@gmail.com'),
(4, 'user3', 'user', 'user', 'user3@gmail.com'),
(5, 'user4', 'user', 'user', 'user4@gmail.com'),
(6, 'nano', '123', 'user', 'nano@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `therapy_id` (`therapy_id`);

--
-- Indeks untuk tabel `therapies`
--
ALTER TABLE `therapies`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `therapies`
--
ALTER TABLE `therapies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`therapy_id`) REFERENCES `therapies` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
