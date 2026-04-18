# Linux Config

Cấu hình cá nhân cho **Neovim** và **tmux** trên Linux / WSL. Dùng hướng dẫn này khi setup PC mới.

---

## Mục lục

1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Clone repo](#clone-repo)
3. [Cài đặt tmux + cấu hình](#cài-đặt-tmux--cấu-hình)
4. [Cài đặt Neovim + cấu hình](#cài-đặt-neovim--cấu-hình)
5. [Kiểm tra kết quả](#kiểm-tra-kết-quả)

---

## Yêu cầu hệ thống

| Công cụ | Phiên bản tối thiểu | Lệnh cài (Ubuntu/Debian) |
|---|---|---|
| git | bất kỳ | `sudo apt install git` |
| tmux | ≥ 3.2 | `sudo apt install tmux` |
| Neovim | ≥ 0.10 | xem mục Neovim bên dưới |
| Node.js | ≥ 18 | `sudo apt install nodejs npm` |
| xclip | bất kỳ | `sudo apt install xclip` |
| curl / wget | bất kỳ | thường có sẵn |

> **WSL**: Đảm bảo `xclip` được cài để copy/paste hoạt động đúng.

---

## Clone repo

```bash
git clone git@github.com:tnhlinh102/Linux-Config.git ~/Linux-Config
```

---

## Cài đặt tmux + cấu hình

### 1. Cài tmux

```bash
sudo apt update && sudo apt install -y tmux xclip
```

### 2. Cài TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 3. Tạo script net-speed (dùng trong status bar)

```bash
mkdir -p ~/.tmux/scripts
cat > ~/.tmux/scripts/net-speed.sh << 'EOF'
#!/usr/bin/env bash
# Hiển thị tốc độ mạng trên tmux status bar
interface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')
[ -z "$interface" ] && { echo "N/A"; exit; }

rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
sleep 1
rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)

rx_speed=$(( (rx2 - rx1) / 1024 ))
tx_speed=$(( (tx2 - tx1) / 1024 ))

echo "↓${rx_speed}KB ↑${tx_speed}KB"
EOF
chmod +x ~/.tmux/scripts/net-speed.sh
```

### 4. Copy file cấu hình

```bash
cp ~/Linux-Config/.tmux.conf ~/.tmux.conf
```

### 5. Reload cấu hình & cài plugins

```bash
tmux source ~/.tmux.conf
# Mở tmux rồi nhấn: Ctrl+Space + I (chữ I hoa) để cài tất cả plugins
```

### Các phím tắt chính (tmux)

| Phím | Chức năng |
|---|---|
| `Ctrl+Space` | Prefix key (thay `Ctrl+b`) |
| `Prefix + \` | Split ngang |
| `Prefix + -` | Split dọc |
| `Prefix + h/j/k/l` | Di chuyển giữa các pane |
| `Prefix + H/J/K/L` | Resize pane |
| `Prefix + r` | Reload config |
| `Ctrl+z` | Zoom pane hiện tại |
| `Prefix + n/m` | Hoán đổi pane lên/xuống |

**Plugins đang dùng:**
- `tmux-resurrect` – khôi phục session sau khi tắt máy
- `tmux-copycat` – tìm kiếm trong buffer
- `vim-tmux-navigator` – di chuyển liền mạch giữa vim & tmux
- `tmux-yank` – copy sang clipboard hệ thống
- `tmux-cpu` – hiển thị CPU/RAM trên status bar

---

## Cài đặt Neovim + cấu hình

### 1. Cài Neovim ≥ 0.10

**Cách A – dùng AppImage (đơn giản nhất):**

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

**Cách B – dùng snap:**

```bash
sudo snap install nvim --classic
```

Kiểm tra: `nvim --version`

### 2. Cài các dependency cần thiết

```bash
# Build tools (cần cho treesitter)
sudo apt install -y build-essential gcc g++ make

# Node.js (cần cho LSP như tsserver, pyright...)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Python provider
pip3 install pynvim

# Ripgrep (cho telescope live_grep)
sudo apt install -y ripgrep fd-find

# Nerd Font (để icon hiển thị đúng)
# Tải font tại: https://www.nerdfonts.com/font-downloads
# Gợi ý: JetBrainsMono Nerd Font hoặc FiraCode Nerd Font
# Đặt font vào ~/.local/share/fonts/ rồi chạy: fc-cache -fv
```

### 3. Copy cấu hình Neovim

```bash
mkdir -p ~/.config
cp -r ~/Linux-Config/nvim ~/.config/nvim
```

### 4. Mở Neovim – tự động cài plugins

```bash
nvim
# Lazy.nvim sẽ tự bootstrap và cài tất cả plugins
# Đợi cài xong rồi restart: :q rồi mở lại nvim
```

### 5. Cài LSP servers qua Mason

Trong Neovim:

```
:MasonInstall lua-language-server
:MasonInstall typescript-language-server
:MasonInstall pyright
:MasonInstall gopls
# hoặc dùng UI: :Mason
```

### Cấu trúc thư mục Neovim

```
nvim/
├── init.lua                  ← entry point
├── lazy-lock.json            ← lockfile phiên bản plugins
└── lua/
    ├── config/vim/
    │   ├── init.lua          ← load vim config
    │   ├── keys.lua          ← keymaps
    │   └── opts.lua          ← options (số dòng, indent...)
    └── init/
        ├── lazy.lua          ← bootstrap lazy.nvim
        └── plugins/
            ├── bufferline.lua
            ├── colorscheme.lua
            ├── fugitive.lua  ← git integration
            ├── lsp/
            │   ├── lspconfig.lua
            │   ├── mason.lua
            │   └── none-ls.lua
            ├── lualine.lua
            ├── nvim-cmp.lua  ← autocompletion
            ├── nvim-surround.lua
            ├── nvim-tree.lua ← file explorer
            ├── telescope.lua ← fuzzy finder
            ├── transparent.lua
            └── treesitter.lua
```

---

## Kiểm tra kết quả

### tmux

```bash
tmux new -s main
# Status bar phía dưới hiển thị: NET / RAM / CPU / giờ / tên máy
# Thử Prefix+\ để split, Prefix+h/l để di chuyển
```

### Neovim

```bash
nvim .
# Thử :NvimTreeToggle để mở file tree
# Thử :Telescope find_files để tìm file
# Thử :checkhealth để kiểm tra toàn bộ setup
```

---

## Cập nhật config

Khi thay đổi config trên máy hiện tại, sync lại repo:

```bash
cp ~/.tmux.conf ~/Linux-Config/.tmux.conf
cp -r ~/.config/nvim ~/Linux-Config/nvim
cd ~/Linux-Config
git add -A
git commit -m "sync config"
git push
```
