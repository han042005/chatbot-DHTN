-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th8 19, 2025 lúc 04:26 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `library_chatbot`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nganh_hoc`
--

CREATE TABLE `nganh_hoc` (
  `id` int(11) NOT NULL,
  `ten_nganh` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `nganh_hoc`
--

INSERT INTO `nganh_hoc` (`id`, `ten_nganh`) VALUES
(1, 'Công nghệ thông tin'),
(2, 'Kinh tế'),
(3, 'Y học'),
(4, 'Giáo dục Mầm non'),
(5, 'Giáo dục Tiểu học'),
(6, 'Giáo dục Tiểu học - Tiếng Jrai'),
(7, 'Giáo dục Chính trị'),
(8, 'Sư phạm Toán học'),
(9, 'Sư phạm Vật lý'),
(10, 'Sư phạm Hóa học'),
(11, 'Sư phạm Sinh học'),
(12, 'Sư phạm Ngữ văn'),
(13, 'Sư phạm Tiếng Anh'),
(14, 'Sư phạm Khoa học tự nhiên'),
(15, 'Giáo dục Thể chất'),
(16, 'Điều dưỡng'),
(17, 'Kỹ thuật xét nghiệm y học'),
(18, 'Ngôn ngữ Anh'),
(19, 'Triết học'),
(20, 'Văn học');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `nganh_hoc`
--
ALTER TABLE `nganh_hoc`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `nganh_hoc`
--
ALTER TABLE `nganh_hoc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
