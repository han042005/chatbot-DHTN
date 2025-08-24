USE `library_chatbot`;

DROP TABLE IF EXISTS `xet_nghiem_y_hoc`;
CREATE TABLE `xet_nghiem_y_hoc` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `ten_sach` VARCHAR(255) NOT NULL,
    `tac_gia` VARCHAR(150) NOT NULL,
    `so_luong_ton` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER after_insert_sach_kinhte
AFTER INSERT ON sach
FOR EACH ROW
BEGIN
    IF NEW.id_nganh = 17 THEN
        INSERT INTO xet_nghiem_y_hoc (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;


INSERT INTO `xet_nghiem_y_hoc` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Kỹ thuật xét nghiệm cơ bản', 'Nguyễn Văn An', 8),
('Hóa sinh lâm sàng', 'Trần Thị Bình', 10),
('Xét nghiệm huyết học', 'Lê Văn Cường', 7),
('Vi sinh – xét nghiệm vi trùng', 'Nguyễn Thị Hạnh', 12),
('Xét nghiệm miễn dịch', 'Phạm Thị Mai', 9),
('Phương pháp chuẩn đoán hiện đại', 'Nguyễn Văn Hoàng', 11),
('Thí nghiệm huyết học', 'Vũ Thị Thu', 6),
('Thí nghiệm hóa sinh', 'Lê Thị Thanh', 14),
('Chẩn đoán phân tử', 'Nguyễn Văn Tuấn', 5),
('An toàn trong phòng xét nghiệm', 'Hoàng Thị Nga', 13);

COMMIT;
