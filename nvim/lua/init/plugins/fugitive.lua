return {
  "tpope/vim-fugitive",
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>gs", vim.cmd.Git)
    keymap.set("n", "<leader>ps", "Git push")
    keymap.set("n", "<leader>pl", "Git pull --rebase")
    keymap.set("n", "<leader>pL", "Git push -u origin");
    keymap.set("n", "<leader>rt", "Git restore .");
    keymap.set("n", "<leader>rs", "Git reset");
  end,
}
