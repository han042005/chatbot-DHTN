-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian tạo: Th8 18, 2025 lúc 10:10 AM
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
-- Cấu trúc bảng cho bảng `faqs`
--

CREATE TABLE `faqs` (
  `id` int(11) NOT NULL,
  `question` text NOT NULL,
  `answer` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `faqs`
--

USE `library_chatbot`;

INSERT INTO `faqs` (`question`, `answer`, `created_at`) VALUES
('Giờ mở cửa của thư viện là khi nào?', 'Thư viện mở cửa từ 7h30 đến 17h30, từ thứ Hai đến thứ Sáu.', NOW()),
('Tôi có thể mượn tối đa bao nhiêu cuốn sách cùng lúc?', 'Mỗi sinh viên được mượn tối đa 5 cuốn trong cùng một thời điểm.', NOW()),
('Thời hạn mượn sách là bao lâu?', 'Thời hạn mượn là 14 ngày và có thể gia hạn thêm nếu sách chưa có người đặt trước.', NOW()),
('Nếu làm mất hoặc hư hỏng sách thì xử lý thế nào?', 'Bạn phải đền bù bằng một cuốn sách cùng loại hoặc nộp phí theo quy định của thư viện.', NOW()),
('Làm thế nào để đăng ký thẻ thư viện?', 'Sinh viên chỉ cần mang thẻ sinh viên đến quầy thủ thư để được cấp thẻ thư viện miễn phí.', NOW()),
('Có cần trả phí khi làm thẻ thư viện không?', 'Không, thẻ thư viện được cấp miễn phí cho tất cả sinh viên.', NOW()),
('Tôi có thể mượn sách bằng chứng minh nhân dân không?', 'Không, chỉ thẻ sinh viên/thẻ thư viện mới có giá trị mượn sách.', NOW()),
('Thời gian cấp lại thẻ thư viện mất bao lâu?', 'Khoảng 3 ngày làm việc sau khi hoàn tất thủ tục.', NOW()),
('Tôi có thể mượn sách khi chưa có thẻ thư viện không?', 'Không, bạn cần có thẻ để sử dụng dịch vụ mượn sách.', NOW()),
('Tôi có thể dùng thẻ thư viện của bạn để mượn sách không?', 'Không, thẻ thư viện chỉ có giá trị với chủ sở hữu.', NOW()),
('Có thể mượn sách bằng thẻ CCCD gắn chip không?', 'Không, chỉ thẻ sinh viên/thư viện mới được chấp nhận.', NOW()),
('Có thể trả sách ở chi nhánh thư viện khác không?', 'Không.', NOW()),
('Tôi có thể gia hạn mượn sách qua website không?', 'Có, chỉ cần đăng nhập tài khoản sinh viên và chọn gia hạn.', NOW()),
('Có ổ cắm điện trong phòng đọc không?', 'Có, để phục vụ sinh viên dùng laptop.', NOW()),
('Có phòng học nhóm không?', 'Có, bạn có thể đặt phòng trước tại quầy thủ thư.', NOW()),
('Có được nói chuyện trong phòng đọc không?', 'Không, phòng đọc yêu cầu giữ im lặng.', NOW()),
('Có cho phép chụp hình tài liệu trong phòng đọc không?', 'Có, nhưng không dùng flash.', NOW()),
('Có khu vực đọc báo, tạp chí riêng không?', 'Có, ở tầng 2 có khu vực dành riêng cho báo và tạp chí.', NOW()),
('Tôi có thể đặt chỗ ngồi trong phòng đọc trước không?', 'Không, chỗ ngồi trong phòng đọc theo nguyên tắc ai đến trước dùng trước.', NOW()),
('Nếu làm mất hỏng sách thì sao?', 'Bạn phải đền bù bằng sách tương tự hoặc nộp phí.', NOW()),
('Nếu không trả sách thì sao?', 'Bạn sẽ bị cấm mượn sách và có thể bị kỷ luật.', NOW()),
('Nếu trả thiếu trang thì xử lý thế nào?', 'Bạn phải đền bù như mất sách.', NOW()),
('Nếu viết bậy lên sách thì có bị xử lý không?', 'Có, đây là hành vi vi phạm nội quy.', NOW()),
('Có tính phí phạt trễ theo ngày không?', 'Có, mức phí là 2000đ/cuốn/ngày.', NOW()),
('Tôi có thể kháng nghị nếu bị phạt oan không?', 'Có, bạn có thể nộp đơn khiếu nại cho thủ thư trưởng.', NOW()),
('Có dịch vụ in ấn không?', 'Có, bạn có thể in ấn tại khu vực dịch vụ hỗ trợ.', NOW()),
('Có dịch vụ mượn liên thư viện không?', 'Có, bạn có thể mượn sách từ thư viện liên kết.', NOW()),
('Có tổ chức hội thảo học thuật không?', 'Có, thư viện thường xuyên tổ chức hội thảo định kỳ.', NOW()),
('Có tổ chức cuộc thi liên quan đến sách không?', 'Có, như cuộc thi kể chuyện sách hoặc review sách.', NOW()),
('Tôi muốn học cách quản lý thời gian, có sách không?', 'Có, tại mục Kỹ năng sống – học tập hiệu quả.', NOW()),
('Có tài liệu về kỹ năng thuyết trình không?', 'Có, bạn tìm tại mục Presentation Skills.', NOW()),
('Có sách dạy cách học online hiệu quả không?', 'Có, trong mục Kỹ năng tự học.', NOW()),
('Có sách ngành công nghệ thông tin không?', 'Có, bạn có thể vào mục Công nghệ thông tin để tìm kiếm.', NOW()),
('Có sách ngành Python không?', 'Có, bạn có thể vào mục Lập trình Python để tìm kiếm.', NOW()),
('Thư viện có dịch vụ hỗ trợ tìm tài liệu không?', 'Có, thủ thư sẽ hỗ trợ bạn tra cứu và tìm kiếm.', NOW()),
('Trong đây có khu vực mượn máy tính không?', 'Không, nhưng bạn có thể ra quán net.', NOW()),
('Ở đây có cấp nước uống miễn phí không?', 'Có, bạn ra đầu cửa lấy.', NOW()),
('Hôm nào thư viện sẽ đông người?', 'Hôm nào có nhiều sinh viên học thì sẽ đông.', NOW()),
('Nếu tôi trả muộn hoặc không trả có bị trừ điểm rèn luyện không?', 'Có.', NOW()),
('Có thể ăn trong khu vực thư viện không?', 'Không, vì đây là chỗ học tập.', NOW());

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `faqs`
--
ALTER TABLE `faqs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho bảng `faqs`
--
ALTER TABLE `faqs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
