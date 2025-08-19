-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th8 19, 2025 lúc 04:27 AM
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
-- Cấu trúc bảng cho bảng `phieu_muon`
--

CREATE TABLE `phieu_muon` (
  `id` int(11) NOT NULL,
  `ma_sv` varchar(50) DEFAULT NULL,
  `ma_gv` varchar(50) DEFAULT NULL,
  `id_sach` int(11) NOT NULL,
  `ten_sach` varchar(255) NOT NULL,
  `tac_gia` varchar(255) DEFAULT NULL,
  `nam_xuat_ban` year(4) DEFAULT NULL,
  `trang_thai` enum('dang_muon','da_tra','qua_han') DEFAULT 'dang_muon',
  `ngay_muon` date NOT NULL,
  `han_tra` date NOT NULL,
  `ngay_tra` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieu_muon`
--

INSERT INTO `phieu_muon` (`id`, `ma_sv`, `ma_gv`, `id_sach`, `ten_sach`, `tac_gia`, `nam_xuat_ban`, `trang_thai`, `ngay_muon`, `han_tra`, `ngay_tra`) VALUES
(24, '23103097', NULL, 10, 'Cơ sở dữ liệu', 'Nguyễn Thị Thu Trang', '2019', 'da_tra', '2025-08-17', '2025-08-25', '2025-08-19'),
(25, '23103097', NULL, 10, 'Cơ sở dữ liệu', 'Nguyễn Thị Thu Trang', '2019', 'dang_muon', '2025-08-17', '2025-08-25', NULL),
(26, '23103097', NULL, 10, 'Cơ sở dữ liệu', 'Nguyễn Thị Thu Trang', '2019', 'dang_muon', '2025-08-17', '2025-08-25', NULL),
(27, '23103097', NULL, 3, 'Lập trình Python cơ bản', NULL, NULL, 'dang_muon', '2025-08-17', '2025-08-25', NULL),
(28, '23103097', NULL, 3, 'Lập trình Python cơ bản', 'Lê Thị Bích Hạnh', '2019', 'da_tra', '2025-08-17', '2025-08-25', '2025-08-17'),
(30, '23103097', NULL, 2, 'Trí tuệ nhân tạo – Nguyên lý và ứng dụng', 'Trần Minh Hoàng', '2021', 'dang_muon', '2025-08-18', '2025-08-25', NULL),
(56, '23103097', NULL, 82, 'Nhiệt học và Nhiệt động lực học', 'Trần Thị Bình', '2019', 'da_tra', '2025-08-19', '2025-08-26', '2025-08-19'),
(57, '23103097', NULL, 104, 'Tiến hóa', 'Nguyễn Thị Hạnh', '2017', 'da_tra', '2025-08-19', '2025-08-26', '2025-08-19'),
(58, '23103097', NULL, 124, 'Linguistics for English Language Teaching', 'David Crystal', '2017', 'da_tra', '2025-08-19', '2025-08-26', '2025-08-19'),
(59, '23103097', NULL, 61, 'Giáo trình Lý luận Chính trị', 'Nguyễn Văn An', '2018', 'da_tra', '2025-08-19', '2025-08-26', '2025-08-19'),
(60, '23103097', NULL, 63, 'Lịch sử Đảng Cộng sản Việt Nam', 'Lê Văn Cường', '2020', 'da_tra', '2025-08-19', '2025-08-26', '2025-08-19');

--
-- Bẫy `phieu_muon`
--
DELIMITER $$
CREATE TRIGGER `trg_phieu_muon_after_insert` AFTER INSERT ON `phieu_muon` FOR EACH ROW BEGIN
  -- Giảm tồn kho sách
  UPDATE sach
  SET so_luong_ton = so_luong_ton - 1
  WHERE ten_sach = NEW.ten_sach;

  -- Nếu sinh viên mượn
  IF NEW.ma_sv IS NOT NULL THEN
    UPDATE sinh_vien
    SET so_sach_da_muon = so_sach_da_muon + 1,
        so_sach_dang_muon = so_sach_dang_muon + 1
    WHERE ma_sv = NEW.ma_sv;
  END IF;

  -- Nếu giảng viên mượn
  IF NEW.ma_gv IS NOT NULL THEN
    UPDATE giang_vien
    SET so_sach_da_muon = so_sach_da_muon + 1,
        so_sach_dang_muon = so_sach_dang_muon + 1
    WHERE ma_gv = NEW.ma_gv;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_phieu_muon_after_update` AFTER UPDATE ON `phieu_muon` FOR EACH ROW BEGIN
  IF NEW.trang_thai = 'da_tra' AND OLD.trang_thai != 'da_tra' THEN
    UPDATE sach
    SET so_luong_ton = so_luong_ton + 1
    WHERE id = NEW.id_sach;

    IF NEW.ma_sv IS NOT NULL THEN
      UPDATE sinh_vien
      SET so_sach_dang_muon = so_sach_dang_muon - 1,
          so_sach_da_tra = so_sach_da_tra + 1
      WHERE ma_sv = NEW.ma_sv;
    END IF;

    IF NEW.ma_gv IS NOT NULL THEN
      UPDATE giang_vien
      SET so_sach_dang_muon = so_sach_dang_muon - 1,
          so_sach_da_tra = so_sach_da_tra + 1
      WHERE ma_gv = NEW.ma_gv;
    END IF;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_phieu_muon_before_insert` BEFORE INSERT ON `phieu_muon` FOR EACH ROW BEGIN
  DECLARE current_stock INT;

  SELECT so_luong_ton INTO current_stock
  FROM sach
  WHERE ten_sach = NEW.ten_sach
  LIMIT 1;

  -- Nếu không đủ sách tồn thì báo lỗi
  IF current_stock IS NULL OR current_stock <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Sách không còn trong kho!';
  END IF;
END
$$
DELIMITER ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `phieu_muon`
--
ALTER TABLE `phieu_muon`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_phieu_sach` (`id_sach`),
  ADD KEY `fk_phieu_sv` (`ma_sv`),
  ADD KEY `fk_phieu_gv` (`ma_gv`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `phieu_muon`
--
ALTER TABLE `phieu_muon`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `phieu_muon`
--
ALTER TABLE `phieu_muon`
  ADD CONSTRAINT `fk_phieu_gv` FOREIGN KEY (`ma_gv`) REFERENCES `giang_vien` (`ma_gv`),
  ADD CONSTRAINT `fk_phieu_sach` FOREIGN KEY (`id_sach`) REFERENCES `sach` (`id`),
  ADD CONSTRAINT `fk_phieu_sv` FOREIGN KEY (`ma_sv`) REFERENCES `sinh_vien` (`ma_sv`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
