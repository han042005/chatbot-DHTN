CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

DROP TABLE IF EXISTS `supham_vatly`;
CREATE TABLE `supham_vatly` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `supham_vatly` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Cơ học đại cương', 'Nguyễn Văn An', 9),
('Nhiệt học và Nhiệt động lực học', 'Trần Thị Bình', 10),
('Điện học và Điện từ học', 'Lê Văn Cường', 7),
('Quang học', 'Nguyễn Thị Hạnh', 12),
('Vật lý hạt nhân', 'Phạm Thị Mai', 8),
('Phương pháp dạy học Vật lý', 'Nguyễn Văn Hoàng', 11),
('Thí nghiệm Vật lý phổ thông', 'Vũ Thị Thu', 6),
('Cơ học lượng tử', 'Lê Thị Thanh', 14),
('Vật lý chất rắn', 'Nguyễn Văn Tuấn', 5),
('Vật lý hiện đại', 'Hoàng Thị Nga', 13);

COMMIT;
