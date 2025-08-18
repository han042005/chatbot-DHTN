document.getElementById("btnLogin").addEventListener("click", async function () {
    const ma_sv = document.getElementById('ma_sv').value.trim();
    const mat_khau = document.getElementById('mat_khau').value.trim();
    const messageEl = document.getElementById('message');

    if (!ma_sv || !mat_khau) {
        messageEl.textContent = "Vui lòng nhập đầy đủ thông tin!";
        return;
    }

    try {
        const res = await fetch('/login-sinh-vien', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ma_sv, mat_khau })
        });

        const data = await res.json();

        if (data.success) {
            messageEl.style.color = "green";
            messageEl.textContent = "Đăng nhập thành công!";
            // Lưu đối tượng dùng chung
            localStorage.setItem('currentUser', JSON.stringify({
                role: 'sinh_vien',
                id: data.data.id,
                ma: data.data.ma_sv,
                email: data.data.email
            }));
            // Chuyển hướng nếu muốn
             window.location.href = "home.html";

        // Sau khi login giảng viên thành công:
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
        }

        } else {
            messageEl.style.color = "red";
            messageEl.textContent = data.message;
        }
    } catch (error) {
        messageEl.textContent = "Lỗi kết nối tới server!";
    }
});
