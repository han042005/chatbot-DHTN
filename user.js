document.addEventListener("DOMContentLoaded", () => {
    // Kiểm tra Moment.js
    if (typeof moment === "undefined") {
        alert("❌ Lỗi: Moment.js không được tải!");
        console.error("Moment.js không được tải. Vui lòng kiểm tra thẻ <script>.");
        return;
    }

    const currentUser = JSON.parse(localStorage.getItem("currentUser"));

    if (!currentUser || !currentUser.ma || !currentUser.role) {
        alert("❌ Vui lòng đăng nhập trước!");
        window.location.href = "login.html";
        return;
    }

    fetch(`/user-info/${currentUser.role}/${currentUser.ma}`)
        .then(res => {
            if (!res.ok) {
                throw new Error(`Lỗi HTTP! Trạng thái: ${res.status}`);
            }
            return res.json();
        })
        .then(data => {
            if (!data.success) {
                alert("❌ Lỗi: " + data.message);
                return;
            }

            const { user, borrows } = data.data;

            // Hiển thị thông tin người dùng
            document.getElementById("userMa").textContent = user.ma || "Không có mã";
            document.getElementById("userEmail").textContent = user.email || "Không có email";
            document.getElementById("totalBorrowed").textContent = user.so_sach_da_muon || 0;
            document.getElementById("currentBorrowed").textContent = user.so_sach_dang_muon || 0;
            document.getElementById("returned").textContent = user.so_sach_da_tra || 0;
            document.getElementById("overdue").textContent = user.so_sach_qua_han || 0;

            // Hiển thị danh sách phiếu mượn
            const tbody = document.getElementById("borrowTableBody");
            tbody.innerHTML = "";
            borrows.forEach(borrow => {
                const ngayMuon = moment(borrow.ngay_muon).tz("Asia/Ho_Chi_Minh").format("DD/MM/YYYY");
                const hanTra = moment(borrow.han_tra).tz("Asia/Ho_Chi_Minh").format("DD/MM/YYYY");
                const ngayTra = borrow.ngay_tra ? moment(borrow.ngay_tra).tz("Asia/Ho_Chi_Minh").format("DD/MM/YYYY") : "";

                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${borrow.ten_sach}</td>
                    <td>${borrow.tac_gia || ""}</td>
                    <td>${borrow.nam_xuat_ban || ""}</td>
                    <td>${ngayMuon}</td>
                    <td>${hanTra}</td>
                    <td>${ngayTra}</td>
                    <td>${borrow.trang_thai}</td>
                `;
                tbody.appendChild(row);
            });
        })
        .catch(err => {
            console.error("Lỗi khi lấy thông tin tài khoản:", err);
            alert(`❌ Lỗi kết nối server! Chi tiết: ${err.message}`);
        });
});

document.getElementById("btnLogout").addEventListener("click", () => {
    localStorage.removeItem("currentUser");
    alert("✅ Bạn đã đăng xuất!");
    window.location.href = "login.html";
});