/* ====== Quản lý nhiều đoạn chat kiểu ChatGPT (frontend) ====== */
const LS_KEY_CONVS = "chat_conversations_v1";
const LS_KEY_MSGS  = "chat_messages_v1";
const LS_KEY_SERVER_IDS = "chat_server_ids_v1"; // <— NEW

function getServerIdMap() { try { return JSON.parse(localStorage.getItem(LS_KEY_SERVER_IDS)) || {}; } catch { return {}; } }
function setServerIdMap(m) { localStorage.setItem(LS_KEY_SERVER_IDS, JSON.stringify(m)); }


let currentConversation = null;

function loadLS(key, defVal) {
  try { return JSON.parse(localStorage.getItem(key)) ?? defVal; } catch { return defVal; }
}
function saveLS(key, val) { localStorage.setItem(key, JSON.stringify(val)); }

function getConvs()  { return loadLS(LS_KEY_CONVS, []); }
function setConvs(v) { saveLS(LS_KEY_CONVS, v); }
function getMsgsMap(){ return loadLS(LS_KEY_MSGS, {}); }
function setMsgsMap(v){ saveLS(LS_KEY_MSGS, v); }

function titleFromMessages(msgs) {
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
  const id = String(Date.now());                 // UI id
  const convs = getConvs();
  convs.unshift({ id, title: "Untitled chat", created_at: new Date().toISOString() });
  setConvs(convs);

  const map = getMsgsMap();
  map[id] = [];
  setMsgsMap(map);

  // serverId chưa có
  const srv = getServerIdMap();
  if (!srv[id]) { srv[id] = null; setServerIdMap(srv); }

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

  if (!currentConversation) await newChat();

  // lưu user vào LS & render
  let map = getMsgsMap();
  (map[currentConversation] ||= []).push({ role: "user", message: text, time: new Date().toISOString() });
  setMsgsMap(map);
  const box = document.getElementById("messages");
  box.innerHTML += `<p><b>user:</b> ${text}</p>`;
  input.value = ""; box.scrollTop = box.scrollHeight;

  // LẤY serverId nếu đã có
  const srvMap = getServerIdMap();
  const serverId = srvMap[currentConversation] || null;

  // Gọi /chat: chỉ gửi conversation_id khi đã có từ server
  const payload = serverId ? { question: text, conversation_id: serverId } : { question: text };

  try {
    const r = await fetch("/chat", {
      method: "POST",
      headers: { "Content-Type":"application/json" },
      body: JSON.stringify(payload)
    });
    const data = await r.json();

    // NHẬN VÀ LƯU conversation_id TỪ SERVER
    if (data.conversation_id && !srvMap[currentConversation]) {
      srvMap[currentConversation] = String(data.conversation_id);
      setServerIdMap(srvMap);
    }

    const answer = typeof data.answer === "string" ? data.answer : JSON.stringify(data);

    // Lưu bot & render
    map = getMsgsMap();
    (map[currentConversation] ||= []).push({ role: "bot", message: answer, time: new Date().toISOString() });
    setMsgsMap(map);
    box.innerHTML += `<p><b>bot:</b> ${answer}</p>`;
    box.scrollTop = box.scrollHeight;

    // Cập nhật tiêu đề
    const convs = getConvs();
    const idx = convs.findIndex(c => c.id === currentConversation);
    if (idx >= 0 && (!convs[idx].title || convs[idx].title === "Untitled chat")) {
      convs[idx].title = (map[currentConversation].find(m => m.role === "user")?.message || "Untitled chat").slice(0, 40);
      setConvs(convs);
      loadConversations();
    }
  } catch (e) {
    box.innerHTML += `<p style="color:#b91c1c"><b>bot:</b> Lỗi gọi API: ${e}</p>`;
  }
}


// Khởi động
loadConversations();
// document.getElementById("newChatBtn").onclick = newChat;
// document.getElementById("sendBtn").onclick = sendMessage;
document.getElementById("msg").onkeydown = (e) => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); sendMessage(); } };