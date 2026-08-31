# nvim_setting

Neovim config ส่วนตัว (ฐานจาก josean, lazy.nvim) สำหรับใช้ซ้ำบน server/เครื่องอื่น

> หมายเหตุ: ส่วน AI autocomplete (minuet + Ollama) กับ tmux/agent ใช้เฉพาะบน MacBook
> จึง **ไม่รวม** ใน repo นี้ — repo นี้คือ nvim ล้วนๆ

## ติดตั้งบนเครื่องใหม่
```bash
git clone https://github.com/artweerasak/nvim_setting.git ~/.config/nvim
nvim   # เปิดครั้งแรก lazy.nvim จะโหลดปลั๊กอินให้อัตโนมัติ
```

## ต้องมี
- Neovim ≥ 0.9
- git, make, ripgrep (`rg`), a Nerd Font
- (ถ้าจะใช้ LSP) node/npm ตามภาษาที่ใช้

## leader = `Space`
- ค้นหาไฟล์: `Space ff` · grep: `Space fs` · explorer: `Space ee`
