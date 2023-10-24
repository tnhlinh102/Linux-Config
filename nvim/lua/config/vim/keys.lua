local keymap = vim.keymap -- for conciseness
-- keymaps
keymap.set("n", "gb", ":bprevious<CR>")
keymap.set("n", "gn", ":bnext<CR>")

keymap.set("n", "<leader>w", ":wa<CR>")

keymap.set("v", "#", ":s/^/# /<CR> :noh <CR>", { silent = true })
keymap.set("v", "-#", ":s/^# //<CR> :noh <CR>", { silent = true })

keymap.set("x", "<leader>p", [["_dP]])

keymap.set("n", "Q", "<nop>")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set({"n", "v"}, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

keymap.set({"n", "v"}, "<leader>d", [["_d]])

keymap.set("n", "<leader>z", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap.set("n", "<leader>gt", ":BufferLinePick<CR>", { silent = true })
