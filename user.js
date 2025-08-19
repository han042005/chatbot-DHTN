document.addEventListener("DOMContentLoaded", () => {
    const currentUser = JSON.parse(localStorage.getItem("currentUser"));

    if (!currentUser || !currentUser.ma || !currentUser.role) {
        alert("❌ Vui lòng đăng nhập trước!");
        window.location.href = "login.html";
        return;
    }

    // Lấy thông tin tài–

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
            document.getElementById("userMa").textContent = user.ma || "Không có mã"; // Sử dụng user.ma
            document.getElementById("userEmail").textContent = user.email || "Không có email";
            document.getElementById("totalBorrowed").textContent = user.so_sach_da_muon || 0;
            document.getElementById("currentBorrowed").textContent = user.so_sach_dang_muon || 0;
            document.getElementById("returned").textContent = user.so_sach_da_tra || 0;
            document.getElementById("overdue").textContent = user.so_sach_qua_han || 0;

            // Hiển thị danh sách phiếu mượn
            const tbody = document.getElementById("borrowTableBody");
            tbody.innerHTML = "";
            borrows.forEach(borrow => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${borrow.ten_sach}</td>
                    <td>${borrow.tac_gia || ""}</td>
                    <td>${borrow.nam_xuat_ban || ""}</td>
                    <td>${borrow.ngay_muon}</td>
                    <td>${borrow.han_tra}</td>
                    <td>${borrow.ngay_tra || ""}</td>
                    <td>${borrow.trang_thai}</td>
                `;
                tbody.appendChild(row);
            });
        })
        .catch(err => {
            console.error("Lỗi khi lấy thông tin tài khoản:", err.message, err.stack);
            alert(`❌ Lỗi kết nối server! Chi tiết: ${err.message}`);
        });
});
document.getElementById("btnLogout").addEventListener("click", () => {
    localStorage.removeItem("currentUser"); 
    alert("✅ Bạn đã đăng xuất!");
    window.location.href = "login.html"; 
});
