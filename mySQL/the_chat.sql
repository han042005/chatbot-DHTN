CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;
DROP TABLE IF EXISTS `giaoduc_thechat`;
CREATE TABLE `giaoduc_thechat` (
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
    IF NEW.id_nganh = 15 THEN
        INSERT INTO giaoduc_thechat (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `giaoduc_thechat` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Phương pháp giảng dạy Thể chất', 'Nguyễn Văn An', 8),
('Giáo dục thể chất ở trường phổ thông', 'Trần Thị Bình', 10),
('Thể dục rèn luyện sức khỏe', 'Lê Văn Cường', 7),
('Thể thao dành cho học sinh tiểu học', 'Nguyễn Thị Hạnh', 12),
('Thể thao phổ thông cơ bản', 'Phạm Thị Mai', 9),
('Tổ chức hoạt động thể chất ngoài trời', 'Nguyễn Văn Hoàng', 11),
('Thí nghiệm thể chất', 'Vũ Thị Thu', 6),
('Giáo dục thể chất mầm non', 'Lê Thị Thanh', 14),
('Tâm lý học trong thể thao học đường', 'Nguyễn Văn Tuấn', 5),
('Huấn luyện vận động cơ bản', 'Hoàng Thị Nga', 13);

COMMIT;