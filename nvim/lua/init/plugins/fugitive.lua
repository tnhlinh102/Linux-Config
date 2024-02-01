return {
  "tpope/vim-fugitive",
    dependencies = {
    "mhinz/vim-signify"
  },
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>gs", vim.cmd.Git)
    keymap.set("n", "<leader>ps", ":Git push <CR>")
    keymap.set("n", "<leader>pl", ":Git pull --rebase <CR>")
    keymap.set("n", "<leader>pS", ":Git push -u origin <CR>");
    keymap.set("n", "<leader>rt", ":Git restore . <CR>");
    keymap.set("n", "<leader>rs", ":Git reset <CR>");
  end,
}
