return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  event = "VeryLazy", -- โหลดตอนเปิด nvim เลย → แถบแท็บด้านบนโชว์เสมอ (ไม่ต้องรอกด Shift-l ก่อน)
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      separator_style = "thin",
      show_buffer_close_icons = false,
      offsets = {
        { filetype = "neo-tree", text = "Explorer", separator = true, text_align = "left" },
      },
    },
  },
  keys = {
    { "<S-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
    { "<S-h>", "<cmd>bprevious<cr>", desc = "Prev buffer" },
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer (jump)" },
    {
      "<leader>bd",
      function()
        -- ปิด buffer ปัจจุบันแล้วเด้งไป buffer ที่เปิดค้างอยู่ตัวก่อนหน้า (ไม่เด้งไป nvim-tree)
        local cur = vim.api.nvim_get_current_buf()
        if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
          vim.cmd("bprevious")
        end
        vim.cmd("bdelete " .. cur)
      end,
      desc = "Close current buffer (แสดง buffer ถัดไป ไม่เด้งไป tree)",
    },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
    { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
    { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
    { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
    { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
  },
}
