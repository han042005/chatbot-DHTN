# chat_ai.py
import mysql.connector
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from rapidfuzz import process
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from fastapi.responses import RedirectResponse, JSONResponse

# ====== Cấu hình MySQL ======
DB_CFG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "root",
    "password": "",          # không có mật khẩu thì để rỗng
    "database": "library_chatbot",   # đổi đúng tên DB của bạn
    # "auth_plugin": "mysql_native_password",  # bật nếu user dùng plugin này
}

# ====== App ======
app = FastAPI(title="Library Chatbot API", version="1.0")

# CORS: cho mọi origin, KHÔNG credentials khi dùng "*"
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ====== DB helpers ======
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

# ====== Model & data ======
try:
    faq_ids, questions, answers = load_faqs()
    print("Kết nối DB & tải FAQ: OK -", len(questions), "câu")
except Exception as e:
    print("Lỗi load_faqs:", e)
    faq_ids, questions, answers = [], [], []

embed_model = SentenceTransformer("all-MiniLM-L6-v2")
question_embeddings = embed_model.encode(questions) if questions else []

FUZZY_THRESHOLD = 85
SEMANTIC_THRESHOLD = 0.60

def answer_from_db(user_question: str) -> str:
    if not questions:
        return "Hiện chưa có dữ liệu trong hệ thống."
    # Fuzzy
    match, score, idx = process.extractOne(user_question, questions)
    if score >= FUZZY_THRESHOLD:
        return answers[idx]
    # Semantic
    user_emb = embed_model.encode([user_question])
    sims = cosine_similarity(user_emb, question_embeddings)[0]
    best_idx = int(sims.argmax())
    if sims[best_idx] >= SEMANTIC_THRESHOLD:
        return answers[best_idx]
    return "Xin lỗi, tôi không tìm thấy thông tin phù hợp trong cơ sở dữ liệu."

# ====== Schemas ======
class ChatRequest(BaseModel):
    question: str

class AddFAQ(BaseModel):
    question: str
    answer: str

# ====== Endpoints ======
@app.post("/chat")
def chat(req: ChatRequest):
    return {"answer": answer_from_db(req.question)}

@app.post("/faq/add")
def add_faq(item: AddFAQ):
    cnx = mysql.connector.connect(**DB_CFG)
    cur = cnx.cursor()
    cur.execute("INSERT INTO faqs (question, answer) VALUES (%s, %s)", (item.question, item.answer))
    cnx.commit(); cur.close(); cnx.close()
    # reload embeddings
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
    # chọn 1 trong 2:
    # return RedirectResponse("/docs")
    return JSONResponse({"message": "Library Chatbot API up. Try POST /chat or open /docs."})

# Cho phép: python chat_ai.py
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("chat_ai:app", host="127.0.0.1", port=8000, reload=True)
