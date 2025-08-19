USE `library_chatbot`;

DROP TABLE IF EXISTS `triet_hoc`;
CREATE TABLE `triet_hoc` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `triet_hoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Lịch sử triết học phương Tây', 'Nguyễn Văn An', 8),
('Triết học Mác – Lênin', 'Trần Thị Bình', 10),
('Triết học hiện đại', 'Lê Văn Cường', 7),
('Triết học phương Đông', 'Nguyễn Thị Hạnh', 12),
('Phương pháp triết học', 'Phạm Thị Mai', 9),
('Triết học và xã hội', 'Nguyễn Văn Hoàng', 11),
('Triết học đạo đức', 'Vũ Thị Thu', 6),
('Triết học khoa học', 'Lê Thị Thanh', 14),
('Tư tưởng triết học đương đại', 'Nguyễn Văn Tuấn', 5),
('Triết học ngôn ngữ', 'Hoàng Thị Nga', 13);

COMMIT;
