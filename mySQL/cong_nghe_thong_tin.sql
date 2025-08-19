-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Cơ sở dữ liệu: `library_chatbot`
CREATE DATABASE IF NOT EXISTS `library_chatbot`;
USE `library_chatbot`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
    /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
    /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
    /*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `sach`
-- (Không có cột Năm xuất bản)
-- --------------------------------------------------------

DROP TABLE IF EXISTS `cong_nghe_thong_tin`;
CREATE TABLE `cong_nghe_thong_tin` (
  `id` INT(11) NOT NULL,
  `ten_sach` VARCHAR(255) NOT NULL,
  `tac_gia` VARCHAR(150) NOT NULL,
  `so_luong_ton` INT(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Dữ liệu mẫu cho bảng `sach`
-- --------------------------------------------------------

INSERT INTO `cong_nghe_thong_tin` (`id`, `ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
(1, 'Cấu trúc dữ liệu và giải thuật', 'Nguyễn Thanh Tùng', 2),
(2, 'Trí tuệ nhân tạo – Nguyên lý và ứng dụng', 'Trần Minh Hoàng', 8),
(3, 'Lập trình Python cơ bản', 'Lê Thị Bích Hạnh', 15),
(4, 'An toàn và bảo mật thông tin', 'Nguyễn Văn Hưng', 10),
(5, 'Hệ điều hành – Lý thuyết và thực hành', 'Phạm Minh Tuấn', 6),
(6, 'Mạng máy tính', 'Hoàng Quang Dũng', 9),
(7, 'Lập trình Web với HTML, CSS, JavaScript', 'Nguyễn Văn Dương', 9),
(8, 'Khoa học dữ liệu', 'Trần Quốc Toàn', 13),
(9, 'Học máy (Machine Learning)', 'Phạm Hải Nam', 7),
(10, 'Cơ sở dữ liệu', 'Nguyễn Thị Thu Trang', 7);

-- --------------------------------------------------------
-- Chỉ mục cho bảng `sach`
-- --------------------------------------------------------

ALTER TABLE `cong_nghe_thong_tin`
  ADD PRIMARY KEY (`id`);

-- --------------------------------------------------------
-- AUTO_INCREMENT cho bảng `sach`
-- --------------------------------------------------------

ALTER TABLE `cong_nghe_thong_tin`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
    /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
    /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
