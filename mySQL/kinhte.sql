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
-- Cấu trúc bảng cho bảng `sach_kinhte`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `sach_kinhte`;
CREATE TABLE `sach_kinhte` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ten_sach` VARCHAR(255) NOT NULL,
  `tac_gia` VARCHAR(150) NOT NULL,
  `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Dữ liệu mẫu cho bảng `sach_kinhte`
-- --------------------------------------------------------

INSERT INTO `sach_kinhte` (`id`, `ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
(1, 'Kinh tế học vi mô', 'Nguyễn Thị Lan', 10),
(2, 'Kinh tế học vĩ mô', 'Trần Văn Khánh', 8),
(3, 'Marketing căn bản', 'Lê Văn Long', 14),
(4, 'Quản trị kinh doanh', 'Nguyễn Hoài Nam', 7),
(5, 'Tài chính doanh nghiệp', 'Phạm Thị Minh', 15),
(6, 'Kế toán tài chính', 'Hoàng Văn Phúc', 6),
(7, 'Phân tích đầu tư', 'Nguyễn Hải Đăng', 12),
(8, 'Quản trị nhân sự', 'Trần Thị Thúy', 9),
(9, 'Thương mại điện tử', 'Phạm Anh Dũng', 11),
(10, 'Kinh doanh quốc tế', 'Nguyễn Hữu Phước', 13);

-- --------------------------------------------------------
-- AUTO_INCREMENT cho bảng `sach_kinhte`
-- --------------------------------------------------------

ALTER TABLE `sach_kinhte`
  AUTO_INCREMENT = 11;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
