CREATE DATABASE IF NOT EXISTS `library_chatbot`;
USE `library_chatbot`;
DROP TABLE IF EXISTS `supham_khoahoc_tunhien`;
CREATE TABLE `supham_khoahoc_tunhien` (
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
    IF NEW.id_nganh = 14 THEN
        INSERT INTO supham_hoahoc (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;


INSERT INTO `supham_khoahoc_tunhien` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Khoa học tự nhiên đại cương', 'Nguyễn Văn An', 8),
('Vật lý cơ bản', 'Trần Thị Bình', 10),
('Hóa học cơ bản', 'Lê Văn Cường', 7),
('Sinh học cơ bản', 'Nguyễn Thị Hạnh', 12),
('Địa lý tự nhiên', 'Phạm Thị Mai', 9),
('Phương pháp dạy học Khoa học tự nhiên', 'Nguyễn Văn Hoàng', 11),
('Thí nghiệm Khoa học tự nhiên', 'Vũ Thị Thu', 6),
('Môi trường và phát triển bền vững', 'Lê Thị Thanh', 14),
('Thiên văn học cơ bản', 'Nguyễn Văn Tuấn', 5),
('Năng lượng và đời sống', 'Hoàng Thị Nga', 13);

COMMIT;
