-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th8 17, 2025 lúc 05:03 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `library_chatbot`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sach`
--

CREATE TABLE `sach` (
  `id` int(11) NOT NULL,
  `ten_sach` varchar(255) NOT NULL,
  `tac_gia` varchar(255) DEFAULT NULL,
  `nam_xuat_ban` year(4) DEFAULT NULL,
  `so_luong_ton` int(11) DEFAULT 0,
  `id_nganh` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sach`
--

INSERT INTO `sach` (`id`, `ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`) VALUES
(1, 'Cấu trúc dữ liệu và giải thuật', 'Nguyễn Thanh Tùng', '2020', 2, 1),
(2, 'Trí tuệ nhân tạo – Nguyên lý và ứng dụng', 'Trần Minh Hoàng', '2021', 8, 1),
(3, 'Lập trình Python cơ bản', 'Lê Thị Bích Hạnh', '2019', 15, 1),
(4, 'An toàn và bảo mật thông tin', 'Nguyễn Văn Hưng', '2022', 10, 1),
(5, 'Hệ điều hành – Lý thuyết và thực hành', 'Phạm Minh Tuấn', '2018', 6, 1),
(6, 'Mạng máy tính', 'Hoàng Quang Dũng', '2019', 9, 1),
(7, 'Lập trình Web với HTML, CSS, JavaScript', 'Nguyễn Văn Dương', '2021', 9, 1),
(8, 'Khoa học dữ liệu', 'Trần Quốc Toản', '2020', 13, 1),
(9, 'Học máy (Machine Learning)', 'Phạm Hải Nam', '2022', 7, 1),
(10, 'Cơ sở dữ liệu', 'Nguyễn Thị Thu Trang', '2019', 7, 1),
(11, 'Kinh tế học vi mô', 'Nguyễn Thị Lan', '2018', 10, 2),
(12, 'Kinh tế học vĩ mô', 'Trần Văn Khánh', '2019', 8, 2),
(13, 'Marketing căn bản', 'Lê Văn Long', '2020', 14, 2),
(14, 'Quản trị kinh doanh', 'Nguyễn Hoài Nam', '2021', 7, 2),
(15, 'Tài chính doanh nghiệp', 'Phạm Thị Minh', '2019', 15, 2),
(16, 'Kế toán tài chính', 'Hoàng Văn Phúc', '2018', 6, 2),
(17, 'Phân tích đầu tư', 'Nguyễn Hải Đăng', '2022', 12, 2),
(18, 'Quản trị nhân sự', 'Trần Thị Thúy', '2021', 9, 2),
(19, 'Thương mại điện tử', 'Phạm Anh Dũng', '2020', 11, 2),
(20, 'Kinh doanh quốc tế', 'Nguyễn Hữu Phước', '2022', 13, 2),
(21, 'Giải phẫu học', 'Nguyễn Hữu Tùng', '2018', 12, 3),
(22, 'Sinh lý học', 'Trần Văn Bình', '2019', 8, 3),
(23, 'Dược lý học', 'Lê Thị Mai', '2020', 14, 3),
(24, 'Chẩn đoán hình ảnh', 'Nguyễn Duy Huề', '2021', 7, 3),
(25, 'Nội khoa cơ bản', 'Phạm Văn Hải', '2019', 10, 3),
(26, 'Ngoại khoa cơ bản', 'Hoàng Văn Thắng', '2018', 6, 3),
(27, 'Sản phụ khoa', 'Nguyễn Thị Hồng', '2022', 15, 3),
(28, 'Nhi khoa', 'Trần Văn Quang', '2021', 9, 3),
(29, 'Y học cổ truyền', 'Phạm Văn Đức', '2020', 11, 3),
(30, 'Dinh dưỡng học', 'Nguyễn Thị Minh Phương', '2022', 13, 3),
(31, 'Phương pháp tổ chức hoạt động vui chơi cho trẻ mầm non', 'Nguyễn Thị Lan', '2018', 7, 4),
(32, 'Tâm lý học trẻ em lứa tuổi mầm non', 'Trần Văn Minh', '2019', 12, 4),
(33, 'Giáo dục âm nhạc cho trẻ mầm non', 'Lê Thị Hoa', '2020', 9, 4),
(34, 'Phát triển ngôn ngữ cho trẻ mầm non', 'Phạm Thị Hương', '2017', 8, 4),
(35, 'Giáo dục thể chất cho trẻ mầm non', 'Nguyễn Văn Thành', '2018', 10, 4),
(36, 'Chăm sóc sức khỏe trẻ mầm non', 'Nguyễn Thị Thu', '2021', 6, 4),
(37, 'Tổ chức hoạt động tạo hình cho trẻ mầm non', 'Vũ Thị Mai', '2019', 11, 4),
(38, 'Phát triển tình cảm – kỹ năng xã hội cho trẻ mầm non', 'Lê Văn Dũng', '2022', 5, 4),
(39, 'Giáo dục lễ giáo cho trẻ mầm non', 'Hoàng Thị Thanh', '2020', 13, 4),
(40, 'Tổ chức hoạt động khám phá khoa học cho trẻ mầm non', 'Nguyễn Thị Oanh', '2021', 14, 4),
(41, 'Phương pháp dạy học Toán ở tiểu học', 'Nguyễn Văn An', '2018', 8, 5),
(42, 'Phương pháp dạy học Tiếng Việt ở tiểu học', 'Trần Thị Bình', '2019', 9, 5),
(43, 'Giáo dục đạo đức ở tiểu học', 'Lê Văn Cường', '2020', 12, 5),
(44, 'Phương pháp dạy học Tự nhiên và Xã hội', 'Nguyễn Thị Hạnh', '2017', 7, 5),
(45, 'Tâm lý học lứa tuổi tiểu học', 'Phạm Thị Mai', '2018', 11, 5),
(46, 'Đánh giá kết quả học tập ở tiểu học', 'Nguyễn Văn Hoàng', '2021', 10, 5),
(47, 'Phát triển kỹ năng sống cho học sinh tiểu học', 'Vũ Thị Thu', '2019', 6, 5),
(48, 'Ứng dụng CNTT trong dạy học tiểu học', 'Lê Thị Thanh', '2022', 15, 5),
(49, 'Giáo dục thể chất ở tiểu học', 'Nguyễn Văn Tuấn', '2020', 5, 5),
(50, 'Phương pháp dạy học Âm nhạc ở tiểu học', 'Hoàng Thị Nga', '2021', 13, 5),
(51, 'Giáo trình Tiếng Jrai cơ bản', 'Ksor H’Blêu', '2018', 9, 6),
(52, 'Từ điển Tiếng Jrai – Tiếng Việt', 'Rơ Châm H’Rê', '2019', 10, 6),
(53, 'Phương pháp giảng dạy Tiếng Jrai ở tiểu học', 'Siu K’Linh', '2020', 7, 6),
(54, 'Sách bài tập Tiếng Jrai lớp 1', 'H’Lan Niê', '2017', 12, 6),
(55, 'Sách bài tập Tiếng Jrai lớp 2', 'Rah Lan Thuyên', '2018', 8, 6),
(56, 'Sách bài tập Tiếng Jrai lớp 3', 'Ksor H’Vinh', '2021', 11, 6),
(57, 'Sách bài tập Tiếng Jrai lớp 4', 'H’Yim Kpă', '2019', 6, 6),
(58, 'Sách bài tập Tiếng Jrai lớp 5', 'Rơ Mah Luyên', '2022', 14, 6),
(59, 'Ngữ pháp Tiếng Jrai', 'Rah Lan Phương', '2020', 5, 6),
(60, 'Văn hóa – Ngôn ngữ Jrai', 'Siêu H’Yen', '2021', 13, 6),
(61, 'Giáo trình Lý luận Chính trị', 'Nguyễn Văn An', '2018', 10, 7),
(62, 'Tư tưởng Hồ Chí Minh', 'Trần Thị Bình', '2019', 8, 7),
(63, 'Lịch sử Đảng Cộng sản Việt Nam', 'Lê Văn Cường', '2020', 12, 7),
(64, 'Pháp luật đại cương', 'Nguyễn Thị Hạnh', '2017', 7, 7),
(65, 'Chính trị học đại cương', 'Phạm Thị Mai', '2018', 11, 7),
(66, 'Kinh tế chính trị Mác – Lênin', 'Nguyễn Văn Hoàng', '2021', 9, 7),
(67, 'Xây dựng Đảng', 'Vũ Thị Thu', '2019', 6, 7),
(68, 'Quan hệ quốc tế', 'Lê Thị Thanh', '2022', 14, 7),
(69, 'Giáo dục công dân', 'Nguyễn Văn Tuấn', '2020', 5, 7),
(70, 'Đường lối cách mạng của Đảng Cộng sản Việt Nam', 'Hoàng Thị Nga', '2021', 13, 7),
(71, 'Giáo trình Đại số tuyến tính', 'Nguyễn Văn An', '2018', 8, 8),
(72, 'Giáo trình Giải tích 1', 'Trần Thị Bình', '2019', 10, 8),
(73, 'Giáo trình Giải tích 2', 'Lê Văn Cường', '2020', 7, 8),
(74, 'Hình học sơ cấp', 'Nguyễn Thị Hạnh', '2017', 12, 8),
(75, 'Lý thuyết xác suất và thống kê', 'Phạm Thị Mai', '2018', 9, 8),
(76, 'Phương pháp dạy học Toán ở trường phổ thông', 'Nguyễn Văn Hoàng', '2021', 11, 8),
(77, 'Logic toán học', 'Vũ Thị Thu', '2019', 6, 8),
(78, 'Đại số trừu tượng', 'Lê Thị Thanh', '2022', 14, 8),
(79, 'Giải tích số', 'Nguyễn Văn Tuấn', '2020', 5, 8),
(80, 'Toán ứng dụng', 'Hoàng Thị Nga', '2021', 13, 8),
(81, 'Cơ học đại cương', 'Nguyễn Văn An', '2018', 9, 9),
(82, 'Nhiệt học và Nhiệt động lực học', 'Trần Thị Bình', '2019', 10, 9),
(83, 'Điện học và Điện từ học', 'Lê Văn Cường', '2020', 7, 9),
(84, 'Quang học', 'Nguyễn Thị Hạnh', '2017', 12, 9),
(85, 'Vật lý hạt nhân', 'Phạm Thị Mai', '2018', 8, 9),
(86, 'Phương pháp dạy học Vật lý', 'Nguyễn Văn Hoàng', '2021', 11, 9),
(87, 'Thí nghiệm Vật lý phổ thông', 'Vũ Thị Thu', '2019', 6, 9),
(88, 'Cơ học lượng tử', 'Lê Thị Thanh', '2022', 14, 9),
(89, 'Vật lý chất rắn', 'Nguyễn Văn Tuấn', '2020', 5, 9),
(90, 'Vật lý hiện đại', 'Hoàng Thị Nga', '2021', 13, 9),
(91, 'Hóa học đại cương', 'Nguyễn Văn An', '2018', 8, 10),
(92, 'Hóa học vô cơ 1', 'Trần Thị Bình', '2019', 10, 10),
(93, 'Hóa học vô cơ 2', 'Lê Văn Cường', '2020', 7, 10),
(94, 'Hóa học hữu cơ 1', 'Nguyễn Thị Hạnh', '2017', 12, 10),
(95, 'Hóa học hữu cơ 2', 'Phạm Thị Mai', '2018', 9, 10),
(96, 'Phương pháp dạy học Hóa học', 'Nguyễn Văn Hoàng', '2021', 11, 10),
(97, 'Hóa phân tích', 'Vũ Thị Thu', '2019', 6, 10),
(98, 'Hóa lý', 'Lê Thị Thanh', '2022', 14, 10),
(99, 'Hóa sinh', 'Nguyễn Văn Tuấn', '2020', 5, 10),
(100, 'Thí nghiệm Hóa học phổ thông', 'Hoàng Thị Nga', '2021', 13, 10),
(101, 'Sinh học đại cương', 'Nguyễn Văn An', '2018', 8, 11),
(102, 'Sinh học tế bào', 'Trần Thị Bình', '2019', 10, 11),
(103, 'Di truyền học', 'Lê Văn Cường', '2020', 7, 11),
(104, 'Tiến hóa', 'Nguyễn Thị Hạnh', '2017', 12, 11),
(105, 'Hệ sinh thái học', 'Phạm Thị Mai', '2018', 9, 11),
(106, 'Phương pháp dạy học Sinh học', 'Nguyễn Văn Hoàng', '2021', 11, 11),
(107, 'Giải phẫu và Sinh lý thực vật', 'Vũ Thị Thu', '2019', 6, 11),
(108, 'Giải phẫu và Sinh lý động vật', 'Lê Thị Thanh', '2022', 14, 11),
(109, 'Vi sinh vật học', 'Nguyễn Văn Tuấn', '2020', 5, 11),
(110, 'Thí nghiệm Sinh học phổ thông', 'Hoàng Thị Nga', '2021', 13, 11),
(111, 'Lý luận văn học', 'Nguyễn Văn An', '2018', 8, 12),
(112, 'Văn học Việt Nam trung đại', 'Trần Thị Bình', '2019', 10, 12),
(113, 'Văn học Việt Nam hiện đại', 'Lê Văn Cường', '2020', 7, 12),
(114, 'Văn học nước ngoài', 'Nguyễn Thị Hạnh', '2017', 12, 12),
(115, 'Ngữ pháp tiếng Việt', 'Phạm Thị Mai', '2018', 9, 12),
(116, 'Phương pháp dạy học Ngữ văn', 'Nguyễn Văn Hoàng', '2021', 11, 12),
(117, 'Phong cách học và tu từ học', 'Vũ Thị Thu', '2019', 6, 12),
(118, 'Lịch sử văn học Việt Nam', 'Lê Thị Thanh', '2022', 14, 12),
(119, 'Tiếng Việt thực hành', 'Nguyễn Văn Tuấn', '2020', 5, 12),
(120, 'Ngôn ngữ học đại cương', 'Hoàng Thị Nga', '2021', 13, 12),
(121, 'English Grammar in Use', 'Raymond Murphy', '2018', 8, 13),
(122, 'Phonetics and Phonology', 'Peter Roach', '2019', 10, 13),
(123, 'Teaching English as a Foreign Language', 'Jeremy Harmer', '2020', 7, 13),
(124, 'Linguistics for English Language Teaching', 'David Crystal', '2017', 12, 13),
(125, 'English Vocabulary in Use', 'Michael McCarthy', '2018', 9, 13),
(126, 'Phương pháp giảng dạy Tiếng Anh', 'Nguyễn Văn Hoàng', '2021', 11, 13),
(127, 'Test Your English Grammar', 'Susan Norman', '2019', 6, 13),
(128, 'English for Academic Purposes', 'R. R. Jordan', '2022', 14, 13),
(129, 'English Writing Skills', 'Ann Hogue', '2020', 5, 13),
(130, 'English Listening Practice', 'John Field', '2021', 13, 13),
(131, 'Khoa học tự nhiên đại cương', 'Nguyễn Văn An', '2018', 8, 14),
(132, 'Vật lý cơ bản', 'Trần Thị Bình', '2019', 10, 14),
(133, 'Hóa học cơ bản', 'Lê Văn Cường', '2020', 7, 14),
(134, 'Sinh học cơ bản', 'Nguyễn Thị Hạnh', '2017', 12, 14),
(135, 'Địa lý tự nhiên', 'Phạm Thị Mai', '2018', 9, 14),
(136, 'Phương pháp dạy học Khoa học tự nhiên', 'Nguyễn Văn Hoàng', '2021', 11, 14),
(137, 'Thí nghiệm Khoa học tự nhiên', 'Vũ Thị Thu', '2019', 6, 14),
(138, 'Môi trường và phát triển bền vững', 'Lê Thị Thanh', '2022', 14, 14),
(139, 'Thiên văn học cơ bản', 'Nguyễn Văn Tuấn', '2020', 5, 14),
(140, 'Năng lượng và đời sống', 'Hoàng Thị Nga', '2021', 13, 14),
(141, 'Phương pháp giảng dạy Thể chất', 'Nguyễn Văn An', '2018', 8, 15),
(142, 'Giáo dục thể chất ở trường phổ thông', 'Trần Thị Bình', '2019', 10, 15),
(143, 'Thể dục rèn luyện sức khỏe', 'Lê Văn Cường', '2020', 7, 15),
(144, 'Thể thao dành cho học sinh tiểu học', 'Nguyễn Thị Hạnh', '2017', 12, 15),
(145, 'Thể thao phổ thông cơ bản', 'Phạm Thị Mai', '2018', 9, 15),
(146, 'Tổ chức hoạt động thể chất ngoài trời', 'Nguyễn Văn Hoàng', '2021', 11, 15),
(147, 'Thí nghiệm thể chất', 'Vũ Thị Thu', '2019', 6, 15),
(148, 'Giáo dục thể chất mầm non', 'Lê Thị Thanh', '2022', 14, 15),
(149, 'Tâm lý học trong thể thao học đường', 'Nguyễn Văn Tuấn', '2020', 5, 15),
(150, 'Huấn luyện vận động cơ bản', 'Hoàng Thị Nga', '2021', 13, 15),
(151, 'Cơ sở điều dưỡng', 'Nguyễn Văn An', '2018', 8, 16),
(152, 'Kỹ năng chăm sóc người bệnh', 'Trần Thị Bình', '2019', 10, 16),
(153, 'Điều dưỡng cơ bản', 'Lê Văn Cường', '2020', 7, 16),
(154, 'Điều dưỡng ngoại khoa', 'Nguyễn Thị Hạnh', '2017', 12, 16),
(155, 'Điều dưỡng nội khoa', 'Phạm Thị Mai', '2018', 9, 16),
(156, 'Dinh dưỡng và chăm sóc bệnh nhân', 'Nguyễn Văn Hoàng', '2021', 11, 16),
(157, 'Giáo dục sức khoẻ cộng đồng', 'Vũ Thị Thu', '2019', 6, 16),
(158, 'Chăm sóc người cao tuổi', 'Lê Thị Thanh', '2022', 14, 16),
(159, 'Điều dưỡng cấp cứu', 'Nguyễn Văn Tuấn', '2020', 5, 16),
(160, 'Phong cách giao tiếp với người bệnh', 'Hoàng Thị Nga', '2021', 13, 16),
(161, 'Kỹ thuật xét nghiệm cơ bản', 'Nguyễn Văn An', '2018', 8, 17),
(162, 'Hóa sinh lâm sàng', 'Trần Thị Bình', '2019', 10, 17),
(163, 'Xét nghiệm huyết học', 'Lê Văn Cường', '2020', 7, 17),
(164, 'Vi sinh – xét nghiệm vi trùng', 'Nguyễn Thị Hạnh', '2017', 12, 17),
(165, 'Xét nghiệm miễn dịch', 'Phạm Thị Mai', '2018', 9, 17),
(166, 'Phương pháp chuẩn đoán hiện đại', 'Nguyễn Văn Hoàng', '2021', 11, 17),
(167, 'Thí nghiệm huyết học', 'Vũ Thị Thu', '2019', 6, 17),
(168, 'Thí nghiệm hóa sinh', 'Lê Thị Thanh', '2022', 14, 17),
(169, 'Chẩn đoán phân tử', 'Nguyễn Văn Tuấn', '2020', 5, 17),
(170, 'An toàn trong phòng xét nghiệm', 'Hoàng Thị Nga', '2021', 13, 17),
(171, 'Linguistics for Language Teaching', 'Carol A. Chapelle', '2018', 8, 18),
(172, 'Ngôn ngữ học ứng dụng', 'Crystal David', '2019', 10, 18),
(173, 'Ngôn ngữ và xã hội', 'Peter Trudgill', '2020', 7, 18),
(174, 'Ngôn ngữ – Tư duy và giao tiếp', 'Edward Sapir', '2017', 12, 18),
(175, 'Phương pháp dạy tiếng Anh nâng cao', 'Lucrecia Garcia', '2018', 9, 18),
(176, 'Ngôn ngữ học tâm lý', 'Susan Ervin-Tripp', '2021', 11, 18),
(177, 'Ngôn ngữ và văn hóa', 'Dell Hymes', '2019', 6, 18),
(178, 'Ngôn ngữ học hiện đại', 'William Labov', '2022', 14, 18),
(179, 'Ngôn ngữ – cấu trúc và chức năng', 'Michael Halliday', '2020', 5, 18),
(180, 'Đa dạng ngôn ngữ', 'Joshua Fishman', '2021', 13, 18),
(181, 'Lịch sử triết học phương Tây', 'Nguyễn Văn An', '2018', 8, 19),
(182, 'Triết học Mác – Lênin', 'Trần Thị Bình', '2019', 10, 19),
(183, 'Triết học hiện đại', 'Lê Văn Cường', '2020', 7, 19),
(184, 'Triết học phương Đông', 'Nguyễn Thị Hạnh', '2017', 12, 19),
(185, 'Phương pháp triết học', 'Phạm Thị Mai', '2018', 9, 19),
(186, 'Triết học và xã hội', 'Nguyễn Văn Hoàng', '2021', 11, 19),
(187, 'Triết học đạo đức', 'Vũ Thị Thu', '2019', 6, 19),
(188, 'Triết học khoa học', 'Lê Thị Thanh', '2022', 14, 19),
(189, 'Tư tưởng triết học đương đại', 'Nguyễn Văn Tuấn', '2020', 5, 19),
(190, 'Triết học ngôn ngữ', 'Hoàng Thị Nga', '2021', 13, 19),
(191, 'Văn học Việt Nam đại cương', 'Nguyễn Văn An', '2018', 8, 20),
(192, 'Tiểu thuyết Việt Nam hiện đại', 'Trần Thị Bình', '2019', 10, 20),
(193, 'Thơ ca Việt Nam', 'Lê Văn Cường', '2020', 7, 20),
(194, 'Phê bình văn học', 'Nguyễn Thị Hạnh', '2017', 12, 20),
(195, 'Thơ ca hiện đại', 'Phạm Thị Mai', '2018', 9, 20),
(196, 'Văn học so sánh', 'Nguyễn Văn Hoàng', '2021', 11, 20),
(197, 'Văn bản học', 'Vũ Thị Thu', '2019', 6, 20),
(198, 'Tiểu luận văn học', 'Lê Thị Thanh', '2022', 14, 20),
(199, 'Ký – tản văn – tùy bút', 'Nguyễn Văn Tuấn', '2020', 5, 20),
(200, 'Ngôn ngữ và văn học', 'Hoàng Thị Nga', '2021', 13, 20);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `sach`
--
ALTER TABLE `sach`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_nganh` (`id_nganh`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `sach`
--
ALTER TABLE `sach`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `sach`
--
ALTER TABLE `sach`
  ADD CONSTRAINT `sach_ibfk_1` FOREIGN KEY (`id_nganh`) REFERENCES `nganh_hoc` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
