// ===== API base (dev dùng port backend, prod cùng domain)
const API_BASE =
  (location.hostname === '127.0.0.1' || location.hostname === 'localhost')
    ? 'http://127.0.0.1:3000'   // <-- sửa đúng port backend
    : '';

function api(path) {
  return `${API_BASE}${path.startsWith('/') ? path : '/' + path}`;
}

// An toàn khi parse JSON: nếu server trả HTML 404 sẽ ném lỗi dễ hiểu
async function fetchJsonSafe(url, opts) {
  const res = await fetch(url, opts);
  if (!res.ok) throw new Error(`HTTP ${res.status} @ ${url}`);
  const ct = res.headers.get('content-type') || '';
  if (!ct.includes('application/json')) {
    const text = await res.text();
    throw new Error(`Response is not JSON. First 120 chars: ${text.slice(0,120)}`);
  }
  return res.json();
}

document.addEventListener("DOMContentLoaded", () => {
  const params = new URLSearchParams(window.location.search);
  const id_nganh = params.get("id_nganh");
  const ten_nganh = params.get("ten_nganh");

  const titleEl = document.getElementById("bookTitle");
  const tbody = document.getElementById("bookTableBody");
  const searchInput = document.getElementById("searchBook");
  const searchBtn = document.getElementById("searchBtn");
  const thongBaoContainer = document.getElementById("thongBaoContainer");


  // ✅ Dùng chung cho nhiều trang
  const isBooksPage = !!tbody;                // có bảng sách => trang danh sách
  const isHomePage  = !!thongBaoContainer;    // có hộp thông báo => trang home

  if (titleEl) {
    titleEl.textContent = ten_nganh
      ? `Danh sách sách - ${ten_nganh}`
      : "Danh sách sách";
  }

  let allBooks = [];
  let filteredBooks = [];

  // ====== Tải dữ liệu sách (chỉ khi có bảng) ======
  async function fetchBooks() {
    if (!isBooksPage) return;
    try {
      const url = id_nganh
        ? api(`/sach/nganh/${encodeURIComponent(id_nganh)}`)
        : api(`/sach`);

      const data = await fetchJsonSafe(url, { headers: { "Accept": "application/json" } });
      allBooks = Array.isArray(data) ? data : (data?.books ?? []);
      filteredBooks = allBooks.slice();
      renderBooks(filteredBooks);
    } catch (err) {
      console.error("Lỗi tải sách:", err);
      if (tbody) {
        tbody.innerHTML = `
          <tr><td colspan="5" style="text-align:center;color:#c00">
            Không tải được dữ liệu sách. Vui lòng thử lại sau.
          </td></tr>
        `;
      }
    }
  }

  function renderBooks(books) {
    if (!tbody) return;
    tbody.innerHTML = "";
    if (!books || books.length === 0) {
      tbody.innerHTML = `
        <tr><td colspan="5" style="text-align:center;opacity:.75">
          Không có sách để hiển thị.
        </td></tr>
      `;
      return;
    }

    const frag = document.createDocumentFragment();
    books.forEach(book => {
      const tr = document.createElement("tr");
      const ten = book.ten_sach ?? "";
      const tg  = book.tac_gia ?? "";
      const nam = book.nam_xuat_ban ?? "";
      const ton = Number.isFinite(+book.so_luong_ton) ? +book.so_luong_ton : 0;
      const id  = book.id ?? "";

      tr.innerHTML = `
        <td>${escapeHtml(ten)}</td>
        <td>${escapeHtml(tg)}</td>
        <td>${escapeHtml(String(nam))}</td>
        <td>${ton}</td>
        <td>
          <button class="borrow-btn" data-id="${id}" ${ton <= 0 ? "disabled" : ""}>
            ${ton > 0 ? "Mượn" : "Hết sách"}
          </button>
        </td>
      `;
      frag.appendChild(tr);
    });
    tbody.appendChild(frag);

    tbody.querySelectorAll(".borrow-btn").forEach(btn => {
      btn.addEventListener("click", onBorrowClick);
    });
  }

  async function onBorrowClick(e) {
    const btn = e.currentTarget;
    const id  = btn.getAttribute("data-id");
    const book = allBooks.find(b => String(b.id) === String(id));
    if (!book) return;

    if (!confirm(`Bạn có chắc muốn mượn sách "${book.ten_sach}" không?`)) return;

    const currentUser = safeParseLocalStorage("currentUser");
    if (!currentUser) {
      alert("❌ Vui lòng đăng nhập trước khi mượn sách!");
      return;
    }

    let ma_sv = null, ma_gv = null;
    if (currentUser.role === "sinh_vien")  ma_sv = currentUser.ma;
    if (currentUser.role === "giang_vien") ma_gv = currentUser.ma;

    const today = new Date();
    const ngay_muon = toYyyyMmDd(today);
    const han = new Date(today);
    han.setDate(han.getDate() + 7);
    const han_tra = toYyyyMmDd(han);

    try {
      const res = await fetch(api("/phieu-muon"), {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ma_sv, ma_gv,
          id_sach: book.id,
          ten_sach: book.ten_sach,
          ngay_muon, han_tra
        })
      });

      const data = await res.json(); // server của bạn chắc chắn trả JSON ở đây
      if (data.success) {
        alert("✅ Mượn sách thành công!");
        const target = allBooks.find(b => b.id === book.id);
        if (target) target.so_luong_ton = Math.max(0, (+target.so_luong_ton || 0) - 1);
        applyFilter();
      } else {
        alert("❌ Lỗi: " + (data.message ?? "Không xác định"));
      }
    } catch (err) {
      console.error(err);
      alert("❌ Lỗi kết nối server khi mượn sách.");
    }
  }

  // ====== Tìm kiếm (chỉ khi có ô search) ======
  function applyFilter() {
    if (!isBooksPage) return;
    const keyword = (searchInput?.value ?? "").toLowerCase().trim();
    filteredBooks = !keyword
      ? allBooks.slice()
      : allBooks.filter(b =>
          (b.ten_sach ?? "").toLowerCase().includes(keyword) ||
          (b.tac_gia ?? "").toLowerCase().includes(keyword)
        );
    renderBooks(filteredBooks);
  }

  function debounce(fn, delay = 250) {
    let t;
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), delay); };
  }

  if (searchInput) {
    const onSearchInput = debounce(applyFilter, 200);
    searchInput.addEventListener("input", onSearchInput);
    searchInput.addEventListener("keydown", (e) => { if (e.key === "Enter") applyFilter(); });
  }
  if (searchBtn) searchBtn.addEventListener("click", applyFilter);

  // ====== Thông báo sách (TTL 30s, chỉ chạy trên home)
  if (isHomePage) {
    const liveNoti = new Map(); // Map<key, {el, timeout}>

    function makeKey(msg) {
      return typeof msg === "object" && msg?.id ? String(msg.id) : String(msg);
    }

    function renderOne(msgText, key) {
      const p = document.createElement("div");
      p.className = "noti-item";
      p.textContent = msgText;

      const close = document.createElement("button");
      close.className = "noti-close";
      close.textContent = "×";
      close.addEventListener("click", () => removeOne(key));
      p.appendChild(close);

      // Thêm vào container với opacity = 0
      p.style.opacity = "0";
      p.style.transform = "translateX(100%)";
      thongBaoContainer.appendChild(p);
      
      // Hiệu ứng fade in + slide in
      setTimeout(() => {
        p.style.transition = "all 0.8s ease-out";
        p.style.opacity = "1";
        p.style.transform = "translateX(0)";
      }, 100);
      
      // Tự động ẩn sau 30 giây
      const t = setTimeout(() => removeOne(key), 30_000);
      liveNoti.set(key, { el: p, timeout: t });
    }

    function removeOne(key) {
      const rec = liveNoti.get(key);
      if (!rec) return;
      clearTimeout(rec.timeout);
      
      // Hiệu ứng fade out + slide out
      rec.el.style.transition = "all 0.8s ease-in";
      rec.el.style.opacity = "0";
      rec.el.style.transform = "translateX(100%)";
      
      setTimeout(() => {
        if (rec.el.parentElement) {
          rec.el.remove();
        }
        liveNoti.delete(key);
      }, 800);
    }

    async function layThongBaoSach() {
      try {
        const data = await fetchJsonSafe(
          api("/api/thong-bao-sach"),
          { headers: { "Accept": "application/json" } }
        );

        const list = Array.isArray(data) ? data : (data?.thongBao ?? []);
        list.forEach(raw => {
          const text = typeof raw === "string" ? raw : (raw?.text ?? JSON.stringify(raw));
          const key  = makeKey(raw);
          if (!liveNoti.has(key)) renderOne(text, key);
        });
        // Không xóa cũ — để TTL tự xử lý
      } catch (err) {
        console.error("Lỗi tải thông báo sách:", err);
      }
    }

    layThongBaoSach();
    setInterval(layThongBaoSach, 15000);
  }





  // Khởi chạy
  fetchBooks();
});

// ====== Helpers ======
function escapeHtml(str) {
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function toYyyyMmDd(date) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

function safeParseLocalStorage(key) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}
