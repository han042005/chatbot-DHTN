USE `library_chatbot`;

DROP TABLE IF EXISTS `ngon_ngu_anh`;
CREATE TABLE `ngon_ngu_anh` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `ngon_ngu_anh` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Linguistics for Language Teaching', 'Carol A. Chapelle', 8),
('Ngôn ngữ học ứng dụng', 'Crystal David', 10),
('Ngôn ngữ và xã hội', 'Peter Trudgill', 7),
('Ngôn ngữ – Tư duy và giao tiếp', 'Edward Sapir', 12),
('Phương pháp dạy tiếng Anh nâng cao', 'Lucrecia Garcia', 9),
('Ngôn ngữ học tâm lý', 'Susan Ervin-Tripp', 11),
('Ngôn ngữ và văn hóa', 'Dell Hymes', 6),
('Ngôn ngữ học hiện đại', 'William Labov', 14),
('Ngôn ngữ – cấu trúc và chức năng', 'Michael Halliday', 5),
('Đa dạng ngôn ngữ', 'Joshua Fishman', 13);

COMMIT;
