CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `supham_nguvan`;
CREATE TABLE `supham_nguvan` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `supham_nguvan` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Lý luận văn học', 'Nguyễn Văn An', 8),
('Văn học Việt Nam trung đại', 'Trần Thị Bình', 10),
('Văn học Việt Nam hiện đại', 'Lê Văn Cường', 7),
('Văn học nước ngoài', 'Nguyễn Thị Hạnh', 12),
('Ngữ pháp tiếng Việt', 'Phạm Thị Mai', 9),
('Phương pháp dạy học Ngữ văn', 'Nguyễn Văn Hoàng', 11),
('Phong cách học và tu từ học', 'Vũ Thị Thu', 6),
('Lịch sử văn học Việt Nam', 'Lê Thị Thanh', 14),
('Tiếng Việt thực hành', 'Nguyễn Văn Tuấn', 5),
('Ngôn ngữ học đại cương', 'Hoàng Thị Nga', 13);

COMMIT;
