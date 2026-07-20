return {
  -- Mở rộng text object a/i: chọn tham số (a), lời gọi hàm (f), ngoặc, nháy, tag
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500, -- Giới hạn số dòng tìm ngược/xuôi để giữ hiệu năng
    },
  },
}
