# chat_ai.py
import os, sys, io
os.environ["PYTHONIOENCODING"] = "utf-8"
if os.name == "nt":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        sys.stdout = io.TextIOWrapper(getattr(sys.stdout, "buffer", sys.stdout.detach()), encoding="utf-8", errors="replace")
        sys.stderr = io.TextIOWrapper(getattr(sys.stderr, "buffer", sys.stderr.detach()), encoding="utf-8", errors="replace")

import mysql.connector
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from rapidfuzz import process
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from fastapi.responses import JSONResponse

DB_CFG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "root",
    "password": "",
    "database": "library_chatbot",
}

app = FastAPI(title="Library Chatbot API", version="1.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

def load_faqs():
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("SELECT id, question, answer FROM faqs")
    rows = cur.fetchall()
    cur.close(); cnx.close()
    ids = [r[0] for r in rows]
    questions = [r[1] for r in rows]
    answers = [r[2] for r in rows]
    return ids, questions, answers

try:
    faq_ids, questions, answers = load_faqs()
    print("DB connected & FAQs loaded:", len(questions))
except Exception as e:
    print("load_faqs error:", e)
    faq_ids, questions, answers = [], [], []

embed_model = SentenceTransformer("all-MiniLM-L6-v2")
question_embeddings = embed_model.encode(questions) if questions else []

FUZZY_THRESHOLD = 85
SEMANTIC_THRESHOLD = 0.65
# ===== NEW: từ điển nhận diện chuyên mục theo từ khóa =====
CATEGORY_KEYWORDS = {
    "cntt": ["công nghệ thông tin", "cntt", "công nghệ", "lập trình", "python", "web", "cơ sở dữ liệu"],
    "kinhte": ["kinh tế", "kế toán", "tài chính", "marketing", "quản trị"],
    "yhoc": ["y học", "sách y", "điều dưỡng", "giải phẫu", "dược", "nhi khoa", "sản phụ khoa"],
    "dieu_duong": ["điều dưỡng", "sách điều dưỡng", "chăm sóc sức khỏe"," chăm sóc bệnh nhân"],
    "giaoduc_chinhtri": ["giáo dục", "chính trị", "xã hội", "luật", "pháp luật", "luật học"],
    "gdmn": ["giáo dục mầm non", "sách giáo dục mầm non", "giáo viên mầm non", "nuôi dạy trẻ"],
    "giaoduc_tieuhoc_jrai": ["giáo dục tiểu học", "sách giáo dục tiểu học", "giáo viên tiểu học", "học sinh tiểu học"],
    "supham_hoahoc": ["sư phạm hóa học", "sách sư phạm hóa học", "giáo viên hóa học", "hóa học"],
    "supham_khoahoc_tunhien": ["sư phạm khoa học tự nhiên", "sách sư phạm khoa học tự nhiên", "giáo viên khoa học tự nhiên", "khoa học tự nhiên"],
    "supham_sinhhoc":["môn sinh","sinh","sinh học","sinh lý"],
    "giaoduc_thechat":["thể chất","thể","thể dục","chất","thể thao"],
    "ngon_ngu_anh":["môn anh","anh","tiếng anh"],
    "supham_toanhoc":["toán học","môn toán","học toán"],
    "triet_hoc":["môn triết","triết","sách triết"],
    "van":["môn văn","văn học","văn","ngữ văn"],
    "vanhoc":["văn học","văn văn","văn"],
    "supham_vatly":["môn lý","vật lý","sư phạm vật lý","lý lý"],
    "xet_nghiem_y_hoc":["xét nghiệm","y học xét nghiệm","xét nghiệm máu"],
    "sach_yhoc":["sách y","y học","ngành y"]



}

CATEGORY_TABLE = {
    "cntt": "cong_nghe_thong_tin",           # bảng CNTT bạn đã tạo
    "kinhte": "sach_kinhte",  # bảng Kinh tế
    "yhoc": "sach_yhoc",
    "dieu_duong":"dieu_duong",
    "giaoduc_chinhtri":"giaoduc_chinhtri",
    "supham_hoahoc":"supham_hoahoc",
    "gdmn":"gdmn",
    "giaoduc_tieuhoc_jrai":"giaoduc_tieuhoc_jrai",
    "supham_khoahoc_tunhien":"supham_khoahoc_tunhien",
    "supham_sinhhoc":"supham_sinhhoc",
    "giaoduc_thechat":"giaoduc_thechat",
    "ngon_ngu_anh":"ngon_ngu_anh",
    "supham_toanhoc":"supham_toanhoc",
    "triet_hoc":"triet_hoc",
    "van":"van",
    "vanhoc":"vanhoc",
    "supham_vatly":"supham_vatly",
    "xet_nghiem_y_hoc":"xet_nghiem_y_hoc",
    "sach_yhoc":"sach_yhoc"
}

# ===== NEW: formatter bảng đơn giản (markdown) =====
def format_books_table_html(rows, title="Kết quả gợi ý"):
    if not rows:
        return "<p>Xin lỗi, mình chưa tìm thấy tựa sách phù hợp.</p>"

    # Tạo header bảng
    table = f"<h3>{title}</h3>"
    table += """
    <table border="1" cellspacing="0" cellpadding="5">
        <thead>
            <tr>
                <th>#</th>
                <th>Tên sách</th>
                <th>Tác giả</th>
                <th>Tồn</th>
            </tr>
        </thead>
        <tbody>
    """

    # Thêm dữ liệu
    for i, (ten, tacgia, ton) in enumerate(rows, 1):
        table += f"""
        <tr>
            <td>{i}</td>
            <td>{ten}</td>
            <td>{tacgia}</td>
            <td>{ton}</td>
        </tr>
        """

    table += "</tbody></table>"
    return table


# ===== NEW: truy vấn theo chuyên mục (table cố định) =====
def fetch_books_by_category(cat_key: str):
    table = CATEGORY_TABLE.get(cat_key)
    if not table:
        return []
    sql = f"SELECT ten_sach, tac_gia, so_luong_ton FROM {table} ORDER BY ten_sach"
    try:
        cnx = mysql.connector.connect(**DB_CFG)
        cur = cnx.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        cur.close(); cnx.close()
        return rows
    except mysql.connector.Error as e:
        # log và trả rỗng để bot trả lời mềm mại
        print("SQL error:", e)
        return []

# ===== NEW: truy vấn theo từ khóa (tìm nhiều bảng) =====
def fetch_books_by_keyword(keyword: str):
    kw = f"%{keyword}%"
    # UNION ALL qua các bảng hiện có; an toàn với parameterized query
    unions = []
    params = []
    for table in CATEGORY_TABLE.values():
        unions.append(f"SELECT ten_sach, tac_gia, so_luong_ton FROM {table} "
                      f"WHERE ten_sach LIKE %s OR tac_gia LIKE %s")
        params.extend([kw, kw])
    sql = " UNION ALL ".join(unions) + " ORDER BY ten_sach"
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute(sql, tuple(params))
    rows = cur.fetchall()
    cur.close(); cnx.close()
    return rows


def answer_from_db(user_question: str) -> str:
    if not questions:
        return "Hiện chưa có dữ liệu trong hệ thống."

    q = user_question.strip().lower()

    # ===== NEW: nếu người dùng muốn "gợi ý sách" thì ưu tiên truy vấn sách =====
    # Các tín hiệu ý định
    if any(k in q for k in ["gợi ý", "goi y", "giới thiệu", "tim sach", "tìm sách", "có sách", "list sách", "ds sách", "danh sách sách"]):
        # 3.1. Thử đoán chuyên mục
        for cat_key, kw_list in CATEGORY_KEYWORDS.items():
            if any(kw in q for kw in kw_list):
                rows = fetch_books_by_category(cat_key)
                return format_books_table_html(rows, title="Gợi ý theo chuyên mục")

        # 3.2. Nếu không khớp chuyên mục, rút từ khóa nổi bật (lấy từ cuối câu)
        # ví dụ: "gợi ý sách về python", "gợi ý sách y", "sách marketing"
        # đơn giản: lấy từ cuối cùng có nghĩa
        tokens = [t for t in q.replace("?", " ").split() if t not in {"sách", "sach", "về", "ve", "cho", "tôi", "toi", "gợi", "ý", "goi", "y"}]
        if tokens:
            # thử dài -> ngắn: "công nghệ thông tin" trước "công nghệ"…
            for span in range(len(tokens), 0, -1):
                key = " ".join(tokens[-span:])
                rows = fetch_books_by_keyword(key)
                if rows:
                    return format_books_table_html(rows, title=f"Gợi ý theo từ khóa: {key}")

        # 3.3. Không tìm thấy
        return "Mình chưa tìm ra sách phù hợp. Bạn thử nêu rõ ngành (ví dụ: 'gợi ý sách y', 'gợi ý sách CNTT', 'gợi ý sách marketing') nhé."


    # Fuzzy
    m = process.extractOne(q, questions)
    if m is not None:
        _, fuzzy_score, fuzzy_idx = m
        if fuzzy_score >= FUZZY_THRESHOLD:
            return answers[fuzzy_idx]

    # Semantic
    user_emb = embed_model.encode([q])
    sims = cosine_similarity(user_emb, question_embeddings)[0]
    best_idx = int(sims.argmax())
    best_score = float(sims[best_idx])
    if best_score >= SEMANTIC_THRESHOLD:
        return answers[best_idx]

    return "Xin lỗi, tôi không tìm thấy thông tin phù hợp trong cơ sở dữ liệu."

class ChatRequest(BaseModel):
    question: str

class AddFAQ(BaseModel):
    question: str
    answer: str

@app.post("/chat")
def chat(req: ChatRequest):
    return {"answer": answer_from_db(req.question)}

@app.post("/faq/add")
def add_faq(item: AddFAQ):
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("INSERT INTO faqs (question, answer) VALUES (%s, %s)", (item.question, item.answer))
    cnx.commit(); cur.close(); cnx.close()
    global faq_ids, questions, answers, question_embeddings
    faq_ids, questions, answers = load_faqs()
    question_embeddings = embed_model.encode(questions) if questions else []
    return {"status": "ok", "message": "Đã thêm FAQ và cập nhật index."}

@app.post("/reload")
def reload_data():
    global faq_ids, questions, answers, question_embeddings
    faq_ids, questions, answers = load_faqs()
    question_embeddings = embed_model.encode(questions) if questions else []
    return {"status": "ok", "count": len(questions)}

@app.get("/", include_in_schema=False)
def root():
    return JSONResponse({"message": "Library Chatbot API up. Try POST /chat or open /docs."})

@app.get("/books/{category}")
def get_books(category: str):
    if category not in CATEGORY_TABLE:
        return {"error": "Chuyên mục không tồn tại"}
    rows = fetch_books_by_category(category)
    return {
        "category": category,
        "books": [
            {"ten_sach": r[0], "tac_gia": r[1], "so_luong_ton": r[2]} for r in rows
        ]
    }



if __name__ == "__main__":
    import uvicorn
    uvicorn.run("chat_ai:app", host="127.0.0.1", port=3001, reload=True)
