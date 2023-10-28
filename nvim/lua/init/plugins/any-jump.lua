return {
  "pechorin/any-jump.vim",
  config = function ()
    
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>j", "AnyJump", { desc = "Jump to definition under cursor" })
    keymap.set("v", "<leader>j", "AnyJumpVisual", { desc = "Jump to selected text in visual mode" })
    keymap.set("n", "<leader>b", ":AnyJumpBack", { desc = "Open previous opened file (after jump)" })
    keymap.set("n", "<leader>al", "AnyJumpLastResults", { desc = "Open last closed search window again" })
  end,
}
