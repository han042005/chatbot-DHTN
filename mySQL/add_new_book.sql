-- ====== THÊM SÁCH MỚI TRỰC TIẾP VÀO DATABASE ======
-- Sử dụng file này để thêm sách mới vào bảng sach
-- Sau khi thêm sách, thông báo sẽ tự động hiện ở trang home

USE `library_chatbot`;

-- ====== CÁCH 1: Thêm sách đơn giản (không có timestamp) ======
INSERT INTO `sach` (`ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`) 
VALUES 
('Lập trình Java nâng cao', 'Nguyễn Văn A', 2024, 15, 1),
('Cơ sở dữ liệu NoSQL', 'Trần Thị B', 2024, 12, 1),
('Machine Learning cơ bản', 'Lê Văn C', 2024, 20, 1);

-- ====== CÁCH 2: Thêm sách với timestamp (nếu đã có cột timestamp) ======
-- Chạy lệnh này nếu đã thêm cột timestamp vào bảng sach
/*
INSERT INTO `sach` (`ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`, `created_at`, `updated_at`) 
VALUES 
('Deep Learning với Python', 'Phạm Văn D', 2024, 18, 1, NOW(), NOW()),
('Blockchain và ứng dụng', 'Hoàng Thị E', 2024, 14, 1, NOW(), NOW());
*/

-- ====== CÁCH 3: Thêm sách theo ngành học ======
-- Ngành Công nghệ thông tin (id_nganh = 1)
INSERT INTO `sach` (`ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`) 
VALUES ('Lập trình Web với React', 'Nguyễn Minh F', 2024, 25, 1);

-- Ngành Kinh tế (id_nganh = 2)  
INSERT INTO `sach` (`ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`) 
VALUES ('Kinh tế học hành vi', 'Trần Quốc G', 2024, 16, 2);

-- Ngành Y học (id_nganh = 3)
INSERT INTO `sach` (`ten_sach`, `tac_gia`, `nam_xuat_ban`, `so_luong_ton`, `id_nganh`) 
VALUES ('Y học tái tạo', 'Lê Hải H', 2024, 22, 3);

-- ====== KIỂM TRA SÁCH VỪA THÊM ======
-- Xem danh sách sách mới nhất
SELECT * FROM `sach` ORDER BY `id` DESC LIMIT 10;

-- ====== LƯU Ý ======
-- 1. Sau khi chạy lệnh INSERT, sách mới sẽ tự động hiện trong danh sách
-- 2. Nếu có cột timestamp, thông báo sẽ hiện ở trang home trong 10 phút
-- 3. Nếu không có timestamp, thông báo sẽ hiện tất cả sách có số lượng > 0
-- 4. Để có thông báo chính xác, nên chạy file add_timestamp_columns.sql trước
