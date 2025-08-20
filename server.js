

const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const cors = require('cors');

const app = express();

// Middleware
app.use(cors({
    origin: ['http://127.0.0.1:5500', 'http://localhost:5500', 'http://127.0.0.1:3000', 'http://localhost:3000'],
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Accept']
}));
app.use(express.json());
app.use(express.static(__dirname));


// ================== KẾT NỐI MYSQL ==================
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'library_chatbot'
});

db.connect(err => {
    if (err) {
        console.error('❌ Lỗi kết nối MySQL:', err);
        return;
    }
    console.log('✅ Đã kết nối MySQL!');
});

// ================== API TEST ==================
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// ================== NGÀNH HỌC ==================
app.get('/nganh-hoc', (req, res) => {
    db.query('SELECT * FROM nganh_hoc', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// ================== SÁCH ==================
app.get('/sach', (req, res) => {
    db.query('SELECT * FROM sach', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.get('/sach/nganh/:id_nganh', (req, res) => {
    const { id_nganh } = req.params;
    db.query('SELECT * FROM sach WHERE id_nganh = ?', [id_nganh], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});



// ================== PHIẾU MƯỢN ==================

// Lấy tất cả phiếu mượn (kèm tác giả + năm xuất bản)
app.get('/phieu-muon', (req, res) => {
    const sql = `
        SELECT pm.*, s.tac_gia, s.nam_xuat_ban
        FROM phieu_muon pm
        JOIN sach s ON pm.id_sach = s.id
    `;
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ success: false, message: 'Lỗi khi lấy phiếu mượn', error: err.sqlMessage });
        res.json(results);
    });
});

// Lấy phiếu mượn theo sinh viên (kèm tác giả + năm xuất bản)
app.get('/phieu-muon/sinh-vien/:ma_sv', (req, res) => {
    const { ma_sv } = req.params;
    const sql = `
        SELECT pm.*, s.tac_gia, s.nam_xuat_ban
        FROM phieu_muon pm
        JOIN sach s ON pm.id_sach = s.id
        WHERE pm.ma_sv = ?
    `;
    db.query(sql, [ma_sv], (err, results) => {
        if (err) return res.status(500).json({ success: false, message: 'Lỗi khi lấy phiếu mượn', error: err.sqlMessage });
        res.json(results);
    });
});

// Lấy phiếu mượn theo giảng viên (kèm tác giả + năm xuất bản)
app.get('/phieu-muon/giang-vien/:ma_gv', (req, res) => {
    const { ma_gv } = req.params;
    const sql = `
        SELECT pm.*, s.tac_gia, s.nam_xuat_ban
        FROM phieu_muon pm
        JOIN sach s ON pm.id_sach = s.id
        WHERE pm.ma_gv = ?
    `;
    db.query(sql, [ma_gv], (err, results) => {
        if (err) return res.status(500).json({ success: false, message: 'Lỗi khi lấy phiếu mượn', error: err.sqlMessage });
        res.json(results);
    });
});

// Tạo phiếu mượn (client chỉ cần gửi ten_sach)
app.post('/phieu-muon', (req, res) => {
    const { ma_sv, ma_gv, ten_sach, ngay_muon, han_tra } = req.body;

    if (!ten_sach || !ngay_muon || !han_tra) {
        return res.status(400).json({ success: false, message: 'Thiếu thông tin bắt buộc' });
    }

    // 1. Tìm sách theo tên
const sqlFindBook = `SELECT id, so_luong_ton, tac_gia, nam_xuat_ban FROM sach WHERE ten_sach = ? LIMIT 1`;
    db.query(sqlFindBook, [ten_sach], (err, books) => {
        if (err) return res.status(500).json({ success: false, message: 'Lỗi khi tìm sách', error: err.sqlMessage });
        if (books.length === 0) {
            return res.status(404).json({ success: false, message: 'Không tìm thấy sách' });
        }

        const { id, so_luong_ton } = books[0];

        if (so_luong_ton <= 0) {
            return res.status(400).json({ success: false, message: 'Sách đã hết trong kho' });
        }

        // 2. Tạo phiếu mượn
        const sqlInsert = `
        INSERT INTO phieu_muon (ma_sv, ma_gv, id_sach, ten_sach, tac_gia, nam_xuat_ban, ngay_muon, han_tra, trang_thai)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'dang_muon')
        `;
        db.query(sqlInsert, [ma_sv || null, ma_gv || null, id, ten_sach, books[0].tac_gia, books[0].nam_xuat_ban, ngay_muon, han_tra], (err2, result) => {
            if (err2) return res.status(400).json({ success: false, message: err2.sqlMessage || 'Lỗi khi tạo phiếu mượn' });

            // 3. Trả về chi tiết phiếu mượn vừa tạo (kèm tác giả + năm xuất bản)
            const sqlDetail = `
                SELECT pm.*, s.tac_gia, s.nam_xuat_ban
                FROM phieu_muon pm
                JOIN sach s ON pm.id_sach = s.id
                WHERE pm.id = ?
            `;
            db.query(sqlDetail, [result.insertId], (err3, detail) => {
                if (err3) return res.status(500).json({ success: false, message: 'Lỗi khi lấy chi tiết phiếu mượn', error: err3.sqlMessage });
                res.json({ success: true, message: 'Tạo phiếu mượn thành công', data: detail[0] });
            });
        });
    });
});



// ================== SINH VIÊN ==================
app.get('/sinh-vien', (req, res) => {
    db.query('SELECT * FROM sinh_vien', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// API ĐĂNG NHẬP SINH VIÊN
app.post('/login-sinh-vien', (req, res) => {
    const { ma_sv, mat_khau } = req.body; // Đúng với tên cột trong DB
    db.query('SELECT * FROM sinh_vien WHERE ma_sv = ? AND mat_khau = ?', 
        [ma_sv, mat_khau], 
        (err, results) => {
            if (err) throw err;
            if (results.length > 0) {
                res.json({ success: true, message: 'Đăng nhập thành công', data: results[0] });
            } else {
                res.json({ success: false, message: 'Sai mã sinh viên hoặc mật khẩu' });
            }
        }
    );
});

// ================== GIẢNG VIÊN ==================
app.get('/giang-vien', (req, res) => {
    db.query('SELECT * FROM giang_vien', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// API ĐĂNG NHẬP GIẢNG VIÊN
app.post('/login-giang-vien', (req, res) => {
    const { ma_gv, mat_khau } = req.body;
    db.query('SELECT * FROM giang_vien WHERE ma_gv = ? AND mat_khau = ?', 
        [ma_gv, mat_khau], 
        (err, results) => {
            if (err) throw err;
            if (results.length > 0) {
                res.json({ success: true, message: 'Đăng nhập thành công', data: results[0] });
            } else {
                res.json({ success: false, message: 'Sai mã giảng viên hoặc mật khẩu' });
            }
        }
    );
});
// ================== TRẢ SÁCH ==================
app.post('/phieu-muon/tra/:id', (req, res) => {
    const { id } = req.params;

    // 1. Lấy phiếu mượn theo id
    db.query('SELECT * FROM phieu_muon WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).json({ success: false, message: 'Lỗi khi tìm phiếu mượn', error: err.sqlMessage });
        if (results.length === 0) return res.status(404).json({ success: false, message: 'Không tìm thấy phiếu mượn' });

        const phieu = results[0];

        if (phieu.trang_thai === 'da_tra') {
            return res.status(400).json({ success: false, message: 'Phiếu mượn này đã được trả' });
        }

        // 2. Cập nhật trạng thái phiếu mượn
        db.query('UPDATE phieu_muon SET trang_thai = "da_tra", ngay_tra = NOW() WHERE id = ?', [id], (err2) => {
            if (err2) return res.status(500).json({ success: false, message: 'Lỗi khi cập nhật phiếu mượn', error: err2.sqlMessage });

            // 3. Tăng lại số lượng tồn của sách
            db.query('UPDATE sach SET so_luong_ton = so_luong_ton + 1 WHERE id = ?', [phieu.id_sach], (err3) => {
                if (err3) return res.status(500).json({ success: false, message: 'Lỗi khi cập nhật kho sách', error: err3.sqlMessage });

                res.json({ success: true, message: 'Trả sách thành công' });
            });
        });
    });
});

// ================== NỘI QUY ==================
app.get('/noi-quy', (req, res) => {
    db.query('SELECT * FROM noi_quy', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// ================== CƠ CẤU TỔ CHỨC ==================
app.get('/co-cau-to-chuc', (req, res) => {
    db.query('SELECT * FROM co_cau_to_chuc', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// ================== START SERVER ==================
const PORT = 3000;
app.listen(PORT, () => console.log(`🚀 Server chạy tại http://localhost:${PORT}`));

// ================== ADMIN API ==================

// API thêm sách mới (chỉ dành cho admin)
app.post('/admin/add-book', (req, res) => {
    const { ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh } = req.body;
    
    if (!ten_sach || !tac_gia || !nam_xuat_ban || !so_luong_ton || !id_nganh) {
        return res.status(400).json({ 
            success: false, 
            message: 'Thiếu thông tin bắt buộc: tên sách, tác giả, năm xuất bản, số lượng, ngành học' 
        });
    }

    // Kiểm tra xem bảng có cột timestamp không
    const checkTimestampSql = `
        SELECT COLUMN_NAME 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'library_chatbot' 
        AND TABLE_NAME = 'sach' 
        AND COLUMN_NAME IN ('created_at', 'updated_at')
    `;
    
    db.query(checkTimestampSql, (err, columns) => {
        if (err) {
            console.error('Lỗi kiểm tra cột timestamp:', err);
            // Fallback: thêm sách không có timestamp
            return insertBookWithoutTimestamp(req, res);
        }
        
        const hasTimestamp = columns.length >= 2;
        
        if (hasTimestamp) {
            // Thêm sách với timestamp
            const sql = `
                INSERT INTO sach (ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh, created_at, updated_at) 
                VALUES (?, ?, ?, ?, ?, NOW(), NOW())
            `;
            
            db.query(sql, [ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh], (err, result) => {
                if (err) {
                    console.error('Lỗi thêm sách:', err);
                    return res.status(500).json({ 
                        success: false, 
                        message: 'Lỗi khi thêm sách vào cơ sở dữ liệu',
                        error: err.sqlMessage 
                    });
                }
                
                // Lấy thông tin sách vừa thêm
                const newBookId = result.insertId;
                db.query('SELECT * FROM sach WHERE id = ?', [newBookId], (err2, books) => {
                    if (err2) {
                        return res.status(500).json({ 
                            success: false, 
                            message: 'Thêm sách thành công nhưng không lấy được thông tin chi tiết' 
                        });
                    }
                    
                    const newBook = books[0];
                    console.log(`✅ Admin đã thêm sách mới: ${newBook.ten_sach} (ID: ${newBook.id})`);
                    
                    res.json({ 
                        success: true, 
                        message: 'Thêm sách thành công!',
                        data: newBook
                    });
                });
            });
        } else {
            // Fallback: thêm sách không có timestamp
            insertBookWithoutTimestamp(req, res);
        }
    });
});

// Hàm fallback khi không có timestamp
function insertBookWithoutTimestamp(req, res) {
    const { ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh } = req.body;
    
    const sql = `
        INSERT INTO sach (ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh) 
        VALUES (?, ?, ?, ?, ?)
    `;
    
    db.query(sql, [ten_sach, tac_gia, nam_xuat_ban, so_luong_ton, id_nganh], (err, result) => {
        if (err) {
            console.error('Lỗi thêm sách:', err);
            return res.status(500).json({ 
                success: false, 
                message: 'Lỗi khi thêm sách vào cơ sở dữ liệu',
                error: err.sqlMessage 
            });
        }
        
        // Lấy thông tin sách vừa thêm
        const newBookId = result.insertId;
        db.query('SELECT * FROM sach WHERE id = ?', [newBookId], (err2, books) => {
            if (err2) {
                return res.status(500).json({ 
                    success: false, 
                    message: 'Thêm sách thành công nhưng không lấy được thông tin chi tiết' 
                });
            }
            
            const newBook = books[0];
            console.log(`✅ Admin đã thêm sách mới: ${newBook.ten_sach} (ID: ${newBook.id})`);
            
            res.json({ 
                success: true, 
                message: 'Thêm sách thành công!',
                data: newBook
            });
        });
    });
}

// ================== THÔNG BÁO SÁCH MỚI ==================

// API lấy sách mới nhập hoặc tăng tồn
app.get("/api/thong-bao-sach", (req, res) => {
  // Kiểm tra xem bảng có cột timestamp không
  const checkTimestampSql = `
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'library_chatbot' 
    AND TABLE_NAME = 'sach' 
    AND COLUMN_NAME IN ('created_at', 'updated_at')
  `;
  
  db.query(checkTimestampSql, (err, columns) => {
    if (err) {
      console.error('Lỗi kiểm tra cột timestamp:', err);
      // Fallback: trả về sách có số lượng tồn > 0
      return getBooksWithoutTimestamp(res);
    }
    
    const hasTimestamp = columns.length >= 2;
    
    if (hasTimestamp) {
      // Sử dụng timestamp để lấy sách mới (trong 30 giây gần nhất)
      const sql = `
        SELECT id, ten_sach, tac_gia, nam_xuat_ban, so_luong_ton,
               created_at, updated_at
        FROM sach
        WHERE COALESCE(updated_at, created_at) >= NOW() - INTERVAL 60 SECOND
        ORDER BY COALESCE(updated_at, created_at) DESC
        LIMIT 10
      `;
      
      db.query(sql, (err, books) => {
        if (err) {
          console.error('Lỗi lấy thông báo sách với timestamp:', err);
          return getBooksWithoutTimestamp(res);
        }
        
        const thongBao = books.map(b => ({
          id: `book-${b.id}`,
          text: `📚 Sách mới: "${b.ten_sach}" - ${b.tac_gia} (năm ${b.nam_xuat_ban}) đã được thêm vào thư viện!`,
        }));
        
        res.json({ success: true, thongBao });
      });
    } else {
      // Fallback: trả về sách có số lượng tồn > 0
      getBooksWithoutTimestamp(res);
    }
  });
});

// Hàm fallback khi không có timestamp
function getBooksWithoutTimestamp(res) {
  const sql = `
    SELECT id, ten_sach, tac_gia, nam_xuat_ban, so_luong_ton
    FROM sach
    WHERE so_luong_ton > 0
    ORDER BY id DESC
    LIMIT 10
  `;
  
  db.query(sql, (err, books) => {
    if (err) {
      console.error('Lỗi lấy thông báo sách:', err);
      return res.status(500).json({ success: false, message: "Lỗi server" });
    }

    const thongBao = books.map(b => ({
      id: `book-${b.id}`,
      text: `📚 Sách: ${b.ten_sach} — ${b.tac_gia} (năm ${b.nam_xuat_ban}). SL: ${b.so_luong_ton}`,
    }));

    res.json({ success: true, thongBao });
  });
}

