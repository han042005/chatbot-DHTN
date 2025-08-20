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

DELIMITER $$

CREATE TRIGGER after_insert_sach_kinhte
AFTER INSERT ON sach
FOR EACH ROW
BEGIN
    IF NEW.id_nganh = 2 THEN
        INSERT INTO sach_kinhte (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

-- AUTO_INCREMENT cho bảng
ALTER TABLE `sach_kinhte`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 11;

-- --------------------------------------------------------
-- AUTO_INCREMENT cho bảng `sach_kinhte`
-- --------------------------------------------------------

ALTER TABLE `sach_kinhte`
  AUTO_INCREMENT = 11;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
