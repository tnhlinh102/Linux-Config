return {
  "tpope/vim-fugitive",
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>gs", vim.cmd.Git)
    keymap.set("n", "<leader>ps", function()
              vim.cmd.Git('push')
          end)
    keymap.set("n", "<leader>pl", function()
              vim.cmd.Git({'pull',  '--rebase'})
          end)
    keymap.set("n", "<leader>pL", ":Git push -u origin ");
    keymap.set("n", "<leader>rt", ":Git restore .");
    keymap.set("n", "<leader>rs", ":Git reset");
  end,
}
