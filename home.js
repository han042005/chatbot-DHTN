document.addEventListener("DOMContentLoaded", () => {
    const categoryList = document.getElementById("categoryList");

    // Lấy danh sách ngành học
   fetch(api("/nganh-hoc"))
        .then(res => res.json())
        .then(data => {
            data.forEach(nganh => {
                const div = document.createElement("div");
                div.classList.add("category");
                div.textContent = nganh.ten_nganh;
                // Chuyển sang trang books.html
                div.addEventListener("click", () => {
                    window.location.href = `books.html?id_nganh=${nganh.id}&ten_nganh=${encodeURIComponent(nganh.ten_nganh)}`;
                });
                categoryList.appendChild(div);
            });
        })
        .catch(err => console.error("Lỗi tải ngành:", err));
});

function renderThongBao(list) {
  const wrap = document.getElementById('thongBaoContainer');
  if (!wrap) return;

  wrap.innerHTML = ''; // nếu muốn chồng nhiều thông báo cũ, bỏ dòng này

  list.forEach(item => {
    const el = document.createElement('div');
    el.className = 'notify-item';
    el.id = item.id;

    el.innerHTML = `
      <div class="notify-text">${item.text}</div>
      <button class="notify-close" aria-label="Đóng">&times;</button>
    `;

    // nút đóng
    el.querySelector('.notify-close').addEventListener('click', () => {
      el.remove();
    });

    wrap.appendChild(el);

    // tự ẩn sau 6 giây (tuỳ chỉnh)
    setTimeout(() => el.remove(), 6000);
  });
}

// … sau khi bạn đã có mảng `thongBao`:
renderThongBao(thongBao);


