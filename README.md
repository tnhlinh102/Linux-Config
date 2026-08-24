# Linux Config

Cấu hình cá nhân cho **Neovim** và **tmux** trên Linux / WSL. Dùng hướng dẫn này khi setup PC mới.

---

## Mục lục

1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Clone repo](#clone-repo)
3. [Cài đặt ngôn ngữ & runtime](#cài-đặt-ngôn-ngữ--runtime)
4. [Cài đặt tmux + cấu hình](#cài-đặt-tmux--cấu-hình)
5. [Cài đặt Neovim + cấu hình](#cài-đặt-neovim--cấu-hình)
6. [Ghi chú cấu hình quan trọng](#ghi-chú-cấu-hình-quan-trọng)
7. [Kiểm tra kết quả](#kiểm-tra-kết-quả)
8. [Cập nhật config](#cập-nhật-config)

---

## Yêu cầu hệ thống

| Công cụ | Phiên bản tối thiểu | Lệnh cài (Ubuntu/Debian) |
|---|---|---|
| git | bất kỳ | `sudo apt install git` |
| tmux | ≥ 3.2 | `sudo apt install tmux` |
| Neovim | **≥ 0.11** | xem mục Neovim bên dưới |
| Node.js | ≥ 18 | xem mục Node.js bên dưới |
| Python | ≥ 3.10 | xem mục Python bên dưới |
| Go | ≥ 1.21 | xem mục Go bên dưới |
| Rust | stable | xem mục Rust bên dưới |
| build-essential | bất kỳ | `sudo apt install build-essential` |
| ripgrep | bất kỳ | `sudo apt install ripgrep` |
| xclip | bất kỳ | `sudo apt install xclip` |

> **Lưu ý về Neovim**: Config dùng API `vim.lsp.config` / `vim.lsp.enable` chỉ có từ **Neovim 0.11** trở lên. Cài phiên bản cũ hơn sẽ lỗi ngay khi mở. Đã kiểm tra trên **0.11.5**.
>
> Đừng cài `neovim` từ apt của Ubuntu — bản trong repo là 0.9.5, quá cũ để chạy config này.

> **WSL**: Đảm bảo `xclip` được cài để copy/paste hoạt động đúng.

---

## Clone repo

```bash
git clone git@github.com:tnhlinh102/Linux-Config.git ~/Linux-Config
```

---

## Cài đặt ngôn ngữ & runtime

Các LSP server, formatter, linter trong config yêu cầu đủ **4 runtime** sau. Cài thiếu bất kỳ cái nào sẽ khiến Mason báo lỗi hoặc LSP không chạy được.

### Node.js ≥ 18

Dùng cho: `ts_ls`, `eslint`, `html`, `cssls`, `tailwindcss`, `svelte`, `graphql`, `emmet_ls`, `prismals`, `jsonls`, `pyright`, `prettier`

```bash
# Dùng NodeSource để có phiên bản mới nhất (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Kiểm tra
node --version   # phải >= v18
npm --version
```

### Python ≥ 3.10

Dùng cho: `pyright` (LSP), `black` (format), `isort` (sort import), `pylint` (lint), `pynvim` (Neovim Python provider)

```bash
sudo apt install -y python3 python3-pip python3-venv

# Neovim Python provider (BẮT BUỘC)
pip3 install pynvim

# Các tool được Mason quản lý, nhưng nếu muốn cài thủ công:
pip3 install black isort pylint

# Kiểm tra
python3 --version   # phải >= 3.10
pip3 --version
```

### Go ≥ 1.21

Dùng cho: `gopls` (LSP), `goimports` (format), `gofumpt` (format), `golangci-lint` (lint)

```bash
# Tải phiên bản mới nhất tại https://go.dev/dl/
# Ví dụ với Go 1.23:
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz

# Thêm vào ~/.zshrc hoặc ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc
source ~/.zshrc

# Kiểm tra
go version   # phải >= 1.21
```

### Rust (qua rustup)

Dùng cho: `rust_analyzer` (LSP), `rustfmt` (format – đi kèm rustup), `clippy` (lint – đi kèm rustup)

> `rustfmt` và `clippy` **không** cài qua Mason mà đi kèm với `rustup` — đây là lý do config có comment `# rustfmt comes with rustup, not Mason`.

```bash
# Cài rustup (bao gồm rustc, cargo, rustfmt, clippy)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Chọn option 1 (default installation)

source ~/.cargo/env   # hoặc mở terminal mới

# Đảm bảo có đủ components
rustup component add rustfmt clippy

# Kiểm tra
rustc --version
cargo --version
rustfmt --version
```

### Tổng hợp: LSP & tools theo ngôn ngữ

| Ngôn ngữ | LSP Server | Formatter | Linter | Runtime cần |
|---|---|---|---|---|
| TypeScript / JS | `ts_ls` | `prettier` | `eslint` (LSP) | Node.js |
| HTML / CSS / Emmet | `html`, `cssls`, `emmet_ls` | `prettier` | – | Node.js |
| Tailwind CSS | `tailwindcss` | – | – | Node.js |
| JSON / JSONC | `jsonls` | `prettier` | – | Node.js |
| Svelte | `svelte` | `prettier` | – | Node.js |
| GraphQL | `graphql` | – | – | Node.js |
| Prisma | `prismals` | – | – | Node.js |
| Python | `pyright` | `black`, `isort` | `pylint` | Python 3 |
| Go | `gopls` | `goimports`, `gofumpt` | `golangci-lint` | Go |
| Rust | `rust_analyzer` | `rustfmt` | `clippy` | Rust/rustup |
| Lua | `lua_ls` | `stylua` | – | (Mason tự cài) |

> **ESLint chạy qua LSP, không qua none-ls.** Builtin `diagnostics.eslint_d` đã bị xoá khỏi none-ls (tách sang repo `none-ls-extras`). Config dùng `eslint-lsp` thay thế — hỗ trợ **flat config** (`eslint.config.mjs` của ESLint 9 / Next.js 16+) và có thêm code action tự sửa khi save.
>
> **`efm` đã bỏ.** Trước đây khai báo rỗng `efm = {}` nên nó attach vào buffer mà không làm gì. Formatter/linter đã do none-ls lo.

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

### 1. Cài Neovim ≥ 0.11

**Cách A – dùng AppImage (đơn giản nhất, luôn có bản mới nhất):**

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

**Cách B – dùng snap:**

```bash
sudo snap install nvim --classic
```

Kiểm tra: `nvim --version`  ← phải hiển thị `v0.11` trở lên

### 2. Cài build tools & ripgrep

```bash
# Cần cho treesitter (compile parser)
sudo apt install -y build-essential gcc g++ make

# Cần cho Telescope live_grep và find_files
sudo apt install -y ripgrep fd-find
```

### 3. Cài Nerd Font

Icons trong lualine, nvim-tree, bufferline cần Nerd Font. Tải tại: https://www.nerdfonts.com/font-downloads

Gợi ý: **JetBrainsMono Nerd Font** hoặc **FiraCode Nerd Font**

```bash
mkdir -p ~/.local/share/fonts
# Copy file .ttf vào đây rồi chạy:
fc-cache -fv
# Sau đó đổi font trong terminal emulator sang font vừa cài
```

### 4. Copy cấu hình Neovim

```bash
mkdir -p ~/.config
cp -r ~/Linux-Config/nvim ~/.config/nvim
```

### 5. Mở Neovim – tự động cài plugins & LSP

```bash
nvim
# Lazy.nvim tự bootstrap → cài tất cả plugins
# Mason tự cài tất cả LSP, formatter, linter (xem mason.lua)
# Đợi thanh progress ở góc phải biến mất → :q → mở lại nvim
```

> Mason sẽ tự cài toàn bộ danh sách trong `ensure_installed` bao gồm:
> **LSP** — `ts_ls`, `eslint`, `html`, `cssls`, `tailwindcss`, `svelte`, `lua_ls`, `graphql`, `emmet_ls`, `prismals`, `jsonls`, `pyright`, `gopls`, `rust_analyzer`
> **Formatter / linter** — `prettier`, `black`, `isort`, `pylint`, `stylua`, `goimports`, `gofumpt`, `golangci-lint`

### 6. Cài treesitter parser

Config ghim `nvim-treesitter` ở branch `master` (xem mục [Ghi chú cấu hình](#ghi-chú-cấu-hình-quan-trọng)). Parser tự cài khi mở file, nhưng cài trước cho chắc:

```bash
nvim -c "Lazy! load nvim-treesitter" -c "TSUpdateSync" -c "qa"
```

Kiểm tra: mở một file `.tsx` rồi chạy `:InspectTree` — phải thấy cây cú pháp, không phải báo lỗi thiếu parser.

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
            ├── any-jump.lua
            ├── autotag.lua   ← tự đóng thẻ JSX/HTML
            ├── bufferline.lua
            ├── colorscheme.lua
            ├── fugitive.lua  ← git integration
            ├── lsp/
            │   ├── lspconfig.lua  ← setup LSP với vim.lsp.config (Nvim 0.11+)
            │   ├── mason.lua      ← tự động cài LSP/tools qua Mason
            │   └── none-ls.lua   ← format on save qua none-ls
            ├── lualine.lua
            ├── nvim-cmp.lua  ← autocompletion
            ├── nvim-surround.lua
            ├── nvim-tree.lua ← file explorer
            ├── smoothie.lua
            ├── telescope.lua ← fuzzy finder
            ├── transparent.lua
            └── treesitter.lua
```

---

## Ghi chú cấu hình quan trọng

Bốn quyết định dưới đây trông nhỏ nhưng đều từng làm config **hỏng âm thầm** — không báo lỗi, chỉ đơn giản là không hoạt động. Đừng "dọn dẹp" chúng mà không đọc lý do.

### 1. `nvim-treesitter` phải ghim `branch = "master"`

```lua
branch = "master",
main = "nvim-treesitter.configs",
```

Branch `main` là bản viết lại, `TSConfig` của nó **chỉ nhận đúng một field `install_dir`**. Nếu để mặc định (lazy.nvim sẽ lấy `main`), toàn bộ `ensure_installed` / `highlight` / `indent` trong config sẽ **bị bỏ qua âm thầm** → file `.tsx` rơi về syntax regex cũ, không có parser.

Cũng cần `highlight = { enable = true }` — cả hai branch đều **không** tự bật highlight.

> Branch `master` đã được đánh dấu archive (commit cuối 03/2026). Vẫn chạy ổn định nhưng không có parser/fix mới. Khi nào chuyển sang `main` thì phải viết lại: tự gọi `vim.treesitter.start()` trong autocmd `FileType`, và `main` **không có** module `indent` / `incremental_selection`.

### 2. `none-ls` không được đặt `lazy = true`

```lua
event = { "BufReadPre", "BufNewFile" },   -- KHÔNG dùng lazy = true
```

`lazy = true` mà không có `event`/`ft`/`cmd`/`keys` nào, lại không file nào `require("null-ls")` → plugin **không bao giờ được load**. Toàn bộ file `none-ls.lua` thành code chết: mất prettier, mất format-on-save, không một dòng lỗi nào.

### 3. Không gọi builtin đã bị xoá khỏi `none-ls`

`null_ls.builtins.diagnostics.eslint_d` hiện là `nil`. Gọi `.with()` trên `nil` sẽ **làm cả `null_ls.setup()` chết** — nghĩa là mất luôn prettier, black, stylua… chứ không chỉ mất eslint. Kiểm tra nhanh khi nghi ngờ:

```vim
:lua print(#require("null-ls.sources").get_all())
```
Ra `0` là setup đã chết ở đâu đó. Bình thường phải ra `8`.

### 4. `mason-lspconfig` v2 dùng `automatic_enable`, không phải `handlers`

```lua
automatic_enable = false,   -- không phải handlers = {}
```

`handlers` là option của **v1** và đã bị xoá ở v2 → truyền vào bị bỏ qua, mọi server đã cài đều bị `vim.lsp.enable()` tự động (kể cả server bạn không cấu hình). Việc setup server do `lspconfig.lua` tự lo qua `vim.lsp.config` + `vim.lsp.enable`.

### Keymap LSP

| Phím | Chức năng |
|---|---|
| `gd` / `gD` | Đi tới definition / declaration |
| `gR` / `gi` | References / implementations |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `<leader>d` / `<leader>D` | Diagnostic dòng / cả buffer |
| `[d` / `]d` | Diagnostic trước / sau |
| `<leader>ih` | Bật/tắt inlay hints |
| `<leader>rs` | Restart LSP |
| `<C-space>` | Mở rộng vùng chọn theo cây treesitter |

> **Inlay hints bật sẵn** cho server nào hỗ trợ (`ts_ls`, `gopls`, `rust_analyzer`). Hiển thị type mà compiler suy luận ra ngay trên màn hình — rất hữu ích khi đang học TypeScript. Thấy rối thì `<leader>ih` để tắt theo buffer.

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
# Thử :Mason để xem trạng thái cài đặt LSP/tools
```

**Kiểm tra stack frontend (TypeScript / React / Next.js / Tailwind):**

```bash
npx create-next-app@latest /tmp/probe --typescript --tailwind --app --eslint --yes
cd /tmp/probe && nvim app/page.tsx
```

Bảy điểm phải đạt:

| Kiểm tra | Cách xem | Kết quả đúng |
|---|---|---|
| Treesitter đọc được `.tsx` | `:InspectTree` | Hiện cây cú pháp, không báo thiếu parser |
| LSP attach đủ | `:checkhealth vim.lsp` | Có `ts_ls`, `eslint`, `tailwindcss`, `emmet_ls`, `null-ls` |
| Type hiển thị | `K` trên một biến | Hiện type |
| Inlay hints | mở file | Type suy luận hiện mờ sau biến |
| Tailwind completion | gõ trong `className=""` | Có gợi ý class (kể cả class custom từ `@theme` của v4) |
| Format on save | `:w` | Prettier tự format lại file |
| none-ls còn sống | `:lua print(#require("null-ls.sources").get_all())` | `8` |

**Kiểm tra từng runtime:**

```bash
node --version    # >= v18
python3 --version # >= 3.10
go version        # >= 1.21
rustc --version   # stable
nvim --version    # >= 0.11
```

---

## Cập nhật config

Khi thay đổi config trên máy hiện tại, sync lại repo:

```bash
cp ~/.tmux.conf ~/Linux-Config/.tmux.conf

# Xoá trước rồi copy — nếu không, cp -r sẽ lồng thành nvim/nvim/
rm -rf ~/Linux-Config/nvim
cp -r ~/.config/nvim ~/Linux-Config/nvim

cd ~/Linux-Config
git add -A
git commit -m "sync config"
git push
```

Sau khi copy, xác nhận hai bên giống hệt nhau trước khi commit:

```bash
diff -rq ~/.config/nvim ~/Linux-Config/nvim && echo "IDENTICAL"
```
