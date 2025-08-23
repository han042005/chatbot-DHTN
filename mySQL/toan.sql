CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `supham_toanhoc`;
CREATE TABLE `supham_toanhoc` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER after_insert_sach_kinhte
AFTER INSERT ON sach
FOR EACH ROW
BEGIN
    IF NEW.id_nganh = 8 THEN
        INSERT INTO supham_toanhoc (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `supham_toanhoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Giáo trình Đại số tuyến tính', 'Nguyễn Văn An', 8),
('Giáo trình Giải tích 1', 'Trần Thị Bình', 10),
('Giáo trình Giải tích 2', 'Lê Văn Cường', 7),
('Hình học sơ cấp', 'Nguyễn Thị Hạnh', 12),
('Lý thuyết xác suất và thống kê', 'Phạm Thị Mai', 9),
('Phương pháp dạy học Toán ở trường phổ thông', 'Nguyễn Văn Hoàng', 11),
('Logic toán học', 'Vũ Thị Thu', 6),
('Đại số trừu tượng', 'Lê Thị Thanh', 14),
('Giải tích số', 'Nguyễn Văn Tuấn', 5),
('Toán ứng dụng', 'Hoàng Thị Nga', 13);

COMMIT;
