CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `giaoduc_tieuhoc_jrai`;
CREATE TABLE `giaoduc_tieuhoc_jrai` (
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
    IF NEW.id_nganh = 6 THEN
        INSERT INTO giaoduc_tieuhoc_jrai (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `giaoduc_tieuhoc_jrai` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Giáo trình Tiếng Jrai cơ bản', 'Ksor H’Blêu', 9),
('Từ điển Tiếng Jrai – Tiếng Việt', 'Rơ Châm H’Rê', 10),
('Phương pháp giảng dạy Tiếng Jrai ở tiểu học', 'Siu K’Linh', 7),
('Sách bài tập Tiếng Jrai lớp 1', 'H’Lan Niê', 12),
('Sách bài tập Tiếng Jrai lớp 2', 'Rah Lan Thuyên', 8),
('Sách bài tập Tiếng Jrai lớp 3', 'Ksor H’Vinh', 11),
('Sách bài tập Tiếng Jrai lớp 4', 'H’Yim Kpă', 6),
('Sách bài tập Tiếng Jrai lớp 5', 'Rơ Mah Luyên', 14),
('Ngữ pháp Tiếng Jrai', 'Rah Lan Phương', 5),
('Văn hóa – Ngôn ngữ Jrai', 'Siêu H’Yen', 13);

COMMIT;
