return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- ปักหมุด branch เก่า (classic) เพราะ config ใช้ API nvim-treesitter.configs ที่ branch main ตัดทิ้งแล้ว
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")

    -- ── FIX: nvim-treesitter (branch master) กับ nvim 0.12+ ──
    -- nvim 0.12 เปลี่ยน match[id] จาก "โหนดเดียว" เป็น "ลิสต์ของโหนด"
    -- ทำให้ directive ของ master crash (attempt to call method 'range' a nil value)
    -- เวลา parse markdown/html → พัง (เช่น ไฟล์ .md, โค้ดบล็อกในบัฟเฟอร์ ฯลฯ)
    -- ลงทะเบียน directive พวกนั้นใหม่ให้รองรับทั้ง API เก่า/ใหม่
    pcall(require, "nvim-treesitter.query_predicates") -- ให้ master ลงทะเบียนก่อน แล้วค่อย override
    local q = vim.treesitter.query
    local function last_node(match, id)
      local n = match[id]
      if type(n) == "table" then n = n[#n] end -- API ใหม่: ลิสต์ → เอาโหนดสุดท้าย
      return n
    end
    q.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = last_node(match, pred[2])
      if not node then return end
      local ok, txt = pcall(vim.treesitter.get_node_text, node, bufnr)
      if not ok or not txt then return end
      local lang = txt:match("^%S*")
      if lang and lang ~= "" then metadata["injection.language"] = lang:lower() end
    end, { force = true })
    q.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = last_node(match, pred[2])
      if not node then return end
      local ok, txt = pcall(vim.treesitter.get_node_text, node, bufnr)
      if not ok or not txt then return end
      local parts = vim.split(txt, "/", {})
      metadata["injection.language"] = parts[#parts]
    end, { force = true })
    q.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local node = last_node(match, pred[2])
      if not node then return end
      local ok, txt = pcall(vim.treesitter.get_node_text, node, bufnr)
      if not ok or not txt then return end
      metadata[pred[3] or "injection.language"] = tostring(txt):lower()
    end, { force = true })
  end,
}
