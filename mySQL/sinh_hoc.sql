CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `supham_sinhhoc`;
CREATE TABLE `supham_sinhhoc` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `supham_sinhhoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Sinh học đại cương', 'Nguyễn Văn An', 8),
('Sinh học tế bào', 'Trần Thị Bình', 10),
('Di truyền học', 'Lê Văn Cường', 7),
('Tiến hóa', 'Nguyễn Thị Hạnh', 12),
('Hệ sinh thái học', 'Phạm Thị Mai', 9),
('Phương pháp dạy học Sinh học', 'Nguyễn Văn Hoàng', 11),
('Giải phẫu và Sinh lý thực vật', 'Vũ Thị Thu', 6),
('Giải phẫu và Sinh lý động vật', 'Lê Thị Thanh', 14),
('Vi sinh vật học', 'Nguyễn Văn Tuấn', 5),
('Thí nghiệm Sinh học phổ thông', 'Hoàng Thị Nga', 13);

COMMIT;
