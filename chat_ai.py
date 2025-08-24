# chat_ai.py (bản nhớ ngữ cảnh 3 câu gần nhất + gợi ý bảng theo ngành giống file 1)
import os, sys, io, re, unicodedata
from collections import deque, defaultdict
from typing import List, Literal, Optional, Deque, Dict

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
from fastapi.responses import JSONResponse
from pydantic import BaseModel

from rapidfuzz import process as rf_process, fuzz as rf_fuzz
from sklearn.metrics.pairwise import cosine_similarity

# ===== Optional: SentenceTransformer (tự tắt nếu không cài / không có mạng) =====
EMBED_OK = True
try:
    from sentence_transformers import SentenceTransformer
except Exception:
    EMBED_OK = False

# =================== DB CONFIG ===================
DB_CFG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "root",
    "password": "",
    "database": "library_chatbot",
}

# =================== FASTAPI ===================
app = FastAPI(title="Library Chatbot API", version="1.2-gioi-y-context3")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =================== MODELS ===================
class Msg(BaseModel):
    role: Literal["user", "bot"]
    message: str

class ChatRequest(BaseModel):
    question: str
    conversation_id: Optional[str] = "default"
    history: List[Msg] = []

class AddFAQ(BaseModel):
    question: str
    answer: str

# =================== TIỆN ÍCH TIẾNG VIỆT ===================
VI_STOP = {
    "va","hoac","la","co","khong","thi","luc","khi","nao","sao","ve","cho","toi",
    "bi","duoc","can","cua","trong","o","den","tu","dau","nua","nhe","a","ha","minh",
    "xin","vui","long","giup","hoi","nho","voi","di"
}

def strip_accents(s: str) -> str:
    if not s: return ""
    return "".join(ch for ch in unicodedata.normalize("NFD", s) if unicodedata.category(ch) != "Mn")

def normalize_text(s: str) -> str:
    s = (s or "").lower().strip()
    s = strip_accents(s)
    s = re.sub(r"[^a-z0-9\s]", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s

def tokenize(s: str) -> List[str]:
    s = normalize_text(s)
    toks = [t for t in s.split() if len(t) >= 2 and t not in VI_STOP]
    return toks

# =================== FAQs (nạp lúc khởi động, có /reload) ===================
faq_ids: List[int] = []
questions: List[str] = []
questions_norm: List[str] = []
answers: List[str] = []
embed_model = None
question_embeddings = None  # semantic vectors

def load_faqs():
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("SELECT id, question, answer FROM faqs")
    rows = cur.fetchall()
    cur.close(); cnx.close()
    ids = [r[0] for r in rows]
    qs = [r[1] or "" for r in rows]
    ans = [r[2] or "" for r in rows]
    qs_norm = [normalize_text(q) for q in qs]
    return ids, qs, qs_norm, ans

def build_embeddings():
    global embed_model, question_embeddings
    if not EMBED_OK:
        embed_model, question_embeddings = None, None
        return
    try:
        if embed_model is None:
            embed_model = SentenceTransformer("all-MiniLM-L6-v2")
        if questions:
            question_embeddings = embed_model.encode([normalize_text(q) for q in questions])
        else:
            question_embeddings = None
    except Exception as e:
        print("Embedding init error:", e)
        question_embeddings = None

def init_data():
    global faq_ids, questions, questions_norm, answers
    try:
        faq_ids, questions, questions_norm, answers = load_faqs()
        print(f"DB connected & FAQs loaded: {len(questions)}")
    except Exception as e:
        print("load_faqs error:", e)
        faq_ids, questions, questions_norm, answers = [], [], [], []
    build_embeddings()

init_data()

# =================== CATEGORY & TRUY VẤN SÁCH ===================
CATEGORY_KEYWORDS: Dict[str, List[str]] = {
    "cntt": ["cong nghe thong tin","cntt","cong nghe","lap trinh","python","web","co so du lieu","csdl"],
    "kinhte": ["kinh te","ke toan","tai chinh","marketing","quan tri"],
    "yhoc": ["y hoc","sach y","dieu duong","giai phau","duoc","nhi khoa","san phu khoa","y khoa","y hoc co so"],
    "dieu_duong": ["dieu duong","sach dieu duong","cham soc suc khoe","cham soc benh nhan"],
    "giaoduc_chinhtri": ["giao duc","chinh tri","xa hoi","luat","phap luat","luat hoc"],
    "gdmn": ["giao duc mam non","sach giao duc mam non","giao vien mam non","nuoi day tre"],
    "giaoduc_tieuhoc_jrai": ["giao duc tieu hoc","sach giao duc tieu hoc","giao vien tieu hoc","hoc sinh tieu hoc"],
    "supham_hoahoc": ["su pham hoa hoc","sach su pham hoa hoc","giao vien hoa hoc","hoa hoc"],
    "supham_khoahoc_tunhien": ["su pham khoa hoc tu nhien","sach su pham khoa hoc tu nhien","khoa hoc tu nhien"],
    "supham_sinhhoc":["mon sinh","sinh","sinh hoc","sinh ly"],
    "giaoduc_thechat":["the chat","the duc","the thao"],
    "ngon_ngu_anh":["mon anh","anh","tieng anh","english"],
    "supham_toanhoc":["toan hoc","mon toan","hoc toan"],
    "triet_hoc":["mon triet","triet","sach triet"],
    "van":["mon van","van hoc","ngu van","van"],
    "vanhoc":["van hoc","van"],
    "supham_vatly":["mon ly","vat ly","su pham vat ly"],
    "xet_nghiem_y_hoc":["xet nghiem","y hoc xet nghiem","xet nghiem mau"],
    "sach_yhoc":["sach y","y hoc","nganh y"]
}
CATEGORY_TABLE: Dict[str, str] = {
    "cntt": "cong_nghe_thong_tin",
    "kinhte": "sach_kinhte",
    "yhoc": "sach_yhoc",
    "dieu_duong": "dieu_duong",
    "giaoduc_chinhtri": "giaoduc_chinhtri",
    "gdmn": "gdmn",
    "giaoduc_tieuhoc_jrai": "giaoduc_tieuhoc_jrai",
    "supham_hoahoc": "supham_hoahoc",
    "supham_khoahoc_tunhien": "supham_khoahoc_tunhien",
    "supham_sinhhoc": "supham_sinhhoc",
    "giaoduc_thechat": "giaoduc_thechat",
    "ngon_ngu_anh": "ngon_ngu_anh",
    "supham_toanhoc": "supham_toanhoc",
    "triet_hoc": "triet_hoc",
    "van": "van",
    "vanhoc": "vanhoc",
    "supham_vatly": "supham_vatly",
    "xet_nghiem_y_hoc": "xet_nghiem_y_hoc",
    "sach_yhoc": "sach_yhoc",
}

# Kích hoạt ý định gợi ý / đề xuất (không cần đổi code mỗi lần)
BOOK_INTENT_HINTS = [
    "goi y", "goi y sach", "goi y de xuat",
    "de xuat", "de xuat sach",
    "gioi thieu", "tim sach", "list sach", "ds sach", "danh sach sach"
]
SPECIAL_DEFAULT_CATEGORY = "sach_yhoc"  # fallback nếu không suy ra ngành

def format_books_table_html(rows, title="Kết quả gợi ý"):
    if not rows:
        return "<p>Xin lỗi, mình chưa tìm thấy tựa sách phù hợp.</p>"
    table = f"<h3>{title}</h3>"
    table += """
    <table border="1" cellspacing="0" cellpadding="6">
        <thead>
            <tr>
                <th>#</th><th>Tên sách</th><th>Tác giả</th><th>Tồn</th>
            </tr>
        </thead>
        <tbody>
    """
    for i, (ten, tacgia, ton) in enumerate(rows, 1):
        table += f"<tr><td>{i}</td><td>{ten}</td><td>{tacgia}</td><td>{ton}</td></tr>"
    table += "</tbody></table>"
    return table

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
        print("SQL error:", e)
        return []

def fetch_books_by_keyword(keyword: str):
    kw = f"%{keyword}%"
    unions, params = [], []
    for table in CATEGORY_TABLE.values():
        unions.append(f"SELECT ten_sach, tac_gia, so_luong_ton FROM {table} WHERE ten_sach LIKE %s OR tac_gia LIKE %s")
        params.extend([kw, kw])
    sql = " UNION ALL ".join(unions) + " ORDER BY ten_sach"
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute(sql, tuple(params))
    rows = cur.fetchall()
    cur.close(); cnx.close()
    return rows

# =================== NHỚ NGỮ CẢNH SERVER-SIDE ===================
MEM: Dict[str, Deque[Msg]] = defaultdict(lambda: deque(maxlen=20))

def add_to_memory(conv_id: str, role: Literal["user","bot"], text: str):
    MEM[conv_id].append(Msg(role=role, message=text))

def get_context(conv_id: str, fallback_history: List[Msg]) -> List[Msg]:
    if conv_id and len(MEM[conv_id]) > 0:
        return list(MEM[conv_id])
    return fallback_history or []

def last_user_context_text(msgs: List[Msg], k: int = 3) -> str:
    recent_user = [m.message for m in msgs if m.role == "user"][-k:]
    return " | ".join(recent_user)

# =================== LOGIC NHẬN DIỆN Ý ĐỊNH / NGÀNH ===================
def detect_book_intent(q: str) -> bool:
    qn = normalize_text(q)
    return any(h in qn for h in BOOK_INTENT_HINTS)

def detect_category_from_text(q: str) -> Optional[str]:
    qn = normalize_text(q)
    # bắt nhanh các cụm phổ biến
    if "sach y" in qn or "y hoc" in qn:
        return "sach_yhoc"
    if "cntt" in qn or "cong nghe thong tin" in qn:
        return "cntt"
    # dò theo từ khoá trong từ điển
    for cat_key, kw_list in CATEGORY_KEYWORDS.items():
        for kw in kw_list:
            if normalize_text(kw) in qn:
                return cat_key
    return None

# =================== RANKING THEO NGỮ CẢNH (cho FAQs) ===================
def context_rank(candidates: List[str], context_text: str, base_scores: List[float]) -> List[int]:
    if not candidates:
        return []
    ctx_tokens = set(tokenize(context_text)) if context_text else set()
    scored = []
    for i, cand in enumerate(candidates):
        cand_tokens = set(tokenize(cand))
        overlap = len(cand_tokens & ctx_tokens)
        union = len(cand_tokens | ctx_tokens) or 1
        jacc = overlap / union
        score = float(base_scores[i]) + overlap * 20 + jacc * 30
        if overlap == 0:
            score -= 25
        scored.append((score, i))
    scored.sort(reverse=True)
    return [i for _, i in scored]

# =================== TRẢ LỜI CHÍNH ===================
def answer_from_db(user_question: str, context_msgs: List[Msg]) -> str:
    # Lấy ngữ cảnh 3 câu user gần nhất
    convo_ctx_text = last_user_context_text(context_msgs, k=3)
    q_norm = normalize_text(user_question)

    # ===== 0) ƯU TIÊN Ý ĐỊNH GỢI Ý / ĐỀ XUẤT =====
    if detect_book_intent(user_question) or detect_book_intent(convo_ctx_text):
        # Suy ngành từ câu hiện tại, nếu không được thì từ ngữ cảnh
        cat = detect_category_from_text(user_question) or detect_category_from_text(convo_ctx_text)
        if not cat:
            cat = SPECIAL_DEFAULT_CATEGORY  # fallback nếu không nêu ngành
        rows = fetch_books_by_category(cat)
        if rows:
            human = "Y học" if cat in ("yhoc","sach_yhoc") else cat.replace("_"," ").title()
            return format_books_table_html(rows, title=f"Gợi ý theo chuyên mục: {human}")

        # Không ra bảng theo chuyên mục -> thử theo keyword từ câu hiện tại hoặc ngữ cảnh
        tokens = tokenize(user_question) or tokenize(convo_ctx_text or "")
        if tokens:
            key = " ".join(tokens[-3:])
            rows = fetch_books_by_keyword(key)
            if rows:
                return format_books_table_html(rows, title=f"Gợi ý theo từ khóa: {key}")
        return "Mình chưa tìm ra sách phù hợp. Bạn thử nêu rõ chuyên mục (vd: 'gợi ý sách CNTT', 'gợi ý sách Y') nhé."

    # ===== 1) FAQs: Fuzzy trước =====
    if not questions:
        return "Hiện chưa có dữ liệu FAQs trong hệ thống."
    try:
        topN = rf_process.extract(q_norm, questions_norm, limit=8, scorer=rf_fuzz.WRatio)
        if topN:
            cand_idx = [idx for (_, _, idx) in topN]
            cand_qs  = [questions[idx] for idx in cand_idx]
            base_scores = [score for (_, score, _) in topN]
            order = context_rank(cand_qs, convo_ctx_text, base_scores) if convo_ctx_text else list(range(len(cand_qs)))
            best_idx_local = order[0]
            best_question_idx = cand_idx[best_idx_local]
            best_score = base_scores[best_idx_local]
            if best_score >= 60:
                return answers[best_question_idx]
    except Exception as e:
        print("Fuzzy error:", e)

    # ===== 2) FAQs: Semantic =====
    try:
        if EMBED_OK and embed_model is not None and question_embeddings is not None:
            user_emb = embed_model.encode([q_norm])
            sims = cosine_similarity(user_emb, question_embeddings)[0]
            cand_idx = sims.argsort()[-8:][::-1]
            cand_qs = [questions[i] for i in cand_idx]
            base_scores = [float(sims[i]) * 100 for i in cand_idx]
            order = context_rank(cand_qs, convo_ctx_text, base_scores) if convo_ctx_text else list(range(len(cand_qs)))
            best_idx_local = order[0]
            best_global_idx = cand_idx[best_idx_local]
            best_sim = float(sims[best_global_idx])
            if best_sim >= 0.50:
                return answers[best_global_idx]
    except Exception as e:
        print("Semantic error:", e)

    # ===== 3) Fallback =====
    return "Mình chưa tìm thấy câu trả lời phù hợp trong FAQs. Bạn có thể hỏi rõ hơn hoặc dùng từ khóa khác giúp mình nhé."

# =================== DEBUG ===================
def debug_context(conv_id: str, history: List[Msg], user_question: str):
    print("=== DEBUG CONTEXT ===")
    print("Conversation ID:", conv_id)
    print("User question:", user_question)
    mem = list(MEM[conv_id]) if conv_id in MEM else []
    print("Server memory size:", len(mem))
    if mem:
        for i, m in enumerate(mem[-3:], 1):
            print(f"  MEM-{i}. {m.role}: {m.message[:120]}")
    if history:
        print("History (client-provided) size:", len(history))
        for i, m in enumerate(history[-3:], 1):
            print(f"  HIS-{i}. {m.role}: {m.message[:120]}")
    print("=====================")

# =================== ROUTES ===================
@app.post("/chat")
def chat(req: ChatRequest):
    conv_id = req.conversation_id or "default"
    debug_context(conv_id, req.history, req.question)

    # nạp history client gửi (ít thôi để sạch)
    if req.history:
        for m in req.history[-5:]:
            add_to_memory(conv_id, m.role, m.message)

    # thêm câu hỏi hiện tại vào memory
    add_to_memory(conv_id, "user", req.question)

    # lấy ngữ cảnh kết hợp (ưu tiên server memory)
    ctx_msgs = get_context(conv_id, req.history)
    ans = answer_from_db(req.question, ctx_msgs)

    # lưu trả lời vào memory
    add_to_memory(conv_id, "bot", ans)

    return {"answer": ans}

@app.post("/faq/add")
def add_faq(item: AddFAQ):
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("INSERT INTO faqs (question, answer) VALUES (%s, %s)", (item.question, item.answer))
    cnx.commit()
    cur.close(); cnx.close()
    # reload dữ liệu FAQs + embeddings
    init_data()
    return {"status": "ok", "message": "Đã thêm FAQ và cập nhật index.", "count": len(questions)}

@app.post("/reload")
def reload_data():
    init_data()
    return {"status": "ok", "count": len(questions)}

@app.post("/clear/{conversation_id}")
def clear_conv(conversation_id: str):
    MEM.pop(conversation_id, None)
    return {"status": "ok", "message": f"Đã xoá ngữ cảnh conv_id={conversation_id}"}

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
        "books": [{"ten_sach": r[0], "tac_gia": r[1], "so_luong_ton": r[2]} for r in rows]
    }

@app.get("/debug/db")
def debug_db():
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("SELECT DATABASE(), @@hostname")
    dbname, host = cur.fetchone()
    cur.close(); cnx.close()
    return {
        "db": dbname,
        "mem_size": {k: len(v) for k, v in MEM.items()}
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("chat_ai:app", host="127.0.0.1", port=3001, reload=True)
