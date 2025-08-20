const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
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
    if (!ma_sv && !ma_gv) {
        return res.status(400).json({ success: false, message: 'Phải cung cấp ma_sv hoặc ma_gv' });
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

                // 4. Lấy thông tin thống kê người dùng
                const table = phieu.ma_sv ? 'sinh_vien' : 'giang_vien';
                const ma = phieu.ma_sv || phieu.ma_gv;
                db.query(`SELECT so_sach_da_muon, so_sach_dang_muon, so_sach_da_tra, so_sach_qua_han FROM ${table} WHERE ${phieu.ma_sv ? 'ma_sv' : 'ma_gv'} = ?`, [ma], (err4, stats) => {
                    if (err4) return res.status(500).json({ success: false, message: 'Lỗi khi lấy thống kê', error: err4.sqlMessage });

                    res.json({ success: true, message: 'Trả sách thành công', stats: stats[0] });
                });
            });
        });
    });
});
// ================== THÔNG TIN TÀI KHOẢN ==================
app.get('/user-info/:role/:ma', (req, res) => {
    const { role, ma } = req.params;
    let table, idField, selectFields;

    if (role === 'sinh_vien') {
        table = 'sinh_vien';
        idField = 'ma_sv';
        selectFields = 'ma_sv AS ma, email, so_sach_da_muon, so_sach_dang_muon, so_sach_da_tra, so_sach_qua_han';
    } else if (role === 'giang_vien') {
        table = 'giang_vien';
        idField = 'ma_gv';
        selectFields = 'ma_gv AS ma, email, so_sach_da_muon, so_sach_dang_muon, so_sach_da_tra, so_sach_qua_han';
    } else {
        return res.status(400).json({ success: false, message: 'Vai trò không hợp lệ' });
    }

    // Lấy thông tin người dùng
    const userSql = `SELECT ${selectFields} FROM ${table} WHERE ${idField} = ?`;
    db.query(userSql, [ma], (err, userResults) => {
        if (err) {
            console.error('Lỗi SQL:', err);
            return res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin người dùng', error: err.sqlMessage });
        }
        if (userResults.length === 0) {
            return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
        }

        // Lấy danh sách phiếu mượn
        const borrowSql = `
            SELECT pm.*, s.tac_gia, s.nam_xuat_ban
            FROM phieu_muon pm
            JOIN sach s ON pm.id_sach = s.id
            WHERE pm.${idField} = ?
        `;
        db.query(borrowSql, [ma], (err2, borrowResults) => {
            if (err2) {
                console.error('Lỗi SQL:', err2);
                return res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách phiếu mượn', error: err2.sqlMessage });
            }

            res.json({
                success: true,
                data: {
                    user: userResults[0],
                    borrows: borrowResults
                }
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

// ================== TỰ ĐỘNG NHẮC HẠN TRẢ BẰNG EMAIL MẶC ĐỊNH ==================
const cron = require('node-cron');
const nodemailer = require('nodemailer');
const moment = require('moment');

const transporter = nodemailer.createTransport({
    host: 'smtp.office365.com',    
    port: 587,                
    secure: false,              
    auth: {
        user: '',      
        pass: ''           
    }
});

function sendReminderEmail(to, ten_sach, han_tra, ma_sv) {
    const mailOptions = {
        from: '',
        to,
        subject: 'Nhắc nhở hạn trả sách',
        text: `Xin chào SV ${ma_sv},\nBạn cần trả sách "${ten_sach}" trước ngày ${han_tra}.\n⚠️ Lưu ý: Nếu không trả đúng hạn, bạn sẽ bị đánh dấu xấu trong hệ thống.`
    };

    transporter.sendMail(mailOptions, (err, info) => {
        if (err) console.error('❌ Lỗi gửi mail:', err);
        else console.log('✅ Mail nhắc hạn trả đã gửi đến:', to);
    });
}

// ================== Cron job nhắc hạn trả ==================
cron.schedule('0 8 * * *', () => {
    console.log('🔔 Kiểm tra hạn trả sách ...');

    //const remindDay = moment().add(3, 'days').format('DD-MM-YYYY');

    const sql = `
        SELECT pm.*, sv.email AS email_sv, gv.email AS email_gv
        FROM phieu_muon pm
        LEFT JOIN sinh_vien sv ON pm.ma_sv = sv.ma_sv
        LEFT JOIN giang_vien gv ON pm.ma_gv = gv.ma_gv
        WHERE pm.trang_thai = 'dang_muon' AND DATE_SUB(pm.han_tra, INTERVAL 3 DAY) = CURDATE()
    `;

    db.query(sql, [remindDay], (err, results) => {
        if (err) return console.error('❌ Lỗi khi kiểm tra hạn trả:', err);

        results.forEach(pm => {
            const email = pm.email_sv || pm.email_gv;
            const ma_sv = pm.ma_sv || pm.ma_gv;
            if (email) sendReminderEmail(email, pm.ten_sach, moment(pm.han_tra).format('DD-MM-YYYY'), ma_sv);
        });
    });
});

// ================== Test gửi mail cho 1 sinh viên ==================
function testSendMail(ma_sv) {
    const sql = `
        SELECT pm.ten_sach, pm.han_tra, sv.email, sv.ma_sv
        FROM phieu_muon pm
        JOIN sinh_vien sv ON pm.ma_sv = sv.ma_sv
        WHERE pm.ma_sv = ? AND pm.trang_thai = 'dang_muon'
    `;

    db.query(sql, [ma_sv], (err, results) => {
        if (err) return console.error(err);
        if (results.length === 0) return console.log('Không có phiếu mượn cần nhắc');

        results.forEach(row => {
            sendReminderEmail(row.email, row.ten_sach, moment(row.han_tra).format('DD-MM-YYYY'), row.ma_sv);
        });
    });
}

// Gọi test cho sinh viên vừa tạo
testSendMail('23103054');

// ================== START SERVER ==================
const PORT = 3000;
app.listen(PORT, () => console.log(`🚀 Server chạy tại http://localhost:${PORT}`));