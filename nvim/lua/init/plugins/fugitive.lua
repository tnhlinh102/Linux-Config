return {
  "tpope/vim-fugitive",
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>gs", vim.cmd.Git)
    local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWinEnter", {
      group = ThePrimeagen_Fugitive,
      pattern = "*",
      callback = function()
          if vim.bo.ft ~= "fugitive" then
              return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = {buffer = bufnr, remap = false}
          keymap.set("n", "<leader>bu", function()
              vim.cmd.Git('push')
          end, opts)

          -- rebase always
          keymap.set("n", "<leader>bd", function()
              vim.cmd.Git({'pull',  '--rebase'})
          end, opts)

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set("n", "<leader>bU", ":Git push -u origin ", opts);
      end,
  })
  end,
}
