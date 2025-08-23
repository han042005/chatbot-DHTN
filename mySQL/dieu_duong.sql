CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `dieu_duong`;
CREATE TABLE `dieu_duong` (
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
    IF NEW.id_nganh = 16 THEN
        INSERT INTO dieu_duong (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `dieu_duong` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Cơ sở điều dưỡng', 'Nguyễn Văn An', 8),
('Kỹ năng chăm sóc người bệnh', 'Trần Thị Bình', 10),
('Điều dưỡng cơ bản', 'Lê Văn Cường', 7),
('Điều dưỡng ngoại khoa', 'Nguyễn Thị Hạnh', 12),
('Điều dưỡng nội khoa', 'Phạm Thị Mai', 9),
('Dinh dưỡng và chăm sóc bệnh nhân', 'Nguyễn Văn Hoàng', 11),
('Giáo dục sức khoẻ cộng đồng', 'Vũ Thị Thu', 6),
('Chăm sóc người cao tuổi', 'Lê Thị Thanh', 14),
('Điều dưỡng cấp cứu', 'Nguyễn Văn Tuấn', 5),
('Phong cách giao tiếp với người bệnh', 'Hoàng Thị Nga', 13);

COMMIT;
