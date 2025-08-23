CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `giaoduc_tieuhoc`;
CREATE TABLE `giaoduc_tieuhoc` (
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
    IF NEW.id_nganh = 5 THEN
        INSERT INTO giaoduc_tieuhoc (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `giaoduc_tieuhoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Phương pháp dạy học Toán ở tiểu học', 'Nguyễn Văn An', 8),
('Phương pháp dạy học Tiếng Việt ở tiểu học', 'Trần Thị Bình', 9),
('Giáo dục đạo đức ở tiểu học', 'Lê Văn Cường', 12),
('Phương pháp dạy học Tự nhiên và Xã hội', 'Nguyễn Thị Hạnh', 7),
('Tâm lý học lứa tuổi tiểu học', 'Phạm Thị Mai', 11),
('Đánh giá kết quả học tập ở tiểu học', 'Nguyễn Văn Hoàng', 10),
('Phát triển kỹ năng sống cho học sinh tiểu học', 'Vũ Thị Thu', 6),
('Ứng dụng CNTT trong dạy học tiểu học', 'Lê Thị Thanh', 15),
('Giáo dục thể chất ở tiểu học', 'Nguyễn Văn Tuấn', 5),
('Phương pháp dạy học Âm nhạc ở tiểu học', 'Hoàng Thị Nga', 13);

COMMIT;
