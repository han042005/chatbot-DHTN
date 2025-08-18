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

def answer_from_db(user_question: str) -> str:
    if not questions:
        return "Hiện chưa có dữ liệu trong hệ thống."

    q = user_question.strip()

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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("chat_ai:app", host="127.0.0.1", port=3000, reload=True)
