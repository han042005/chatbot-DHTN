document.getElementById("btnLogin").addEventListener("click", async function () {
    const ma = document.getElementById('ma_sv').value.trim(); // Input chung cho ma_sv hoặc ma_gv
    const mat_khau = document.getElementById('mat_khau').value.trim();
    const messageEl = document.getElementById('message');

    if (!ma || !mat_khau) {
        messageEl.textContent = "Vui lòng nhập đầy đủ thông tin!";
        return;
    }

    try {
        // Thử đăng nhập sinh viên
        let res = await fetch('/login-sinh-vien', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ma_sv: ma, mat_khau })
        });
        let data = await res.json();

        if (data.success) {
            messageEl.style.color = "green";
            messageEl.textContent = "Đăng nhập thành công!";
            localStorage.setItem('currentUser', JSON.stringify({
                role: 'sinh_vien',
                id: data.data.id,
                ma: data.data.ma_sv,
                email: data.data.email
            }));
            window.location.href = "home.html";
            return;
        }

        // Nếu đăng nhập sinh viên thất bại, thử đăng nhập giảng viên
        res = await fetch('/login-giang-vien', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ma_gv: ma, mat_khau })
        });
        data = await res.json();

        if (data.success) {
            messageEl.style.color = "green";
            messageEl.textContent = "Đăng nhập thành công!";
            localStorage.setItem('currentUser', JSON.stringify({
                role: 'giang_vien',
                id: data.data.id,
                ma: data.data.ma_gv,
                email: data.data.email
            }));
            window.location.href = "home.html";
        } else {
            messageEl.style.color = "red";
            messageEl.textContent = data.message || "Sai mã hoặc mật khẩu!";
        }
    } catch (error) {
        messageEl.textContent = "Lỗi kết nối tới server!";
        console.error("Lỗi:", error);
    }
});