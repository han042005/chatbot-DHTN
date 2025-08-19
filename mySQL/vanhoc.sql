USE `library_chatbot`;

DROP TABLE IF EXISTS `van_hoc`;
CREATE TABLE `van_hoc` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `van_hoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Văn học Việt Nam đại cương', 'Nguyễn Văn An', 8),
('Tiểu thuyết Việt Nam hiện đại', 'Trần Thị Bình', 10),
('Thơ ca Việt Nam', 'Lê Văn Cường', 7),
('Phê bình văn học', 'Nguyễn Thị Hạnh', 12),
('Thơ ca hiện đại', 'Phạm Thị Mai', 9),
('Văn học so sánh', 'Nguyễn Văn Hoàng', 11),
('Văn bản học', 'Vũ Thị Thu', 6),
('Tiểu luận văn học', 'Lê Thị Thanh', 14),
('Ký – tản văn – tùy bút', 'Nguyễn Văn Tuấn', 5),
('Ngôn ngữ và văn học', 'Hoàng Thị Nga', 13);

COMMIT;
