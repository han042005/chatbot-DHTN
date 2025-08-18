# client.py
import requests

API_URL = "http://127.0.0.1:8000/chat"

while True:
    q = input("Bạn: ")
    if q.lower().strip() in ("exit", "quit"): break
    r = requests.post(API_URL, json={"question": q}, timeout=30)
    print("Bot:", r.json().get("answer"))
