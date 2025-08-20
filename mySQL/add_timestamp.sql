-- Thêm cột timestamp vào bảng sach để theo dõi sách mới
USE `library_chatbot`;

-- Thêm cột created_at và updated_at
ALTER TABLE `sach` 
ADD COLUMN `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Cập nhật dữ liệu cũ (nếu có)
UPDATE `sach` SET 
    `created_at` = NOW() - INTERVAL FLOOR(RAND() * 30) DAY,
    `updated_at` = NOW() - INTERVAL FLOOR(RAND() * 30) DAY
WHERE `created_at` IS NULL;

-- Tạo index để tối ưu truy vấn theo thời gian
CREATE INDEX `idx_sach_timestamp` ON `sach` (`created_at`, `updated_at`);

-- Kiểm tra dữ liệu trong 2 phút gần nhất
SELECT * 
FROM `sach`
WHERE COALESCE(`updated_at`, `created_at`) >= NOW() - INTERVAL 15 MINUTE
ORDER BY COALESCE(`updated_at`, `created_at`) DESC;