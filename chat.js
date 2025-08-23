/* ====== Quản lý nhiều đoạn chat kiểu ChatGPT (dùng chung API /chat) ====== */
const LS_KEY_CONVS = "chat_conversations_v1";   // danh sách conv
const LS_KEY_MSGS  = "chat_messages_v1";        // map {convId: [ {role, message, time} ]}

let currentConversation = null;

function loadLS(key, defVal) {
  try { return JSON.parse(localStorage.getItem(key)) ?? defVal; } catch { return defVal; }
}
function saveLS(key, val) { localStorage.setItem(key, JSON.stringify(val)); }

function getConvs()        { return loadLS(LS_KEY_CONVS, []); }
function setConvs(convs)   { saveLS(LS_KEY_CONVS, convs); }
function getMsgsMap()      { return loadLS(LS_KEY_MSGS, {}); }
function setMsgsMap(map)   { saveLS(LS_KEY_MSGS, map); }

function titleFromMessages(msgs) {
  // Lấy 1 câu đầu tiên của user làm tiêu đề
  const firstUser = msgs.find(m => m.role === "user");
  if (!firstUser) return "Untitled chat";
  const t = firstUser.message.trim();
  return t.length > 40 ? t.slice(0, 37) + "..." : t || "Untitled chat";
}

async function loadConversations() {
  const convs = getConvs();
  const list = document.getElementById("chatList");
  list.innerHTML = "";
  convs.forEach(c => {
    const li = document.createElement("li");
    li.style.cursor = "pointer";
    li.textContent = c.title || "Untitled chat";
    li.onclick = () => openChat(c.id);
    list.appendChild(li);
  });
}

async function newChat() {
  const id = String(Date.now());
  const convs = getConvs();
  convs.unshift({ id, title: "Untitled chat", created_at: new Date().toISOString() });
  setConvs(convs);

  // Khởi tạo messages rỗng cho conv này
  const map = getMsgsMap();
  map[id] = [];
  setMsgsMap(map);

  currentConversation = id;
  document.getElementById("messages").innerHTML = "";
  loadConversations();
}

async function openChat(id) {
  currentConversation = id;
  const map = getMsgsMap();
  const msgs = map[id] || [];

  const box = document.getElementById("messages");
  box.innerHTML = msgs.map(m => `<p><b>${m.role}:</b> ${m.message}</p>`).join("");
  box.scrollTop = box.scrollHeight;
}

async function sendMessage() {
  const input = document.getElementById("msg");
  const text = (input.value || "").trim();
  if (!text) return;
  if (!currentConversation) {
    // Nếu chưa có conv, tạo mới tự động
    await newChat();
  }

  // 1) Lưu tin nhắn user vào localStorage
  let map = getMsgsMap();
  const msgs = map[currentConversation] || [];
  msgs.push({ role: "user", message: text, time: new Date().toISOString() });
  map[currentConversation] = msgs;
  setMsgsMap(map);

  // 2) Render ngay cho mượt
  const box = document.getElementById("messages");
  box.innerHTML += `<p><b>user:</b> ${text}</p>`;
  input.value = "";
  box.scrollTop = box.scrollHeight;

  // 3) Gọi API cũ /chat để lấy trả lời
  try {
    const r = await fetch("/chat", {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify({ question: text })
    });
    const data = await r.json();
    const answer = typeof data.answer === "string"
      ? data.answer
      : JSON.stringify(data.answer);

    // 4) Lưu bot vào localStorage
    map = getMsgsMap();
    const msgs2 = map[currentConversation] || [];
    msgs2.push({ role: "bot", message: answer, time: new Date().toISOString() });
    map[currentConversation] = msgs2;
    setMsgsMap(map);

    // 5) Render bot
    box.innerHTML += `<p><b>bot:</b> ${answer}</p>`;
    box.scrollTop = box.scrollHeight;

    // 6) Cập nhật tiêu đề conv (nếu còn "Untitled")
    const convs = getConvs();
    const idx = convs.findIndex(c => c.id === currentConversation);
    if (idx >= 0 && (!convs[idx].title || convs[idx].title === "Untitled chat")) {
      convs[idx].title = titleFromMessages(msgs2);
      setConvs(convs);
      loadConversations();
    }
  } catch (e) {
    box.innerHTML += `<p style="color:#b91c1c"><b>bot:</b> Lỗi gọi API: ${e}</p>`;
  }
}

// Khởi động
loadConversations();
// Nếu muốn tự tạo 1 cuộc chat đầu tiên khi mở trang:
// newChat();
