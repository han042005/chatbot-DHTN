document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const id_nganh = params.get("id_nganh");
    const ten_nganh = params.get("ten_nganh");

    document.getElementById("bookTitle").textContent = `Danh sách sách - ${ten_nganh}`;

    let allBooks = [];

    // Lấy dữ liệu sách
    fetch(`/sach/nganh/${id_nganh}`)
        .then(res => res.json())
        .then(books => {
            allBooks = books;
            renderBooks(allBooks);
        })
        .catch(err => console.error("Lỗi tải sách:", err));

    // Hàm hiển thị sách
function renderBooks(books) {
    const tbody = document.getElementById("bookTableBody");
    tbody.innerHTML = "";
    books.forEach(book => {
        const row = document.createElement("tr");

        row.innerHTML = `
            <td>${book.ten_sach}</td>
            <td>${book.tac_gia || ""}</td>
            <td>${book.nam_xuat_ban || ""}</td>
            <td>${book.so_luong_ton}</td>
            <td><button class="borrow-btn" data-ten-sach="${book.ten_sach}">Mượn</button></td>
        `;

        tbody.appendChild(row);
    });

    // Gắn sự kiện cho các nút Mượn
    document.querySelectorAll(".borrow-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            const ten_sach = btn.getAttribute("data-ten-sach");
            if (confirm(`Bạn có chắc muốn mượn sách "${ten_sach}" không?`)) {
                borrowBook(ten_sach);
            }
        });
    });
}
function borrowBook(ten_sach) {
    // Kiểm tra Moment.js
    if (typeof moment === "undefined") {
        alert("❌ Lỗi: Moment.js không được tải!");
        console.error("Moment.js không được tải. Vui lòng kiểm tra thẻ <script>.");
        return;
    }

    const currentUser = JSON.parse(localStorage.getItem("currentUser"));
    if (!currentUser || !currentUser.ma) {
        alert("❌ Vui lòng đăng nhập trước khi mượn sách!");
        window.location.href = "login.html";
        return;
    }

    let ma_sv = null;
    let ma_gv = null;
    if (currentUser.role === "sinh_vien") {
        ma_sv = currentUser.ma;
    } else if (currentUser.role === "giang_vien") {
        ma_gv = currentUser.ma;
    } else {
        alert("❌ Lỗi: Vai trò người dùng không hợp lệ!");
        return;
    }

    // Tạo ngày trong múi giờ Asia/Ho_Chi_Minh
    const today = moment().tz("Asia/Ho_Chi_Minh").format("YYYY-MM-DD");
    const han_tra = moment().tz("Asia/Ho_Chi_Minh").add(7, "days").format("YYYY-MM-DD");

    // Ghi log dữ liệu gửi đi để kiểm tra
    console.log("Dữ liệu gửi đi:", {
        ma_sv,
        ma_gv,
        ten_sach,
        ngay_muon: today,
        han_tra
    });

    fetch("/phieu-muon", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ma_sv, ma_gv, ten_sach, ngay_muon: today, han_tra })
    })
    .then(res => {
        console.log("Phản hồi từ server:", res); // Ghi log phản hồi
        if (!res.ok) {
            throw new Error(`Lỗi HTTP! Trạng thái: ${res.status}`);
        }
        return res.json();
    })
    .then(data => {
        console.log("Dữ liệu phản hồi:", data); // Ghi log dữ liệu JSON
        if (data.success) {
            alert("✅ Mượn sách thành công!");
            const book = allBooks.find(b => b.ten_sach === ten_sach);
            if (book) book.so_luong_ton -= 1;
            renderBooks(allBooks);
        } else {
            alert(`❌ Lỗi: ${data.message || "Không thể mượn sách!"}`);
        }
    })
    .catch(err => {
        console.error("Lỗi khi mượn sách:", err);
        alert(`❌ Lỗi kết nối server! Chi tiết: ${err.message}`);
    });
}


    // Lọc sách khi gõ
    const searchInput = document.getElementById("searchBook");
    const searchBtn = document.getElementById("searchBtn");

    function filterBooks() {
        const keyword = searchInput.value.toLowerCase().trim();
        const filtered = allBooks.filter(book =>
            book.ten_sach.toLowerCase().includes(keyword) ||
            (book.tac_gia && book.tac_gia.toLowerCase().includes(keyword))
        );
        renderBooks(filtered);
    }

    searchInput.addEventListener("input", filterBooks);
    searchBtn.addEventListener("click", filterBooks);
});
