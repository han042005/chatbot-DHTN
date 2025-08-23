CREATE DATABASE IF NOT EXISTS library_chatbot;
USE `library_chatbot`;

SET SQL_MODE= "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP TABLE IF EXISTS `gdmn`;
CREATE TABLE `gdmn` (
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
    IF NEW.id_nganh = 4 THEN
        INSERT INTO gdmn (id, ten_sach, tac_gia, so_luong_ton)
        VALUES (NEW.id, NEW.ten_sach, NEW.tac_gia, NEW.so_luong_ton);
    END IF;
END$$

DELIMITER ;

INSERT INTO `gdmn` (`ten_sach`, `tac_gia`, `so_luong_ton`) VALUES
('Phương pháp tổ chức hoạt động vui chơi cho trẻ mầm non', 'Nguyễn Thị Lan', 7),
('Tâm lý học trẻ em lứa tuổi mầm non', 'Trần Văn Minh', 12),
('Giáo dục âm nhạc cho trẻ mầm non', 'Lê Thị Hoa', 9),
('Phát triển ngôn ngữ cho trẻ mầm non', 'Phạm Thị Hương', 8),
('Giáo dục thể chất cho trẻ mầm non', 'Nguyễn Văn Thành', 10),
('Chăm sóc sức khỏe trẻ mầm non', 'Nguyễn Thị Thu', 6),
('Tổ chức hoạt động tạo hình cho trẻ mầm non', 'Vũ Thị Mai', 11),
('Phát triển tình cảm – kỹ năng xã hội cho trẻ mầm non', 'Lê Văn Dũng', 5),
('Giáo dục lễ giáo cho trẻ mầm non', 'Hoàng Thị Thanh', 13),
('Tổ chức hoạt động khám phá khoa học cho trẻ mầm non', 'Nguyễn Thị Oanh', 14);

COMMIT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
