// ================== IMPORT & CẤU HÌNH CƠ BẢN ==================
const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const cors = require("cors");
const { spawn } = require("child_process");

// fetch (ESM) cho Node CJS
const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));

const app = express();
app.use(express.json());
app.use(cors());
app.use(express.static(__dirname));

// ================== KẾT NỐI MYSQL ==================
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'library_chatbot'
});

db.connect(err => {
  if (err) { console.error('❌ Lỗi kết nối MySQL:', err); return; }
  console.log('✅ Đã kết nối MySQL!');
});

// ================== PYTHON CHATBOT (FASTAPI) ==================
const PY_PORT = 3001;
let PY_READY = false;

const py = spawn("python", [
  "-m", "uvicorn",
  "chat_ai:app",
  "--host", "127.0.0.1",
  "--port", String(PY_PORT)
  // "--reload" // KHÔNG nên bật trong chế độ spawn để tránh nhiều process trùng cổng
], {
  env: { ...process.env, PYTHONIOENCODING: "utf-8" }
});

py.stdout.setEncoding("utf8");
py.stderr.setEncoding("utf8");
py.stdout.on("data", d => {
  process.stdout.write(`PYTHON: ${d}`);
  if (String(d).includes("Uvicorn running on")) PY_READY = true;
});
py.stderr.on("data", d => process.stderr.write(`PYTHON ERR: ${d}`));
py.on("close", code => console.log(`Python process exited with code ${code}`));

// Chờ Python sẵn sàng (dùng trước khi gọi /chat)
async function waitPythonReady(maxWaitMs = 15000) {
  if (PY_READY) return;
  const start = Date.now();
  while (Date.now() - start < maxWaitMs) {
    try {
      const r = await fetch(`http://127.0.0.1:${PY_PORT}/`, { method: "GET" });
      if (r.ok) { PY_READY = true; return; }
    } catch (_) {}
    await new Promise(r => setTimeout(r, 400));
  }
  throw new Error("Python API not ready on port " + PY_PORT);
}

// ================== API TEST (trang web) ==================
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'login.html'));
});

// ================== NGÀNH HỌC ==================
app.get('/nganh-hoc', (req, res) => {
  db.query('SELECT * FROM nganh_hoc', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

// ================== SÁCH ==================
app.get('/sach', (req, res) => {
  db.query('SELECT * FROM sach', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

app.get('/sach/nganh/:id_nganh', (req, res) => {
  const { id_nganh } = req.params;
  db.query('SELECT * FROM sach WHERE id_nganh = ?', [id_nganh], (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

// ================== PHIẾU MƯỢN ==================
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

app.post('/phieu-muon', (req, res) => {
  const { ma_sv, ma_gv, ten_sach, ngay_muon, han_tra } = req.body;
  if (!ten_sach || !ngay_muon || !han_tra) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin bắt buộc' });
  }

  const sqlFindBook = `SELECT id, so_luong_ton, tac_gia, nam_xuat_ban FROM sach WHERE ten_sach = ? LIMIT 1`;
  db.query(sqlFindBook, [ten_sach], (err, books) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi khi tìm sách', error: err.sqlMessage });
    if (books.length === 0) return res.status(404).json({ success: false, message: 'Không tìm thấy sách' });

    const { id, so_luong_ton } = books[0];
    if (so_luong_ton <= 0) return res.status(400).json({ success: false, message: 'Sách đã hết trong kho' });

    const sqlInsert = `
      INSERT INTO phieu_muon (ma_sv, ma_gv, id_sach, ten_sach, tac_gia, nam_xuat_ban, ngay_muon, han_tra, trang_thai)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'dang_muon')
    `;
    db.query(sqlInsert, [ma_sv || null, ma_gv || null, id, ten_sach, books[0].tac_gia, books[0].nam_xuat_ban, ngay_muon, han_tra], (err2, result) => {
      if (err2) return res.status(400).json({ success: false, message: err2.sqlMessage || 'Lỗi khi tạo phiếu mượn' });

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

app.post('/phieu-muon/tra/:id', (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM phieu_muon WHERE id = ?', [id], (err, results) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi khi tìm phiếu mượn', error: err.sqlMessage });
    if (results.length === 0) return res.status(404).json({ success: false, message: 'Không tìm thấy phiếu mượn' });

    const phieu = results[0];
    if (phieu.trang_thai === 'da_tra') return res.status(400).json({ success: false, message: 'Phiếu mượn này đã được trả' });

    db.query('UPDATE phieu_muon SET trang_thai = "da_tra", ngay_tra = NOW() WHERE id = ?', [id], (err2) => {
      if (err2) return res.status(500).json({ success: false, message: 'Lỗi khi cập nhật phiếu mượn', error: err2.sqlMessage });
      db.query('UPDATE sach SET so_luong_ton = so_luong_ton + 1 WHERE id = ?', [phieu.id_sach], (err3) => {
        if (err3) return res.status(500).json({ success: false, message: 'Lỗi khi cập nhật kho sách', error: err3.sqlMessage });
        res.json({ success: true, message: 'Trả sách thành công' });
      });
    });
  });
});

// ================== SINH VIÊN / GIẢNG VIÊN ==================
app.get('/sinh-vien', (req, res) => {
  db.query('SELECT * FROM sinh_vien', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

app.post('/login-sinh-vien', (req, res) => {
  const { ma_sv, mat_khau } = req.body;
  db.query('SELECT * FROM sinh_vien WHERE ma_sv = ? AND mat_khau = ?', [ma_sv, mat_khau], (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    if (results.length > 0) res.json({ success: true, message: 'Đăng nhập thành công', data: results[0] });
    else res.json({ success: false, message: 'Sai mã sinh viên hoặc mật khẩu' });
  });
});

app.get('/giang-vien', (req, res) => {
  db.query('SELECT * FROM giang_vien', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

app.post('/login-giang-vien', (req, res) => {
  const { ma_gv, mat_khau } = req.body;
  db.query('SELECT * FROM giang_vien WHERE ma_gv = ? AND mat_khau = ?', [ma_gv, mat_khau], (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    if (results.length > 0) res.json({ success: true, message: 'Đăng nhập thành công', data: results[0] });
    else res.json({ success: false, message: 'Sai mã giảng viên hoặc mật khẩu' });
  });
});

// ================== NỘI QUY / CƠ CẤU ==================
app.get('/noi-quy', (req, res) => {
  db.query('SELECT * FROM noi_quy', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

app.get('/co-cau-to-chuc', (req, res) => {
  db.query('SELECT * FROM co_cau_to_chuc', (err, results) => {
    if (err) return res.status(500).json({ error: err.sqlMessage });
    res.json(results);
  });
});

// ================== PROXY BOOKS ==================
app.get("/books/:category", async (req, res) => {
  try {
    await waitPythonReady();
    const r = await fetch(`http://127.0.0.1:${PY_PORT}/books/${encodeURIComponent(req.params.category)}`);
    const data = await r.json();
    res.status(r.status).json(data);
  } catch (e) {
    res.status(500).json({ error: String(e.message || e) });
  }
});

// ================== PROXY CHATBOT (CÓ NHỚ NGỮ CẢNH) ==================
app.post("/chat", (req, res) => {
  const question = (req.body?.question || "").trim();
  const convId   = req.body?.conversation_id ?? null;

  if (!question) return res.status(400).json({ error: "question required" });

  console.log("REQ /chat convId=", convId);

  const sendToPython = async (history) => {
    try {
      await waitPythonReady();

      const r = await fetch(`http://127.0.0.1:${PY_PORT}/chat`, {
        method: "POST",
        headers: { "Content-Type": "application/json", "Accept": "application/json" },
        body: JSON.stringify({ question, conversation_id: convId || "default", history: history || [] }),
      });

      const raw = await r.text();
      let data; try { data = JSON.parse(raw); } catch { data = { text: raw }; }
      if (!r.ok) throw new Error(`Python ${r.status}: ${raw.slice(0,300)}`);

      // RÚT ANSWER AN TOÀN — KHÔNG BAO GIỜ TRẢ {}
      let answer =
        (typeof data?.answer  === "string" && data.answer.trim())  ||
        (typeof data?.message === "string" && data.message.trim()) ||
        (typeof data?.reply   === "string" && data.reply.trim())   ||
        (typeof data?.output  === "string" && data.output.trim())  ||
        (typeof data?.text    === "string" && data.text.trim())    ||
        "";

      if (!answer && data && typeof data === "object") {
        answer = JSON.stringify(data);
      }
      if (!answer) answer = "Xin lỗi, tôi không có câu trả lời cho câu hỏi này.";

      // Ghi DB & trả về
      if (convId) {
        // đã có conversation
        db.query("INSERT INTO chat_history (user_message, bot_response) VALUES (?, ?)", [question, answer]);
        db.query("INSERT INTO chat_messages (conversation_id, role, message) VALUES (?, 'user', ?)", [convId, question]);
        db.query("INSERT INTO chat_messages (conversation_id, role, message) VALUES (?, 'bot',  ?)", [convId, answer]);
        db.query(
          "UPDATE conversations SET title = COALESCE(NULLIF(title,'Untitled chat'), ?) WHERE id = ?",
          [question.length > 40 ? question.slice(0,37) + "..." : question, convId]
        );
        return res.json({ answer, conversation_id: String(convId) });
      } else {
        // tạo conversation mới & trả id cho FE
        db.query("INSERT INTO conversations (title) VALUES ('Untitled chat')", (err, r2) => {
          if (err || !r2?.insertId) {
            console.error("Lỗi tạo conversation:", err);
            // vẫn trả câu trả lời để UI không bị trống
            return res.json({ answer, conversation_id: null });
          }
          const newId = r2.insertId; // INT gọn
          db.query("INSERT INTO chat_history (user_message, bot_response) VALUES (?, ?)", [question, answer]);
          db.query("INSERT INTO chat_messages (conversation_id, role, message) VALUES (?, 'user', ?)", [newId, question]);
          db.query("INSERT INTO chat_messages (conversation_id, role, message) VALUES (?, 'bot',  ?)", [newId, answer]);
          return res.json({ answer, conversation_id: String(newId) });
        });
      }
    } catch (e) {
      console.error("Proxy /chat error:", e);
      res.status(500).json({ error: String(e.message || e) });
    }
  };

  if (convId) {
    db.query(
      "SELECT role, message FROM chat_messages WHERE conversation_id = ? ORDER BY id DESC LIMIT 8",
      [convId],
      (err, rows) => {
        if (err) return res.status(500).json({ error: err.sqlMessage });
        console.log("history rows len =", rows?.length || 0);
        sendToPython((rows || []).reverse());
      }
    );
  } else {
    sendToPython([]); // lần đầu không có history
  }
});

// ================== START SERVER ==================
const PORT = 3000;
app.listen(PORT, () => console.log(`🚀 Server chạy tại http://localhost:${PORT}`));
