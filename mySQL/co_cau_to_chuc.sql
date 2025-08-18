-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th8 17, 2025 lúc 05:04 PM
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
-- Cấu trúc bảng cho bảng `co_cau_to_chuc`
--

CREATE TABLE `co_cau_to_chuc` (
  `id` int(11) NOT NULL,
  `ho_ten` varchar(255) NOT NULL,
  `chuc_vu` varchar(255) NOT NULL,
  `nhiem_vu` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `co_cau_to_chuc`
--

INSERT INTO `co_cau_to_chuc` (`id`, `ho_ten`, `chuc_vu`, `nhiem_vu`) VALUES
(1, 'ThS. Vũ Thị Giang', 'Giám đốc', 'Phụ trách chung, chịu trách nhiệm trước Lãnh đạo Trường về lãnh đạo, chỉ đạo các hoạt động của đơn vị. Trực tiếp chỉ đạo các văn bản đến/đi và công việc chuyên môn nghiệp vụ.'),
(2, 'CN. Nguyễn Thị Thùy Dung', 'Thư viện viên', 'Bổ sung tài liệu học tập, Báo/Tạp chí, Giao kho. Rà soát tài liệu học tập, phục vụ đánh giá chương trình đào tạo.'),
(3, 'CN. Hà Ngọc Hồi', 'Thư viện viên', 'Nhận tài liệu biếu tặng, nội sinh. Xử lý tài liệu, in mã vạch, nhãn. Thực hiện công tác PCCC.'),
(4, 'ThS. Nguyễn Thị Lành', 'Thư viện viên', 'Quản lí, phục vụ, thanh lọc kho giáo trình. Thanh toán ra trường cho SV, cán bộ nghỉ hưu/chuyển công tác. Quản lí phần mềm mượn/trả tài liệu.'),
(5, 'ThS. Vũ Đình Trung', 'Thư viện viên', 'Quản lí, phục vụ kho đọc. Đề xuất sửa chữa, kiểm kê CSVC, VPP. Quản lí fanpage thư viện.'),
(6, 'CN. Nguyễn Thị Thúy', 'Thư viện viên', 'Quản lí, phục vụ, thanh lọc kho Tổng hợp. Công tác văn thư.'),
(7, 'CN. Võ Huyền Trang', 'Thư viện viên', 'Quản lí, phục vụ, thanh lọc kho giáo trình. Sắp xếp tài liệu ổn định kho.'),
(8, 'CN. Nguyễn Thị Thu Giang', 'Thư viện viên', 'Quản lý trang web và cơ sở dữ liệu thư viện. Rà soát tài liệu phục vụ đánh giá chương trình đào tạo.'),
(9, 'Phạm Thị Miện', 'Nhân viên phục vụ', 'Làm vệ sinh Tòa nhà Thư viện và hút bụi, vệ sinh các kho tài liệu.');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `co_cau_to_chuc`
--
ALTER TABLE `co_cau_to_chuc`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `co_cau_to_chuc`
--
ALTER TABLE `co_cau_to_chuc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
