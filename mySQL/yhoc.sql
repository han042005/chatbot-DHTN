-- Chọn database (thay ql_sach bằng tên database của bạn)
CREATE DATABASE IF NOT EXISTS ql_sach;
USE ql_sach;

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `sach_yhoc`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `sach_yhoc`;
CREATE TABLE `sach_yhoc` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ten_sach` VARCHAR(255) NOT NULL,
  `tac_gia` VARCHAR(150) NOT NULL,
  `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Dữ liệu mẫu cho bảng `sach_yhoc`
-- --------------------------------------------------------

INSERT INTO `sach_yhoc` (`id`, `ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
(1, 'Giải phẫu học', 'Nguyễn Hữu Tùng', 12),
(2, 'Sinh lý học', 'Trần Văn Bình', 8),
(3, 'Dược lý học', 'Lê Thị Mai', 14),
(4, 'Chẩn đoán hình ảnh', 'Nguyễn Duy Huề', 7),
(5, 'Nội khoa cơ bản', 'Phạm Văn Hải', 10),
(6, 'Ngoại khoa cơ bản', 'Hoàng Văn Thắng', 6),
(7, 'Sản phụ khoa', 'Nguyễn Thị Hồng', 15),
(8, 'Nhi khoa', 'Trần Văn Quang', 9),
(9, 'Y học cổ truyền', 'Phạm Văn Đức', 11),
(10, 'Dinh dưỡng học', 'Nguyễn Thị Minh Phương', 13);

-- Tự động tăng id tiếp theo từ 11
ALTER TABLE `sach_yhoc` AUTO_INCREMENT = 11;
