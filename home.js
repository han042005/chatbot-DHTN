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



