CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `giaoduc_chinhtri`;
CREATE TABLE `giaoduc_chinhtri` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TRIGGER after_insert_sach_kinhte
AFTER INSERT ON sach
FOR EACH ROW
BEGIN
    IF NEW.id_nganh = 7 THEN
        INSERT INTO giaoduc_chinhtri (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `giaoduc_chinhtri` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Giáo trình Lý luận Chính trị', 'Nguyễn Văn An', 10),
('Tư tưởng Hồ Chí Minh', 'Trần Thị Bình', 8),
('Lịch sử Đảng Cộng sản Việt Nam', 'Lê Văn Cường', 12),
('Pháp luật đại cương', 'Nguyễn Thị Hạnh', 7),
('Chính trị học đại cương', 'Phạm Thị Mai', 11),
('Kinh tế chính trị Mác – Lênin', 'Nguyễn Văn Hoàng', 9),
('Xây dựng Đảng', 'Vũ Thị Thu', 6),
('Quan hệ quốc tế', 'Lê Thị Thanh', 14),
('Giáo dục công dân', 'Nguyễn Văn Tuấn', 5),
('Đường lối cách mạng của Đảng Cộng sản Việt Nam', 'Hoàng Thị Nga', 13);

COMMIT;
