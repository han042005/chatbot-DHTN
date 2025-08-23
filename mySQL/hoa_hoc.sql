CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `supham_hoahoc`;
CREATE TABLE `supham_hoahoc` (
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
    IF NEW.id_nganh = 10 THEN
        INSERT INTO supham_hoahoc (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `supham_hoahoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Hóa học đại cương', 'Nguyễn Văn An', 8),
('Hóa học vô cơ 1', 'Trần Thị Bình', 10),
('Hóa học vô cơ 2', 'Lê Văn Cường', 7),
('Hóa học hữu cơ 1', 'Nguyễn Thị Hạnh', 12),
('Hóa học hữu cơ 2', 'Phạm Thị Mai', 9),
('Phương pháp dạy học Hóa học', 'Nguyễn Văn Hoàng', 11),
('Hóa phân tích', 'Vũ Thị Thu', 6),
('Hóa lý', 'Lê Thị Thanh', 14),
('Hóa sinh', 'Nguyễn Văn Tuấn', 5),
('Thí nghiệm Hóa học phổ thông', 'Hoàng Thị Nga', 13);

COMMIT;
